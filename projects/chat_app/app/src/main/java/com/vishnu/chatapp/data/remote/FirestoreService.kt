package com.vishnu.chatapp.data.remote

import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.Query
import com.vishnu.chatapp.data.model.ChatMessage
import com.vishnu.chatapp.data.model.ChatRoom
import com.vishnu.chatapp.data.model.User
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.tasks.await

class FirestoreService {

    private val db = FirebaseFirestore.getInstance()
    private val usersCollection = db.collection("users")
    private val roomsCollection = db.collection("chatRooms")

    /**
     * Listen for chat rooms that the given user participates in.
     *
     * NOTE: Firestore does NOT allow `whereArrayContains` + `orderBy` on a
     * different field without a composite index. Instead we fetch all rooms
     * the user is in and sort client-side. This avoids the silent
     * "requires index" error that was preventing rooms from appearing.
     */
    fun getChatRooms(userId: String): Flow<List<ChatRoom>> = callbackFlow {
        Log.d("FirestoreService", "getChatRooms: starting listener for user=$userId")

        val listener: ListenerRegistration = roomsCollection
            .whereArrayContains("participants", userId)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e("FirestoreService", "getChatRooms listener error: ${error.message}", error)
                    // Don't send emptyList on error — keep the previous data
                    return@addSnapshotListener
                }
                if (snapshot == null) {
                    Log.w("FirestoreService", "getChatRooms: snapshot is null")
                    trySend(emptyList())
                    return@addSnapshotListener
                }
                Log.d("FirestoreService", "getChatRooms: received ${snapshot.documents.size} rooms")
                val rooms = snapshot.documents.mapNotNull { doc ->
                    try {
                        doc.toObject(ChatRoom::class.java)?.copy(id = doc.id)
                    } catch (e: Exception) {
                        Log.w("FirestoreService", "Failed to parse room ${doc.id}", e)
                        null
                    }
                }
                // Sort client-side by lastMessageTime descending
                val sorted = rooms.sortedByDescending { it.lastMessageTime }
                trySend(sorted)
            }
        awaitClose {
            Log.d("FirestoreService", "getChatRooms: removing listener for user=$userId")
            listener.remove()
        }
    }

    fun getMessages(roomId: String): Flow<List<ChatMessage>> = callbackFlow {
        Log.d("FirestoreService", "getMessages: starting listener for room=$roomId")

        val listener: ListenerRegistration = roomsCollection.document(roomId)
            .collection("messages")
            .orderBy("timestamp", Query.Direction.ASCENDING)
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.e("FirestoreService", "getMessages listener error for room=$roomId: ${error.message}", error)
                    return@addSnapshotListener
                }
                if (snapshot == null) {
                    Log.w("FirestoreService", "getMessages: snapshot is null for room=$roomId")
                    trySend(emptyList())
                    return@addSnapshotListener
                }
                Log.d("FirestoreService", "getMessages: received ${snapshot.documents.size} messages for room=$roomId")
                val messages = snapshot.documents.mapNotNull { doc ->
                    try {
                        doc.toObject(ChatMessage::class.java)?.copy(id = doc.id)
                    } catch (e: Exception) {
                        Log.w("FirestoreService", "Failed to parse message ${doc.id}", e)
                        null
                    }
                }
                trySend(messages)
            }
        awaitClose {
            Log.d("FirestoreService", "getMessages: removing listener for room=$roomId")
            listener.remove()
        }
    }

    suspend fun sendMessage(roomId: String, message: ChatMessage) {
        Log.d("FirestoreService", "sendMessage: sending to room=$roomId content='${message.content}'")

        roomsCollection.document(roomId)
            .collection("messages")
            .add(message)
            .await()

        // Update last message in room — include sender info so chat list and
        // Cloud Functions can attribute the message correctly.
        roomsCollection.document(roomId).update(
            mapOf(
                "lastMessage" to message.content,
                "lastMessageTime" to message.timestamp,
                "lastMessageSenderId" to message.senderId,
                "lastMessageSenderName" to message.senderName
            )
        ).await()

        Log.d("FirestoreService", "sendMessage: success for room=$roomId")
    }

    suspend fun createChatRoom(room: ChatRoom): String {
        Log.d("FirestoreService", "createChatRoom: participants=${room.participants}")
        val docRef = roomsCollection.add(room).await()
        Log.d("FirestoreService", "createChatRoom: created id=${docRef.id}")
        return docRef.id
    }

    /**
     * Find an existing 1:1 (non-group) chat room between two users.
     * Returns the room ID if found, or null otherwise.
     *
     * NOTE: We only use `whereArrayContains` (no extra `whereEqualTo`) so
     * that Firestore does not require a composite index. The `isGroup` and
     * second-participant checks are done client-side.
     */
    suspend fun findDirectChatRoom(userId1: String, userId2: String): String? {
        Log.d("FirestoreService", "findDirectChatRoom: searching for room between $userId1 and $userId2")
        val snapshot = roomsCollection
            .whereArrayContains("participants", userId1)
            .get()
            .await()

        for (doc in snapshot.documents) {
            val isGroup = doc.getBoolean("isGroup") ?: false
            if (isGroup) continue
            val participants = doc.get("participants") as? List<*> ?: continue
            if (participants.contains(userId2) && participants.size == 2) {
                Log.d("FirestoreService", "findDirectChatRoom: found existing room ${doc.id}")
                return doc.id
            }
        }
        Log.d("FirestoreService", "findDirectChatRoom: no existing room found")
        return null
    }

    suspend fun updateUserStatus(userId: String, status: String) {
        usersCollection.document(userId).set(
            mapOf(
                "status" to status,
                "lastSeen" to System.currentTimeMillis()
            ),
            com.google.firebase.firestore.SetOptions.merge()
        ).await()
    }

    fun getUsers(): Flow<List<User>> = callbackFlow {
        val listener = usersCollection
            .addSnapshotListener { snapshot, error ->
                if (error != null) {
                    Log.w("FirestoreService", "getUsers listener error", error)
                    trySend(emptyList())
                    return@addSnapshotListener
                }
                val users = snapshot?.documents?.mapNotNull { doc ->
                    doc.toObject(User::class.java)?.copy(uid = doc.id)
                } ?: emptyList()
                trySend(users)
            }
        awaitClose { listener.remove() }
    }

    suspend fun createOrUpdateUser(user: User) {
        usersCollection.document(user.uid).set(user).await()
    }

    suspend fun getUser(userId: String): User? {
        return try {
            usersCollection.document(userId).get().await()
                .toObject(User::class.java)
        } catch (e: Exception) {
            Log.w("FirestoreService", "getUser failed for $userId", e)
            null
        }
    }

    /**
     * Get a chat room by its ID.
     */
    suspend fun getChatRoom(roomId: String): ChatRoom? {
        return try {
            val doc = roomsCollection.document(roomId).get().await()
            doc.toObject(ChatRoom::class.java)?.copy(id = doc.id)
        } catch (e: Exception) {
            Log.w("FirestoreService", "getChatRoom failed for $roomId", e)
            null
        }
    }

    /**
     * Delete a chat room and all its messages.
     */
    suspend fun deleteChatRoom(roomId: String) {
        Log.d("FirestoreService", "deleteChatRoom: deleting room=$roomId")
        // Delete all messages in the sub-collection first
        val messagesSnapshot = roomsCollection.document(roomId)
            .collection("messages")
            .get()
            .await()
        for (doc in messagesSnapshot.documents) {
            doc.reference.delete().await()
        }
        // Delete the room document itself
        roomsCollection.document(roomId).delete().await()
        Log.d("FirestoreService", "deleteChatRoom: deleted room=$roomId")
    }

    /**
     * Block a user by adding them to the current user's blockedUsers list.
     */
    suspend fun blockUser(currentUserId: String, blockedUserId: String) {
        Log.d("FirestoreService", "blockUser: $currentUserId blocking $blockedUserId")
        usersCollection.document(currentUserId).set(
            mapOf("blockedUsers" to com.google.firebase.firestore.FieldValue.arrayUnion(blockedUserId)),
            com.google.firebase.firestore.SetOptions.merge()
        ).await()
        Log.d("FirestoreService", "blockUser: done")
    }

    /**
     * Unblock a user.
     */
    suspend fun unblockUser(currentUserId: String, blockedUserId: String) {
        usersCollection.document(currentUserId).set(
            mapOf("blockedUsers" to com.google.firebase.firestore.FieldValue.arrayRemove(blockedUserId)),
            com.google.firebase.firestore.SetOptions.merge()
        ).await()
    }
}
