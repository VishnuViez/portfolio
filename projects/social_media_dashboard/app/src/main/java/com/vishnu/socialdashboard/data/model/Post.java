package com.vishnu.socialdashboard.data.model;

import com.google.gson.annotations.SerializedName;

public class Post {
    @SerializedName("id")
    private int id;

    @SerializedName("userId")
    private int userId;

    private String username;
    private String userAvatar;

    @SerializedName("body")
    private String content;

    private String imageUrl;

    @SerializedName("title")
    private String title;

    private int likesCount;
    private int commentsCount;
    private int sharesCount;
    private long timestamp;
    private boolean isLiked;

    public Post() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() {
        return username != null ? username : "user_" + userId;
    }
    public void setUsername(String username) { this.username = username; }

    public String getUserAvatar() {
        if (userAvatar == null || userAvatar.isEmpty()) {
            return "https://i.pravatar.cc/150?u=" + userId;
        }
        return userAvatar;
    }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getImageUrl() {
        if (id % 3 == 0) {
            return "https://picsum.photos/seed/" + id + "/600/400";
        }
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getLikesCount() { return likesCount > 0 ? likesCount : (id * 17 + 5); }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }

    public int getCommentsCount() { return commentsCount > 0 ? commentsCount : (id * 3 + 1); }
    public void setCommentsCount(int commentsCount) { this.commentsCount = commentsCount; }

    public int getSharesCount() { return sharesCount > 0 ? sharesCount : (id * 2); }
    public void setSharesCount(int sharesCount) { this.sharesCount = sharesCount; }

    public long getTimestamp() {
        return timestamp > 0 ? timestamp : System.currentTimeMillis() - (id * 3600000L);
    }
    public void setTimestamp(long timestamp) { this.timestamp = timestamp; }

    public boolean isLiked() { return isLiked; }
    public void setLiked(boolean liked) { isLiked = liked; }
}
