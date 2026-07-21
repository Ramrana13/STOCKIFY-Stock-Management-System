<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.stock.model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");

    if(products == null){
        response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Shop Stock - Stock Management System</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">

</head>

<body class="d-flex flex-column min-vh-100 bg-light">

    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <main class="container my-5">

        <!-- Page Header -->
        <div class="row mb-4">

            <div class="col-md-6">

                <h2 class="fw-bold">
                    <i class="bi bi-shop text-primary"></i>
                    Shop Floor Inventory
                </h2>

                <p class="text-muted">
                    Record sales and request stock transfers from warehouse.
                </p>

            </div>

        </div>

        <!-- Search Card -->
        <div class="card shadow-sm border-0 mb-4">

            <div class="card-body">

                <div class="row">

                    <div class="col-md-6">

                        <input type="text"
                               id="shopSearch"
                               class="form-control"
                               placeholder="Search products...">

                    </div>

                </div>

            </div>

        </div>

        <!-- Product Table Card -->
        <div class="card shadow-sm border-0">

            <div class="card-body">

                <% if(products.isEmpty()){ %>

                    <div class="text-center py-5">

                        <i class="bi bi-box-seam display-4 text-muted"></i>

                        <h4 class="mt-3">
                            No Products Available
                        </h4>

                        <p class="text-muted">
                            Please add products first.
                        </p>

                        <a href="<%= request.getContextPath() %>/InventoryServlet?action=list"
                           class="btn btn-primary">

                            Product Catalog

                        </a>

                    </div>

                <% } else { %>

                    <div class="table-responsive">

                        <table class="table table-hover align-middle">

                            <thead class="table-dark">

                                <tr>

                                    <th>ID</th>
                                    <th>Product</th>
                                    <th>Warehouse Stock</th>
                                    <th>Shop Stock</th>
                                    <th>Sold Qty</th>
                                    <th width="350">Actions</th>

                                </tr>

                            </thead>

                            <tbody>

                            <% for(Product p : products){ %>

                                <tr>

                                    <!-- Product ID -->
                                    <td>
                                        <strong>#<%= p.getId() %></strong>
                                    </td>

                                    <!-- Product Info -->
                                    <td>

                                        <div class="fw-bold">
                                            <%= p.getName() %>
                                        </div>

                                        <small class="text-muted">
                                            <%= p.getSku() %>
                                        </small>

                                    </td>

                                    <!-- Warehouse Stock -->
                                    <td>

                                        <span class="badge bg-secondary fs-6">

                                            <%= p.getWarehouseQuantity() %> Available

                                        </span>

                                    </td>

                                    <!-- Shop Stock -->
                                    <td>

                                        <% if(p.getShopQuantity() == 0){ %>

                                            <span class="badge bg-danger fs-6">

                                                Out of Stock

                                            </span>

                                        <% } else if(p.getShopQuantity() <= p.getMinStock()){ %>

                                            <span class="badge bg-warning text-dark fs-6">

                                                Low (<%= p.getShopQuantity() %>)

                                            </span>

                                        <% } else { %>

                                            <span class="badge bg-success fs-6">

                                                <%= p.getShopQuantity() %> Units

                                            </span>

                                        <% } %>

                                    </td>

                                    <!-- Sold Quantity -->
                                    <td>

                                        <span class="fw-bold text-primary">

                                            <%= p.getShopSoldQuantity() %> sales

                                        </span>

                                    </td>

                                    <!-- Actions -->
                                    <td>

                                        <div class="d-flex gap-2 flex-wrap">

                                            <!-- Sell Form -->
                                            <form action="<%= request.getContextPath() %>/InventoryServlet"
                                                  method="POST"
                                                  class="d-flex gap-2">

                                                <input type="hidden"
                                                       name="action"
                                                       value="recordSale">

                                                <input type="hidden"
                                                       name="id"
                                                       value="<%= p.getId() %>">

                                                <input type="number"
                                                       name="soldQty"
                                                       min="1"
                                                       max="<%= p.getShopQuantity() %>"
                                                       placeholder="Qty"
                                                       class="form-control"
                                                       style="width:90px;"
                                                       required
                                                       <%= p.getShopQuantity()==0 ? "disabled" : "" %>>

                                                <button type="submit"
                                                        class="btn btn-outline-info"
                                                        <%= p.getShopQuantity()==0 ? "disabled" : "" %>>

                                                    <i class="bi bi-cart-plus"></i>
                                                    Sell

                                                </button>

                                            </form>

                                            <!-- Request Stock -->
                                            <a href="<%= request.getContextPath() %>/transferRequest.jsp?id=<%= p.getId() %>"
                                               class="btn btn-primary">

                                                <i class="bi bi-arrow-left-right"></i>
                                                Request Stock

                                            </a>

                                        </div>

                                    </td>

                                </tr>

                            <% } %>

                            </tbody>

                        </table>

                    </div>

                <% } %>

            </div>

        </div>

    </main>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>

