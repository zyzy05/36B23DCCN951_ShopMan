package vn.shopman.model;

import java.time.LocalDateTime;

public class Review {
    private String customerName;
    private String content;
    private int rating;
    private LocalDateTime createdAt;

    public Review(String name, int rating, String content, LocalDateTime createdAt) {
        customerName = name;
        this.rating = rating;
        this.content = content;
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public int getRating() {
        return rating;
    }

    public String getContent() {
        return content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
