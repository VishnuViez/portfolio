package com.vishnu.socialdashboard.data.model;

import com.google.gson.annotations.SerializedName;

public class Comment {
    @SerializedName("id")
    private int id;

    @SerializedName("postId")
    private int postId;

    private int userId;

    @SerializedName("name")
    private String username;

    private String userAvatar;

    @SerializedName("body")
    private String content;

    @SerializedName("email")
    private String email;

    private long timestamp;

    public Comment() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public int getUserId() { return userId > 0 ? userId : (id % 10 + 1); }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() {
        return username != null ? username : email;
    }
    public void setUsername(String username) { this.username = username; }

    public String getUserAvatar() {
        if (userAvatar == null || userAvatar.isEmpty()) {
            return "https://i.pravatar.cc/150?u=" + getId() + postId;
        }
        return userAvatar;
    }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public long getTimestamp() {
        return timestamp > 0 ? timestamp : System.currentTimeMillis() - (id * 1800000L);
    }
    public void setTimestamp(long timestamp) { this.timestamp = timestamp; }
}
