package com.vishnu.socialdashboard.data.repository;

import com.vishnu.socialdashboard.data.api.ApiClient;
import com.vishnu.socialdashboard.data.api.SocialApiService;
import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.data.model.Post;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PostRepository {

    private final SocialApiService apiService;

    public PostRepository() {
        this.apiService = ApiClient.getInstance().getApiService();
    }

    public interface PostListCallback {
        void onSuccess(List<Post> posts);
        void onError(String message);
    }

    public interface PostCallback {
        void onSuccess(Post post);
        void onError(String message);
    }

    public interface CommentListCallback {
        void onSuccess(List<Comment> comments);
        void onError(String message);
    }

    public void getPosts(PostListCallback callback) {
        apiService.getPosts().enqueue(new Callback<List<Post>>() {
            @Override
            public void onResponse(Call<List<Post>> call, Response<List<Post>> response) {
                if (response.isSuccessful() && response.body() != null) {
                    callback.onSuccess(response.body());
                } else {
                    callback.onError("Failed to load posts");
                }
            }

            @Override
            public void onFailure(Call<List<Post>> call, Throwable t) {
                callback.onError(t.getMessage());
            }
        });
    }

    public void getPost(int postId, PostCallback callback) {
        apiService.getPost(postId).enqueue(new Callback<Post>() {
            @Override
            public void onResponse(Call<Post> call, Response<Post> response) {
                if (response.isSuccessful() && response.body() != null) {
                    callback.onSuccess(response.body());
                } else {
                    callback.onError("Failed to load post");
                }
            }

            @Override
            public void onFailure(Call<Post> call, Throwable t) {
                callback.onError(t.getMessage());
            }
        });
    }

    public void getComments(int postId, CommentListCallback callback) {
        apiService.getComments(postId).enqueue(new Callback<List<Comment>>() {
            @Override
            public void onResponse(Call<List<Comment>> call, Response<List<Comment>> response) {
                if (response.isSuccessful() && response.body() != null) {
                    callback.onSuccess(response.body());
                } else {
                    callback.onError("Failed to load comments");
                }
            }

            @Override
            public void onFailure(Call<List<Comment>> call, Throwable t) {
                callback.onError(t.getMessage());
            }
        });
    }

    public void createPost(Post post, PostCallback callback) {
        apiService.createPost(post).enqueue(new Callback<Post>() {
            @Override
            public void onResponse(Call<Post> call, Response<Post> response) {
                if (response.isSuccessful() && response.body() != null) {
                    callback.onSuccess(response.body());
                } else {
                    callback.onError("Failed to create post");
                }
            }

            @Override
            public void onFailure(Call<Post> call, Throwable t) {
                callback.onError(t.getMessage());
            }
        });
    }
}
