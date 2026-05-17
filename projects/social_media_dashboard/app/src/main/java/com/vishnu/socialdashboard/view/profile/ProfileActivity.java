package com.vishnu.socialdashboard.view.profile;

import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.bumptech.glide.Glide;
import com.vishnu.socialdashboard.data.model.User;
import com.vishnu.socialdashboard.databinding.ActivityProfileBinding;
import com.vishnu.socialdashboard.presenter.profile.ProfileContract;
import com.vishnu.socialdashboard.presenter.profile.ProfilePresenter;
import com.vishnu.socialdashboard.utils.Constants;
import com.vishnu.socialdashboard.utils.DateUtils;

public class ProfileActivity extends AppCompatActivity implements ProfileContract.View {

    private ActivityProfileBinding binding;
    private ProfilePresenter presenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityProfileBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setupToolbar();

        presenter = new ProfilePresenter();
        presenter.attachView(this);

        int userId = getIntent().getIntExtra(Constants.EXTRA_USER_ID, 1);
        presenter.loadProfile(userId);
    }

    private void setupToolbar() {
        setSupportActionBar(binding.toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Profile");
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    @Override
    public void showProfile(User user) {
        binding.tvProfileName.setText(user.getDisplayName());
        binding.tvProfileUsername.setText("@" + user.getUsername());
        binding.tvProfileBio.setText(user.getBio());
        binding.tvPostsCount.setText(DateUtils.formatCount(user.getPostsCount()));
        binding.tvFollowersCount.setText(DateUtils.formatCount(user.getFollowersCount()));
        binding.tvFollowingCount.setText(DateUtils.formatCount(user.getFollowingCount()));

        Glide.with(this)
                .load(user.getAvatarUrl())
                .circleCrop()
                .into(binding.ivProfileAvatar);
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
