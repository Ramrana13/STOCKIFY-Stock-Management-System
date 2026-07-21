<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.model.Product" %>
<%
    // Fetch product details sent by InventoryServlet
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product - Stock Management System</title>
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
            <div class="col-12">
                <h2 class="font-bold mb-1"><i class="bi bi-pencil-square text-primary"></i> Edit Product (#<%= product.getId() %>)</h2>
                <p class="text-secondary">Modify product definitions and safety margins.</p>
            </div>
        </div>

        <!-- Form Card -->
        <div class="row justify-content-center animate-fade-in">
            <div class="col-lg-8">
                <div class="card-premium p-4">
                    <form action="<%= request.getContextPath() %>/UpdateProductServlet" method="POST" onsubmit="return validateProductForm()">
                        <input type="hidden" name="id" value="<%= product.getId() %>">
                        
                        <!-- Row 1: Name and SKU -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label font-semibold">Product Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-premium" id="name" name="name" value="<%= product.getName() %>">
                            </div>
                            <div class="col-md-6">
                                <label for="sku" class="form-label font-semibold">SKU / Code <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-premium" id="sku" name="sku" value="<%= product.getSku() %>">
                                <div class="form-text">Unique barcode SKU code.</div>
                            </div>
                        </div>

                        <!-- Row 2: Category and Price -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="category" class="form-label font-semibold">Category <span class="text-danger">*</span></label>
                                <select class="form-select form-control-premium" id="category" name="category">
                                    <option value="Electronics" <%= "Electronics".equals(product.getCategory()) ? "selected" : "" %>>Electronics</option>
                                    <option value="Accessories" <%= "Accessories".equals(product.getCategory()) ? "selected" : "" %>>Accessories</option>
                                    <option value="Furniture" <%= "Furniture".equals(product.getCategory()) ? "selected" : "" %>>Furniture</option>
                                    <option value="Utilities" <%= "Utilities".equals(product.getCategory()) ? "selected" : "" %>>Utilities</option>
                                    <option value="Stationery" <%= "Stationery".equals(product.getCategory()) ? "selected" : "" %>>Stationery</option>
                                    <option value="Other" <%= "Other".equals(product.getCategory()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="price" class="form-label font-semibold">Unit Price (INR) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">&#8377;</span>
                                    <input type="number" step="0.01" class="form-control form-control-premium" id="price" name="price" value="<%= product.getPrice() %>">
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: Minimum Safety Stock -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="minStock" class="form-label font-semibold">Minimum Safety Stock <span class="text-danger">*</span></label>
                                <input type="number" class="form-control form-control-premium" id="minStock" name="minStock" value="<%= product.getMinStock() %>">
                                <div class="form-text">Trigger threshold alert if stock falls below this amount.</div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="mb-4">
                            <label for="description" class="form-label font-semibold">Product Description</label>
                            <textarea class="form-control form-control-premium" id="description" name="description" rows="4"><%= product.getDescription() != null ? product.getDescription() : "" %></textarea>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <a href="<%= request.getContextPath() %>/InventoryServlet?action=list" class="btn btn-light border font-semibold">Cancel</a>
                            <button type="submit" class="btn btn-premium">Update Product</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />
