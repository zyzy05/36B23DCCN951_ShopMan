package vn.shopman.model;

import java.math.BigDecimal;

public class StatCustomer1 {
    private int customerId;
    private int invoiceCount;
    private String customerCode;
    private String fullName;
    private String phone;
    private String email;
    private BigDecimal revenue;

    public StatCustomer1(
            int id,
            String code,
            String name,
            String phone,
            String email,
            int count,
            BigDecimal revenue
    ) {
        customerId = id;
        customerCode = code;
        fullName = name;
        this.phone = phone;
        this.email = email;
        invoiceCount = count;
        this.revenue = revenue;
    }

    public int getCustomerId() {
        return customerId;
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public String getFullName() {
        return fullName;
    }

    public String getPhone() {
        return phone;
    }

    public String getEmail() {
        return email;
    }

    public int getInvoiceCount() {
        return invoiceCount;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }
}
