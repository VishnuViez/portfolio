package com.vishnu.chatapp.call.ui

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.*
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat

/**
 * Composable helper to request call permissions (camera + microphone).
 * Returns a lambda that triggers permission request and a state indicating if granted.
 */
@Composable
fun rememberCallPermissionState(
    isVideo: Boolean,
    onPermissionsGranted: () -> Unit
): () -> Unit {
    val context = LocalContext.current

    val permissions = remember(isVideo) {
        buildList {
            add(Manifest.permission.RECORD_AUDIO)
            if (isVideo) {
                add(Manifest.permission.CAMERA)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                add(Manifest.permission.BLUETOOTH_CONNECT)
            }
        }.toTypedArray()
    }

    val launcher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { results ->
        val allGranted = results.all { it.value }
        if (allGranted) {
            onPermissionsGranted()
        }
    }

    return {
        val allGranted = permissions.all {
            ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED
        }
        if (allGranted) {
            onPermissionsGranted()
        } else {
            launcher.launch(permissions)
        }
    }
}

fun hasCallPermissions(context: android.content.Context, isVideo: Boolean): Boolean {
    val hasAudio = ContextCompat.checkSelfPermission(
        context, Manifest.permission.RECORD_AUDIO
    ) == PackageManager.PERMISSION_GRANTED

    val hasCamera = if (isVideo) {
        ContextCompat.checkSelfPermission(
            context, Manifest.permission.CAMERA
        ) == PackageManager.PERMISSION_GRANTED
    } else true

    return hasAudio && hasCamera
}

