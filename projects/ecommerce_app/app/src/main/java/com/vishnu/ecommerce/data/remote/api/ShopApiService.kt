package com.vishnu.ecommerce.data.remote.api

import com.vishnu.ecommerce.data.remote.model.ProductResponse
import retrofit2.Response
import retrofit2.http.*

interface ShopApiService {

    @GET("products")
    suspend fun getProducts(): Response<List<ProductResponse>>

    @GET("products/{id}")
    suspend fun getProductById(@Path("id") id: String): Response<ProductResponse>

    @GET("products/category/{category}")
    suspend fun getProductsByCategory(@Path("category") category: String): Response<List<ProductResponse>>

    @GET("products/categories")
    suspend fun getCategories(): Response<List<String>>
}
