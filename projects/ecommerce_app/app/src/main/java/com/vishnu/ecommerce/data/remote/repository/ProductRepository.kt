package com.vishnu.ecommerce.data.remote.repository

import com.vishnu.ecommerce.data.local.dao.ProductDao
import com.vishnu.ecommerce.data.local.entity.ProductEntity
import com.vishnu.ecommerce.data.remote.api.ShopApiService
import com.vishnu.ecommerce.utils.Resource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ProductRepository @Inject constructor(
    private val apiService: ShopApiService,
    private val productDao: ProductDao
) {
    fun getProducts(): Flow<Resource<List<ProductEntity>>> = flow {
        emit(Resource.Loading())
        try {
            val response = apiService.getProducts()
            if (response.isSuccessful) {
                val products = response.body()?.map { it.toEntity() } ?: emptyList()
                productDao.insertProducts(products)
                emit(Resource.Success(products))
            } else {
                emit(Resource.Error("Failed to fetch products: ${response.message()}"))
            }
        } catch (e: Exception) {
            // Fallback to cached data
            productDao.getAllProducts().collect { cached ->
                if (cached.isNotEmpty()) {
                    emit(Resource.Success(cached))
                } else {
                    emit(Resource.Error("No internet connection and no cached data"))
                }
            }
        }
    }

    fun searchProducts(query: String): Flow<List<ProductEntity>> =
        productDao.searchProducts(query)

    fun getProductsByCategory(category: String): Flow<Resource<List<ProductEntity>>> = flow {
        emit(Resource.Loading())
        try {
            val response = apiService.getProductsByCategory(category)
            if (response.isSuccessful) {
                val products = response.body()?.map { it.toEntity() } ?: emptyList()
                emit(Resource.Success(products))
            } else {
                emit(Resource.Error("Failed to fetch category products"))
            }
        } catch (e: Exception) {
            productDao.getProductsByCategory(category).collect { cached ->
                emit(Resource.Success(cached))
            }
        }
    }

    suspend fun getProductById(id: String): ProductEntity? = productDao.getProductById(id)

    private fun com.vishnu.ecommerce.data.remote.model.ProductResponse.toEntity() = ProductEntity(
        id = id,
        name = title,
        description = description,
        price = price,
        imageUrl = image,
        category = category,
        rating = rating.rate,
        reviewCount = rating.count,
        inStock = true
    )
}
