package com.vishnu.ecommerce.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "orders")
data class OrderEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val totalAmount: Double,
    val status: String,
    val itemCount: Int,
    val shippingAddress: String,
    val createdAt: Long = System.currentTimeMillis()
)
