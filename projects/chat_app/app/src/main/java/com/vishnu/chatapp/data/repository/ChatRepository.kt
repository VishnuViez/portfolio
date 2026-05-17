package com.vishnu.chatapp.data.repository

import android.util.Log
import com.vishnu.chatapp.data.local.ChatDatabase
import com.vishnu.chatapp.data.local.MessageEntity
import com.vishnu.chatapp.data.model.ChatMessage
import com.vishnu.chatapp.data.model.ChatRoom
import com.vishnu.chatapp.data.model.MessageType
import com.vishnu.chatapp.data.remote.FirestoreService
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map

/**
 * Connection state based on Firestore real-time listener health.
 */
sealed class ConnectionState {
    data object Connected : ConnectionState()
    data object Disconnected : ConnectionState()
    data class Error(val message: String) : ConnectionState()
}

class ChatRepository(
    private val firestoreService: FirestoreService = FirestoreService(),
    private val database: ChatDatabase? = null
) {

    private val messageDao = database?.messageDao()

    private val _connectionState = MutableStateFlow<ConnectionState>(ConnectionState.Disconnected)
    val connectionState: StateFlow<ConnectionState> = _connectionState.asStateFlow()

    fun getChatRooms(userId: String): Flow<List<ChatRoom>> {
        Log.d("ChatRepository", "getChatRooms for user=$userId")
        return firestoreService.getChatRooms(userId)
    }

    fun getMessages(roomId: String): Flow<List<ChatMessage>> {
        Log.d("ChatRepository", "getMessages for room=$roomId")
        return firestoreService.getMessages(roomId)
    }

    fun getCachedMessages(roomId: String): Flow<List<ChatMessage>>? {
        return messageDao?.getMessagesForRoom(roomId)?.map { entities ->
            entities.map { it.toChatMessage() }
        }
    }

    suspend fun sendMessage(roomId: String, message: ChatMessage) {
        Log.d("ChatRepository", "sendMessage to room=$roomId, sender=${message.senderId}")
        // Send to Firestore — the real-time snapshot listener will deliver it to all participants
        firestoreService.sendMessage(roomId, message)
        Log.d("ChatRepository", "sendMessage: Firestore write complete for room=$roomId")

        // Cache locally
        messageDao?.insertMessage(message.toEntity())
    }

    suspend fun cacheMessages(messages: List<ChatMessage>) {
        messageDao?.insertMessages(messages.map { it.toEntity() })
    }

    suspend fun createChatRoom(room: ChatRoom): String {
        return firestoreService.createChatRoom(room)
    }

    suspend fun findDirectChatRoom(userId1: String, userId2: String): String? {
        return firestoreService.findDirectChatRoom(userId1, userId2)
    }

    /**
     * Get a chat room by its ID.
     */
    suspend fun getChatRoom(roomId: String): ChatRoom? {
        return firestoreService.getChatRoom(roomId)
    }

    /**
     * Called when Firestore snapshot listener successfully delivers data.
     */
    fun markConnected() {
        _connectionState.value = ConnectionState.Connected
    }

    /**
     * Called when Firestore snapshot listener reports an error.
     */
    fun markError(message: String) {
        _connectionState.value = ConnectionState.Error(message)
    }

    suspend fun markMessagesAsRead(roomId: String) {
        messageDao?.markMessagesAsRead(roomId)
    }

    suspend fun deleteChatRoom(roomId: String) {
        Log.d("ChatRepository", "deleteChatRoom: room=$roomId")
        firestoreService.deleteChatRoom(roomId)
        messageDao?.deleteMessagesForRoom(roomId)
    }

    suspend fun blockUser(currentUserId: String, blockedUserId: String) {
        Log.d("ChatRepository", "blockUser: $currentUserId blocking $blockedUserId")
        firestoreService.blockUser(currentUserId, blockedUserId)
    }
}

private fun ChatMessage.toEntity() = MessageEntity(
    id = id,
    roomId = roomId,
    senderId = senderId,
    senderName = senderName,
    content = content,
    timestamp = timestamp,
    type = type.name,
    isRead = isRead
)

private fun MessageEntity.toChatMessage() = ChatMessage(
    id = id,
    roomId = roomId,
    senderId = senderId,
    senderName = senderName,
    content = content,
    timestamp = timestamp,
    type = try { MessageType.valueOf(type) } catch (_: Exception) { MessageType.TEXT },
    isRead = isRead
)
