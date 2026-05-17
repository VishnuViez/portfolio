package com.vishnu.chatapp

import android.app.Application
import android.util.Log
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import com.vishnu.chatapp.BuildConfig

class ChatApp : Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this

        // Ensure Firebase is initialized early to avoid "configuration not found" errors
        try {
            FirebaseApp.initializeApp(this)
            val apps = FirebaseApp.getApps(this).joinToString { it.name }
            Log.i("ChatApp", "Firebase initialized: $apps")

            // Install debug App Check provider in debug builds so App Check won't block development flows.
            if (BuildConfig.DEBUG) {
                try {
                    val firebaseAppCheck = FirebaseAppCheck.getInstance()
                    firebaseAppCheck.installAppCheckProviderFactory(DebugAppCheckProviderFactory.getInstance())
                    Log.i("ChatApp", "Debug App Check provider installed")
                } catch (e: Exception) {
                    Log.w("ChatApp", "Failed to install Debug App Check provider", e)
                }
            }
        } catch (e: Exception) {
            Log.e("ChatApp", "Failed to initialize Firebase", e)
        }
    }

    companion object {
        lateinit var instance: ChatApp
            private set
    }
}
