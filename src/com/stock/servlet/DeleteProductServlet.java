package com.stock.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.stock.dao.ProductDAO;

/**
 * Controller Servlet handling the deletion of product records from the catalog database.
 */
@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            
            // Delete product
            boolean success = productDAO.deleteProduct(productId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&success=Product deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Failed to delete product");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Invalid product ID format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
