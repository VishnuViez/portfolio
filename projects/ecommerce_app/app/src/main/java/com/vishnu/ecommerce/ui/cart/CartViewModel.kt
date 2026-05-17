package com.vishnu.ecommerce.ui.cart

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.firebase.auth.FirebaseAuth
import com.vishnu.ecommerce.data.local.entity.CartItemEntity
import com.vishnu.ecommerce.data.local.entity.OrderEntity
import com.vishnu.ecommerce.data.remote.repository.CartRepository
import com.vishnu.ecommerce.data.remote.repository.OrderRepository
import com.vishnu.ecommerce.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class CartViewModel @Inject constructor(
    private val cartRepository: CartRepository,
    private val orderRepository: OrderRepository,
    private val firebaseAuth: FirebaseAuth
) : ViewModel() {

    val cartItems: StateFlow<List<CartItemEntity>> = cartRepository.getCartItems()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val cartTotal: StateFlow<Double?> = cartRepository.getCartTotal()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), 0.0)

    private val _orderState = MutableStateFlow<Resource<OrderEntity>>(Resource.Loading())
    val orderState: StateFlow<Resource<OrderEntity>> = _orderState

    fun updateQuantity(productId: String, quantity: Int) {
        viewModelScope.launch {
            if (quantity <= 0) cartRepository.removeFromCart(productId)
            else cartRepository.updateQuantity(productId, quantity)
        }
    }

    fun removeItem(productId: String) {
        viewModelScope.launch { cartRepository.removeFromCart(productId) }
    }

    fun placeOrder(address: String) {
        val userId = firebaseAuth.currentUser?.uid ?: "guest"
        val items = cartItems.value
        val total = cartTotal.value ?: 0.0
        viewModelScope.launch {
            orderRepository.placeOrder(userId, total, items.size, address).collect {
                _orderState.value = it
            }
        }
    }
}
