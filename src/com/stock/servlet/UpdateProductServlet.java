package com.stock.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.stock.dao.ProductDAO;
import com.stock.model.Product;

/**
 * Controller Servlet handling modifications of existing catalog products.
 */
@WebServlet("/UpdateProductServlet")
public class UpdateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        try {
            // Retrieve parameters
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name").trim();
            String sku = request.getParameter("sku").trim();
            String description = request.getParameter("description").trim();
            String category = request.getParameter("category").trim();
            double price = Double.parseDouble(request.getParameter("price"));
            int minStock = Integer.parseInt(request.getParameter("minStock"));

            // Server-side validation
            if (name.isEmpty() || sku.isEmpty() || category.isEmpty() || price <= 0 || minStock < 0) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Invalid product parameters");
                return;
            }

            // Bind values
            Product product = new Product(id, name, sku, description, category, price, minStock);

            // Update in DB
            boolean success = productDAO.updateProduct(product);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&success=Product updated successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Failed to update product. SKU might be duplicate.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Invalid numeric inputs: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list");
    }
}
