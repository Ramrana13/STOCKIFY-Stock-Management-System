<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.dao.ProductDAO" %>
<%@ page import="com.stock.dao.TransferDAO" %>
<%@ page import="com.stock.model.Product" %>
<%@ page import="com.stock.model.Transfer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Stock Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom Style Sheet -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Include Navbar (Performs Session Validation) -->
    <jsp:include page="navbar.jsp" />

    <%
        // Initialize DAOs to fetch dashboard statistics
        ProductDAO productDAO = new ProductDAO();
        TransferDAO transferDAO = new TransferDAO();

        int totalProducts = productDAO.getTotalProductCount();
        int totalStock = productDAO.getTotalStockQuantity();
        int lowStockCount = productDAO.getLowStockCount();
        int pendingTransfersCount = transferDAO.getPendingTransfersCount();

        List<Product> lowStockProducts = productDAO.getLowStockProducts();
        List<Transfer> pendingTransfers = transferDAO.getPendingTransfers();
    %>

    <main class="container my-4">
        <!-- Welcome Message -->
        <div class="row mb-4 animate-fade-in">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="h2 font-bold mb-1">Welcome Back, Administrator!</h1>
                        <p class="text-secondary">Here is your inventory status summary for today.</p>
                    </div>
                    <div>
                        <span class="badge bg-light text-dark p-2 border"><i class="bi bi-clock-history me-1"></i> System Active</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Analytical Cards Row -->
        <div class="row g-4 mb-5 animate-fade-in">
            <!-- Card 1: Total Products -->
            <div class="col-md-6 col-lg-3">
                <div class="card-premium p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-secondary font-semibold text-uppercase fs-7">Total Products</span>
                            <h2 class="font-bold mt-2 mb-0"><%= totalProducts %></h2>
                        </div>
                        <div class="card-icon bg-gradient-primary">
                            <i class="bi bi-tags text-white"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="<%= request.getContextPath() %>/InventoryServlet?action=list" class="text-decoration-none fs-8 text-primary font-semibold">View Catalog <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <!-- Card 2: Total Stock Qty -->
            <div class="col-md-6 col-lg-3">
                <div class="card-premium p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-secondary font-semibold text-uppercase fs-7">Total Stock Quantity</span>
                            <h2 class="font-bold mt-2 mb-0"><%= totalStock %></h2>
                        </div>
                        <div class="card-icon bg-gradient-secondary">
                            <i class="bi bi-box-seam text-white"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="<%= request.getContextPath() %>/InventoryServlet?action=warehouse" class="text-decoration-none fs-8 text-info font-semibold">Manage Stock <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <!-- Card 3: Low Stock Alerts -->
            <div class="col-md-6 col-lg-3">
                <div class="card-premium p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-secondary font-semibold text-uppercase fs-7">Low Stock Alerts</span>
                            <h2 class="font-bold mt-2 mb-0 <%= lowStockCount > 0 ? "text-danger" : "text-success" %>"><%= lowStockCount %></h2>
                        </div>
                        <div class="card-icon <%= lowStockCount > 0 ? "bg-gradient-danger" : "bg-gradient-success" %>">
                            <i class="bi bi-exclamation-triangle text-white"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="#lowStockSection" class="text-decoration-none fs-8 text-danger font-semibold">Review Alerts <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>

            <!-- Card 4: Pending Transfers -->
            <div class="col-md-6 col-lg-3">
                <div class="card-premium p-3 h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-secondary font-semibold text-uppercase fs-7">Pending Transfers</span>
                            <h2 class="font-bold mt-2 mb-0 <%= pendingTransfersCount > 0 ? "text-warning" : "text-success" %>"><%= pendingTransfersCount %></h2>
                        </div>
                        <div class="card-icon bg-gradient-warning">
                            <i class="bi bi-arrow-left-right text-white"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="<%= request.getContextPath() %>/TransferServlet?action=list" class="text-decoration-none fs-8 text-warning font-semibold">Approve Requests <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Left Side: Pending Transfers Action Section -->
            <div class="col-lg-7">
                <div class="card-premium p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="font-bold m-0"><i class="bi bi-hourglass-split text-warning"></i> Pending Stock Transfers</h4>
                        <span class="badge bg-warning text-dark"><%= pendingTransfersCount %> Requests</span>
                    </div>
                    <p class="text-muted fs-8">Approve or Reject requests to move stock from the central warehouse to the shop.</p>
                    
                    <div class="table-responsive">
                        <% if (pendingTransfers.isEmpty()) { %>
                            <div class="text-center py-4 text-secondary">
                                <i class="bi bi-clipboard-check fs-1 text-muted"></i>
                                <p class="mt-2 mb-0">No pending stock transfers.</p>
                            </div>
                        <% } else { %>
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>SKU</th>
                                        <th>Qty</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int limit = Math.min(pendingTransfers.size(), 5);
                                        for (int i = 0; i < limit; i++) {
                                            Transfer t = pendingTransfers.get(i);
                                    %>
                                        <tr>
                                            <td><strong><%= t.getProductName() %></strong></td>
                                            <td><span class="badge bg-light text-dark"><%= t.getProductSku() %></span></td>
                                            <td><%= t.getQuantity() %></td>
                                            <td class="text-end">
                                                <form action="<%= request.getContextPath() %>/TransferServlet" method="POST" class="d-inline">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="id" value="<%= t.getId() %>">
                                                    <input type="hidden" name="redirect" value="dashboard">
                                                    <button type="submit" class="btn btn-success btn-sm me-1" data-bs-toggle="tooltip" title="Approve Transfer">
                                                        <i class="bi bi-check-lg"></i>
                                                    </button>
                                                </form>
                                                <form action="<%= request.getContextPath() %>/TransferServlet" method="POST" class="d-inline">
                                                    <input type="hidden" name="action" value="reject">
                                                    <input type="hidden" name="id" value="<%= t.getId() %>">
                                                    <input type="hidden" name="redirect" value="dashboard">
                                                    <button type="submit" class="btn btn-danger btn-sm" data-bs-toggle="tooltip" title="Reject Transfer">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <% if (pendingTransfers.size() > 5) { %>
                                <div class="text-center mt-3">
                                    <a href="<%= request.getContextPath() %>/TransferServlet?action=list" class="btn btn-sm btn-outline-primary">View All Transfers</a>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Right Side: Low Stock Alerts Detail Section -->
            <div id="lowStockSection" class="col-lg-5">
                <div class="card-premium p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="font-bold m-0"><i class="bi bi-bell text-danger"></i> Low Stock Alerts</h4>
                        <span class="badge bg-danger"><%= lowStockCount %> Products</span>
                    </div>
                    <p class="text-muted fs-8">Products below minimum safety margins (Warehouse + Shop quantities combined).</p>

                    <div class="table-responsive">
                        <% if (lowStockProducts.isEmpty()) { %>
                            <div class="text-center py-4 text-secondary">
                                <i class="bi bi-check-circle fs-1 text-success"></i>
                                <p class="mt-2 mb-0">All product stock levels are stable.</p>
                            </div>
                        <% } else { %>
                            <table class="table align-middle">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Safety</th>
                                        <th>Actual</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int limit = Math.min(lowStockProducts.size(), 5);
                                        for (int i = 0; i < limit; i++) {
                                            Product p = lowStockProducts.get(i);
                                            int actualQty = p.getWarehouseQuantity() + p.getShopQuantity();
                                    %>
                                        <tr>
                                            <td>
                                                <div class="font-semibold"><%= p.getName() %></div>
                                                <small class="text-muted"><%= p.getSku() %></small>
                                            </td>
                                            <td><%= p.getMinStock() %></td>
                                            <td class="text-danger font-bold"><%= actualQty %></td>
                                            <td>
                                                <% if (actualQty == 0) { %>
                                                    <span class="badge bg-danger">Out of Stock</span>
                                                <% } else { %>
                                                    <span class="badge bg-warning text-dark">Low Stock</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <% if (lowStockProducts.size() > 5) { %>
                                <div class="text-center mt-3">
                                    <a href="<%= request.getContextPath() %>/ReportServlet?filter=low" class="btn btn-sm btn-outline-danger">View All Alerts</a>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />
