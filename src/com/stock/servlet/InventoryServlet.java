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
 * Controller Servlet managing general inventory views (list, warehouse, shop)
 * and stock modifications (warehouse adjustments, sales recordings).
 */
@WebServlet("/InventoryServlet")
public class InventoryServlet extends HttpServlet {
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "warehouse":
                listWarehouseStock(request, response);
                break;
            case "shop":
                listShopStock(request, response);
                break;
            case "list":
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if ("updateWarehouse".equals(action)) {
            updateWarehouseStock(request, response);
        } else if ("recordSale".equals(action)) {
            recordShopSale(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list");
        }
    }

    // --- Action Handlers ---

    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> list = productDAO.getAllProducts();
        request.setAttribute("products", list);
        request.getRequestDispatcher("/inventory.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/updateProduct.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Product not found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list&error=Invalid product ID format");
        }
    }

    private void listWarehouseStock(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> list = productDAO.getAllProducts();
        request.setAttribute("products", list);
        request.getRequestDispatcher("/warehouse.jsp").forward(request, response);
    }

    private void listShopStock(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> list = productDAO.getAllProducts();
        request.setAttribute("products", list);
        request.getRequestDispatcher("/shop.jsp").forward(request, response);
    }

    private void updateWarehouseStock(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int qty = Integer.parseInt(request.getParameter("quantity"));

            if (qty < 0) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=warehouse&error=Quantity cannot be negative");
                return;
            }

            boolean success = productDAO.updateWarehouseStock(id, qty);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=warehouse&success=Warehouse stock updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=warehouse&error=Failed to update warehouse stock");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=warehouse&error=Invalid numeric entries");
        }
    }

    private void recordShopSale(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int soldQty = Integer.parseInt(request.getParameter("soldQty"));

            if (soldQty <= 0) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Sale quantity must be positive");
                return;
            }

            Product product = productDAO.getProductById(id);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Product not found");
                return;
            }

            int currentShopQty = product.getShopQuantity();
            int currentSoldQty = product.getShopSoldQuantity();

            if (currentShopQty < soldQty) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Insufficient stock in shop floor to fulfill sale");
                return;
            }

            // Decrement shop quantity, increment sold quantity
            boolean success = productDAO.updateShopStock(id, currentShopQty - soldQty, currentSoldQty + soldQty);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&success=Sale logged successfully!");
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Failed to record sale");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Invalid numeric parameters");
        }
    }
}
