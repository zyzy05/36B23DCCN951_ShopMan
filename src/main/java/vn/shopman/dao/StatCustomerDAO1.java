package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.StatCustomer1;
import vn.shopman.util.DateRange;
import vn.shopman.util.DB;

public class StatCustomerDAO1 {
    // Aggregates completed invoice count and revenue per customer.
    public List<StatCustomer1> statisticsCustomerByRevenue(
            LocalDate start,
            LocalDate end
    ) throws SQLException {
        List<StatCustomer1> result = new ArrayList<>();
        LocalDate endExclusive = DateRange.exclusiveEnd(start, end);

        String query = "SELECT c.customer_id, c.customer_code, c.full_name, "
                + "c.phone, c.email, COUNT(i.invoice_id) invoice_count, "
                + "COALESCE(SUM(i.total_amount), 0) revenue "
                + "FROM Customer c "
                + "JOIN Invoice i ON i.customer_id = c.customer_id "
                + "WHERE i.created_at >= ? AND i.created_at < ? "
                + "AND i.status = 'HOÀN THÀNH' "
                + "GROUP BY c.customer_id, c.customer_code, c.full_name, c.phone, c.email "
                + "ORDER BY revenue DESC";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setDate(1, java.sql.Date.valueOf(start));
            statement.setDate(2, java.sql.Date.valueOf(endExclusive));

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(new StatCustomer1(
                            resultSet.getInt("customer_id"),
                            resultSet.getString("customer_code"),
                            resultSet.getString("full_name"),
                            resultSet.getString("phone"),
                            resultSet.getString("email"),
                            resultSet.getInt("invoice_count"),
                            resultSet.getBigDecimal("revenue")
                    ));
                }
            }
        }

        return result;
    }
}
