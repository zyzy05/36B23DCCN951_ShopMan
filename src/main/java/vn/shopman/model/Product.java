package vn.shopman.model;

import java.math.BigDecimal;

public class Product {
    private final int productId;
    private final String productCode;
    private final String name;
    private final String brand;
    private final String unit;
    private final String description;
    private final String category;
    private final String imageUrl;
    private final BigDecimal price;
    private final int stock;

    public Product(
            int id,
            String code,
            String name,
            String brand,
            String unit,
            BigDecimal price,
            int stock,
            String description,
            String category,
            String imageUrl
    ) {
        productId = id;
        productCode = code;
        this.name = name;
        this.brand = brand;
        this.unit = unit;
        this.price = price;
        this.stock = stock;
        this.description = description;
        this.category = category;
        this.imageUrl = imageUrl;
    }

    public int getProductId() {
        return productId;
    }

    public String getProductCode() {
        return productCode;
    }

    public String getName() {
        return name;
    }

    public String getBrand() {
        return brand;
    }

    public String getUnit() {
        return unit;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public int getStock() {
        return stock;
    }

    public String getDescription() {
        return description;
    }

    public String getCategory() {
        return category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

}
