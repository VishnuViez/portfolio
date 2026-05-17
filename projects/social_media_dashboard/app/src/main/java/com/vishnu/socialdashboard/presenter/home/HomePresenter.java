package com.vishnu.socialdashboard.presenter.home;

import com.vishnu.socialdashboard.data.model.Post;
import com.vishnu.socialdashboard.data.repository.PostRepository;
import com.vishnu.socialdashboard.presenter.common.BasePresenter;

import java.util.List;

public class HomePresenter extends BasePresenter<HomeContract.View> implements HomeContract.Presenter {

    private final PostRepository postRepository;

    public HomePresenter() {
        this.postRepository = new PostRepository();
    }

    @Override
    public void loadPosts() {
        if (!isViewAttached()) return;
        view.showLoading();

        postRepository.getPosts(new PostRepository.PostListCallback() {
            @Override
            public void onSuccess(List<Post> posts) {
                if (!isViewAttached()) return;
                view.hideLoading();
                if (posts != null && !posts.isEmpty()) {
                    view.showPosts(posts);
                } else {
                    view.showEmpty();
                }
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
    public void refreshPosts() {
        if (!isViewAttached()) return;

        postRepository.getPosts(new PostRepository.PostListCallback() {
            @Override
            public void onSuccess(List<Post> posts) {
                if (!isViewAttached()) return;
                view.hideLoading();
                if (posts != null && !posts.isEmpty()) {
                    view.showPosts(posts);
                } else {
                    view.showEmpty();
                }
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
    public void likePost(int postId, int position) {
        if (!isViewAttached()) return;
        view.onPostLiked(position);
    }
}
