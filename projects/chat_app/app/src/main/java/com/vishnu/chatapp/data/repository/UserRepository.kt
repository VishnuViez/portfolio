package com.vishnu.chatapp.data.repository

import com.vishnu.chatapp.data.model.User
import com.vishnu.chatapp.data.remote.FirestoreService
import kotlinx.coroutines.flow.Flow

class UserRepository(
    private val firestoreService: FirestoreService = FirestoreService()
) {

    fun getUsers(): Flow<List<User>> {
        return firestoreService.getUsers()
    }

    suspend fun getUser(userId: String): User? {
        return firestoreService.getUser(userId)
    }

    suspend fun updateUserStatus(userId: String, status: String) {
        firestoreService.updateUserStatus(userId, status)
    }

    suspend fun updateUser(user: User) {
        firestoreService.createOrUpdateUser(user)
    }
}
