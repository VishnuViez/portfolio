package com.vishnu.ecommerce.ui.home

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import com.vishnu.ecommerce.R
import com.vishnu.ecommerce.databinding.ActivityMainBinding
import com.vishnu.ecommerce.ui.cart.CartActivity
import com.vishnu.ecommerce.ui.orders.OrdersActivity
import com.vishnu.ecommerce.ui.product.ProductDetailActivity
import com.vishnu.ecommerce.utils.Constants
import com.vishnu.ecommerce.utils.Resource
import com.vishnu.ecommerce.utils.gone
import com.vishnu.ecommerce.utils.visible
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private val viewModel: HomeViewModel by viewModels()
    private lateinit var productAdapter: ProductAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setSupportActionBar(binding.toolbar)
        setupRecyclerView()
        setupSearch()
        setupSwipeRefresh()
        setupCategoryChips()
        observeProducts()
        observeCartCount()
    }

    private fun setupRecyclerView() {
        productAdapter = ProductAdapter { product ->
            val intent = Intent(this, ProductDetailActivity::class.java)
            intent.putExtra(Constants.PRODUCT_ID_KEY, product.id)
            startActivity(intent)
        }
        binding.rvProducts.apply {
            adapter = productAdapter
            layoutManager = GridLayoutManager(this@MainActivity, 2)
        }
    }

    private fun setupSearch() {
        binding.searchView.setOnQueryTextListener(object : androidx.appcompat.widget.SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?) = false
            override fun onQueryTextChange(newText: String?): Boolean {
                viewModel.searchProducts(newText.orEmpty())
                return true
            }
        })
    }

    private fun setupSwipeRefresh() {
        binding.swipeRefresh.setOnRefreshListener {
            viewModel.refreshProducts()
        }
    }

    private fun setupCategoryChips() {
        val categories = listOf("All", "Electronics", "Jewelery", "Men's Clothing", "Women's Clothing")
        binding.chipGroupCategories.removeAllViews()
        categories.forEachIndexed { index, category ->
            val chip = com.google.android.material.chip.Chip(this).apply {
                text = category
                isCheckable = true
                isChecked = index == 0
                setOnClickListener { viewModel.filterByCategory(if (index == 0) null else category.lowercase()) }
            }
            binding.chipGroupCategories.addView(chip)
        }
    }

    private fun observeProducts() {
        lifecycleScope.launch {
            viewModel.products.collect { resource ->
                when (resource) {
                    is Resource.Loading -> {
                        binding.progressBar.visible()
                        binding.tvError.gone()
                    }
                    is Resource.Success -> {
                        binding.progressBar.gone()
                        binding.swipeRefresh.isRefreshing = false
                        binding.tvError.gone()
                        productAdapter.submitList(resource.data)
                    }
                    is Resource.Error -> {
                        binding.progressBar.gone()
                        binding.swipeRefresh.isRefreshing = false
                        binding.tvError.text = resource.message
                        binding.tvError.visible()
                    }

                    // Handle Idle explicitly so when is exhaustive
                    is Resource.Idle -> {
                        binding.progressBar.gone()
                        binding.swipeRefresh.isRefreshing = false
                        binding.tvError.gone()
                    }
                }
            }
        }
    }

    private fun observeCartCount() {
        lifecycleScope.launch {
            viewModel.cartCount.collect { count ->
                invalidateOptionsMenu()
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.main_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean = when (item.itemId) {
        R.id.action_cart -> {
            startActivity(Intent(this, CartActivity::class.java))
            true
        }
        R.id.action_orders -> {
            startActivity(Intent(this, OrdersActivity::class.java))
            true
        }
        else -> super.onOptionsItemSelected(item)
    }
}
