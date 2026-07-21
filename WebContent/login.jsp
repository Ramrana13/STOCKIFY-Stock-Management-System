<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Stock Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom Style Sheet -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body class="login-bg d-flex flex-column min-vh-100 justify-content-center">

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-gradient-primary rounded-circle mb-3 shadow" style="width: 64px; height: 64px;">
                        <i class="bi bi-box-seam text-white fs-2"></i>
                    </div>
                    <h2 class="text-gradient">Stockify</h2>
                    <p class="text-muted">Stock & Inventory Management System</p>
                </div>
                
                <div class="card login-card p-4">
                    <h4 class="text-center font-bold mb-4">Admin Console Login</h4>
                    
                    <!-- Alert container for validation errors -->
                    <div id="alertContainer">
                        <%
                            String error = request.getParameter("error");
                            String msg = request.getParameter("msg");
                            if (error != null) {
                        %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <%
                            }
                            if ("unauthorized".equals(msg)) {
                        %>
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                <i class="bi bi-shield-lock-fill"></i> Please login to access pages!
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <%
                            }
                            if ("logout".equals(msg)) {
                        %>
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-info-circle-fill"></i> Logged out successfully!
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <form action="<%= request.getContextPath() %>/LoginServlet" method="POST" onsubmit="return validateLoginForm()">
                        <div class="mb-3">
                            <label for="username" class="form-label font-semibold text-secondary">Username</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-secondary"></i></span>
                                <input type="text" class="form-control form-control-premium border-start-0" id="username" name="username" placeholder="Enter username" autocomplete="username">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label font-semibold text-secondary">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-secondary"></i></span>
                                <input type="password" class="form-control form-control-premium border-start-0" id="password" name="password" placeholder="Enter password" autocomplete="current-password">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-premium w-100 py-2.5 fs-5">
                            <i class="bi bi-box-arrow-in-right"></i> Sign In
                        </button>
                    </form>
                </div>
                
                <div class="text-center mt-4 text-secondary">
                    <p class="mb-0"><small>For testing use: <strong>admin</strong> / <strong>admin123</strong></small></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom validation -->
    <script src="<%= request.getContextPath() %>/js/validation.js"></script>
</body>
</html>
