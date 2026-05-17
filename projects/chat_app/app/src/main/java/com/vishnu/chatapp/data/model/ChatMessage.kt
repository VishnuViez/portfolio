package com.vishnu.chatapp.data.model

data class ChatMessage(
    val id: String = "",
    val senderId: String = "",
    val senderName: String = "",
    val content: String = "",
    val timestamp: Long = System.currentTimeMillis(),
    val type: MessageType = MessageType.TEXT,
    val isRead: Boolean = false,
    val roomId: String = ""
)

enum class MessageType { TEXT, IMAGE, SYSTEM }
