package com.vishnu.socialdashboard.presenter.profile;

import com.vishnu.socialdashboard.data.model.User;
import com.vishnu.socialdashboard.view.common.BaseView;

public interface ProfileContract {

    interface View extends BaseView {
        void showProfile(User user);
    }

    interface Presenter {
        void loadProfile(int userId);
    }
}
