package com.vishnu.ecommerce.ui.home

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vishnu.ecommerce.data.local.entity.ProductEntity
import com.vishnu.ecommerce.databinding.ItemProductBinding
import com.vishnu.ecommerce.utils.loadImage
import com.vishnu.ecommerce.utils.toCurrency

class ProductAdapter(
    private val onProductClick: (ProductEntity) -> Unit
) : ListAdapter<ProductEntity, ProductAdapter.ProductViewHolder>(ProductDiffCallback()) {

    inner class ProductViewHolder(private val binding: ItemProductBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(product: ProductEntity) {
            binding.apply {
                ivProduct.loadImage(product.imageUrl)
                tvName.text = product.name
                tvPrice.text = product.price.toCurrency()
                tvCategory.text = product.category.replaceFirstChar { it.uppercase() }
                ratingBar.rating = product.rating
                tvReviews.text = "(${product.reviewCount})"
                root.setOnClickListener { onProductClick(product) }
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductViewHolder {
        val binding = ItemProductBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ProductViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ProductViewHolder, position: Int) {
        holder.bind(getItem(position))
    }
}

class ProductDiffCallback : DiffUtil.ItemCallback<ProductEntity>() {
    override fun areItemsTheSame(oldItem: ProductEntity, newItem: ProductEntity) = oldItem.id == newItem.id
    override fun areContentsTheSame(oldItem: ProductEntity, newItem: ProductEntity) = oldItem == newItem
}
