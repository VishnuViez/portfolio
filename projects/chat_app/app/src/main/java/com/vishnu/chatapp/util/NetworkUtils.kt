package com.vishnu.chatapp.util

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.util.Log
import com.vishnu.chatapp.ChatApp

/**
 * Small utility to check network connectivity using the application's Context.
 * This centralizes connectivity checks so other classes can reuse it.
 */
object NetworkUtils {

    /**
     * Returns true if the device has an active validated network with Internet capability.
     * Uses the Application context (ChatApp.instance).
     */
    fun isNetworkConnected(): Boolean {
        return try {
            val context: Context = ChatApp.instance
            val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
                ?: run {
                    Log.w("NetworkUtils", "ConnectivityManager not available")
                    return false
                }
            val activeNetwork = cm.activeNetwork ?: return false
            val nc = cm.getNetworkCapabilities(activeNetwork) ?: return false
            val hasInternet = nc.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            val isValidated = nc.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
            val connected = hasInternet && isValidated
            Log.d("NetworkUtils", "networkConnected=$connected (internet=$hasInternet, validated=$isValidated)")
            connected
        } catch (ex: Exception) {
            Log.w("NetworkUtils", "network connectivity check failed", ex)
            false
        }
    }
}

