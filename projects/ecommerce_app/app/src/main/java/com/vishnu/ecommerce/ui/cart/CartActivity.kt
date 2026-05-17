package com.vishnu.ecommerce.ui.cart

import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.vishnu.ecommerce.databinding.ActivityCartBinding
import com.vishnu.ecommerce.utils.Resource
import com.vishnu.ecommerce.utils.toCurrency
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class CartActivity : AppCompatActivity() {

    private lateinit var binding: ActivityCartBinding
    private val viewModel: CartViewModel by viewModels()
    private lateinit var cartAdapter: CartAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityCartBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Shopping Cart"

        setupRecyclerView()
        observeCart()
        setupCheckout()
    }

    private fun setupRecyclerView() {
        cartAdapter = CartAdapter(
            onQuantityChanged = { productId, quantity -> viewModel.updateQuantity(productId, quantity) },
            onRemove = { productId -> viewModel.removeItem(productId) }
        )
        binding.rvCart.apply {
            adapter = cartAdapter
            layoutManager = LinearLayoutManager(this@CartActivity)
        }
    }

    private fun observeCart() {
        lifecycleScope.launch {
            viewModel.cartItems.collect { items ->
                cartAdapter.submitList(items)
                binding.tvEmptyCart.visibility = if (items.isEmpty()) android.view.View.VISIBLE else android.view.View.GONE
            }
        }
        lifecycleScope.launch {
            viewModel.cartTotal.collect { total ->
                binding.tvTotal.text = (total ?: 0.0).toCurrency()
            }
        }
    }

    private fun setupCheckout() {
        binding.btnCheckout.setOnClickListener {
            viewModel.placeOrder("123 Main St, City")
        }
        lifecycleScope.launch {
            viewModel.orderState.collect { state ->
                when (state) {
                    is Resource.Success -> {
                        Toast.makeText(this@CartActivity, "Order placed successfully!", Toast.LENGTH_LONG).show()
                        finish()
                    }
                    is Resource.Error -> {
                        Toast.makeText(this@CartActivity, state.message, Toast.LENGTH_LONG).show()
                    }
                    else -> {}
                }
            }
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressedDispatcher.onBackPressed()
        return true
    }
}
