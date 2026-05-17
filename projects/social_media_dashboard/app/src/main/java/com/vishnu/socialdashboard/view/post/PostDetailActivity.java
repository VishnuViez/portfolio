package com.vishnu.socialdashboard.view.post;

import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.bumptech.glide.Glide;
import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.databinding.ActivityPostDetailBinding;
import com.vishnu.socialdashboard.presenter.post.PostDetailContract;
import com.vishnu.socialdashboard.presenter.post.PostDetailPresenter;
import com.vishnu.socialdashboard.utils.Constants;
import com.vishnu.socialdashboard.utils.DateUtils;
import com.vishnu.socialdashboard.view.adapter.CommentAdapter;

import java.util.List;

public class PostDetailActivity extends AppCompatActivity implements PostDetailContract.View {

    private ActivityPostDetailBinding binding;
    private PostDetailPresenter presenter;
    private CommentAdapter commentAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityPostDetailBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setupToolbar();
        setupCommentsRecyclerView();

        presenter = new PostDetailPresenter();
        presenter.attachView(this);

        int postId = getIntent().getIntExtra(Constants.EXTRA_POST_ID, 1);
        presenter.loadPostDetail(postId);
        presenter.loadComments(postId);
    }

    private void setupToolbar() {
        setSupportActionBar(binding.toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Post");
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupCommentsRecyclerView() {
        commentAdapter = new CommentAdapter();
        binding.rvComments.setLayoutManager(new LinearLayoutManager(this));
        binding.rvComments.setAdapter(commentAdapter);
        binding.rvComments.setNestedScrollingEnabled(false);
    }

    @Override
    public void showPost(Post post) {
        binding.tvDetailUsername.setText(post.getUsername());
        binding.tvDetailTimestamp.setText(DateUtils.getTimeAgo(post.getTimestamp()));
        binding.tvDetailContent.setText(post.getContent());
        binding.tvDetailLikes.setText(DateUtils.formatCount(post.getLikesCount()) + " likes");
        binding.tvDetailComments.setText(DateUtils.formatCount(post.getCommentsCount()) + " comments");
        binding.tvDetailShares.setText(DateUtils.formatCount(post.getSharesCount()) + " shares");

        Glide.with(this)
                .load(post.getUserAvatar())
                .circleCrop()
                .into(binding.ivDetailAvatar);

        if (post.getImageUrl() != null && !post.getImageUrl().isEmpty()) {
            binding.ivDetailImage.setVisibility(View.VISIBLE);
            Glide.with(this).load(post.getImageUrl()).into(binding.ivDetailImage);
        } else {
            binding.ivDetailImage.setVisibility(View.GONE);
        }
    }

    @Override
    public void showComments(List<Comment> comments) {
        binding.tvCommentsHeader.setText("Comments (" + comments.size() + ")");
        commentAdapter.setComments(comments);
    }

    @Override
    public void showCommentsEmpty() {
        binding.tvCommentsHeader.setText("No comments yet");
    }

    @Override
    public void showLoading() {
        binding.progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideLoading() {
        binding.progressBar.setVisibility(View.GONE);
    }

    @Override
    public void showError(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        presenter.detachView();
    }
}
