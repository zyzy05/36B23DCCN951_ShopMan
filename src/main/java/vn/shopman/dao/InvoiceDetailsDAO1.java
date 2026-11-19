package vn.shopman.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import vn.shopman.model.InvoiceDetails1;
import vn.shopman.util.DB;

public class InvoiceDetailsDAO1 {
    // Loads the product rows displayed on an invoice detail page.
    public List<InvoiceDetails1> getInvoiceDetails(int invoiceId) throws SQLException {
        List<InvoiceDetails1> result = new ArrayList<>();

        String query = "SELECT p.product_code, p.product_name, p.unit, "
                + "d.quantity, d.unit_price, d.line_total "
                + "FROM InvoiceDetails d "
                + "JOIN Product p ON p.product_id = d.product_id "
                + "WHERE d.invoice_id = ?";

        try (
                Connection connection = DB.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {
            statement.setInt(1, invoiceId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(new InvoiceDetails1(
                            resultSet.getString(1),
                            resultSet.getString(2),
                            resultSet.getString(3),
                            resultSet.getInt(4),
                            resultSet.getBigDecimal(5),
                            resultSet.getBigDecimal(6)
                    ));
                }
            }
        }

        return result;
    }
}
