package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import vn.shopman.model.User;
import vn.shopman.util.DB;
import vn.shopman.util.PasswordUtil;

public class UserDAO {
    // Authenticates active users without copying their password hash into the session model.
    public User authenticate(String username, String password) throws SQLException {
        String query = "SELECT user_id, username, role, customer_id, status "
                + "FROM User "
                + "WHERE username = ? AND password_hash = ? AND status = 'HOẠT ĐỘNG'";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setString(1, username);
            statement.setString(2, PasswordUtil.sha256(password));

            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    return null;
                }

                return new User(
                        result.getInt("user_id"),
                        result.getString("username"),
                        result.getString("role"),
                        (Integer) result.getObject("customer_id"),
                        result.getString("status")
                );
            }
        }
    }
}
