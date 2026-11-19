package vn.shopman.model;

import java.time.LocalDateTime;

public class SearchHistory {
    private int id;
    private String keyword;
    private LocalDateTime searchedAt;

    public SearchHistory(int id, String keyword, LocalDateTime searchedAt) {
        this.id = id;
        this.keyword = keyword;
        this.searchedAt = searchedAt;
    }

    public int getId() {
        return id;
    }

    public String getKeyword() {
        return keyword;
    }

    public LocalDateTime getSearchedAt() {
        return searchedAt;
    }
}
