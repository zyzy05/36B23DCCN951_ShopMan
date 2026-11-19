package vn.shopman.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Invoice1 {
    private int invoiceId;
    private String invoiceCode;
    private String status;
    private LocalDateTime createdAt;
    private BigDecimal total;

    public Invoice1(
            int id,
            String code,
            LocalDateTime createdAt,
            String status,
            BigDecimal total
    ) {
        invoiceId = id;
        invoiceCode = code;
        this.createdAt = createdAt;
        this.status = status;
        this.total = total;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public String getStatus() {
        return status;
    }

    public BigDecimal getTotal() {
        return total;
    }
}
