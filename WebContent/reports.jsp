<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.model.Product" %>
<%@ page import="java.util.List" %>
<%
    // Fetch product catalog with quantities from ReportServlet
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) {
        response.sendRedirect(request.getContextPath() + "/ReportServlet");
        return;
    }

    // Precalculate totals
    int totalItems = products.size();
    int warehouseQty = 0;
    int shopQty = 0;
    int soldQty = 0;
    double totalValuation = 0.0;
    
    for (Product p : products) {
        warehouseQty += p.getWarehouseQuantity();
        shopQty += p.getShopQuantity();
        soldQty += p.getShopSoldQuantity();
        totalValuation += (p.getWarehouseQuantity() + p.getShopQuantity()) * p.getPrice();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Reports - Stock Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom Style Sheet -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
    
    <!-- Print Specific Styling -->
    <style>
        @media print {
            .navbar-custom, footer, .btn, .no-print, #alertContainer, .card-premium .mt-3 {
                display: none !important;
            }
            body {
                background-color: #fff !important;
                color: #000 !important;
                padding: 0 !important;
                margin: 0 !important;
            }
            .card-premium {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
                background: none !important;
            }
            .table-premium tbody tr {
                background: none !important;
                box-shadow: none !important;
            }
            .table-premium tbody tr td, .table-premium th {
                border: 1px solid #dee2e6 !important;
                padding: 8px !important;
            }
            .print-header {
                display: block !important;
            }
        }
        .print-header {
            display: none;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="container my-4">
        <!-- Header for browser -->
        <div class="row align-items-center mb-4 no-print animate-fade-in">
            <div class="col-md-6">
                <h2 class="font-bold mb-1"><i class="bi bi-file-earmark-bar-graph text-primary"></i> Report Center</h2>
                <p class="text-secondary mb-0">Generate inventory audits, filter records, and export reports.</p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <button onclick="printReport()" class="btn btn-outline-dark me-2 font-semibold">
                    <i class="bi bi-printer"></i> Print / Save PDF
                </button>
                <button onclick="exportTableToExcel('reportTable', 'inventory-ledger-report.csv')" class="btn btn-premium font-semibold">
                    <i class="bi bi-file-earmark-excel"></i> Export CSV/Excel
                </button>
            </div>
        </div>

        <!-- Header for Print view -->
        <div class="print-header text-center mb-4">
            <h2>Stockify Inventory Audit Report</h2>
            <p class="mb-1 text-muted">Generated Date: <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %></p>
            <hr>
        </div>

        <!-- Report Parameters / Summary Cards -->
        <div class="row g-3 mb-4 animate-fade-in">
            <div class="col-6 col-md-3">
                <div class="card-premium p-3 text-center">
                    <span class="text-secondary fs-8 font-semibold">Total Product Lines</span>
                    <h4 class="font-bold mt-1 mb-0"><%= totalItems %></h4>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card-premium p-3 text-center">
                    <span class="text-secondary fs-8 font-semibold">Warehouse Quantity</span>
                    <h4 class="font-bold text-success mt-1 mb-0"><%= warehouseQty %> units</h4>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card-premium p-3 text-center">
                    <span class="text-secondary fs-8 font-semibold">Shop Stock / Sales</span>
                    <h4 class="font-bold text-info mt-1 mb-0"><%= shopQty %> / <%= soldQty %> units</h4>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="card-premium p-3 text-center">
                    <span class="text-secondary fs-8 font-semibold">Est. Asset Valuation</span>
                    <h4 class="font-bold text-gradient mt-1 mb-0">&#8377;<%= String.format("%,.2f", totalValuation) %></h4>
                </div>
            </div>
        </div>

        <!-- Live Filters (For Browser View only) -->
        <div class="row mb-4 no-print animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-funnel"></i></span>
                                <input type="text" id="reportSearch" onkeyup="filterTable('reportSearch', 'reportTable')" class="form-control form-control-premium" placeholder="Search catalog...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select id="stockFilter" class="form-select form-control-premium" onchange="applyStockFilter()">
                                <option value="all">Filter: All Stock Levels</option>
                                <option value="low">Filter: Low Stock Warnings</option>
                                <option value="out">Filter: Out of Stock Only</option>
                                <option value="ok">Filter: Healthy Stock Levels</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Ledger Table -->
        <div class="row animate-fade-in">
            <div class="col-12">
                <div class="card-premium p-4">
                    <div class="table-responsive">
                        <table class="table table-premium align-middle" id="reportTable">
                            <thead>
                                <tr>
                                    <th>SKU</th>
                                    <th>Product Description</th>
                                    <th>Category</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-center">Warehouse</th>
                                    <th class="text-center">Shop Stock</th>
                                    <th class="text-center">Total Stock</th>
                                    <th class="text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    for (Product p : products) { 
                                        int totalQty = p.getWarehouseQuantity() + p.getShopQuantity();
                                        boolean isLow = totalQty <= p.getMinStock();
                                        boolean isOut = totalQty == 0;
                                        String rowClass = "stock-ok";
                                        if (isOut) rowClass = "stock-out";
                                        else if (isLow) rowClass = "stock-low";
                                %>
                                    <tr data-stock-status="<%= rowClass %>">
                                        <td><span class="badge bg-light text-dark font-semibold border"><%= p.getSku() %></span></td>
                                        <td>
                                            <div class="font-semibold"><%= p.getName() %></div>
                                            <small class="text-muted">Safety Target: <%= p.getMinStock() %> units</small>
                                        </td>
                                        <td><%= p.getCategory() %></td>
                                        <td class="text-end font-semibold">&#8377;<%= String.format("%,.2f", p.getPrice()) %></td>
                                        <td class="text-center"><%= p.getWarehouseQuantity() %></td>
                                        <td class="text-center"><%= p.getShopQuantity() %></td>
                                        <td class="text-center font-bold <%= isLow ? "text-danger" : "text-success" %>"><%= totalQty %></td>
                                        <td class="text-center">
                                            <% if (isOut) { %>
                                                <span class="badge bg-danger fs-8 px-2.5">Out of Stock</span>
                                            <% } else if (isLow) { %>
                                                <span class="badge bg-warning text-dark fs-8 px-2.5">Low Stock</span>
                                            <% } else { %>
                                                <span class="badge bg-success fs-8 px-2.5">Active</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Local filter scripts for reports page -->
    <script>
        function applyStockFilter() {
            var filterVal = document.getElementById("stockFilter").value;
            var rows = document.querySelectorAll("#reportTable tbody tr");
            
            for (var i = 0; i < rows.length; i++) {
                var status = rows[i].getAttribute("data-stock-status");
                
                if (filterVal === "all") {
                    rows[i].style.display = "";
                } else if (filterVal === "low" && status === "stock-low") {
                    rows[i].style.display = "";
                } else if (filterVal === "out" && status === "stock-out") {
                    rows[i].style.display = "";
                } else if (filterVal === "ok" && status === "stock-ok") {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
