package vn.shopman.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import com.mysql.cj.jdbc.Driver;

public final class DB {
    private DB() {
    }

    // Resolves configuration in system-property, environment, then default order.
    private static String config(String property, String environment, String fallback) {
        String value = System.getProperty(property);

        if (value == null || value.isBlank()) {
            value = System.getenv(environment);
        }

        return value == null || value.isBlank() ? fallback : value.trim();
    }

    // Opens one JDBC connection using the configured MySQL connection settings.
    public static Connection getConnection() throws SQLException {
        String host = config("shopman.db.host", "SHOPMAN_DB_HOST", "localhost");
        String port = config("shopman.db.port", "SHOPMAN_DB_PORT", "3306");
        String database = config("shopman.db.database", "SHOPMAN_DB_DATABASE", "ShopMan");
        String user = config("shopman.db.user", "SHOPMAN_DB_USER", "root");
        String password = config("shopman.db.password", "SHOPMAN_DB_PASSWORD", "240870");

        String url = config(
                "shopman.db.url",
                "SHOPMAN_DB_URL",
                "jdbc:mysql://" + host + ":" + port + "/" + database
                        + "?useUnicode=true&characterEncoding=UTF-8"
                        + "&serverTimezone=Asia/Ho_Chi_Minh"
                        + "&useSSL=false&allowPublicKeyRetrieval=true");

        Properties properties = new Properties();
        properties.setProperty("user", user);
        properties.setProperty("password", password);

        Connection connection = new Driver().connect(url, properties);
        if (connection == null) {
            throw new SQLException("The configured URL is not a supported MySQL JDBC URL.");
        }
        return connection;
    }
}
