package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.Product;
import vn.shopman.util.DB;

public class ProductDAO {
    private static final String BASE_QUERY =
            "SELECT p.product_id, p.product_code, p.product_name, p.brand, "
                    + "p.unit, p.unit_price, p.stock_quantity, p.description, "
                    + "p.image_url, c.category_name "
                    + "FROM Product p "
                    + "LEFT JOIN Category c ON c.category_id = p.category_id ";

    // Maps the shared product query columns into the view model.
    private Product map(ResultSet resultSet) throws SQLException {
        return new Product(
                resultSet.getInt("product_id"),
                resultSet.getString("product_code"),
                resultSet.getString("product_name"),
                resultSet.getString("brand"),
                resultSet.getString("unit"),
                resultSet.getBigDecimal("unit_price"),
                resultSet.getInt("stock_quantity"),
                resultSet.getString("description"),
                resultSet.getString("category_name"),
                resultSet.getString("image_url")
        );
    }

    // Searches names by prefix/word and product codes by substring.
    public List<Product> searchProducts(String keyword) throws SQLException {
        List<Product> result = new ArrayList<>();

        String query = BASE_QUERY
                + "WHERE (p.product_name LIKE ? ESCAPE '!' "
                + "OR p.product_name LIKE ? ESCAPE '!' "
                + "OR p.product_code LIKE ? ESCAPE '!') "
                + "ORDER BY p.product_name";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            String searchKeyword = keyword.trim()
                    .replace("!", "!!")
                    .replace("%", "!%")
                    .replace("_", "!_");
            statement.setString(1, searchKeyword + "%");
            statement.setString(2, "% " + searchKeyword + "%");
            statement.setString(3, "%" + searchKeyword + "%");

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(map(resultSet));
                }
            }
        }

        return result;
    }

    // Returns one product for the customer detail page, or null when absent.
    public Product getProductDetails(int productId) throws SQLException {
        String query = BASE_QUERY + "WHERE p.product_id = ?";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, productId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? map(resultSet) : null;
            }
        }
    }

    // Finds same-category products and caps the requested result count.
    public List<Product> getRelatedProducts(int productId, int limit) throws SQLException {
        List<Product> result = new ArrayList<>();

        String query = BASE_QUERY
                + "WHERE p.category_id = ("
                + "SELECT category_id FROM Product WHERE product_id = ?"
                + ") AND p.product_id <> ? "
                + "ORDER BY p.product_name LIMIT ?";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, productId);
            statement.setInt(2, productId);
            statement.setInt(3, Math.max(1, Math.min(limit, 12)));

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(map(resultSet));
                }
            }
        }

        return result;
    }
}
