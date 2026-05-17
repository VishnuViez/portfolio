package com.vishnu.socialdashboard.presenter.common;

import com.vishnu.socialdashboard.view.common.BaseView;

public abstract class BasePresenter<V extends BaseView> {
    protected V view;

    public void attachView(V view) {
        this.view = view;
    }

    public void detachView() {
        this.view = null;
    }

    public boolean isViewAttached() {
        return view != null;
    }
}
