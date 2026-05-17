package com.vishnu.socialdashboard.presenter.post;

import com.vishnu.socialdashboard.data.model.Comment;
import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.data.repository.PostRepository;
import com.vishnu.socialdashboard.presenter.common.BasePresenter;

import java.util.List;

public class PostDetailPresenter extends BasePresenter<PostDetailContract.View> implements PostDetailContract.Presenter {

    private final PostRepository postRepository;

    public PostDetailPresenter() {
        this.postRepository = new PostRepository();
    }

    @Override
    public void loadPostDetail(int postId) {
        if (!isViewAttached()) return;
        view.showLoading();

        postRepository.getPost(postId, new PostRepository.PostCallback() {
            @Override
            public void onSuccess(Post post) {
                if (!isViewAttached()) return;
                view.hideLoading();
                view.showPost(post);
            }

            @Override
            public void onError(String message) {
                if (!isViewAttached()) return;
                view.hideLoading();
                view.showError(message);
            }
        });
    }

    @Override
    public void loadComments(int postId) {
        if (!isViewAttached()) return;

        postRepository.getComments(postId, new PostRepository.CommentListCallback() {
            @Override
            public void onSuccess(List<Comment> comments) {
                if (!isViewAttached()) return;
                if (comments != null && !comments.isEmpty()) {
                    view.showComments(comments);
                } else {
                    view.showCommentsEmpty();
                }
            }

            @Override
            public void onError(String message) {
                if (!isViewAttached()) return;
                view.showError(message);
            }
        });
    }
}
