package com.vishnu.ecommerce.ui.product

import androidx.lifecycle.*
import com.vishnu.ecommerce.data.local.entity.CartItemEntity
import com.vishnu.ecommerce.data.local.entity.ProductEntity
import com.vishnu.ecommerce.data.remote.repository.CartRepository
import com.vishnu.ecommerce.data.remote.repository.ProductRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ProductDetailViewModel @Inject constructor(
    private val productRepository: ProductRepository,
    private val cartRepository: CartRepository
) : ViewModel() {

    private val _product = MutableLiveData<ProductEntity?>()
    val product: LiveData<ProductEntity?> = _product

    fun loadProduct(id: String) {
        viewModelScope.launch {
            _product.value = productRepository.getProductById(id)
        }
    }

    fun addToCart(product: ProductEntity) {
        viewModelScope.launch {
            cartRepository.addToCart(
                CartItemEntity(
                    productId = product.id,
                    name = product.name,
                    price = product.price,
                    imageUrl = product.imageUrl,
                    quantity = 1
                )
            )
        }
    }
}
