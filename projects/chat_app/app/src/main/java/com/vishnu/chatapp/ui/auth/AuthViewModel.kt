package com.vishnu.chatapp.ui.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vishnu.chatapp.data.repository.AuthRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class AuthViewModel : ViewModel() {

    private val authRepository = AuthRepository()

    private val _loginState = MutableStateFlow<AuthUiState>(AuthUiState.Idle)
    val loginState: StateFlow<AuthUiState> = _loginState.asStateFlow()

    private val _registerState = MutableStateFlow<AuthUiState>(AuthUiState.Idle)
    val registerState: StateFlow<AuthUiState> = _registerState.asStateFlow()

    fun login(email: String, password: String, onSuccess: () -> Unit) {
        if (email.isBlank() || password.isBlank()) {
            _loginState.value = AuthUiState.Error("Please fill in all fields")
            return
        }

        viewModelScope.launch {
            _loginState.value = AuthUiState.Loading
            val result = authRepository.signIn(email, password)
            result.fold(
                onSuccess = {
                    _loginState.value = AuthUiState.Idle
                    onSuccess()
                },
                onFailure = {
                    _loginState.value = AuthUiState.Error(it.message ?: "Login failed")
                }
            )
        }
    }

    fun register(name: String, email: String, password: String, confirmPassword: String, onSuccess: () -> Unit) {
        if (name.isBlank() || email.isBlank() || password.isBlank()) {
            _registerState.value = AuthUiState.Error("Please fill in all fields")
            return
        }
        if (password != confirmPassword) {
            _registerState.value = AuthUiState.Error("Passwords do not match")
            return
        }
        if (password.length < 6) {
            _registerState.value = AuthUiState.Error("Password must be at least 6 characters")
            return
        }

        viewModelScope.launch {
            _registerState.value = AuthUiState.Loading
            val result = authRepository.signUp(email, password, name)
            result.fold(
                onSuccess = {
                    authRepository.signOut()
                    _registerState.value = AuthUiState.Idle
                    onSuccess()
                },
                onFailure = {
                    _registerState.value = AuthUiState.Error(it.message ?: "Registration failed")
                }
            )
        }
    }
}

sealed class AuthUiState {
    data object Idle : AuthUiState()
    data object Loading : AuthUiState()
    data class Error(val message: String) : AuthUiState()
}
