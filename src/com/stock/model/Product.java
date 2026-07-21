package com.stock.model;

import java.io.Serializable;

/**
 * JavaBean representing a Product. Contains basic details and helper fields
 * representing associated warehouse and shop stock levels for unified rendering.
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String sku;
    private String description;
    private String category;
    private double price;
    private int minStock;

    // Helper fields populated when joining stock tables
    private int warehouseQuantity;
    private int shopQuantity;
    private int shopSoldQuantity;

    // Default constructor
    public Product() {}

    // Constructor with main parameters
    public Product(int id, String name, String sku, String description, String category, double price, int minStock) {
        this.id = id;
        this.name = name;
        this.sku = sku;
        this.description = description;
        this.category = category;
        this.price = price;
        this.minStock = minStock;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getMinStock() {
        return minStock;
    }

    public void setMinStock(int minStock) {
        this.minStock = minStock;
    }

    public int getWarehouseQuantity() {
        return warehouseQuantity;
    }

    public void setWarehouseQuantity(int warehouseQuantity) {
        this.warehouseQuantity = warehouseQuantity;
    }

    public int getShopQuantity() {
        return shopQuantity;
    }

    public void setShopQuantity(int shopQuantity) {
        this.shopQuantity = shopQuantity;
    }

    public int getShopSoldQuantity() {
        return shopSoldQuantity;
    }

    public void setShopSoldQuantity(int shopSoldQuantity) {
        this.shopSoldQuantity = shopSoldQuantity;
    }

    // Checking if stock is below safe threshold
    public boolean isLowStock() {
        // Safe check across total inventory or individual locations
        return (warehouseQuantity + shopQuantity) <= minStock;
    }

    @Override
    public String toString() {
        return "Product [id=" + id + ", name=" + name + ", sku=" + sku + ", price=" + price + ", minStock=" + minStock + "]";
    }
}
