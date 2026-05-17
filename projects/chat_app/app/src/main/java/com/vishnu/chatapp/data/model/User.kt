package com.vishnu.chatapp.data.model

data class User(
    val uid: String = "",
    val displayName: String = "",
    val email: String = "",
    val avatarUrl: String = "",
    val status: String = "offline",
    val lastSeen: Long = System.currentTimeMillis(),
    val fcmToken: String = ""
)
