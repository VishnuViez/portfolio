package com.vishnu.chatapp.data.remote

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class ChatFCMService : FirebaseMessagingService() {

    companion object {
        private const val TAG = "ChatFCMService"
        private const val CHANNEL_ID = "chat_messages"
        private const val CHANNEL_NAME = "Chat Messages"
        private const val CALL_CHANNEL_ID = "incoming_calls"
        private const val CALL_CHANNEL_NAME = "Incoming Calls"

        /**
         * Save the current FCM token to the user's Firestore document.
         */
        fun saveFcmTokenToFirestore(token: String? = null) {
            val userId = FirebaseAuth.getInstance().currentUser?.uid ?: return
            val db = FirebaseFirestore.getInstance()

            if (token != null) {
                db.collection("users").document(userId)
                    .update("fcmToken", token)
                    .addOnSuccessListener { Log.d(TAG, "FCM token saved for user $userId") }
                    .addOnFailureListener { e -> Log.w(TAG, "Failed to save FCM token", e) }
            } else {
                com.google.firebase.messaging.FirebaseMessaging.getInstance().token
                    .addOnSuccessListener { newToken ->
                        db.collection("users").document(userId)
                            .update("fcmToken", newToken)
                            .addOnSuccessListener { Log.d(TAG, "FCM token saved for user $userId") }
                            .addOnFailureListener { e -> Log.w(TAG, "Failed to save FCM token", e) }
                    }
                    .addOnFailureListener { e -> Log.w(TAG, "Failed to get FCM token", e) }
            }
        }

        /**
         * Remove the FCM token from the user's Firestore document (e.g. on sign-out).
         */
        fun removeFcmTokenFromFirestore() {
            val userId = FirebaseAuth.getInstance().currentUser?.uid ?: return
            val db = FirebaseFirestore.getInstance()
            db.collection("users").document(userId)
                .update("fcmToken", "")
                .addOnFailureListener { e -> Log.w(TAG, "Failed to remove FCM token", e) }
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(TAG, "New FCM token: $token")
        saveFcmTokenToFirestore(token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        Log.d(TAG, "FCM message received: ${message.data}")

        val messageType = message.data["type"] ?: "chat"

        // Don't show notification for messages sent by the current user
        val senderId = message.data["senderId"] ?: ""
        val currentUserId = FirebaseAuth.getInstance().currentUser?.uid ?: ""
        if (senderId == currentUserId) return

        when (messageType) {
            "call" -> handleCallNotification(message.data)
            else -> handleChatNotification(message.data)
        }
    }

    private fun handleChatNotification(data: Map<String, String>) {
        val senderName = data["senderName"] ?: "New message"
        val content = data["content"] ?: ""
        val roomId = data["roomId"] ?: ""

        showChatNotification(senderName, content, roomId)
    }

    private fun handleCallNotification(data: Map<String, String>) {
        val callerName = data["callerName"] ?: "Unknown"
        val callType = data["callType"] ?: "AUDIO"
        val callId = data["callId"] ?: ""
        val isVideo = callType == "VIDEO"
        val typeLabel = if (isVideo) "Video" else "Audio"

        Log.d(TAG, "Incoming call notification: $callerName ($typeLabel), callId=$callId")

        // The actual incoming call handling is done via the Firestore listener
        // in CallViewModel. This notification serves as a wake-up for the device
        // and shows a heads-up notification.
        showCallNotification(callerName, typeLabel, callId)
    }

    private fun showChatNotification(title: String, body: String, roomId: String) {
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Chat message notifications"
                enableVibration(true)
            }
            notificationManager.createNotificationChannel(channel)
        }

        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("roomId", roomId)
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            roomId.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_email)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        notificationManager.notify(roomId.hashCode(), notification)
    }

    private fun showCallNotification(callerName: String, callType: String, callId: String) {
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CALL_CHANNEL_ID,
                CALL_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Incoming call notifications"
                enableVibration(true)
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
            }
            notificationManager.createNotificationChannel(channel)
        }

        val fullScreenIntent = PendingIntent.getActivity(
            this,
            callId.hashCode(),
            packageManager.getLaunchIntentForPackage(packageName)?.apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra("incoming_call", true)
                putExtra("callId", callId)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, CALL_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentTitle("Incoming $callType Call")
            .setContentText("$callerName is calling...")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setOngoing(true)
            .setAutoCancel(false)
            .setFullScreenIntent(fullScreenIntent, true)
            .setVibrate(longArrayOf(0, 500, 300, 500, 300, 500))
            .build()

        notificationManager.notify(callId.hashCode(), notification)
    }
}
