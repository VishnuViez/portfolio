package com.vishnu.socialdashboard.data.model;

import java.util.List;

public class Feed {
    private List<Post> posts;
    private int page;
    private boolean hasMore;

    public Feed() {}

    public Feed(List<Post> posts, int page, boolean hasMore) {
        this.posts = posts;
        this.page = page;
        this.hasMore = hasMore;
    }

    public List<Post> getPosts() { return posts; }
    public void setPosts(List<Post> posts) { this.posts = posts; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }

    public boolean isHasMore() { return hasMore; }
    public void setHasMore(boolean hasMore) { this.hasMore = hasMore; }
}
