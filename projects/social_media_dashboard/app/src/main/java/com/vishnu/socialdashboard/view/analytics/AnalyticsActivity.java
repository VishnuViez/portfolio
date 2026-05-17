package com.vishnu.socialdashboard.view.analytics;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.vishnu.socialdashboard.R;
import com.vishnu.socialdashboard.data.model.AnalyticsData;
import com.vishnu.socialdashboard.databinding.ActivityAnalyticsBinding;
import com.vishnu.socialdashboard.presenter.analytics.AnalyticsContract;
import com.vishnu.socialdashboard.presenter.analytics.AnalyticsPresenter;
import com.vishnu.socialdashboard.utils.DateUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class AnalyticsActivity extends AppCompatActivity implements AnalyticsContract.View {

    private ActivityAnalyticsBinding binding;
    private AnalyticsPresenter presenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAnalyticsBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setupToolbar();

        presenter = new AnalyticsPresenter();
        presenter.attachView(this);
        presenter.loadAnalytics();
    }

    private void setupToolbar() {
        setSupportActionBar(binding.toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle("Analytics");
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        binding.toolbar.setNavigationOnClickListener(v -> finish());
    }

    @Override
    public void showAnalytics(AnalyticsData data) {
        // Summary cards
        binding.tvTotalLikes.setText(DateUtils.formatCount(data.getTotalLikes()));
        binding.tvTotalComments.setText(DateUtils.formatCount(data.getTotalComments()));
        binding.tvTotalShares.setText(DateUtils.formatCount(data.getTotalShares()));
        binding.tvEngagementRate.setText(String.format("%.1f%%", data.getEngagementRate()));

        // Follower growth line chart
        setupFollowerGrowthChart(data.getFollowerGrowth());
    }

    @Override
    public void showWeeklyEngagement(List<Integer> engagement) {
        setupWeeklyEngagementChart(engagement);
    }

    private void setupFollowerGrowthChart(List<Integer> followerGrowth) {
        List<Entry> entries = new ArrayList<>();
        for (int i = 0; i < followerGrowth.size(); i++) {
            entries.add(new Entry(i, followerGrowth.get(i)));
        }

        LineDataSet dataSet = new LineDataSet(entries, "Followers");
        int primaryColor = getResources().getColor(R.color.primary, getTheme());
        dataSet.setColor(primaryColor);
        dataSet.setCircleColor(primaryColor);
        dataSet.setLineWidth(2f);
        dataSet.setCircleRadius(3f);
        dataSet.setDrawFilled(true);
        dataSet.setFillColor(primaryColor);
        dataSet.setFillAlpha(50);
        dataSet.setDrawValues(false);
        dataSet.setMode(LineDataSet.Mode.CUBIC_BEZIER);

        LineData lineData = new LineData(dataSet);
        binding.chartFollowerGrowth.setData(lineData);
        binding.chartFollowerGrowth.getDescription().setEnabled(false);
        binding.chartFollowerGrowth.setTouchEnabled(true);
        binding.chartFollowerGrowth.setDragEnabled(true);
        binding.chartFollowerGrowth.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        binding.chartFollowerGrowth.getAxisRight().setEnabled(false);
        binding.chartFollowerGrowth.getLegend().setEnabled(true);
        binding.chartFollowerGrowth.animateX(1000);
        binding.chartFollowerGrowth.invalidate();
    }

    private void setupWeeklyEngagementChart(List<Integer> engagement) {
        List<BarEntry> entries = new ArrayList<>();
        for (int i = 0; i < engagement.size(); i++) {
            entries.add(new BarEntry(i, engagement.get(i)));
        }

        BarDataSet dataSet = new BarDataSet(entries, "Engagement");
        int accentColor = getResources().getColor(R.color.accent, getTheme());
        dataSet.setColor(accentColor);
        dataSet.setDrawValues(true);
        dataSet.setValueTextSize(10f);

        BarData barData = new BarData(dataSet);
        barData.setBarWidth(0.7f);

        binding.chartWeeklyEngagement.setData(barData);
        binding.chartWeeklyEngagement.getDescription().setEnabled(false);

        String[] days = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
        binding.chartWeeklyEngagement.getXAxis().setValueFormatter(
                new IndexAxisValueFormatter(Arrays.asList(days)));
        binding.chartWeeklyEngagement.getXAxis().setPosition(XAxis.XAxisPosition.BOTTOM);
        binding.chartWeeklyEngagement.getXAxis().setGranularity(1f);
        binding.chartWeeklyEngagement.getAxisRight().setEnabled(false);
        binding.chartWeeklyEngagement.getLegend().setEnabled(true);
        binding.chartWeeklyEngagement.animateY(1000);
        binding.chartWeeklyEngagement.invalidate();
    }

    @Override
    public void showLoading() {
        binding.progressBar.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideLoading() {
        binding.progressBar.setVisibility(View.GONE);
    }

    @Override
    public void showError(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        presenter.detachView();
    }
}
