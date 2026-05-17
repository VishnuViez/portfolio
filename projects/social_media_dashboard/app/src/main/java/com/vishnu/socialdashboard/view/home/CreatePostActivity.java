package com.vishnu.socialdashboard.view.home;

import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.data.repository.PostRepository;
import com.vishnu.socialdashboard.databinding.ActivityCreatePostBinding;

public class CreatePostActivity extends AppCompatActivity {

    private ActivityCreatePostBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityCreatePostBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setupToolbar();
        setupSubmitButton();
    }

    private void setupToolbar() {
        setSupportActionBar(binding.toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Create Post");
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    private void setupSubmitButton() {
        binding.btnSubmit.setOnClickListener(v -> {
            String content = binding.etContent.getText().toString().trim();
            if (content.isEmpty()) {
                binding.tilContent.setError("Post content cannot be empty");
                return;
            }
            binding.tilContent.setError(null);
            submitPost(content);
        });
    }

    private void submitPost(String content) {
        binding.btnSubmit.setEnabled(false);

        Post post = new Post();
        post.setUserId(1);
        post.setContent(content);
        post.setTitle("New Post");

        new PostRepository().createPost(post, new PostRepository.PostCallback() {
            @Override
            public void onSuccess(Post post) {
                runOnUiThread(() -> {
                    Toast.makeText(CreatePostActivity.this, "Post created!", Toast.LENGTH_SHORT).show();
                    finish();
                });
            }

            @Override
            public void onError(String message) {
                runOnUiThread(() -> {
                    binding.btnSubmit.setEnabled(true);
                    Toast.makeText(CreatePostActivity.this, "Error: " + message, Toast.LENGTH_LONG).show();
                });
            }
        });
    }
}
