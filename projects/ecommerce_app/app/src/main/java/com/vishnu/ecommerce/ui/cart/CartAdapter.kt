package com.vishnu.ecommerce.ui.cart

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vishnu.ecommerce.data.local.entity.CartItemEntity
import com.vishnu.ecommerce.databinding.ItemCartBinding
import com.vishnu.ecommerce.utils.loadImage
import com.vishnu.ecommerce.utils.toCurrency

class CartAdapter(
    private val onQuantityChanged: (String, Int) -> Unit,
    private val onRemove: (String) -> Unit
) : ListAdapter<CartItemEntity, CartAdapter.CartViewHolder>(CartDiffCallback()) {

    inner class CartViewHolder(private val binding: ItemCartBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(item: CartItemEntity) {
            binding.apply {
                ivProduct.loadImage(item.imageUrl)
                tvName.text = item.name
                tvPrice.text = item.price.toCurrency()
                tvQuantity.text = item.quantity.toString()
                tvSubtotal.text = (item.price * item.quantity).toCurrency()

                btnIncrease.setOnClickListener { onQuantityChanged(item.productId, item.quantity + 1) }
                btnDecrease.setOnClickListener { onQuantityChanged(item.productId, item.quantity - 1) }
                btnRemove.setOnClickListener { onRemove(item.productId) }
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CartViewHolder {
        val binding = ItemCartBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return CartViewHolder(binding)
    }

    override fun onBindViewHolder(holder: CartViewHolder, position: Int) {
        holder.bind(getItem(position))
    }
}

class CartDiffCallback : DiffUtil.ItemCallback<CartItemEntity>() {
    override fun areItemsTheSame(oldItem: CartItemEntity, newItem: CartItemEntity) = oldItem.productId == newItem.productId
    override fun areContentsTheSame(oldItem: CartItemEntity, newItem: CartItemEntity) = oldItem == newItem
}
