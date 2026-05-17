package com.vishnu.chatapp.call.ui

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import com.vishnu.chatapp.call.CallUiState
import com.vishnu.chatapp.data.model.CallStatus
import org.webrtc.EglBase
import org.webrtc.RendererCommon
import org.webrtc.SurfaceViewRenderer
import org.webrtc.VideoTrack

/**
 * Active call screen — shows controls for ongoing audio/video call (WhatsApp-style).
 */
@Composable
fun ActiveCallScreen(
    uiState: CallUiState,
    eglBaseContext: EglBase.Context?,
    onEndCall: () -> Unit,
    onToggleMute: () -> Unit,
    onToggleSpeaker: () -> Unit,
    onToggleCamera: () -> Unit,
    onSwitchCamera: () -> Unit
) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF1A1A2E),
                        Color(0xFF16213E),
                        Color(0xFF0F3460)
                    )
                )
            )
    ) {
        if (uiState.isVideoCall) {
            VideoCallContent(
                uiState = uiState,
                eglBaseContext = eglBaseContext,
                onEndCall = onEndCall,
                onToggleMute = onToggleMute,
                onToggleSpeaker = onToggleSpeaker,
                onToggleCamera = onToggleCamera,
                onSwitchCamera = onSwitchCamera
            )
        } else {
            AudioCallContent(
                uiState = uiState,
                onEndCall = onEndCall,
                onToggleMute = onToggleMute,
                onToggleSpeaker = onToggleSpeaker
            )
        }
    }
}

@Composable
private fun AudioCallContent(
    uiState: CallUiState,
    onEndCall: () -> Unit,
    onToggleMute: () -> Unit,
    onToggleSpeaker: () -> Unit
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(80.dp))

        // Call status
        Text(
            text = getStatusText(uiState),
            color = Color.White.copy(alpha = 0.6f),
            fontSize = 14.sp
        )

        Spacer(modifier = Modifier.height(32.dp))

        // Avatar
        Box(
            modifier = Modifier
                .size(120.dp)
                .clip(CircleShape)
                .background(
                    Brush.linearGradient(
                        colors = listOf(Color(0xFF6C63FF), Color(0xFFFF6584))
                    )
                ),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = uiState.callerName.firstOrNull()?.uppercase() ?: "?",
                color = Color.White,
                fontSize = 48.sp,
                fontWeight = FontWeight.Bold
            )
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Name
        Text(
            text = uiState.callerName,
            color = Color.White,
            fontSize = 26.sp,
            fontWeight = FontWeight.Bold,
            textAlign = TextAlign.Center
        )

        Spacer(modifier = Modifier.height(8.dp))

        // Duration or status
        Text(
            text = if (uiState.isConnected) formatDuration(uiState.callDuration) else getStatusText(uiState),
            color = Color.White.copy(alpha = 0.7f),
            fontSize = 16.sp
        )

        Spacer(modifier = Modifier.weight(1f))

        // Controls
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 40.dp),
            horizontalArrangement = Arrangement.SpaceEvenly,
            verticalAlignment = Alignment.CenterVertically
        ) {
            CallControlButton(
                icon = if (uiState.isMuted) Icons.Default.MicOff else Icons.Default.Mic,
                label = if (uiState.isMuted) "Unmute" else "Mute",
                isActive = uiState.isMuted,
                onClick = onToggleMute
            )

            CallControlButton(
                icon = if (uiState.isSpeakerOn) Icons.Default.VolumeUp else Icons.Default.VolumeDown,
                label = "Speaker",
                isActive = uiState.isSpeakerOn,
                onClick = onToggleSpeaker
            )
        }

        Spacer(modifier = Modifier.height(40.dp))

        // End call button
        IconButton(
            onClick = onEndCall,
            modifier = Modifier
                .size(70.dp)
                .clip(CircleShape)
                .background(Color(0xFFFF3B30))
        ) {
            Icon(
                imageVector = Icons.Default.CallEnd,
                contentDescription = "End Call",
                tint = Color.White,
                modifier = Modifier.size(32.dp)
            )
        }

        Spacer(modifier = Modifier.height(50.dp))
    }
}

