package com.vishnu.ecommerce.data.local.database

import androidx.room.Database
import androidx.room.RoomDatabase
import com.vishnu.ecommerce.data.local.dao.CartDao
import com.vishnu.ecommerce.data.local.dao.OrderDao
import com.vishnu.ecommerce.data.local.dao.ProductDao
import com.vishnu.ecommerce.data.local.entity.CartItemEntity
import com.vishnu.ecommerce.data.local.entity.OrderEntity
import com.vishnu.ecommerce.data.local.entity.ProductEntity

@Database(
    entities = [ProductEntity::class, CartItemEntity::class, OrderEntity::class],
    version = 1,
    exportSchema = false
)
abstract class ShopDatabase : RoomDatabase() {
    abstract fun productDao(): ProductDao
    abstract fun cartDao(): CartDao
    abstract fun orderDao(): OrderDao
}
