package com.vishnu.socialdashboard.presenter.home;

import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.view.common.BaseView;

import java.util.List;

public interface HomeContract {

    interface View extends BaseView {
        void showPosts(List<Post> posts);
        void showEmpty();
        void onPostLiked(int position);
    }

    interface Presenter {
        void loadPosts();
        void refreshPosts();
        void likePost(int postId, int position);
    }
}
