package com.vishnu.chatapp.ui.chat

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vishnu.chatapp.data.model.ChatMessage
import com.vishnu.chatapp.data.model.MessageType
import com.vishnu.chatapp.data.repository.AuthRepository
import com.vishnu.chatapp.data.repository.ChatRepository
import com.vishnu.chatapp.data.repository.ConnectionState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch
import java.util.UUID

class ChatViewModel : ViewModel() {

    private val chatRepository = ChatRepository()
    private val authRepository = AuthRepository()

    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages: StateFlow<List<ChatMessage>> = _messages.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _connectionState = MutableStateFlow<ConnectionState>(
        ConnectionState.Disconnected
    )
    val connectionState: StateFlow<ConnectionState> = _connectionState.asStateFlow()

    private val _isTyping = MutableStateFlow(false)
    val isTyping: StateFlow<Boolean> = _isTyping.asStateFlow()

    private var currentRoomId: String = ""

    fun loadMessages(roomId: String) {
        if (currentRoomId == roomId) return // Already listening
        currentRoomId = roomId
        Log.d("ChatViewModel", "loadMessages: starting for room=$roomId")

        viewModelScope.launch {
            _isLoading.value = true
            chatRepository.getMessages(roomId)
                .catch { e ->
                    Log.e("ChatViewModel", "loadMessages error for room=$roomId", e)
                    _isLoading.value = false
                    _connectionState.value = ConnectionState.Error(e.message ?: "Unknown error")
                    chatRepository.markError(e.message ?: "Unknown error")
                }
                .collect { messageList ->
                    Log.d("ChatViewModel", "loadMessages: received ${messageList.size} messages for room=$roomId")
                    _messages.value = messageList
                    _isLoading.value = false
                    _connectionState.value = ConnectionState.Connected
                    chatRepository.markConnected()
                    // Cache messages locally
                    chatRepository.cacheMessages(messageList)
                }
        }

        // Also observe the repository-level connection state
        viewModelScope.launch {
            chatRepository.connectionState.collect { state ->
                _connectionState.value = state
            }
        }
    }

    fun sendMessage(text: String) {
        if (text.isBlank()) return

        val currentUser = authRepository.currentUser ?: return
        val message = ChatMessage(
            id = UUID.randomUUID().toString(),
            senderId = currentUser.uid,
            senderName = currentUser.displayName ?: "User",
            content = text,
            timestamp = System.currentTimeMillis(),
            type = MessageType.TEXT,
            roomId = currentRoomId
        )

        Log.d("ChatViewModel", "sendMessage: room=$currentRoomId content='$text'")
        viewModelScope.launch {
            try {
                chatRepository.sendMessage(currentRoomId, message)
                Log.d("ChatViewModel", "sendMessage: success")
            } catch (e: Exception) {
                Log.e("ChatViewModel", "sendMessage: failed", e)
                _connectionState.value = ConnectionState.Error(e.message ?: "Send failed")
            }
        }
    }

    fun setTyping(typing: Boolean) {
        _isTyping.value = typing
    }

    fun markAsRead() {
        viewModelScope.launch {
            chatRepository.markMessagesAsRead(currentRoomId)
        }
    }

    fun deleteChatRoom(onComplete: () -> Unit) {
        viewModelScope.launch {
            try {
                chatRepository.deleteChatRoom(currentRoomId)
                Log.d("ChatViewModel", "deleteChatRoom: deleted room=$currentRoomId")
                onComplete()
            } catch (e: Exception) {
                Log.e("ChatViewModel", "deleteChatRoom: failed", e)
            }
        }
    }

    fun blockUser(onComplete: () -> Unit) {
        val currentUser = authRepository.currentUser ?: return
        // Find the other participant's ID from the messages
        val otherUserId = _messages.value
            .firstOrNull { it.senderId != currentUser.uid }?.senderId
        if (otherUserId == null) {
            Log.w("ChatViewModel", "blockUser: could not determine other user")
            onComplete()
            return
        }
        viewModelScope.launch {
            try {
                chatRepository.blockUser(currentUser.uid, otherUserId)
                chatRepository.deleteChatRoom(currentRoomId)
                Log.d("ChatViewModel", "blockUser: blocked $otherUserId and deleted room=$currentRoomId")
                onComplete()
            } catch (e: Exception) {
                Log.e("ChatViewModel", "blockUser: failed", e)
            }
        }
    }
}
