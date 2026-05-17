package com.vishnu.socialdashboard.view.home;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;

import com.vishnu.socialdashboard.R;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.databinding.ActivityMainBinding;
import com.vishnu.socialdashboard.presenter.home.HomeContract;
import com.vishnu.socialdashboard.presenter.home.HomePresenter;
import com.vishnu.socialdashboard.utils.Constants;
import com.vishnu.socialdashboard.view.adapter.PostAdapter;
import com.vishnu.socialdashboard.view.analytics.AnalyticsActivity;
import com.vishnu.socialdashboard.view.post.PostDetailActivity;
import com.vishnu.socialdashboard.view.profile.ProfileActivity;

import java.util.List;

public class MainActivity extends AppCompatActivity implements HomeContract.View {

    private ActivityMainBinding binding;
    private HomePresenter presenter;
    private PostAdapter postAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setupToolbar();
        setupRecyclerView();
        setupSwipeRefresh();
        setupBottomNavigation();
        setupFab();

        presenter = new HomePresenter();
        presenter.attachView(this);
        presenter.loadPosts();
    }

    private void setupToolbar() {
        setSupportActionBar(binding.toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle(R.string.app_name);
        }
    }

    private void setupRecyclerView() {
        postAdapter = new PostAdapter();
        binding.rvPosts.setLayoutManager(new LinearLayoutManager(this));
        binding.rvPosts.setAdapter(postAdapter);

        postAdapter.setOnPostClickListener(new PostAdapter.OnPostClickListener() {
            @Override
            public void onPostClick(Post post) {
                Intent intent = new Intent(MainActivity.this, PostDetailActivity.class);
                intent.putExtra(Constants.EXTRA_POST_ID, post.getId());
                startActivity(intent);
            }

            @Override
            public void onLikeClick(Post post, int position) {
                presenter.likePost(post.getId(), position);
            }

            @Override
            public void onCommentClick(Post post) {
                Intent intent = new Intent(MainActivity.this, PostDetailActivity.class);
                intent.putExtra(Constants.EXTRA_POST_ID, post.getId());
                startActivity(intent);
            }

            @Override
            public void onShareClick(Post post) {
                Intent shareIntent = new Intent(Intent.ACTION_SEND);
                shareIntent.setType("text/plain");
                shareIntent.putExtra(Intent.EXTRA_TEXT, post.getContent());
                startActivity(Intent.createChooser(shareIntent, "Share via"));
            }

            @Override
            public void onProfileClick(int userId) {
                Intent intent = new Intent(MainActivity.this, ProfileActivity.class);
                intent.putExtra(Constants.EXTRA_USER_ID, userId);
                startActivity(intent);
            }
        });
    }

    private void setupSwipeRefresh() {
        binding.swipeRefresh.setColorSchemeResources(R.color.primary);
        binding.swipeRefresh.setOnRefreshListener(() -> presenter.refreshPosts());
    }

    private void setupBottomNavigation() {
        binding.bottomNav.setOnItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.nav_home) {
                return true;
            } else if (id == R.id.nav_analytics) {
                startActivity(new Intent(this, AnalyticsActivity.class));
                return true;
            } else if (id == R.id.nav_profile) {
                Intent intent = new Intent(this, ProfileActivity.class);
                intent.putExtra(Constants.EXTRA_USER_ID, 1);
                startActivity(intent);
                return true;
            }
            return false;
        });
    }

    private void setupFab() {
        binding.fabCreatePost.setOnClickListener(v ->
                startActivity(new Intent(this, CreatePostActivity.class)));
    }

    @Override
    protected void onResume() {
        super.onResume();
        binding.bottomNav.setSelectedItemId(R.id.nav_home);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.action_notifications) {
            Toast.makeText(this, "Notifications clicked", Toast.LENGTH_SHORT).show();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void showPosts(List<Post> posts) {
        binding.rvPosts.setVisibility(View.VISIBLE);
        binding.tvEmpty.setVisibility(View.GONE);
        postAdapter.setPosts(posts);
    }

    @Override
    public void showEmpty() {
        binding.rvPosts.setVisibility(View.GONE);
        binding.tvEmpty.setVisibility(View.VISIBLE);
    }

    @Override
    public void onPostLiked(int position) {
        postAdapter.updatePostAt(position);
    }

    @Override
    public void showLoading() {
        binding.swipeRefresh.setRefreshing(true);
    }

    @Override
    public void hideLoading() {
        binding.swipeRefresh.setRefreshing(false);
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
