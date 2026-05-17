package com.vishnu.ecommerce.data.remote.repository

import com.vishnu.ecommerce.data.local.dao.CartDao
import com.vishnu.ecommerce.data.local.dao.OrderDao
import com.vishnu.ecommerce.data.local.entity.OrderEntity
import com.vishnu.ecommerce.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import java.util.UUID
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OrderRepository @Inject constructor(
    private val orderDao: OrderDao,
    private val cartDao: CartDao
) {
    fun getOrders(userId: String): Flow<List<OrderEntity>> = orderDao.getOrdersByUser(userId)

    fun placeOrder(userId: String, totalAmount: Double, itemCount: Int, address: String): Flow<Resource<OrderEntity>> = flow {
        emit(Resource.Loading())
        try {
            val order = OrderEntity(
                id = UUID.randomUUID().toString(),
                userId = userId,
                totalAmount = totalAmount,
                status = "Placed",
                itemCount = itemCount,
                shippingAddress = address
            )
            orderDao.insertOrder(order)
            cartDao.clearCart()
            emit(Resource.Success(order))
        } catch (e: Exception) {
            emit(Resource.Error(e.message ?: "Failed to place order"))
        }
    }
}
