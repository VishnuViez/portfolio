package com.vishnu.chatapp.data.remote

import android.util.Log
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.UserProfileChangeRequest
import com.vishnu.chatapp.util.NetworkUtils
import com.vishnu.chatapp.BuildConfig
import kotlinx.coroutines.delay
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.tasks.await

class FirebaseAuthService {

    private val auth: FirebaseAuth = FirebaseAuth.getInstance()

    init {
        // Disable reCAPTCHA / app verification in debug builds to avoid
        // CONFIGURATION_NOT_FOUND errors when reCAPTCHA Enterprise is not
        // set up in the Firebase Console.
        if (BuildConfig.DEBUG) {
            auth.firebaseAuthSettings.setAppVerificationDisabledForTesting(true)
        }
    }

    val currentUser: FirebaseUser?
        get() = auth.currentUser

    val authState: Flow<FirebaseUser?> = callbackFlow {
        val listener = FirebaseAuth.AuthStateListener { firebaseAuth ->
            trySend(firebaseAuth.currentUser)
        }
        auth.addAuthStateListener(listener)
        awaitClose { auth.removeAuthStateListener(listener) }
    }

    private fun mapFirebaseError(e: Exception): Exception {
        val msg = e.message ?: ""

        // Explicit mapping for configuration not found related to reCAPTCHA / App Check
        if (msg.contains("CONFIGURATION_NOT_FOUND", ignoreCase = true) ||
            msg.contains("recaptcha", ignoreCase = true) && msg.contains("configuration", ignoreCase = true)
        ) {
            return Exception("Firebase Auth reCAPTCHA configuration not found. In the Firebase Console enable/configure reCAPTCHA (or App Check) for Authentication, or use the Auth emulator for development. See Firebase Console > Authentication > Sign-in method or App Check settings.")
        }

        // App Check provider missing
        if (msg.contains("No AppCheckProvider installed", ignoreCase = true) || msg.contains("AppCheck", ignoreCase = true) && msg.contains("not installed", ignoreCase = true)) {
            return Exception("No App Check provider installed. For development, install the Debug App Check provider or use the Auth emulator. See Firebase App Check docs.")
        }

        // Initialization/config issues
        if (msg.contains("Default FirebaseApp is not initialized", ignoreCase = true) ||
            msg.contains("FirebaseApp with name [DEFAULT] doesn't exist", ignoreCase = true) ||
            (msg.contains("configuration", ignoreCase = true) && msg.contains("not found", ignoreCase = true))
        ) {
            return Exception("Firebase not configured or initialized. Ensure app/google-services.json is present, the application class initializes Firebase, and the package name matches the json file.")
        }

        // Common network / ReCAPTCHA issues surfaced by Firebase SDK
        if (msg.contains("network error", ignoreCase = true) ||
            msg.contains("unreachable host", ignoreCase = true) ||
            msg.contains("timeout", ignoreCase = true) ||
            msg.contains("interrupted connection", ignoreCase = true) ||
            msg.contains("RecaptchaAction", ignoreCase = true)
        ) {
            return Exception("Network error while contacting reCAPTCHA/Firebase. Check device network connectivity, try again, or test on a device/emulator with Google Play Services.")
        }

        return e
    }

    suspend fun signIn(email: String, password: String): Result<FirebaseUser> {
        // Fast fail if no network
        if (!NetworkUtils.isNetworkConnected()) {
            Log.w("FirebaseAuthService", "signIn failed: no network")
            return Result.failure(Exception("No network connection. Please connect to the internet and try again."))
        }

        return try {
            val result = auth.signInWithEmailAndPassword(email, password).await()
            result.user?.let { Result.success(it) }
                ?: Result.failure(Exception("Sign in failed"))
        } catch (e: Exception) {
            val mapped = mapFirebaseError(e)
            Log.w("FirebaseAuthService", "signIn error: ${'$'}{mapped.message}")
            Result.failure(mapped)
        }
    }

    suspend fun signUp(email: String, password: String, displayName: String): Result<FirebaseUser> {
        // Fast fail if no network
        if (!NetworkUtils.isNetworkConnected()) {
            Log.w("FirebaseAuthService", "signUp failed: no network")
            return Result.failure(Exception("No network connection. Please connect to the internet and try again."))
        }

        // Simple retry on transient network/recaptcha failures
        val maxAttempts = 3
        var lastException: Exception? = null

        for (attempt in 1..maxAttempts) {
            try {
                Log.d("FirebaseAuthService", "signUp attempt $attempt")
                val result = auth.createUserWithEmailAndPassword(email, password).await()
                val user = result.user ?: return Result.failure(Exception("Sign up failed"))

                val profileUpdates = UserProfileChangeRequest.Builder()
                    .setDisplayName(displayName)
                    .build()
                user.updateProfile(profileUpdates).await()
                Log.i("FirebaseAuthService", "signUp successful for uid=${'$'}{user.uid}")
                return Result.success(user)
            } catch (e: Exception) {
                val mapped = mapFirebaseError(e)
                lastException = mapped
                Log.w("FirebaseAuthService", "signUp error on attempt $attempt: ${'$'}{mapped.message}", e)

                // If it's a network/recaptcha related message, retry after a short backoff.
                val msg = mapped.message ?: ""
                if (msg.contains("Network error", ignoreCase = true) || msg.contains("reCAPTCHA", ignoreCase = true) ||
                    msg.contains("recaptcha", ignoreCase = true) || msg.contains("network error", ignoreCase = true)
                ) {
                    if (attempt < maxAttempts) {
                        // exponential backoff: 1s, 2s
                        delay(1000L * attempt)
                        continue
                    }
                }

                // Non-retriable or out of attempts
                return Result.failure(mapped)
            }
        }

        return Result.failure(lastException ?: Exception("Sign up failed"))
    }

    fun signOut() {
        auth.signOut()
    }
}
