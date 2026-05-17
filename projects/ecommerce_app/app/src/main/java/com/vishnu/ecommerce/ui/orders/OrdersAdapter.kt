package com.vishnu.ecommerce.ui.orders

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.vishnu.ecommerce.data.local.entity.OrderEntity
import com.vishnu.ecommerce.databinding.ItemOrderBinding
import com.vishnu.ecommerce.utils.toCurrency
import java.text.SimpleDateFormat
import java.util.*

class OrdersAdapter : ListAdapter<OrderEntity, OrdersAdapter.OrderViewHolder>(OrderDiffCallback()) {

    inner class OrderViewHolder(private val binding: ItemOrderBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(order: OrderEntity) {
            val dateFormat = SimpleDateFormat("MMM dd, yyyy HH:mm", Locale.getDefault())
            binding.apply {
                tvOrderId.text = "Order #${order.id.take(8)}"
                tvDate.text = dateFormat.format(Date(order.createdAt))
                tvStatus.text = order.status
                tvTotal.text = order.totalAmount.toCurrency()
                tvItemCount.text = "${order.itemCount} items"
                tvAddress.text = order.shippingAddress
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): OrderViewHolder {
        val binding = ItemOrderBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return OrderViewHolder(binding)
    }

    override fun onBindViewHolder(holder: OrderViewHolder, position: Int) {
        holder.bind(getItem(position))
    }
}

class OrderDiffCallback : DiffUtil.ItemCallback<OrderEntity>() {
    override fun areItemsTheSame(oldItem: OrderEntity, newItem: OrderEntity) = oldItem.id == newItem.id
    override fun areContentsTheSame(oldItem: OrderEntity, newItem: OrderEntity) = oldItem == newItem
}
