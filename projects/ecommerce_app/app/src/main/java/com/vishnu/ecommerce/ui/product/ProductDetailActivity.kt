package com.vishnu.ecommerce.ui.product

import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import com.vishnu.ecommerce.databinding.ActivityProductDetailBinding
import com.vishnu.ecommerce.utils.Constants
import com.vishnu.ecommerce.utils.loadImage
import com.vishnu.ecommerce.utils.toCurrency
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class ProductDetailActivity : AppCompatActivity() {

    private lateinit var binding: ActivityProductDetailBinding
    private val viewModel: ProductDetailViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityProductDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        val productId = intent.getStringExtra(Constants.PRODUCT_ID_KEY) ?: return finish()
        viewModel.loadProduct(productId)
        observeProduct()
    }

    private fun observeProduct() {
        viewModel.product.observe(this) { product ->
            product?.let {
                binding.apply {
                    ivProduct.loadImage(it.imageUrl)
                    tvName.text = it.name
                    tvPrice.text = it.price.toCurrency()
                    tvDescription.text = it.description
                    tvCategory.text = it.category.replaceFirstChar { c -> c.uppercase() }
                    ratingBar.rating = it.rating
                    tvReviews.text = "${it.reviewCount} reviews"
                    tvStock.text = if (it.inStock) "In Stock" else "Out of Stock"

                    btnAddToCart.setOnClickListener { _ ->
                        viewModel.addToCart(it)
                        Toast.makeText(this@ProductDetailActivity, "Added to cart!", Toast.LENGTH_SHORT).show()
                    }
                }
                supportActionBar?.title = it.name
            }
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressedDispatcher.onBackPressed()
        return true
    }
}
