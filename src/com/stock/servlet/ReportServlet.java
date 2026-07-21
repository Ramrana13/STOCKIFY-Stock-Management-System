package com.stock.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.stock.dao.ProductDAO;
import com.stock.model.Product;

/**
 * Controller Servlet for loading and filtering historical reports.
 */
@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        this.productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        String filter = request.getParameter("filter");
        List<Product> productsList;

        if ("low".equals(filter)) {
            // Retrieve only products at or below safety stock limits
            productsList = productDAO.getLowStockProducts();
        } else {
            // Retrieve all products
            productsList = productDAO.getAllProducts();
        }

        // Set attributes and forward to View
        request.setAttribute("products", productsList);
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
