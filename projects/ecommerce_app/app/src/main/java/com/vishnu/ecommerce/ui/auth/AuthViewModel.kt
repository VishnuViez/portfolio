package com.vishnu.ecommerce.ui.auth

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseUser
import com.vishnu.ecommerce.data.remote.repository.AuthRepository
import com.vishnu.ecommerce.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class AuthViewModel @Inject constructor(
    private val authRepository: AuthRepository
) : ViewModel() {

    private val _authState = MutableStateFlow<Resource<FirebaseUser>>(Resource.Idle())
    val authState: StateFlow<Resource<FirebaseUser>> = _authState

    fun isLoggedIn(): Boolean = authRepository.currentUser != null

    fun login(email: String, password: String) {
        viewModelScope.launch {
            authRepository.login(email, password).collect { _authState.value = it }
        }
    }

    fun register(email: String, password: String, name: String) {
        viewModelScope.launch {
            authRepository.register(email, password, name).collect { _authState.value = it }
        }
    }

    fun logout() = authRepository.logout()
}
