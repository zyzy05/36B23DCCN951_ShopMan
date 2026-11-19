package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.Invoice1;
import vn.shopman.model.Customer1;
import vn.shopman.model.InvoiceHeader1;
import vn.shopman.util.DateRange;
import vn.shopman.util.DB;

public class InvoiceDAO1 {
    // Loads the customer profile shown with a manager's invoice history.
    public Customer1 getCustomerById(int customerId) throws SQLException {
        String query = "SELECT customer_id, customer_code, full_name, phone, email, address "
                + "FROM Customer WHERE customer_id = ?";

        try (Connection connection = DB.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, customerId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }
                return new Customer1(
                        resultSet.getInt("customer_id"),
                        resultSet.getString("customer_code"),
                        resultSet.getString("full_name"),
                        resultSet.getString("phone"),
                        resultSet.getString("email"),
                        resultSet.getString("address")
                );
            }
        }
    }

    // Loads an invoice together with its customer for the invoice detail view.
    public InvoiceHeader1 getInvoiceHeader(int invoiceId) throws SQLException {
        String query = "SELECT i.invoice_id, i.invoice_code, i.created_at, i.status, "
                + "i.total_amount, i.shipping_fee, c.customer_id, c.customer_code, "
                + "c.full_name, c.phone, c.email, c.address "
                + "FROM Invoice i JOIN Customer c ON c.customer_id = i.customer_id "
                + "WHERE i.invoice_id = ?";

        try (Connection connection = DB.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, invoiceId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }
                Customer1 customer = new Customer1(
                        resultSet.getInt("customer_id"),
                        resultSet.getString("customer_code"),
                        resultSet.getString("full_name"),
                        resultSet.getString("phone"),
                        resultSet.getString("email"),
                        resultSet.getString("address")
                );
                return new InvoiceHeader1(
                        resultSet.getInt("invoice_id"),
                        resultSet.getString("invoice_code"),
                        resultSet.getTimestamp("created_at").toLocalDateTime(),
                        resultSet.getString("status"),
                        resultSet.getBigDecimal("total_amount"),
                        resultSet.getBigDecimal("shipping_fee"),
                        customer
                );
            }
        }
    }

    // Returns completed invoices in the inclusive calendar-date range.
    public List<Invoice1> getInvoicesByCustomerId(
            int customerId,
            LocalDate start,
            LocalDate end
    ) throws SQLException {
        List<Invoice1> result = new ArrayList<>();
        LocalDate endExclusive = DateRange.exclusiveEnd(start, end);

        String query = "SELECT invoice_id, invoice_code, created_at, status, total_amount "
                + "FROM Invoice "
                + "WHERE customer_id = ? AND created_at >= ? AND created_at < ? "
                + "AND status = 'HOÀN THÀNH' "
                + "ORDER BY created_at DESC";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, customerId);
            statement.setDate(2, java.sql.Date.valueOf(start));
            statement.setDate(3, java.sql.Date.valueOf(endExclusive));

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(new Invoice1(
                            resultSet.getInt(1),
                            resultSet.getString(2),
                            resultSet.getTimestamp(3).toLocalDateTime(),
                            resultSet.getString(4),
                            resultSet.getBigDecimal(5)
                    ));
                }
            }
        }

        return result;
    }
}
