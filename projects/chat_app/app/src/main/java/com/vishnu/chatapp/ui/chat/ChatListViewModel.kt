package com.vishnu.chatapp.ui.chat

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vishnu.chatapp.data.model.ChatRoom
import com.vishnu.chatapp.data.repository.AuthRepository
import com.vishnu.chatapp.data.repository.ChatRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

class ChatListViewModel : ViewModel() {

    private val chatRepository = ChatRepository()
    private val authRepository = AuthRepository()

    private val _chatRooms = MutableStateFlow<List<ChatRoom>>(emptyList())
    val chatRooms: StateFlow<List<ChatRoom>> = _chatRooms.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private var allRooms: List<ChatRoom> = emptyList()

    private val currentUserId: String
        get() = authRepository.currentUser?.uid ?: ""

    init {
        loadChatRooms()
    }

    private fun loadChatRooms() {
        val userId = authRepository.currentUser?.uid ?: return
        Log.d("ChatListViewModel", "loadChatRooms: starting for user=$userId")
        viewModelScope.launch {
            _isLoading.value = true
            chatRepository.getChatRooms(userId)
                .catch { e ->
                    Log.e("ChatListViewModel", "loadChatRooms error", e)
                    _isLoading.value = false
                }
                .collect { rooms ->
                    Log.d("ChatListViewModel", "loadChatRooms: received ${rooms.size} rooms")
                    // For 1:1 chats, resolve the display name so each user sees
                    // the OTHER person's name, not their own.
                    allRooms = rooms.map { room ->
                        if (!room.isGroup && room.participantNames.isNotEmpty()) {
                            val otherName = room.participantNames.entries
                                .firstOrNull { it.key != currentUserId }?.value
                            if (otherName != null) room.copy(name = otherName) else room
                        } else {
                            room
                        }
                    }
                    filterRooms(_searchQuery.value)
                    _isLoading.value = false
                }
        }
    }

    fun searchRooms(query: String) {
        _searchQuery.value = query
        filterRooms(query)
    }

    fun deleteChatRoom(roomId: String) {
        viewModelScope.launch {
            try {
                chatRepository.deleteChatRoom(roomId)
                Log.d("ChatListViewModel", "deleteChatRoom: deleted room=$roomId")
            } catch (e: Exception) {
                Log.e("ChatListViewModel", "deleteChatRoom: failed", e)
            }
        }
    }

    private fun filterRooms(query: String) {
        _chatRooms.value = if (query.isBlank()) {
            allRooms
        } else {
            allRooms.filter {
                it.name.contains(query, ignoreCase = true) ||
                        it.lastMessage.contains(query, ignoreCase = true)
            }
        }
    }
}
