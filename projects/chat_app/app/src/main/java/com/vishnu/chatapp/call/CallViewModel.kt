package com.vishnu.chatapp.call

import android.app.Application
import android.content.Context
import android.media.AudioManager
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseAuth
import com.vishnu.chatapp.data.model.CallData
import com.vishnu.chatapp.data.model.CallStatus
import com.vishnu.chatapp.data.model.CallType
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import org.webrtc.IceCandidate
import org.webrtc.MediaStream
import org.webrtc.PeerConnection
import org.webrtc.SessionDescription
import org.webrtc.VideoTrack
import java.util.UUID

data class CallUiState(
    val isInCall: Boolean = false,
    val isIncomingCall: Boolean = false,
    val isOutgoingCall: Boolean = false,
    val callData: CallData? = null,
    val callStatus: CallStatus = CallStatus.RINGING,
    val isMuted: Boolean = false,
    val isSpeakerOn: Boolean = false,
    val isCameraOn: Boolean = true,
    val isVideoCall: Boolean = false,
    val callDuration: Long = 0L,
    val remoteVideoTrack: VideoTrack? = null,
    val localVideoTrack: VideoTrack? = null,
    val callerName: String = "",
    val isConnected: Boolean = false
)

class CallViewModel(application: Application) : AndroidViewModel(application) {

    companion object {
        private const val TAG = "CallViewModel"
    }

    private val context: Context get() = getApplication<Application>().applicationContext
    private val signalingService = CallSignalingService()
    private var webRTCEngine: WebRTCEngine? = null

    private val _uiState = MutableStateFlow(CallUiState())
    val uiState: StateFlow<CallUiState> = _uiState.asStateFlow()

    private val _incomingCall = MutableStateFlow<CallData?>(null)
    val incomingCall: StateFlow<CallData?> = _incomingCall.asStateFlow()

    private var callListenerJob: Job? = null
    private var candidateListenerJob: Job? = null
    private var incomingCallListenerJob: Job? = null
    private var timerJob: Job? = null
    private var currentCallId: String? = null
    private var isCaller: Boolean = false

    private val audioManager: AudioManager
        get() = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    /**
     * Start listening for incoming calls for the current user.
     */
    fun startListeningForIncomingCalls() {
        val userId = FirebaseAuth.getInstance().currentUser?.uid ?: return
        if (incomingCallListenerJob?.isActive == true) return

        incomingCallListenerJob = viewModelScope.launch {
            signalingService.listenForIncomingCalls(userId).collect { callData ->
                if (callData != null && !_uiState.value.isInCall) {
                    Log.d(TAG, "Incoming call from ${callData.callerName}")
                    _incomingCall.value = callData
                    _uiState.value = _uiState.value.copy(
                        isIncomingCall = true,
                        callData = callData,
                        callerName = callData.callerName,
                        isVideoCall = callData.callType == CallType.VIDEO,
                        callStatus = CallStatus.RINGING
                    )
                    // Start foreground service for incoming call
                    CallService.startIncomingCall(
                        context,
                        callData.callerName,
                        callData.callType == CallType.VIDEO
                    )
                }
            }
        }
    }

