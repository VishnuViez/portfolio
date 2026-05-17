package com.vishnu.socialdashboard.view.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.vishnu.socialdashboard.R;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.databinding.ItemPostBinding;
import com.vishnu.socialdashboard.utils.DateUtils;

import java.util.ArrayList;
import java.util.List;

public class PostAdapter extends RecyclerView.Adapter<PostAdapter.PostViewHolder> {

    private final List<Post> posts = new ArrayList<>();
    private OnPostClickListener listener;

    public interface OnPostClickListener {
        void onPostClick(Post post);
        void onLikeClick(Post post, int position);
        void onCommentClick(Post post);
        void onShareClick(Post post);
        void onProfileClick(int userId);
    }

    public void setOnPostClickListener(OnPostClickListener listener) {
        this.listener = listener;
    }

    public void setPosts(List<Post> newPosts) {
        posts.clear();
        posts.addAll(newPosts);
        notifyDataSetChanged();
    }

    public void updatePostAt(int position) {
        if (position >= 0 && position < posts.size()) {
            notifyItemChanged(position);
        }
    }

    @NonNull
    @Override
    public PostViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemPostBinding binding = ItemPostBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new PostViewHolder(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull PostViewHolder holder, int position) {
        holder.bind(posts.get(position), position);
    }

    @Override
    public int getItemCount() {
        return posts.size();
    }

    class PostViewHolder extends RecyclerView.ViewHolder {
        private final ItemPostBinding binding;

        PostViewHolder(ItemPostBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(Post post, int position) {
            binding.tvUsername.setText(post.getUsername());
            binding.tvTimestamp.setText(DateUtils.getTimeAgo(post.getTimestamp()));
            binding.tvContent.setText(post.getContent());
            binding.tvLikesCount.setText(DateUtils.formatCount(post.getLikesCount()));
            binding.tvCommentsCount.setText(DateUtils.formatCount(post.getCommentsCount()));
            binding.tvSharesCount.setText(DateUtils.formatCount(post.getSharesCount()));

            Glide.with(binding.getRoot().getContext())
                    .load(post.getUserAvatar())
                    .placeholder(R.drawable.ic_like)
                    .circleCrop()
                    .into(binding.ivAvatar);

            if (post.getImageUrl() != null && !post.getImageUrl().isEmpty()) {
                binding.ivPostImage.setVisibility(View.VISIBLE);
                Glide.with(binding.getRoot().getContext())
                        .load(post.getImageUrl())
                        .into(binding.ivPostImage);
            } else {
                binding.ivPostImage.setVisibility(View.GONE);
            }

            binding.ivLike.setImageResource(post.isLiked() ?
                    R.drawable.ic_like : R.drawable.ic_like);

            if (listener != null) {
                binding.getRoot().setOnClickListener(v -> listener.onPostClick(post));
                binding.btnLike.setOnClickListener(v -> {
                    post.setLiked(!post.isLiked());
                    post.setLikesCount(post.isLiked() ?
                            post.getLikesCount() + 1 : post.getLikesCount() - 1);
                    notifyItemChanged(position);
                    listener.onLikeClick(post, position);
                });
                binding.btnComment.setOnClickListener(v -> listener.onCommentClick(post));
                binding.btnShare.setOnClickListener(v -> listener.onShareClick(post));
                binding.ivAvatar.setOnClickListener(v -> listener.onProfileClick(post.getUserId()));
                binding.tvUsername.setOnClickListener(v -> listener.onProfileClick(post.getUserId()));
            }
        }
    }
}
