package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.Review;
import vn.shopman.util.DB;

public class ReviewDAO {
    // Loads reviews newest-first for a product detail page.
    public List<Review> getReviewsByProductId(int productId) throws SQLException {
        List<Review> result = new ArrayList<>();

        String query = "SELECT c.full_name, r.rating, r.comment, r.created_at "
                + "FROM Review r "
                + "JOIN Customer c ON c.customer_id = r.customer_id "
                + "WHERE r.product_id = ? "
                + "ORDER BY r.created_at DESC";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, productId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Timestamp createdAt = resultSet.getTimestamp(4);
                    result.add(new Review(
                            resultSet.getString(1),
                            resultSet.getInt(2),
                            resultSet.getString(3),
                            createdAt == null ? null : createdAt.toLocalDateTime()
                    ));
                }
            }
        }

        return result;
    }
}
