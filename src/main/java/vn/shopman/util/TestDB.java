package vn.shopman.util;

import java.sql.SQLException;

public class TestDB {
    // Checks database connectivity and prints actionable setup guidance.
    public static void main(String[] args) {
        try (var connection = DB.getConnection()) {
            System.out.println("KET NOI MYSQL THANH CONG!");
            System.out.println("URL: " + connection.getMetaData().getURL());
            System.out.println("DATABASE: " + connection.getCatalog());
        } catch (SQLException e) {
            System.err.println("KET NOI MYSQL THAT BAI!");

            String message = e.getMessage();

            if (message != null && message.contains("Access denied")) {
                System.err.println(
                        "MySQL tu choi tai khoan. "
                                + "Hay dat SHOPMAN_DB_USER va SHOPMAN_DB_PASSWORD."
                );
            } else if (message != null && message.contains("Unknown database")) {
                System.err.println(
                        "Database ShopMan chua ton tai. "
                                + "Hay chay database/shopman.sql."
                );
            } else if (message != null && message.contains("Communications link failure")) {
                System.err.println(
                        "Khong ket noi duoc MySQL. "
                                + "Hay kiem tra MySQL, host va port 3306."
                );
            }

            System.err.println(
                    "Chi tiet: " + message
            );
            System.exit(1);
        }
    }
}
