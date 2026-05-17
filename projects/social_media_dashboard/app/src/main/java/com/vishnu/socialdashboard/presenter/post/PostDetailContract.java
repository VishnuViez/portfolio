package com.vishnu.socialdashboard.presenter.post;

import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.view.common.BaseView;

import java.util.List;

public interface PostDetailContract {

    interface View extends BaseView {
        void showPost(Post post);
        void showComments(List<Comment> comments);
        void showCommentsEmpty();
    }

    interface Presenter {
        void loadPostDetail(int postId);
        void loadComments(int postId);
    }
}
