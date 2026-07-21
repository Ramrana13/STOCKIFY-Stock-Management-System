package com.stock.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.stock.conn.DBConnection;
import com.stock.model.User;

/**
 * Data Access Object for Users table. Handles admin login credentials validation.
 */
public class UserDAO {

    /**
     * Validates the login credentials against database records.
     * @param username Given username
     * @param password Given password
     * @return User object if credentials are correct, null otherwise
     */
    public User validateUser(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("full_name"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error validating user login: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
}
