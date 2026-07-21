package com.stock.servlet;

import com.stock.dao.ProductDAO;
import com.stock.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String name = request.getParameter("name");
            String sku = request.getParameter("sku");
            String category = request.getParameter("category");

            double price =
                    Double.parseDouble(request.getParameter("price"));

            int minStock =
                    Integer.parseInt(request.getParameter("minStock"));

            int initialStock =
                    Integer.parseInt(request.getParameter("initialStock"));

            String description =
                    request.getParameter("description");

            Product product = new Product();

            product.setName(name);
            product.setSku(sku);
            product.setCategory(category);
            product.setPrice(price);
            product.setMinStock(minStock);
            product.setWarehouseQuantity(initialStock);
            product.setDescription(description);

            ProductDAO dao = new ProductDAO();

            boolean success = dao.addProduct(product);

            if(success) {
                response.sendRedirect(
                        "InventoryServlet?action=list&msg=added");
            } else {
                response.sendRedirect(
                        "addProduct.jsp?error=1");
            }

        } catch(Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    "addProduct.jsp?error=1");
        }
    }
}