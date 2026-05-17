package com.vishnu.socialdashboard.view.adapter;

import android.view.LayoutInflater;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.databinding.ItemCommentBinding;
import com.vishnu.socialdashboard.utils.DateUtils;

import java.util.ArrayList;
import java.util.List;

public class CommentAdapter extends RecyclerView.Adapter<CommentAdapter.CommentViewHolder> {

    private final List<Comment> comments = new ArrayList<>();

    public void setComments(List<Comment> newComments) {
        comments.clear();
        comments.addAll(newComments);
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public CommentViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemCommentBinding binding = ItemCommentBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new CommentViewHolder(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentViewHolder holder, int position) {
        holder.bind(comments.get(position));
    }

    @Override
    public int getItemCount() {
        return comments.size();
    }

    static class CommentViewHolder extends RecyclerView.ViewHolder {
        private final ItemCommentBinding binding;

        CommentViewHolder(ItemCommentBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(Comment comment) {
            binding.tvCommentUsername.setText(comment.getUsername());
            binding.tvCommentContent.setText(comment.getContent());
            binding.tvCommentTimestamp.setText(DateUtils.getTimeAgo(comment.getTimestamp()));

            Glide.with(binding.getRoot().getContext())
                    .load(comment.getUserAvatar())
                    .circleCrop()
                    .into(binding.ivCommentAvatar);
        }
    }
}
