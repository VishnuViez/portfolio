package com.vishnu.socialdashboard.data.repository;

import com.vishnu.socialdashboard.data.model.AnalyticsData;
import com.vishnu.socialdashboard.data.model.Post;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class AnalyticsRepository {

    public interface AnalyticsCallback {
        void onSuccess(AnalyticsData data);
        void onError(String message);
    }

    public void getAnalytics(AnalyticsCallback callback) {
        // Generate mock analytics data
        Random random = new Random(42);

        List<Integer> followerGrowth = new ArrayList<>();
        int base = 1200;
        for (int i = 0; i < 30; i++) {
            base += random.nextInt(80) - 20;
            followerGrowth.add(base);
        }

        List<Post> topPosts = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Post post = new Post();
            post.setId(i);
            post.setUserId(1);
            post.setContent("Top performing post #" + i);
            post.setLikesCount(random.nextInt(500) + 200);
            post.setCommentsCount(random.nextInt(100) + 20);
            post.setSharesCount(random.nextInt(50) + 10);
            topPosts.add(post);
        }

        AnalyticsData data = new AnalyticsData(
                12450,
                3280,
                1890,
                156,
                followerGrowth,
                4.7f,
                topPosts
        );

        callback.onSuccess(data);
    }

    public List<Integer> getWeeklyEngagement() {
        List<Integer> engagement = new ArrayList<>();
        Random random = new Random(123);
        String[] days = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
        for (int i = 0; i < 7; i++) {
            engagement.add(random.nextInt(300) + 100);
        }
        return engagement;
    }
}
