package com.vishnu.socialdashboard.presenter.profile;

import com.vishnu.socialdashboard.data.model.User;
import com.vishnu.socialdashboard.data.repository.UserRepository;
import com.vishnu.socialdashboard.presenter.common.BasePresenter;

public class ProfilePresenter extends BasePresenter<ProfileContract.View> implements ProfileContract.Presenter {

    private final UserRepository userRepository;

    public ProfilePresenter() {
        this.userRepository = new UserRepository();
    }

    @Override
    public void loadProfile(int userId) {
        if (!isViewAttached()) return;
        view.showLoading();

        userRepository.getUser(userId, new UserRepository.UserCallback() {
            @Override
            public void onSuccess(User user) {
                if (!isViewAttached()) return;
                view.hideLoading();
                view.showProfile(user);
            }

            @Override
            public void onError(String message) {
                if (!isViewAttached()) return;
                view.hideLoading();
                view.showError(message);
            }
        });
    }
}
