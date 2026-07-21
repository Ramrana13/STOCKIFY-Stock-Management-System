<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.stock.model.User" %>

<%
    // Strict session validation
    User loggedInUser = (User) session.getAttribute("user");

    if (loggedInUser == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?msg=unauthorized"
        );
        return;
    }

    // Get current URI for active navbar highlighting
    String uri = request.getRequestURI();
%>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container-fluid">

        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center"
           href="<%= request.getContextPath() %>/dashboard.jsp">

            <i class="bi bi-box-seam me-2"></i>
            Stockify Admin

        </a>

        <!-- Mobile Toggle -->
        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarText"
                aria-controls="navbarText"
                aria-expanded="false"
                aria-label="Toggle navigation">

            <span class="navbar-toggler-icon"></span>

        </button>

        <!-- Navbar Content -->
        <div class="collapse navbar-collapse" id="navbarText">

            <!-- Left Navigation -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <!-- Dashboard -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= uri.contains("dashboard.jsp") ? "active" : "" %>"
                       href="<%= request.getContextPath() %>/dashboard.jsp">

                        <i class="bi bi-speedometer2"></i>
                        Dashboard

                    </a>
                </li>

                <!-- Products -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= (uri.contains("inventory")
                            || uri.contains("addProduct")
                            || uri.contains("updateProduct"))
                            ? "active" : "" %>"

                       href="<%= request.getContextPath() %>/InventoryServlet?action=list">

                        <i class="bi bi-list-stars"></i>
                        Products

                    </a>
                </li>

                <!-- Warehouse -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= uri.contains("warehouse") ? "active" : "" %>"

                       href="<%= request.getContextPath() %>/InventoryServlet?action=warehouse">

                        <i class="bi bi-building"></i>
                        Warehouse Stock

                    </a>
                </li>

                <!-- Shop -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= uri.contains("shop") ? "active" : "" %>"

                       href="<%= request.getContextPath() %>/InventoryServlet?action=shop">

                        <i class="bi bi-shop"></i>
                        Shop Stock

                    </a>
                </li>

                <!-- Transfers -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= uri.contains("transfers") ? "active" : "" %>"

                       href="<%= request.getContextPath() %>/TransferServlet?action=list">

                        <i class="bi bi-arrow-left-right"></i>
                        Transfers

                    </a>
                </li>

                <!-- Reports -->
                <li class="nav-item">
                    <a class="nav-link
                        <%= uri.contains("reports") ? "active" : "" %>"

                       href="<%= request.getContextPath() %>/ReportServlet">

                        <i class="bi bi-file-earmark-bar-graph"></i>
                        Reports

                    </a>
                </li>

            </ul>

            <!-- Right User Section -->
            <span class="navbar-text d-flex align-items-center">

                <i class="bi bi-person-circle text-info me-2 fs-5"></i>

                <!-- Logged In User Name -->
                <span class="text-white me-3 fw-semibold">

                    <%= loggedInUser.getFullName() %>

                </span>

                <!-- Logout Button -->
                <a href="<%= request.getContextPath() %>/LogoutServlet"
                   class="btn btn-outline-danger btn-sm border-2 fw-semibold">

                    <i class="bi bi-box-arrow-right"></i>
                    Logout

                </a>

            </span>

        </div>
    </div>
</nav>

<!-- Alert Messages -->
<div class="container mt-3" id="alertContainer">

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    if (success != null && !success.trim().isEmpty()) {
%>

    <div class="alert alert-success alert-dismissible fade show"
         role="alert">

        <i class="bi bi-check-circle-fill me-2"></i>

        <%= success %>

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close">
        </button>

    </div>

<%
    }

    if (error != null && !error.trim().isEmpty()) {
%>

    <div class="alert alert-danger alert-dismissible fade show"
         role="alert">

        <i class="bi bi-exclamation-triangle-fill me-2"></i>

        <%= error %>

        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert"
                aria-label="Close">
        </button>

    </div>

<%
    }
%>

</div>
