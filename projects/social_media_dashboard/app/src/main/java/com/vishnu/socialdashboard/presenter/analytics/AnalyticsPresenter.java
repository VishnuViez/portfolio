package com.vishnu.socialdashboard.presenter.analytics;

import com.vishnu.socialdashboard.data.model.AnalyticsData;
import com.vishnu.socialdashboard.data.repository.AnalyticsRepository;
import com.vishnu.socialdashboard.presenter.common.BasePresenter;

import java.util.List;

public class AnalyticsPresenter extends BasePresenter<AnalyticsContract.View> implements AnalyticsContract.Presenter {

    private final AnalyticsRepository analyticsRepository;

    public AnalyticsPresenter() {
        this.analyticsRepository = new AnalyticsRepository();
    }

    @Override
    public void loadAnalytics() {
        if (!isViewAttached()) return;
        view.showLoading();

        analyticsRepository.getAnalytics(new AnalyticsRepository.AnalyticsCallback() {
            @Override
            public void onSuccess(AnalyticsData data) {
                if (!isViewAttached()) return;
                view.hideLoading();
                view.showAnalytics(data);

                List<Integer> weeklyEngagement = analyticsRepository.getWeeklyEngagement();
                view.showWeeklyEngagement(weeklyEngagement);
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
