package vn.shopman.model;

public class User {
    private int userId;
    private String username;
    private String role;
    private String status;
    private Integer customerId;

    public User(
            int id,
            String username,
            String role,
            Integer customerId,
            String status
    ) {
        this.userId = id;
        this.username = username;
        this.role = role;
        this.customerId = customerId;
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public String getStatus() {
        return status;
    }
}
