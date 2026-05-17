# Proguard rules for VChat

# Keep Firebase classes
-keepattributes Signature
-keepattributes *Annotation*

# Keep data model classes
-keep class com.vishnu.chatapp.data.model.** { *; }
-keep class com.vishnu.chatapp.data.local.MessageEntity { *; }

# OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }

# Gson
-keep class com.google.gson.** { *; }
-keepattributes EnclosingMethod

# Room
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class *

# WebRTC
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**
-keep class io.getstream.webrtc.** { *; }
