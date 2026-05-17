package com.vishnu.socialdashboard.data.model;

import com.google.gson.annotations.SerializedName;

public class User {
    @SerializedName("id")
    private int id;

    @SerializedName("username")
    private String username;

    @SerializedName("name")
    private String displayName;

    private String avatarUrl;

    @SerializedName("phone")
    private String bio;

    private int followersCount;
    private int followingCount;
    private int postsCount;

    public User() {}

    public User(int id, String username, String displayName, String avatarUrl, String bio,
                int followersCount, int followingCount, int postsCount) {
        this.id = id;
        this.username = username;
        this.displayName = displayName;
        this.avatarUrl = avatarUrl;
        this.bio = bio;
        this.followersCount = followersCount;
        this.followingCount = followingCount;
        this.postsCount = postsCount;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getAvatarUrl() {
        if (avatarUrl == null || avatarUrl.isEmpty()) {
            return "https://i.pravatar.cc/150?u=" + id;
        }
        return avatarUrl;
    }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getFollowersCount() { return followersCount > 0 ? followersCount : (id * 234 + 100); }
    public void setFollowersCount(int followersCount) { this.followersCount = followersCount; }

    public int getFollowingCount() { return followingCount > 0 ? followingCount : (id * 56 + 50); }
    public void setFollowingCount(int followingCount) { this.followingCount = followingCount; }

    public int getPostsCount() { return postsCount > 0 ? postsCount : (id * 12 + 10); }
    public void setPostsCount(int postsCount) { this.postsCount = postsCount; }
}