@Composable
private fun VideoCallContent(
    uiState: CallUiState,
    eglBaseContext: EglBase.Context?,
    onEndCall: () -> Unit,
    onToggleMute: () -> Unit,
    onToggleSpeaker: () -> Unit,
    onToggleCamera: () -> Unit,
    onSwitchCamera: () -> Unit
) {
    Box(modifier = Modifier.fillMaxSize()) {
        // Remote video (full screen)
        if (uiState.remoteVideoTrack != null && eglBaseContext != null) {
            WebRTCVideoView(
                videoTrack = uiState.remoteVideoTrack,
                eglBaseContext = eglBaseContext,
                modifier = Modifier.fillMaxSize(),
                isMirror = false
            )
        } else {
            // Placeholder when no remote video
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color(0xFF1A1A2E)),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Box(
                        modifier = Modifier
                            .size(100.dp)
                            .clip(CircleShape)
                            .background(
                                Brush.linearGradient(
                                    colors = listOf(Color(0xFF6C63FF), Color(0xFFFF6584))
                                )
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = uiState.callerName.firstOrNull()?.uppercase() ?: "?",
                            color = Color.White,
                            fontSize = 40.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                    Spacer(modifier = Modifier.height(16.dp))
                    Text(
                        text = uiState.callerName,
                        color = Color.White,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.Bold
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = if (uiState.isConnected) formatDuration(uiState.callDuration) else getStatusText(uiState),
                        color = Color.White.copy(alpha = 0.7f),
                        fontSize = 14.sp
                    )
                }
            }
        }

        // Local video (picture-in-picture, top right)
        if (uiState.localVideoTrack != null && uiState.isCameraOn && eglBaseContext != null) {
            Box(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(top = 60.dp, end = 16.dp)
                    .size(width = 110.dp, height = 150.dp)
                    .clip(RoundedCornerShape(12.dp))
            ) {
                WebRTCVideoView(
                    videoTrack = uiState.localVideoTrack,
                    eglBaseContext = eglBaseContext,
                    modifier = Modifier.fillMaxSize(),
                    isMirror = true
                )
            }
        }

        // Top bar with name and duration
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 50.dp, start = 16.dp, end = 16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = uiState.callerName,
                    color = Color.White,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.SemiBold
                )
                Text(
                    text = if (uiState.isConnected) formatDuration(uiState.callDuration) else getStatusText(uiState),
                    color = Color.White.copy(alpha = 0.7f),
                    fontSize = 13.sp
                )
            }
        }

        // Bottom controls
        Column(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .background(
                    Brush.verticalGradient(
                        colors = listOf(Color.Transparent, Color.Black.copy(alpha = 0.7f))
                    )
                )
                .padding(bottom = 40.dp, top = 20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                CallControlButton(
                    icon = if (uiState.isCameraOn) Icons.Default.Videocam else Icons.Default.VideocamOff,
                    label = "Camera",
                    isActive = !uiState.isCameraOn,
                    onClick = onToggleCamera
                )

                CallControlButton(
                    icon = if (uiState.isMuted) Icons.Default.MicOff else Icons.Default.Mic,
                    label = if (uiState.isMuted) "Unmute" else "Mute",
                    isActive = uiState.isMuted,
                    onClick = onToggleMute
                )

                CallControlButton(
                    icon = Icons.Default.FlipCameraAndroid,
                    label = "Flip",
                    isActive = false,
                    onClick = onSwitchCamera
                )

                CallControlButton(
                    icon = if (uiState.isSpeakerOn) Icons.Default.VolumeUp else Icons.Default.VolumeDown,
                    label = "Speaker",
                    isActive = uiState.isSpeakerOn,
                    onClick = onToggleSpeaker
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            // End call button
            IconButton(
                onClick = onEndCall,
                modifier = Modifier
                    .size(65.dp)
                    .clip(CircleShape)
                    .background(Color(0xFFFF3B30))
            ) {
                Icon(
                    imageVector = Icons.Default.CallEnd,
                    contentDescription = "End Call",
                    tint = Color.White,
                    modifier = Modifier.size(30.dp)
                )
            }
        }
    }
}

@Composable
private fun CallControlButton(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    label: String,
    isActive: Boolean,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        IconButton(
            onClick = onClick,
            modifier = Modifier
                .size(52.dp)
                .clip(CircleShape)
                .background(
                    if (isActive) Color.White.copy(alpha = 0.3f)
                    else Color.White.copy(alpha = 0.1f)
                )
        ) {
            Icon(
                imageVector = icon,
                contentDescription = label,
                tint = Color.White,
                modifier = Modifier.size(24.dp)
            )
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(
            text = label,
            color = Color.White.copy(alpha = 0.7f),
            fontSize = 11.sp
        )
    }
}

@Composable
fun WebRTCVideoView(
    videoTrack: VideoTrack,
    eglBaseContext: EglBase.Context,
    modifier: Modifier = Modifier,
    isMirror: Boolean = false
) {
    val context = LocalContext.current
    var renderer by remember { mutableStateOf<SurfaceViewRenderer?>(null) }

    DisposableEffect(videoTrack) {
        onDispose {
            try {
                videoTrack.removeSink(renderer)
                renderer?.release()
            } catch (_: Exception) {}
        }
    }

    AndroidView(
        factory = {
            SurfaceViewRenderer(context).apply {
                init(eglBaseContext, null)
                setScalingType(RendererCommon.ScalingType.SCALE_ASPECT_FILL)
                setMirror(isMirror)
                setEnableHardwareScaler(true)
                renderer = this
                videoTrack.addSink(this)
            }
        },
        modifier = modifier
    )
}

private fun getStatusText(uiState: CallUiState): String {
    return when {
        uiState.isOutgoingCall && uiState.callStatus == CallStatus.RINGING -> "Calling..."
        uiState.callStatus == CallStatus.RINGING -> "Ringing..."
        uiState.isConnected -> "Connected"
        uiState.callStatus == CallStatus.ANSWERED -> "Connecting..."
        else -> "Calling..."
    }
}

private fun formatDuration(seconds: Long): String {
    val hrs = seconds / 3600
    val mins = (seconds % 3600) / 60
    val secs = seconds % 60
    return if (hrs > 0) {
        String.format("%d:%02d:%02d", hrs, mins, secs)
    } else {
        String.format("%02d:%02d", mins, secs)
    }
}

