package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.SearchHistory;
import vn.shopman.util.DB;

public class SearchHistoryDAO {
    // Returns the eight most recent searches for the customer dashboard.
    public List<SearchHistory> getSearchHistory(int customerId) throws SQLException {
        List<SearchHistory> result = new ArrayList<>();

        String query = "SELECT search_history_id, keyword, searched_at "
                + "FROM SearchHistory "
                + "WHERE customer_id = ? "
                + "ORDER BY searched_at DESC "
                + "LIMIT 8";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, customerId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(new SearchHistory(
                            resultSet.getInt(1),
                            resultSet.getString(2),
                            resultSet.getTimestamp(3).toLocalDateTime()
                    ));
                }
            }
        }

        return result;
    }

    // Persists a search term so customers can repeat recent searches.
    public void saveSearchHistory(int customerId, String keyword) throws SQLException {
        String query = "INSERT INTO SearchHistory "
                + "(customer_id, keyword, searched_at) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP)";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, customerId);
            statement.setString(2, keyword);
            statement.executeUpdate();
        }
    }
}
