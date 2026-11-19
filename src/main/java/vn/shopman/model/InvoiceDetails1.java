package vn.shopman.model;

import java.math.BigDecimal;

public class InvoiceDetails1 {
    private String productCode;
    private String productName;
    private String unit;
    private int quantity;
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;

    public InvoiceDetails1(
            String code,
            String name,
            String unit,
            int quantity,
            BigDecimal unitPrice,
            BigDecimal lineTotal
    ) {
        productCode = code;
        productName = name;
        this.unit = unit;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }

    public String getProductCode() {
        return productCode;
    }

    public String getProductName() {
        return productName;
    }

    public String getUnit() {
        return unit;
    }

    public int getQuantity() {
        return quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public BigDecimal getLineTotal() {
        return lineTotal;
    }
}
