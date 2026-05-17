package com.vishnu.socialdashboard.data.model;

import java.util.List;

public class AnalyticsData {
    private int totalLikes;
    private int totalComments;
    private int totalShares;
    private int totalPosts;
    private List<Integer> followerGrowth;
    private float engagementRate;
    private List<Post> topPosts;

    public AnalyticsData() {}

    public AnalyticsData(int totalLikes, int totalComments, int totalShares, int totalPosts,
                         List<Integer> followerGrowth, float engagementRate, List<Post> topPosts) {
        this.totalLikes = totalLikes;
        this.totalComments = totalComments;
        this.totalShares = totalShares;
        this.totalPosts = totalPosts;
        this.followerGrowth = followerGrowth;
        this.engagementRate = engagementRate;
        this.topPosts = topPosts;
    }

    public int getTotalLikes() { return totalLikes; }
    public void setTotalLikes(int totalLikes) { this.totalLikes = totalLikes; }

    public int getTotalComments() { return totalComments; }
    public void setTotalComments(int totalComments) { this.totalComments = totalComments; }

    public int getTotalShares() { return totalShares; }
    public void setTotalShares(int totalShares) { this.totalShares = totalShares; }

    public int getTotalPosts() { return totalPosts; }
    public void setTotalPosts(int totalPosts) { this.totalPosts = totalPosts; }

    public List<Integer> getFollowerGrowth() { return followerGrowth; }
    public void setFollowerGrowth(List<Integer> followerGrowth) { this.followerGrowth = followerGrowth; }

    public float getEngagementRate() { return engagementRate; }
    public void setEngagementRate(float engagementRate) { this.engagementRate = engagementRate; }

    public List<Post> getTopPosts() { return topPosts; }
    public void setTopPosts(List<Post> topPosts) { this.topPosts = topPosts; }
}
