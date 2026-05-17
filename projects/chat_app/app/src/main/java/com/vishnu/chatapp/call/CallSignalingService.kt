package com.vishnu.chatapp.call

import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.vishnu.chatapp.data.model.CallData
import com.vishnu.chatapp.data.model.CallStatus
import com.vishnu.chatapp.data.model.CallType
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.tasks.await
import org.webrtc.IceCandidate

/**
 * Handles all Firestore-based WebRTC signaling:
 * - Creating/updating call documents
 * - Exchanging SDP offer/answer
 * - Exchanging ICE candidates
 * - Listening for call state changes
 */
class CallSignalingService {

    companion object {
        private const val TAG = "CallSignaling"
        private const val CALLS_COLLECTION = "calls"
        private const val CANDIDATES_COLLECTION = "candidates"
        private const val CALLER_CANDIDATES = "callerCandidates"
        private const val CALLEE_CANDIDATES = "calleeCandidates"
    }

    private val db = FirebaseFirestore.getInstance()
    private val callsRef = db.collection(CALLS_COLLECTION)

    /**
     * Create a new call document in Firestore (caller side).
     */
    suspend fun createCall(callData: CallData): String {
        Log.d(TAG, "Creating call: ${callData.callerId} -> ${callData.calleeId}, type=${callData.callType}")
        val docRef = callsRef.document(callData.callId)
        docRef.set(callData).await()
        return callData.callId
    }

    /**
     * Update the SDP offer in the call document.
     */
    suspend fun setOffer(callId: String, sdp: String) {
        Log.d(TAG, "Setting offer SDP for call=$callId")
        callsRef.document(callId).update("offerSdp", sdp).await()
    }

    /**
     * Update the SDP answer in the call document.
     */
    suspend fun setAnswer(callId: String, sdp: String) {
        Log.d(TAG, "Setting answer SDP for call=$callId")
        callsRef.document(callId).update(
            mapOf(
                "answerSdp" to sdp,
                "status" to CallStatus.ANSWERED.name
            )
        ).await()
    }

    /**
     * Update call status.
     */
    suspend fun updateCallStatus(callId: String, status: CallStatus) {
        Log.d(TAG, "Updating call status: call=$callId, status=$status")
        callsRef.document(callId).update("status", status.name).await()
    }

    /**
     * Add an ICE candidate from the caller side.
     */
    suspend fun addCallerCandidate(callId: String, candidate: IceCandidate) {
        val data = mapOf(
            "sdpMid" to candidate.sdpMid,
            "sdpMLineIndex" to candidate.sdpMLineIndex,
            "sdp" to candidate.sdp
        )
        callsRef.document(callId)
            .collection(CALLER_CANDIDATES)
            .add(data).await()
    }

    /**
     * Add an ICE candidate from the callee side.
     */
    suspend fun addCalleeCandidate(callId: String, candidate: IceCandidate) {
        val data = mapOf(
            "sdpMid" to candidate.sdpMid,
            "sdpMLineIndex" to candidate.sdpMLineIndex,
            "sdp" to candidate.sdp
        )
        callsRef.document(callId)
            .collection(CALLEE_CANDIDATES)
            .add(data).await()
    }

