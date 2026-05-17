package com.vishnu.socialdashboard.data.repository;

import com.vishnu.socialdashboard.data.api.ApiClient;
import com.vishnu.socialdashboard.data.api.SocialApiService;
import com.vishnu.socialdashboard.data.model.User;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class UserRepository {

    private final SocialApiService apiService;

    public UserRepository() {
        this.apiService = ApiClient.getInstance().getApiService();
    }

    public interface UserCallback {
        void onSuccess(User user);
        void onError(String message);
    }

    public void getUser(int userId, UserCallback callback) {
        apiService.getUser(userId).enqueue(new Callback<User>() {
            @Override
            public void onResponse(Call<User> call, Response<User> response) {
                if (response.isSuccessful() && response.body() != null) {
                    callback.onSuccess(response.body());
                } else {
                    callback.onError("Failed to load user");
                }
            }

            @Override
            public void onFailure(Call<User> call, Throwable t) {
                callback.onError(t.getMessage());
            }
        });
    }
}
