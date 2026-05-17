package com.vishnu.chatapp.data.repository

import com.google.firebase.auth.FirebaseUser
import com.vishnu.chatapp.data.model.User
import com.vishnu.chatapp.data.remote.ChatFCMService
import com.vishnu.chatapp.data.remote.FirebaseAuthService
import com.vishnu.chatapp.data.remote.FirestoreService
import kotlinx.coroutines.flow.Flow
import android.util.Log

class AuthRepository(
    private val authService: FirebaseAuthService = FirebaseAuthService(),
    private val firestoreService: FirestoreService = FirestoreService()
) {

    val currentUser: FirebaseUser?
        get() = authService.currentUser

    val authState: Flow<FirebaseUser?> = authService.authState

    suspend fun signIn(email: String, password: String): Result<FirebaseUser> {
        val result = authService.signIn(email, password)
        result.getOrNull()?.let { user ->
            // Best-effort Firestore sync — must not block login
            try {
                val existing = firestoreService.getUser(user.uid)
                if (existing == null) {
                    val newUser = User(
                        uid = user.uid,
                        displayName = user.displayName ?: "User",
                        email = user.email ?: email,
                        status = "online"
                    )
                    firestoreService.createOrUpdateUser(newUser)
                } else {
                    firestoreService.updateUserStatus(user.uid, "online")
                }
            } catch (e: Exception) {
                Log.w("AuthRepository", "Firestore sync failed on sign-in (non-fatal)", e)
            }
            // Save FCM token after successful sign-in
            ChatFCMService.saveFcmTokenToFirestore()
        }
        return result
    }

    suspend fun signUp(email: String, password: String, displayName: String): Result<FirebaseUser> {
        val result = authService.signUp(email, password, displayName)
        result.getOrNull()?.let { firebaseUser ->
            // Best-effort Firestore sync — must not block sign-up
            try {
                val user = User(
                    uid = firebaseUser.uid,
                    displayName = displayName,
                    email = email,
                    status = "online"
                )
                firestoreService.createOrUpdateUser(user)
            } catch (e: Exception) {
                Log.w("AuthRepository", "Firestore sync failed on sign-up (non-fatal)", e)
            }
            // Save FCM token after successful sign-up
            ChatFCMService.saveFcmTokenToFirestore()
        }
        return result
    }

    suspend fun signOut() {
        // Remove FCM token before signing out so the user stops receiving notifications
        ChatFCMService.removeFcmTokenFromFirestore()
        try {
            currentUser?.uid?.let { uid ->
                firestoreService.updateUserStatus(uid, "offline")
            }
        } catch (e: Exception) {
            Log.w("AuthRepository", "Failed to update status on sign-out", e)
        }
        authService.signOut()
    }

    /**
     * Ensures the currently signed-in user has a document in the Firestore
     * "users" collection. Call this on every app launch so that every
     * authenticated user is discoverable in the contacts list.
     */
    suspend fun ensureCurrentUserInFirestore() {
        val firebaseUser = authService.currentUser ?: return
        try {
            val existing = firestoreService.getUser(firebaseUser.uid)
            if (existing == null) {
                val user = User(
                    uid = firebaseUser.uid,
                    displayName = firebaseUser.displayName ?: "User",
                    email = firebaseUser.email ?: "",
                    status = "online"
                )
                firestoreService.createOrUpdateUser(user)
            } else {
                firestoreService.updateUserStatus(firebaseUser.uid, "online")
            }
        } catch (e: Exception) {
            Log.w("AuthRepository", "ensureCurrentUserInFirestore failed (non-fatal)", e)
        }
    }
}
