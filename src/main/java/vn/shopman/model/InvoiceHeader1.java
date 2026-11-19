package vn.shopman.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class InvoiceHeader1 {
    private final int invoiceId;
    private final String invoiceCode;
    private final LocalDateTime createdAt;
    private final String status;
    private final BigDecimal total;
    private final BigDecimal shippingFee;
    private final Customer1 customer;

    public InvoiceHeader1(int invoiceId, String invoiceCode, LocalDateTime createdAt,
                          String status, BigDecimal total, BigDecimal shippingFee,
                          Customer1 customer) {
        this.invoiceId = invoiceId;
        this.invoiceCode = invoiceCode;
        this.createdAt = createdAt;
        this.status = status;
        this.total = total;
        this.shippingFee = shippingFee;
        this.customer = customer;
    }

    public int getInvoiceId() { return invoiceId; }
    public String getInvoiceCode() { return invoiceCode; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public String getStatus() { return status; }
    public BigDecimal getTotal() { return total; }
    public BigDecimal getShippingFee() { return shippingFee; }
    public Customer1 getCustomer() { return customer; }
}
