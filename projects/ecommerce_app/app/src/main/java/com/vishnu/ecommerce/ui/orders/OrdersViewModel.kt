package com.vishnu.ecommerce.ui.orders

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseAuth
import com.vishnu.ecommerce.data.local.entity.OrderEntity
import com.vishnu.ecommerce.data.remote.repository.OrderRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import javax.inject.Inject

@HiltViewModel
class OrdersViewModel @Inject constructor(
    private val orderRepository: OrderRepository,
    private val firebaseAuth: FirebaseAuth
) : ViewModel() {

    val orders: StateFlow<List<OrderEntity>> = orderRepository
        .getOrders(firebaseAuth.currentUser?.uid ?: "guest")
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())
}
