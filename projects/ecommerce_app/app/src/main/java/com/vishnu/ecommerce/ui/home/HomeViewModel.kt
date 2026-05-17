package com.vishnu.ecommerce.ui.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vishnu.ecommerce.data.local.entity.ProductEntity
import com.vishnu.ecommerce.data.remote.repository.CartRepository
import com.vishnu.ecommerce.data.remote.repository.ProductRepository
import com.vishnu.ecommerce.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    private val productRepository: ProductRepository,
    private val cartRepository: CartRepository
) : ViewModel() {

    private val _products = MutableStateFlow<Resource<List<ProductEntity>>>(Resource.Loading())
    val products: StateFlow<Resource<List<ProductEntity>>> = _products

    val cartCount: StateFlow<Int> = cartRepository.getCartCount()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), 0)

    init {
        loadProducts()
    }

    private fun loadProducts() {
        viewModelScope.launch {
            productRepository.getProducts().collect { _products.value = it }
        }
    }

    fun refreshProducts() = loadProducts()

    fun filterByCategory(category: String?) {
        viewModelScope.launch {
            if (category == null) {
                loadProducts()
            } else {
                productRepository.getProductsByCategory(category).collect { _products.value = it }
            }
        }
    }

    fun searchProducts(query: String) {
        if (query.isBlank()) {
            loadProducts()
            return
        }
        viewModelScope.launch {
            productRepository.searchProducts(query).collect { products ->
                _products.value = Resource.Success(products)
            }
        }
    }
}
