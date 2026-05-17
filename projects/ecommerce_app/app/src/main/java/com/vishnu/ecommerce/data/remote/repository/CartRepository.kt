package com.vishnu.ecommerce.data.remote.repository

import com.vishnu.ecommerce.data.local.dao.CartDao
import com.vishnu.ecommerce.data.local.entity.CartItemEntity
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class CartRepository @Inject constructor(
    private val cartDao: CartDao
) {
    fun getCartItems(): Flow<List<CartItemEntity>> = cartDao.getCartItems()
    fun getCartTotal(): Flow<Double?> = cartDao.getCartTotal()
    fun getCartCount(): Flow<Int> = cartDao.getCartCount()

    suspend fun addToCart(item: CartItemEntity) = cartDao.addToCart(item)
    suspend fun updateQuantity(productId: String, quantity: Int) = cartDao.updateQuantity(productId, quantity)
    suspend fun removeFromCart(productId: String) = cartDao.removeFromCart(productId)
    suspend fun clearCart() = cartDao.clearCart()
}
