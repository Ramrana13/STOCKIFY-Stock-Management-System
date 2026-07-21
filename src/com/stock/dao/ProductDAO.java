package com.stock.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.stock.conn.DBConnection;
import com.stock.model.Product;

/**
 * Data Access Object (DAO) for Product operations. Handles CRUD, stocks in warehouse
 * and shop, search filters, and dashboard analytics.
 */
public class ProductDAO {

    /**
     * Creates a product and initializes its stock in both warehouse and shop to 0.
     */
    public boolean addProduct(Product product) {
        String insertProduct = "INSERT INTO products (name, sku, description, category, price, min_stock) VALUES (?, ?, ?, ?, ?, ?)";
        String initWarehouse = "INSERT INTO warehouse_stock (product_id, quantity) VALUES (?, ?)";
        String initShop = "INSERT INTO shop_stock (product_id, quantity, sold_quantity) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Enable Transaction
            
            try (PreparedStatement ps1 = conn.prepareStatement(insertProduct, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps1.setString(1, product.getName());
                ps1.setString(2, product.getSku());
                ps1.setString(3, product.getDescription());
                ps1.setString(4, product.getCategory());
                ps1.setDouble(5, product.getPrice());
                ps1.setInt(6, product.getMinStock());
                
                int affectedRows = ps1.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
                
                int productId = 0;
                try (ResultSet generatedKeys = ps1.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        productId = generatedKeys.getInt(1);
                    }
                }
                
                // Initialize warehouse stock (default quantity: 0)
                try (PreparedStatement ps2 = conn.prepareStatement(initWarehouse)) {
                    ps2.setInt(1, productId);
                    ps2.setInt(2, product.getWarehouseQuantity()); // Use what is provided (usually 0)
                    ps2.executeUpdate();
                }
                
                // Initialize shop stock (default quantity: 0, sold: 0)
                try (PreparedStatement ps3 = conn.prepareStatement(initShop)) {
                    ps3.setInt(1, productId);
                    ps3.setInt(2, product.getShopQuantity());
                    ps3.setInt(3, product.getShopSoldQuantity());
                    ps3.executeUpdate();
                }
                
                conn.commit(); // Commit Transaction
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing product's metadata in the database.
     */
    public boolean updateProduct(Product product) {
        String query = "UPDATE products SET name = ?, sku = ?, description = ?, category = ?, price = ?, min_stock = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, product.getName());
            ps.setString(2, product.getSku());
            ps.setString(3, product.getDescription());
            ps.setString(4, product.getCategory());
            ps.setDouble(5, product.getPrice());
            ps.setInt(6, product.getMinStock());
            ps.setInt(7, product.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a product from the database (foreign key constraints handle stock cascade).
     */
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves a single product by ID, along with its warehouse and shop quantities.
     */
    public Product getProductById(int id) {
        String query = "SELECT p.*, w.quantity AS warehouse_qty, s.quantity AS shop_qty, s.sold_quantity AS shop_sold_qty " +
                       "FROM products p " +
                       "LEFT JOIN warehouse_stock w ON p.id = w.product_id " +
                       "LEFT JOIN shop_stock s ON p.id = s.product_id " +
                       "WHERE p.id = ?";
        Product product = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    product = mapProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving product by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    /**
     * Retrieves all products along with their stock levels.
     */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.*, w.quantity AS warehouse_qty, s.quantity AS shop_qty, s.sold_quantity AS shop_sold_qty " +
                       "FROM products p " +
                       "LEFT JOIN warehouse_stock w ON p.id = w.product_id " +
                       "LEFT JOIN shop_stock s ON p.id = s.product_id " +
                       "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all products: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Searches products by name, SKU, or category.
     */
    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.*, w.quantity AS warehouse_qty, s.quantity AS shop_qty, s.sold_quantity AS shop_sold_qty " +
                       "FROM products p " +
                       "LEFT JOIN warehouse_stock w ON p.id = w.product_id " +
                       "LEFT JOIN shop_stock s ON p.id = s.product_id " +
                       "WHERE p.name LIKE ? OR p.sku LIKE ? OR p.category LIKE ? " +
                       "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns products where total inventory (warehouse + shop) is at or below the min_stock level.
     */
    public List<Product> getLowStockProducts() {
        List<Product> list = new ArrayList<>();
        String query = "SELECT p.*, w.quantity AS warehouse_qty, s.quantity AS shop_qty, s.sold_quantity AS shop_sold_qty " +
                       "FROM products p " +
                       "LEFT JOIN warehouse_stock w ON p.id = w.product_id " +
                       "LEFT JOIN shop_stock s ON p.id = s.product_id " +
                       "WHERE (COALESCE(w.quantity, 0) + COALESCE(s.quantity, 0)) <= p.min_stock " +
                       "ORDER BY p.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving low stock products: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Updates warehouse stock quantity for a product.
     */
    public boolean updateWarehouseStock(int productId, int quantity) {
        String query = "UPDATE warehouse_stock SET quantity = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating warehouse stock: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates shop stock quantity and logs/updates sold count for a product.
     */
    public boolean updateShopStock(int productId, int quantity, int soldQuantity) {
        String query = "UPDATE shop_stock SET quantity = ?, sold_quantity = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, quantity);
            ps.setInt(2, soldQuantity);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating shop stock: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // --- Analytics Methods ---

    /**
     * Gets total distinct product definitions in the system.
     */
    public int getTotalProductCount() {
        String query = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gets total inventory quantity (sum of central warehouse and shop inventories).
     */
    public int getTotalStockQuantity() {
        String query = "SELECT (SELECT SUM(quantity) FROM warehouse_stock) + (SELECT SUM(quantity) FROM shop_stock)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gets count of products that are in low stock state.
     */
    public int getLowStockCount() {
        String query = "SELECT COUNT(*) FROM products p " +
                       "LEFT JOIN warehouse_stock w ON p.id = w.product_id " +
                       "LEFT JOIN shop_stock s ON p.id = s.product_id " +
                       "WHERE (COALESCE(w.quantity, 0) + COALESCE(s.quantity, 0)) <= p.min_stock";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Maps ResultSet rows into Product entity.
     */
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setSku(rs.getString("sku"));
        p.setDescription(rs.getString("description"));
        p.setCategory(rs.getString("category"));
        p.setPrice(rs.getDouble("price"));
        p.setMinStock(rs.getInt("min_stock"));
        p.setWarehouseQuantity(rs.getInt("warehouse_qty"));
        p.setShopQuantity(rs.getInt("shop_qty"));
        p.setShopSoldQuantity(rs.getInt("shop_sold_qty"));
        return p;
    }
}
