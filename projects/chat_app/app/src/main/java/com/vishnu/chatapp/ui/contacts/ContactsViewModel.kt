package com.vishnu.chatapp.ui.contacts

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vishnu.chatapp.data.model.ChatRoom
import com.vishnu.chatapp.data.model.User
import com.vishnu.chatapp.data.repository.AuthRepository
import com.vishnu.chatapp.data.repository.ChatRepository
import com.vishnu.chatapp.data.repository.UserRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

class ContactsViewModel : ViewModel() {

    private val userRepository = UserRepository()
    private val chatRepository = ChatRepository()
    private val authRepository = AuthRepository()

    private val _users = MutableStateFlow<List<User>>(emptyList())
    val users: StateFlow<List<User>> = _users.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private var allUsers: List<User> = emptyList()

    init {
        loadUsers()
    }

    private fun loadUsers() {
        val currentUserId = authRepository.currentUser?.uid ?: return
        viewModelScope.launch {
            _isLoading.value = true
            userRepository.getUsers()
                .catch { _isLoading.value = false }
                .collect { userList ->
                    // Exclude current user
                    allUsers = userList.filter { it.uid != currentUserId }
                    filterUsers(_searchQuery.value)
                    _isLoading.value = false
                }
        }
    }

    fun searchUsers(query: String) {
        _searchQuery.value = query
        filterUsers(query)
    }

    private fun filterUsers(query: String) {
        _users.value = if (query.isBlank()) {
            allUsers
        } else {
            allUsers.filter {
                it.displayName.contains(query, ignoreCase = true) ||
                        it.email.contains(query, ignoreCase = true)
            }
        }
    }

    suspend fun createChatWithUser(otherUser: User): String {
        val currentUserId = authRepository.currentUser?.uid ?: return ""
        val currentUserName = authRepository.currentUser?.displayName ?: "User"

        // Check if a 1:1 chat room already exists with this user
        val existingRoomId = chatRepository.findDirectChatRoom(currentUserId, otherUser.uid)
        if (existingRoomId != null) {
            return existingRoomId
        }

        val room = ChatRoom(
            name = otherUser.displayName,
            participants = listOf(currentUserId, otherUser.uid),
            participantNames = mapOf(
                currentUserId to currentUserName,
                otherUser.uid to otherUser.displayName
            ),
            isGroup = false,
            avatarUrl = otherUser.avatarUrl,
            lastMessageTime = System.currentTimeMillis()
        )

        return chatRepository.createChatRoom(room)
    }
}
