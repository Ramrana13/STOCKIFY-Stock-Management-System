<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.model.Product" %>
<%@ page import="java.util.List" %>
<%
    // Fetch products list sent by InventoryServlet
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) {
        // Redirect to servlet if page accessed directly
        response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Inventory - Stock Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom Style Sheet -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="container my-4">
        <!-- Breadcrumbs & Header -->
        <div class="row align-items-center mb-4 animate-fade-in">
            <div class="col-md-6">
                <h2 class="font-bold mb-1"><i class="bi bi-list-stars text-primary"></i> Product Catalog</h2>
                <p class="text-secondary mb-0">Manage and query item metadata definitions.</p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <a href="<%= request.getContextPath() %>/addProduct.jsp" class="btn btn-premium">
                    <i class="bi bi-plus-lg"></i> Add New Product
                </a>
            </div>
        </div>

        <!-- Controls Card (Search and Stats Summary) -->
        <div class="row mb-4 animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-3">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                                <input type="text" id="productSearch" onkeyup="filterTable('productSearch', 'productTable')" class="form-control form-control-premium border-start-0" placeholder="Search by name, SKU, category...">
                            </div>
                        </div>
                        <div class="col-md-6 text-md-end mt-2 mt-md-0">
                            <span class="text-secondary font-semibold me-3">Total Displayed: <strong id="rowCount" class="text-dark"><%= products.size() %></strong> items</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Catalog Table -->
        <div class="row animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-4">
                    <div class="table-responsive">
                        <% if (products.isEmpty()) { %>
                            <div class="text-center py-5 text-secondary">
                                <i class="bi bi-emoji-neutral fs-1 text-muted"></i>
                                <h4 class="mt-3">No Products Registered</h4>
                                <p class="mb-4">Get started by inserting your first product into the database.</p>
                                <a href="<%= request.getContextPath() %>/addProduct.jsp" class="btn btn-premium btn-sm">Add Product</a>
                            </div>
                        <% } else { %>
                            <table class="table table-hover table-premium align-middle" id="productTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Product Details</th>
                                        <th>SKU / Code</th>
                                        <th>Category</th>
                                        <th>Price (INR)</th>
                                        <th>Safety Stock</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Product p : products) { %>
                                        <tr>
                                            <td><strong>#<%= p.getId() %></strong></td>
                                            <td>
                                                <div class="font-semibold"><%= p.getName() %></div>
                                                <small class="text-muted"><%= p.getDescription() != null && p.getDescription().length() > 60 ? p.getDescription().substring(0, 57) + "..." : p.getDescription() %></small>
                                            </td>
                                            <td><span class="badge bg-light text-dark font-semibold border"><%= p.getSku() %></span></td>
                                            <td><%= p.getCategory() %></td>
                                            <td class="font-semibold">&#8377; <%= String.format("%,.2f", p.getPrice()) %></td>
                                            <td>
                                                <span class="badge bg-dark-subtle text-dark border"><%= p.getMinStock() %> units</span>
                                            </td>
                                            <td class="text-center">
                                                <a href="<%= request.getContextPath() %>/InventoryServlet?action=edit&id=<%= p.getId() %>" class="btn btn-sm btn-outline-primary me-1" data-bs-toggle="tooltip" title="Edit Product">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="<%= request.getContextPath() %>/DeleteProductServlet?id=<%= p.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to delete this product? All stock entries will be permanently removed!')" data-bs-toggle="tooltip" title="Delete Product">
                                                    <i class="bi bi-trash"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />
