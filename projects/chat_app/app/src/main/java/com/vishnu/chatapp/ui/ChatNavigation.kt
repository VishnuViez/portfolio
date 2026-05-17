package com.vishnu.chatapp.ui

import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.google.firebase.auth.FirebaseAuth
import com.vishnu.chatapp.call.CallViewModel
import com.vishnu.chatapp.call.ui.ActiveCallScreen
import com.vishnu.chatapp.call.ui.IncomingCallScreen
import com.vishnu.chatapp.call.ui.rememberCallPermissionState
import com.vishnu.chatapp.data.repository.AuthRepository
import com.vishnu.chatapp.data.repository.ChatRepository
import com.vishnu.chatapp.ui.auth.LoginScreen
import com.vishnu.chatapp.ui.auth.RegisterScreen
import com.vishnu.chatapp.ui.chat.ChatListScreen
import com.vishnu.chatapp.ui.chat.ChatScreen
import com.vishnu.chatapp.ui.contacts.ContactsScreen
import com.vishnu.chatapp.ui.profile.ProfileScreen
import kotlinx.coroutines.launch

sealed class Screen(val route: String) {
    data object Login : Screen("login")
    data object Register : Screen("register")
    data object ChatList : Screen("chatList")
    data object Chat : Screen("chat/{roomId}/{receiverName}") {
        fun createRoute(roomId: String, receiverName: String) =
            "chat/$roomId/${java.net.URLEncoder.encode(receiverName, "UTF-8")}"
    }
    data object Profile : Screen("profile")
    data object Contacts : Screen("contacts")
    data object ActiveCall : Screen("activeCall")
    data object IncomingCall : Screen("incomingCall")
}

@Composable
fun ChatNavigation(navController: NavHostController) {
    val authRepository = AuthRepository()
    val startDestination = if (authRepository.currentUser != null) {
        Screen.ChatList.route
    } else {
        Screen.Login.route
    }

    // Shared CallViewModel scoped to the navigation graph
    val callViewModel: CallViewModel = viewModel()
    val callUiState by callViewModel.uiState.collectAsState()
    val incomingCall by callViewModel.incomingCall.collectAsState()
    val scope = rememberCoroutineScope()
    val chatRepository = ChatRepository()

    // Start listening for incoming calls when user is authenticated
    LaunchedEffect(authRepository.currentUser) {
        if (authRepository.currentUser != null) {
            callViewModel.startListeningForIncomingCalls()
        }
    }

    // Navigate to incoming call screen when a call comes in
    LaunchedEffect(incomingCall) {
        val call = incomingCall
        if (call != null && navController.currentDestination?.route != Screen.IncomingCall.route
            && navController.currentDestination?.route != Screen.ActiveCall.route
        ) {
            navController.navigate(Screen.IncomingCall.route)
        }
    }

    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Screen.Login.route) {
            LoginScreen(navController = navController)
        }

        composable(Screen.Register.route) {
            RegisterScreen(navController = navController)
        }

        composable(Screen.ChatList.route) {
            ChatListScreen(
                onChatClick = { roomId, receiverName ->
                    navController.navigate(Screen.Chat.createRoute(roomId, receiverName))
                },
                onProfileClick = {
                    navController.navigate(Screen.Profile.route)
                },
                onNewChatClick = {
                    navController.navigate(Screen.Contacts.route)
                }
            )
        }

        composable(
            route = Screen.Chat.route,
            arguments = listOf(
                navArgument("roomId") { type = NavType.StringType },
                navArgument("receiverName") { type = NavType.StringType }
            )
        ) { backStackEntry ->
            val roomId = backStackEntry.arguments?.getString("roomId") ?: return@composable
            val receiverName = backStackEntry.arguments?.getString("receiverName") ?: return@composable

            // Permission launchers for audio and video calls
            val requestAudioCallPermission = rememberCallPermissionState(isVideo = false) {
                scope.launch {
                    initiateCall(chatRepository, callViewModel, roomId, receiverName, isVideo = false)
                    navController.navigate(Screen.ActiveCall.route)
                }
            }
            val requestVideoCallPermission = rememberCallPermissionState(isVideo = true) {
                scope.launch {
                    initiateCall(chatRepository, callViewModel, roomId, receiverName, isVideo = true)
                    navController.navigate(Screen.ActiveCall.route)
                }
            }

            ChatScreen(
                roomId = roomId,
                receiverName = receiverName,
                onNavigateBack = { navController.popBackStack() },
                onAudioCall = { _, _ -> requestAudioCallPermission() },
                onVideoCall = { _, _ -> requestVideoCallPermission() }
            )
        }

        composable(Screen.Profile.route) {
            ProfileScreen(navController = navController)
        }

        composable(Screen.Contacts.route) {
            ContactsScreen(
                onNavigateBack = { navController.popBackStack() },
                onContactClick = { roomId, receiverName ->
                    navController.navigate(Screen.Chat.createRoute(roomId, receiverName)) {
                        popUpTo(Screen.ChatList.route)
                    }
                }
            )
        }

        composable(Screen.IncomingCall.route) {
            val call = callUiState.callData
            if (call == null) {
                // Call was cancelled before screen was shown
                LaunchedEffect(Unit) { navController.popBackStack() }
                return@composable
            }
            IncomingCallScreen(
                callerName = call.callerName,
                callType = call.callType,
                onAccept = {
                    callViewModel.answerCall()
                    navController.navigate(Screen.ActiveCall.route) {
                        popUpTo(Screen.IncomingCall.route) { inclusive = true }
                    }
                },
                onReject = {
                    callViewModel.rejectCall()
                    navController.popBackStack()
                }
            )
        }

        composable(Screen.ActiveCall.route) {
            // If call ended, navigate back
            if (!callUiState.isInCall && !callUiState.isOutgoingCall) {
                LaunchedEffect(Unit) {
                    navController.popBackStack()
                }
                return@composable
            }

            ActiveCallScreen(
                uiState = callUiState,
                eglBaseContext = callViewModel.getEglBaseContext(),
                onEndCall = {
                    callViewModel.endCall()
                    navController.popBackStack()
                },
                onToggleMute = { callViewModel.toggleMute() },
                onToggleSpeaker = { callViewModel.toggleSpeaker() },
                onToggleCamera = { callViewModel.toggleCamera() },
                onSwitchCamera = { callViewModel.switchCamera() }
            )
        }
    }
}

/**
 * Helper to resolve the receiver's user ID from the chat room and initiate a call.
 */
private suspend fun initiateCall(
    chatRepository: ChatRepository,
    callViewModel: CallViewModel,
    roomId: String,
    receiverName: String,
    isVideo: Boolean
) {
    val currentUserId = FirebaseAuth.getInstance().currentUser?.uid ?: return
    val room = chatRepository.getChatRoom(roomId) ?: return
    val receiverId = room.participants.firstOrNull { it != currentUserId } ?: return
    val decodedName = java.net.URLDecoder.decode(receiverName, "UTF-8")

    callViewModel.startCall(
        calleeId = receiverId,
        calleeName = decodedName,
        roomId = roomId,
        isVideo = isVideo
    )
}