    /**
     * Listen for the call document changes (status, answer SDP, etc.).
     */
    fun listenForCallUpdates(callId: String): Flow<CallData?> = callbackFlow {
        val listener: ListenerRegistration = callsRef.document(callId)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e(TAG, "Error listening to call $callId", error)
                    trySend(null)
                    return@addSnapshotListener
                }
                if (snapshot == null || !snapshot.exists()) {
                    trySend(null)
                    return@addSnapshotListener
                }
                try {
                    val data = snapshot.data ?: return@addSnapshotListener
                    val callData = CallData(
                        callId = snapshot.id,
                        callerId = data["callerId"] as? String ?: "",
                        callerName = data["callerName"] as? String ?: "",
                        calleeId = data["calleeId"] as? String ?: "",
                        calleeName = data["calleeName"] as? String ?: "",
                        callType = try { CallType.valueOf(data["callType"] as? String ?: "AUDIO") } catch (_: Exception) { CallType.AUDIO },
                        status = try { CallStatus.valueOf(data["status"] as? String ?: "RINGING") } catch (_: Exception) { CallStatus.RINGING },
                        offerSdp = data["offerSdp"] as? String ?: "",
                        answerSdp = data["answerSdp"] as? String ?: "",
                        timestamp = (data["timestamp"] as? Long) ?: System.currentTimeMillis(),
                        roomId = data["roomId"] as? String ?: ""
                    )
                    trySend(callData)
                } catch (e: Exception) {
                    Log.e(TAG, "Error parsing call data", e)
                    trySend(null)
                }
            }
        awaitClose { listener.remove() }
    }

    /**
     * Listen for ICE candidates from the callee (used by caller).
     */
    fun listenForCalleeCandidates(callId: String): Flow<IceCandidate> = callbackFlow {
        val listener = callsRef.document(callId)
            .collection(CALLEE_CANDIDATES)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e(TAG, "Error listening for callee candidates", error)
                    return@addSnapshotListener
                }
                snapshot?.documentChanges?.forEach { change ->
                    if (change.type == com.google.firebase.firestore.DocumentChange.Type.ADDED) {
                        val data = change.document.data
                        val candidate = IceCandidate(
                            data["sdpMid"] as? String ?: "",
                            (data["sdpMLineIndex"] as? Long)?.toInt() ?: 0,
                            data["sdp"] as? String ?: ""
                        )
                        trySend(candidate)
                    }
                }
            }
        awaitClose { listener.remove() }
    }

    /**
     * Listen for ICE candidates from the caller (used by callee).
     */
    fun listenForCallerCandidates(callId: String): Flow<IceCandidate> = callbackFlow {
        val listener = callsRef.document(callId)
            .collection(CALLER_CANDIDATES)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e(TAG, "Error listening for caller candidates", error)
                    return@addSnapshotListener
                }
                snapshot?.documentChanges?.forEach { change ->
                    if (change.type == com.google.firebase.firestore.DocumentChange.Type.ADDED) {
                        val data = change.document.data
                        val candidate = IceCandidate(
                            data["sdpMid"] as? String ?: "",
                            (data["sdpMLineIndex"] as? Long)?.toInt() ?: 0,
                            data["sdp"] as? String ?: ""
                        )
                        trySend(candidate)
                    }
                }
            }
        awaitClose { listener.remove() }
    }

    /**
     * Listen for incoming calls for a specific user.
     */
    fun listenForIncomingCalls(userId: String): Flow<CallData?> = callbackFlow {
        val listener = callsRef
            .whereEqualTo("calleeId", userId)
            .whereEqualTo("status", CallStatus.RINGING.name)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e(TAG, "Error listening for incoming calls", error)
                    trySend(null)
                    return@addSnapshotListener
                }
                val calls = snapshot?.documents?.mapNotNull { doc ->
                    try {
                        val data = doc.data ?: return@mapNotNull null
                        CallData(
                            callId = doc.id,
                            callerId = data["callerId"] as? String ?: "",
                            callerName = data["callerName"] as? String ?: "",
                            calleeId = data["calleeId"] as? String ?: "",
                            calleeName = data["calleeName"] as? String ?: "",
                            callType = try { CallType.valueOf(data["callType"] as? String ?: "AUDIO") } catch (_: Exception) { CallType.AUDIO },
                            status = try { CallStatus.valueOf(data["status"] as? String ?: "RINGING") } catch (_: Exception) { CallStatus.RINGING },
                            offerSdp = data["offerSdp"] as? String ?: "",
                            answerSdp = data["answerSdp"] as? String ?: "",
                            timestamp = (data["timestamp"] as? Long) ?: System.currentTimeMillis(),
                            roomId = data["roomId"] as? String ?: ""
                        )
                    } catch (e: Exception) {
                        Log.e(TAG, "Error parsing incoming call", e)
                        null
                    }
                } ?: emptyList()

                // Send the most recent incoming call
                val latestCall = calls.maxByOrNull { it.timestamp }
                if (latestCall != null) {
                    trySend(latestCall)
                }
            }
        awaitClose { listener.remove() }
    }

    /**
     * Clean up a call document and its sub-collections.
     */
    suspend fun cleanupCall(callId: String) {
        try {
            // Delete caller candidates
            val callerCandidates = callsRef.document(callId)
                .collection(CALLER_CANDIDATES).get().await()
            for (doc in callerCandidates.documents) {
                doc.reference.delete().await()
            }
            // Delete callee candidates
            val calleeCandidates = callsRef.document(callId)
                .collection(CALLEE_CANDIDATES).get().await()
            for (doc in calleeCandidates.documents) {
                doc.reference.delete().await()
            }
            // Delete the call document itself
            callsRef.document(callId).delete().await()
            Log.d(TAG, "Cleaned up call $callId")
        } catch (e: Exception) {
            Log.e(TAG, "Error cleaning up call $callId", e)
        }
    }
}

