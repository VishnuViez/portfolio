package com.vishnu.socialdashboard.data.api;

import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.data.model.User;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;

public interface SocialApiService {

    @GET("posts")
    Call<List<Post>> getPosts();

    @GET("posts/{id}")
    Call<Post> getPost(@Path("id") int postId);

    @GET("posts/{id}/comments")
    Call<List<Comment>> getComments(@Path("id") int postId);

    @GET("users/{id}")
    Call<User> getUser(@Path("id") int userId);

    @POST("posts")
    Call<Post> createPost(@Body Post post);
}
