package com.stock.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.stock.conn.DBConnection;
import com.stock.model.Transfer;

public class TransferDAO {

    // CREATE TRANSFER REQUEST
    public boolean createTransferRequest(int productId, int quantity) {

        String sql =
            "INSERT INTO transfers(product_id, quantity, status) " +
            "VALUES (?, ?, 'PENDING')";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setInt(1, productId);
            ps.setInt(2, quantity);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }

    // GET PENDING TRANSFERS
    public List<Transfer> getPendingTransfers() {

        List<Transfer> list = new ArrayList<>();

        String sql =
            "SELECT t.*, p.name AS product_name, p.sku AS product_sku " +
            "FROM transfers t " +
            "JOIN products p ON t.product_id = p.id " +
            "WHERE t.status='PENDING' " +
            "ORDER BY t.transfer_date DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Transfer t = new Transfer();

                t.setId(rs.getInt("id"));
                t.setProductId(rs.getInt("product_id"));
                t.setQuantity(rs.getInt("quantity"));
                t.setStatus(rs.getString("status"));

                t.setRequestDate(
                    rs.getTimestamp("transfer_date")
                );

                t.setProductName(
                    rs.getString("product_name")
                );

                t.setProductSku(
                    rs.getString("product_sku")
                );

                list.add(t);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    // GET TRANSFER HISTORY
    public List<Transfer> getTransferHistory() {

        List<Transfer> list = new ArrayList<>();

        String sql =
            "SELECT th.*, p.name AS product_name, p.sku AS product_sku " +
            "FROM transfer_history th " +
            "JOIN products p ON th.product_id = p.id " +
            "ORDER BY th.action_date DESC";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            while (rs.next()) {

                Transfer t = new Transfer();

                t.setId(rs.getInt("id"));
                t.setProductId(rs.getInt("product_id"));
                t.setQuantity(rs.getInt("quantity"));
                t.setStatus(rs.getString("status"));

                t.setActionDate(
                    rs.getTimestamp("action_date")
                );

                t.setProductName(
                    rs.getString("product_name")
                );

                t.setProductSku(
                    rs.getString("product_sku")
                );

                list.add(t);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    // APPROVE TRANSFER
    public boolean approveTransfer(int transferId) {

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();

            conn.setAutoCommit(false);

            // GET TRANSFER DETAILS
            String getTransfer =
                "SELECT * FROM transfers " +
                "WHERE id=? AND status='PENDING'";

            PreparedStatement ps1 =
                conn.prepareStatement(getTransfer);

            ps1.setInt(1, transferId);

            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) {

                conn.rollback();
                return false;
            }

            int productId =
                rs.getInt("product_id");

            int quantity =
                rs.getInt("quantity");

            // CHECK WAREHOUSE STOCK
            String warehouseQuery =
                "SELECT quantity FROM warehouse_stock " +
                "WHERE product_id=?";

            PreparedStatement ps2 =
                conn.prepareStatement(warehouseQuery);

            ps2.setInt(1, productId);

            ResultSet rs2 = ps2.executeQuery();

            if (!rs2.next()) {

                conn.rollback();
                return false;
            }

            int warehouseQty =
                rs2.getInt("quantity");

            if (warehouseQty < quantity) {

                conn.rollback();
                return false;
            }

            // REDUCE WAREHOUSE STOCK
            String reduceWarehouse =
                "UPDATE warehouse_stock " +
                "SET quantity = quantity - ? " +
                "WHERE product_id=?";

            PreparedStatement ps3 =
                conn.prepareStatement(reduceWarehouse);

            ps3.setInt(1, quantity);
            ps3.setInt(2, productId);

            ps3.executeUpdate();

            // UPDATE SHOP STOCK
            String updateShop =
                "UPDATE shop_stock " +
                "SET quantity = quantity + ? " +
                "WHERE product_id=?";

            PreparedStatement ps4 =
                conn.prepareStatement(updateShop);

            ps4.setInt(1, quantity);
            ps4.setInt(2, productId);

            int rowsUpdated =
                ps4.executeUpdate();

            // IF SHOP STOCK ROW DOES NOT EXIST
            if (rowsUpdated == 0) {

                String insertShop =
                    "INSERT INTO shop_stock(product_id, quantity, sold_quantity) " +
                    "VALUES (?, ?, 0)";

                PreparedStatement psInsert =
                    conn.prepareStatement(insertShop);

                psInsert.setInt(1, productId);
                psInsert.setInt(2, quantity);

                psInsert.executeUpdate();
            }

            // UPDATE TRANSFER STATUS
            String approveTransfer =
                "UPDATE transfers " +
                "SET status='APPROVED' " +
                "WHERE id=?";

            PreparedStatement ps5 =
                conn.prepareStatement(approveTransfer);

            ps5.setInt(1, transferId);

            ps5.executeUpdate();

            // INSERT HISTORY
            String insertHistory =
                "INSERT INTO transfer_history " +
                "(transfer_id, product_id, quantity, status) " +
                "VALUES (?, ?, ?, 'APPROVED')";

            PreparedStatement ps6 =
                conn.prepareStatement(insertHistory);

            ps6.setInt(1, transferId);
            ps6.setInt(2, productId);
            ps6.setInt(3, quantity);

            ps6.executeUpdate();

            conn.commit();

            return true;

        } catch (Exception e) {

            try {

                if (conn != null) {

                    conn.rollback();
                }

            } catch (Exception ex) {

                ex.printStackTrace();
            }

            e.printStackTrace();

            return false;

        } finally {

            try {

                if (conn != null) {

                    conn.setAutoCommit(true);
                    conn.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }

    // REJECT TRANSFER
    public boolean rejectTransfer(int transferId) {

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();

            conn.setAutoCommit(false);

            String getTransfer =
                "SELECT * FROM transfers " +
                "WHERE id=? AND status='PENDING'";

            PreparedStatement ps1 =
                conn.prepareStatement(getTransfer);

            ps1.setInt(1, transferId);

            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) {

                conn.rollback();
                return false;
            }

            int productId =
                rs.getInt("product_id");

            int quantity =
                rs.getInt("quantity");

            // UPDATE STATUS
            String rejectTransfer =
                "UPDATE transfers " +
                "SET status='REJECTED' " +
                "WHERE id=?";

            PreparedStatement ps2 =
                conn.prepareStatement(rejectTransfer);

            ps2.setInt(1, transferId);

            ps2.executeUpdate();

            // INSERT HISTORY
            String insertHistory =
                "INSERT INTO transfer_history " +
                "(transfer_id, product_id, quantity, status) " +
                "VALUES (?, ?, ?, 'REJECTED')";

            PreparedStatement ps3 =
                conn.prepareStatement(insertHistory);

            ps3.setInt(1, transferId);
            ps3.setInt(2, productId);
            ps3.setInt(3, quantity);

            ps3.executeUpdate();

            conn.commit();

            return true;

        } catch (Exception e) {

            try {

                if (conn != null) {

                    conn.rollback();
                }

            } catch (Exception ex) {

                ex.printStackTrace();
            }

            e.printStackTrace();

            return false;

        } finally {

            try {

                if (conn != null) {

                    conn.setAutoCommit(true);
                    conn.close();
                }

            } catch (Exception e) {

                e.printStackTrace();
            }
        }
    }

    // GET PENDING COUNT
    public int getPendingTransfersCount() {

        String sql =
            "SELECT COUNT(*) FROM transfers " +
            "WHERE status='PENDING'";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            if (rs.next()) {

                return rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }
}



