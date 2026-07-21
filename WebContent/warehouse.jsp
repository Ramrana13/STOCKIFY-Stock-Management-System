<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.model.Product" %>
<%@ page import="java.util.List" %>
<%
    // Retrieve products list from servlet
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=warehouse");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Stock - Stock Management System</title>
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
        <!-- Header -->
        <div class="row align-items-center mb-4 animate-fade-in">
            <div class="col-md-6">
                <h2 class="font-bold mb-1"><i class="bi bi-building text-primary"></i> Warehouse Inventory</h2>
                <p class="text-secondary mb-0">Monitor and update physical stock stored in the central warehouse.</p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <span class="badge bg-light text-dark p-2 border font-semibold">Central Hub</span>
            </div>
        </div>

        <!-- Filter and Search -->
        <div class="row mb-4 animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-3">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                                <input type="text" id="warehouseSearch" onkeyup="filterTable('warehouseSearch', 'warehouseTable')" class="form-control form-control-premium border-start-0" placeholder="Search products...">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Warehouse Stock Table -->
        <div class="row animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-4">
                    <div class="table-responsive">
                        <% if (products.isEmpty()) { %>
                            <div class="text-center py-5 text-secondary">
                                <i class="bi bi-box fs-1 text-muted"></i>
                                <h4 class="mt-3">No Products Registered</h4>
                                <p>Create products in the Catalog first to manage their stock levels.</p>
                                <a href="<%= request.getContextPath() %>/InventoryServlet?action=list" class="btn btn-premium btn-sm">Product Catalog</a>
                            </div>
                        <% } else { %>
                            <table class="table table-hover table-premium align-middle" id="warehouseTable">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Product Name</th>
                                        <th>SKU / Code</th>
                                        <th>Category</th>
                                        <th class="text-center">Current Stock</th>
                                        <th class="text-end" style="width: 250px;">Update Stock Level</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Product p : products) { %>
                                        <tr>
                                            <td><strong>#<%= p.getId() %></strong></td>
                                            <td class="font-semibold"><%= p.getName() %></td>
                                            <td><span class="badge bg-light text-dark font-semibold border"><%= p.getSku() %></span></td>
                                            <td><%= p.getCategory() %></td>
                                            <td class="text-center">
                                                <% if (p.getWarehouseQuantity() == 0) { %>
                                                    <span class="badge bg-danger fs-6 px-3">0 (Out of Stock)</span>
                                                <% } else if (p.getWarehouseQuantity() <= p.getMinStock()) { %>
                                                    <span class="badge bg-warning text-dark fs-6 px-3"><%= p.getWarehouseQuantity() %> (Low Stock)</span>
                                                <% } else { %>
                                                    <span class="badge bg-success fs-6 px-3"><%= p.getWarehouseQuantity() %></span>
                                                <% } %>
                                            </td>
                                            <td class="text-end">
                                                <!-- Inline Quick Update form -->
                                                <form action="<%= request.getContextPath() %>/InventoryServlet" method="POST" class="d-flex align-items-center justify-content-end gap-1">
                                                    <input type="hidden" name="action" value="updateWarehouse">
                                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                                    <input type="number" min="0" name="quantity" value="<%= p.getWarehouseQuantity() %>" class="form-control form-control-premium text-center" style="width: 100px;" required>
                                                    <button type="submit" class="btn btn-sm btn-premium py-2" data-bs-toggle="tooltip" title="Save Stock">
                                                        <i class="bi bi-save"></i>
                                                    </button>
                                                </form>
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
