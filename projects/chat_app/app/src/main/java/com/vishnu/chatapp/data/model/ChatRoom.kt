package com.vishnu.chatapp.data.model

data class ChatRoom(
    val id: String = "",
    val name: String = "",
    val participants: List<String> = emptyList(),
    val participantNames: Map<String, String> = emptyMap(),
    val lastMessage: String = "",
    val lastMessageTime: Long = 0,
    val lastMessageSenderId: String = "",
    val unreadCount: Int = 0,
    val isGroup: Boolean = false,
    val avatarUrl: String = ""
)