    /**
     * Initiate an outgoing call.
     */
    fun startCall(
        calleeId: String,
        calleeName: String,
        roomId: String,
        isVideo: Boolean
    ) {
        val currentUser = FirebaseAuth.getInstance().currentUser ?: return
        val callId = UUID.randomUUID().toString()
        currentCallId = callId
        isCaller = true

        val callData = CallData(
            callId = callId,
            callerId = currentUser.uid,
            callerName = currentUser.displayName ?: "User",
            calleeId = calleeId,
            calleeName = calleeName,
            callType = if (isVideo) CallType.VIDEO else CallType.AUDIO,
            status = CallStatus.RINGING,
            roomId = roomId
        )

        _uiState.value = _uiState.value.copy(
            isInCall = true,
            isOutgoingCall = true,
            isIncomingCall = false,
            callData = callData,
            callerName = calleeName,
            isVideoCall = isVideo,
            isCameraOn = isVideo,
            callStatus = CallStatus.RINGING
        )

        // Start foreground service
        CallService.startOutgoingCall(context, calleeName, isVideo)

        viewModelScope.launch {
            try {
                // Create call in Firestore
                signalingService.createCall(callData)

                // Initialize WebRTC
                initializeWebRTC(isVideo)

                // Create offer
                webRTCEngine?.createOffer { sdp ->
                    viewModelScope.launch {
                        signalingService.setOffer(callId, sdp.description)
                    }
                }

                // Listen for call updates (answer, status changes)
                listenForCallUpdates(callId)

                // Listen for callee ICE candidates
                listenForCalleeCandidates(callId)

                // Auto-end call after 60s if not answered
                viewModelScope.launch {
                    delay(60_000)
                    if (_uiState.value.callStatus == CallStatus.RINGING) {
                        Log.d(TAG, "Call timeout - not answered")
                        endCall(CallStatus.MISSED)
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start call", e)
                endCall(CallStatus.ENDED)
            }
        }
    }

    /**
     * Answer an incoming call.
     */
    fun answerCall() {
        val callData = _uiState.value.callData ?: return
        val callId = callData.callId
        currentCallId = callId
        isCaller = false
        val isVideo = callData.callType == CallType.VIDEO

        _uiState.value = _uiState.value.copy(
            isInCall = true,
            isIncomingCall = false,
            isOutgoingCall = false,
            callStatus = CallStatus.ANSWERED,
            isCameraOn = isVideo
        )

        // Switch to active call foreground notification
        CallService.startOutgoingCall(context, callData.callerName, isVideo)

        viewModelScope.launch {
            try {
                // Initialize WebRTC
                initializeWebRTC(isVideo)

                // Set remote description (offer from caller)
                if (callData.offerSdp.isNotEmpty()) {
                    webRTCEngine?.setRemoteDescription(
                        SessionDescription(SessionDescription.Type.OFFER, callData.offerSdp)
                    )
                }

                // Create answer
                webRTCEngine?.createAnswer { sdp ->
                    viewModelScope.launch {
                        signalingService.setAnswer(callId, sdp.description)
                    }
                }

                // Listen for call updates
                listenForCallUpdates(callId)

                // Listen for caller ICE candidates
                listenForCallerCandidates(callId)

            } catch (e: Exception) {
                Log.e(TAG, "Failed to answer call", e)
                endCall(CallStatus.ENDED)
            }
        }
    }

    /**
     * Reject an incoming call.
     */
    fun rejectCall() {
        val callData = _uiState.value.callData ?: _incomingCall.value ?: return
        viewModelScope.launch {
            try {
                signalingService.updateCallStatus(callData.callId, CallStatus.REJECTED)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to reject call", e)
            }
        }
        resetCallState()
    }

    /**
     * End the current call.
     */
    fun endCall(status: CallStatus = CallStatus.ENDED) {
        val callId = currentCallId ?: _uiState.value.callData?.callId
        if (callId != null) {
            viewModelScope.launch {
                try {
                    signalingService.updateCallStatus(callId, status)
                    // Clean up after a delay to ensure both sides process the status
                    delay(2000)
                    signalingService.cleanupCall(callId)
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to end call", e)
                }
            }
        }
        resetCallState()
    }

    /**
     * Toggle microphone mute.
     */
    fun toggleMute() {
        val newMuted = !_uiState.value.isMuted
        _uiState.value = _uiState.value.copy(isMuted = newMuted)
        webRTCEngine?.setMicEnabled(!newMuted)
    }

    /**
     * Toggle speaker.
     */
    fun toggleSpeaker() {
        val newSpeaker = !_uiState.value.isSpeakerOn
        _uiState.value = _uiState.value.copy(isSpeakerOn = newSpeaker)
        @Suppress("DEPRECATION")
        audioManager.isSpeakerphoneOn = newSpeaker
    }

    /**
     * Toggle camera (video calls only).
     */
    fun toggleCamera() {
        val newCameraOn = !_uiState.value.isCameraOn
        _uiState.value = _uiState.value.copy(isCameraOn = newCameraOn)
        webRTCEngine?.setCameraEnabled(newCameraOn)
    }

    /**
     * Switch front/back camera.
     */
    fun switchCamera() {
        webRTCEngine?.switchCamera()
    }

    fun getEglBaseContext() = webRTCEngine?.getEglBaseContext()

    private fun initializeWebRTC(isVideo: Boolean) {
        webRTCEngine = WebRTCEngine(context).apply {
            initialize()
            createPeerConnection()

            onIceCandidate = { candidate ->
                viewModelScope.launch {
                    val callId = currentCallId ?: return@launch
                    try {
                        if (isCaller) {
                            signalingService.addCallerCandidate(callId, candidate)
                        } else {
                            signalingService.addCalleeCandidate(callId, candidate)
                        }
                    } catch (e: Exception) {
                        Log.e(TAG, "Failed to send ICE candidate", e)
                    }
                }
            }

            onRemoteStream = { stream ->
                Log.d(TAG, "Remote stream received, video tracks: ${stream.videoTracks.size}")
                if (stream.videoTracks.isNotEmpty()) {
                    _uiState.value = _uiState.value.copy(
                        remoteVideoTrack = stream.videoTracks[0]
                    )
                }
            }

            onConnectionStateChange = { state ->
                Log.d(TAG, "Connection state changed: $state")
                when (state) {
                    PeerConnection.IceConnectionState.CONNECTED -> {
                        _uiState.value = _uiState.value.copy(
                            isConnected = true,
                            callStatus = CallStatus.ANSWERED
                        )
                        startCallTimer()
                    }
                    PeerConnection.IceConnectionState.DISCONNECTED,
                    PeerConnection.IceConnectionState.FAILED -> {
                        _uiState.value = _uiState.value.copy(isConnected = false)
                        endCall()
                    }
                    else -> {}
                }
            }

            onLocalVideoTrack = { track ->
                _uiState.value = _uiState.value.copy(localVideoTrack = track)
            }

            // Start media
            startLocalAudio()
            if (isVideo) {
                startLocalVideo()
            }
        }

        // Set speaker on for video calls by default
        if (isVideo) {
            @Suppress("DEPRECATION")
            audioManager.isSpeakerphoneOn = true
            _uiState.value = _uiState.value.copy(isSpeakerOn = true)
        }
    }

    private fun listenForCallUpdates(callId: String) {
        callListenerJob?.cancel()
        callListenerJob = viewModelScope.launch {
            signalingService.listenForCallUpdates(callId).collect { callData ->
                if (callData == null) return@collect

                when (callData.status) {
                    CallStatus.ANSWERED -> {
                        if (isCaller && callData.answerSdp.isNotEmpty()) {
                            // Caller receives the answer
                            webRTCEngine?.setRemoteDescription(
                                SessionDescription(SessionDescription.Type.ANSWER, callData.answerSdp)
                            )
                            _uiState.value = _uiState.value.copy(
                                callStatus = CallStatus.ANSWERED
                            )
                        }
                    }
                    CallStatus.REJECTED -> {
                        Log.d(TAG, "Call was rejected")
                        resetCallState()
                    }
                    CallStatus.ENDED -> {
                        Log.d(TAG, "Call ended by remote")
                        resetCallState()
                    }
                    CallStatus.MISSED -> {
                        Log.d(TAG, "Call was missed")
                        resetCallState()
                    }
                    else -> {}
                }
            }
        }
    }

    private fun listenForCalleeCandidates(callId: String) {
        candidateListenerJob?.cancel()
        candidateListenerJob = viewModelScope.launch {
            signalingService.listenForCalleeCandidates(callId).collect { candidate ->
                webRTCEngine?.addIceCandidate(candidate)
            }
        }
    }

    private fun listenForCallerCandidates(callId: String) {
        candidateListenerJob?.cancel()
        candidateListenerJob = viewModelScope.launch {
            signalingService.listenForCallerCandidates(callId).collect { candidate ->
                webRTCEngine?.addIceCandidate(candidate)
            }
        }
    }

    private fun startCallTimer() {
        timerJob?.cancel()
        timerJob = viewModelScope.launch {
            var seconds = 0L
            while (true) {
                _uiState.value = _uiState.value.copy(callDuration = seconds)
                delay(1000)
                seconds++
            }
        }
    }

    private fun resetCallState() {
        callListenerJob?.cancel()
        candidateListenerJob?.cancel()
        timerJob?.cancel()

        webRTCEngine?.dispose()
        webRTCEngine = null

        CallService.stop(context)

        currentCallId = null
        isCaller = false

        _uiState.value = CallUiState()
        _incomingCall.value = null
    }

    override fun onCleared() {
        super.onCleared()
        incomingCallListenerJob?.cancel()
        resetCallState()
    }
}
