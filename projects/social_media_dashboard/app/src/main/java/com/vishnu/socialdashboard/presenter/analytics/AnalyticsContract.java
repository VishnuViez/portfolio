package com.vishnu.socialdashboard.presenter.analytics;

import com.vishnu.socialdashboard.data.model.AnalyticsData;
import com.vishnu.socialdashboard.view.common.BaseView;

import java.util.List;

public interface AnalyticsContract {

    interface View extends BaseView {
        void showAnalytics(AnalyticsData data);
        void showWeeklyEngagement(List<Integer> engagement);
    }

    interface Presenter {
        void loadAnalytics();
    }
}
