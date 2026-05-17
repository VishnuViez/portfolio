package com.vishnu.chatapp.data.remote

import com.google.gson.Gson
import com.vishnu.chatapp.data.model.ChatMessage
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.receiveAsFlow
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import okhttp3.WebSocket
import okhttp3.WebSocketListener
import java.util.concurrent.TimeUnit

class WebSocketClient {

    private var webSocket: WebSocket? = null
    private val client = OkHttpClient.Builder()
        .readTimeout(0, TimeUnit.MILLISECONDS)
        .pingInterval(30, TimeUnit.SECONDS)
        .build()

    private val gson = Gson()

    private val _messages = Channel<ChatMessage>(Channel.BUFFERED)
    val messages: Flow<ChatMessage> = _messages.receiveAsFlow()

    private val _connectionState = Channel<ConnectionState>(Channel.CONFLATED)
    val connectionState: Flow<ConnectionState> = _connectionState.receiveAsFlow()

    private var serverUrl = "wss://echo.websocket.events"
    private var shouldReconnect = true

    fun connect(url: String = serverUrl) {
        serverUrl = url
        shouldReconnect = true

        val request = Request.Builder()
            .url(serverUrl)
            .build()

        webSocket = client.newWebSocket(request, object : WebSocketListener() {
            override fun onOpen(webSocket: WebSocket, response: Response) {
                _connectionState.trySend(ConnectionState.Connected)
            }

            override fun onMessage(webSocket: WebSocket, text: String) {
                try {
                    val message = gson.fromJson(text, ChatMessage::class.java)
                    _messages.trySend(message)
                } catch (e: Exception) {
                    // If not valid JSON, wrap as text message
                    val fallback = ChatMessage(
                        id = System.currentTimeMillis().toString(),
                        content = text,
                        timestamp = System.currentTimeMillis()
                    )
                    _messages.trySend(fallback)
                }
            }

            override fun onClosing(webSocket: WebSocket, code: Int, reason: String) {
                webSocket.close(1000, null)
                _connectionState.trySend(ConnectionState.Disconnected)
            }

            override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
                _connectionState.trySend(ConnectionState.Error(t.message ?: "Unknown error"))
                if (shouldReconnect) {
                    reconnect()
                }
            }
        })
    }

    fun sendMessage(message: ChatMessage) {
        val json = gson.toJson(message)
        webSocket?.send(json)
    }

    fun disconnect() {
        shouldReconnect = false
        webSocket?.close(1000, "User disconnected")
        webSocket = null
    }

    private fun reconnect() {
        Thread {
            Thread.sleep(3000)
            if (shouldReconnect) {
                connect(serverUrl)
            }
        }.start()
    }

    sealed class ConnectionState {
        data object Connected : ConnectionState()
        data object Disconnected : ConnectionState()
        data class Error(val message: String) : ConnectionState()
    }
}
