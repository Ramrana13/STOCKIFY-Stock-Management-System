package com.stock.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * JavaBean representing a Transfer request from Warehouse to Shop.
 */
public class Transfer implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int productId;
    private int quantity;
    private String status; // PENDING, APPROVED, REJECTED
    private Timestamp requestDate;

    // Helper fields for details/audit lists
    private String productName;
    private String productSku;
    private Timestamp actionDate;

    // Default constructor
    public Transfer() {}

    public Transfer(int id, int productId, int quantity, String status, Timestamp requestDate) {
        this.id = id;
        this.productId = productId;
        this.quantity = quantity;
        this.status = status;
        this.requestDate = requestDate;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductSku() {
        return productSku;
    }

    public void setProductSku(String productSku) {
        this.productSku = productSku;
    }

    public Timestamp getActionDate() {
        return actionDate;
    }

    public void setActionDate(Timestamp actionDate) {
        this.actionDate = actionDate;
    }

    @Override
    public String toString() {
        return "Transfer [id=" + id + ", productId=" + productId + ", quantity=" + quantity + ", status=" + status + "]";
    }
}
