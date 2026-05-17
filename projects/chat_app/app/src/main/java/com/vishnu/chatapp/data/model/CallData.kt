package com.vishnu.chatapp.data.model

/**
 * Represents a call document stored in Firestore under the "calls" collection.
 * Used for WebRTC signaling between two users.
 */
data class CallData(
    val callId: String = "",
    val callerId: String = "",
    val callerName: String = "",
    val calleeId: String = "",
    val calleeName: String = "",
    val callType: CallType = CallType.AUDIO,
    val status: CallStatus = CallStatus.RINGING,
    val offerSdp: String = "",
    val answerSdp: String = "",
    val timestamp: Long = System.currentTimeMillis(),
    val roomId: String = ""   // the chat room for reference
)

enum class CallType { AUDIO, VIDEO }

enum class CallStatus {
    RINGING,        // Call is ringing on receiver side
    ANSWERED,       // Receiver picked up
    REJECTED,       // Receiver rejected
    ENDED,          // Call ended normally
    MISSED,         // Call was not answered
    BUSY            // Receiver is on another call
}

