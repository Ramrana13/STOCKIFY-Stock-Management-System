<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.stock.model.Transfer" %>

<%
    List<Transfer> pendingTransfers =
        (List<Transfer>) request.getAttribute("pendingTransfers");

    List<Transfer> transferHistory =
        (List<Transfer>) request.getAttribute("transferHistory");
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Transfer Management</title>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
      rel="stylesheet">

<!-- Custom CSS -->
<link href="<%= request.getContextPath() %>/css/style.css"
      rel="stylesheet">

</head>

<body class="d-flex flex-column min-vh-100 bg-light">

<!-- Navbar -->
<jsp:include page="navbar.jsp" />

<main class="container my-5">

    <!-- Page Header -->
    <div class="row mb-4">

        <div class="col-md-6">

            <h2 class="fw-bold">
                <i class="bi bi-arrow-left-right text-primary"></i>
                Transfer Requests
            </h2>

            <p class="text-muted">
                Manage warehouse stock transfer requests.
            </p>

        </div>

    </div>

    <!-- Pending Requests -->

    <div class="card shadow-sm border-0 mb-4">

        <div class="card-header bg-primary text-white">

            Pending Requests

        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-dark">

                        <tr>

                            <th>ID</th>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <th>Actions</th>

                        </tr>

                    </thead>

                    <tbody>

                    <%
                        if(pendingTransfers != null &&
                           !pendingTransfers.isEmpty()) {

                            for(Transfer t : pendingTransfers) {
                    %>

                        <tr>

                            <td>
                                <strong>#<%= t.getId() %></strong>
                            </td>

                            <td>

                                <div class="fw-bold">
                                    <%= t.getProductName() %>
                                </div>

                                <small class="text-muted">
                                    <%= t.getProductSku() %>
                                </small>

                            </td>

                            <td>

                                <span class="badge bg-info fs-6">

                                    <%= t.getQuantity() %> Units

                                </span>

                            </td>

                            <td>

                                <span class="badge bg-warning text-dark fs-6">

                                    <%= t.getStatus() %>

                                </span>

                            </td>

                            <td>

                                <!-- Approve Form -->
                                <form action="<%= request.getContextPath() %>/TransferServlet"
                                      method="POST"
                                      class="d-inline">

                                    <input type="hidden"
                                           name="action"
                                           value="approve">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= t.getId() %>">

                                    <button type="submit"
                                            class="btn btn-success btn-sm">

                                        <i class="bi bi-check-circle"></i>
                                        Approve

                                    </button>

                                </form>

                                <!-- Reject Form -->
                                <form action="<%= request.getContextPath() %>/TransferServlet"
                                      method="POST"
                                      class="d-inline">

                                    <input type="hidden"
                                           name="action"
                                           value="reject">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= t.getId() %>">

                                    <button type="submit"
                                            class="btn btn-danger btn-sm">

                                        <i class="bi bi-x-circle"></i>
                                        Reject

                                    </button>

                                </form>

                            </td>

                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>

                            <td colspan="5"
                                class="text-center text-muted py-4">

                                No Pending Requests

                            </td>

                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

    <!-- Transfer History -->

    <div class="card shadow-sm border-0">

        <div class="card-header bg-dark text-white">

            Transfer History

        </div>

        <div class="card-body">

            <div class="table-responsive">

                <table class="table table-hover align-middle">

                    <thead class="table-dark">

                        <tr>

                            <th>ID</th>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Status</th>

                        </tr>

                    </thead>

                    <tbody>

                    <%
                        if(transferHistory != null &&
                           !transferHistory.isEmpty()) {

                            for(Transfer t : transferHistory) {
                    %>

                        <tr>

                            <td>
                                <strong>#<%= t.getId() %></strong>
                            </td>

                            <td>

                                <div class="fw-bold">
                                    <%= t.getProductName() %>
                                </div>

                                <small class="text-muted">
                                    <%= t.getProductSku() %>
                                </small>

                            </td>

                            <td>

                                <span class="badge bg-info fs-6">

                                    <%= t.getQuantity() %> Units

                                </span>

                            </td>

                            <td>

                                <%
                                    if("APPROVED".equals(t.getStatus())) {
                                %>

                                    <span class="badge bg-success fs-6">

                                        APPROVED

                                    </span>

                                <%
                                    } else {
                                %>

                                    <span class="badge bg-danger fs-6">

                                        REJECTED

                                    </span>

                                <%
                                    }
                                %>

                            </td>

                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>

                            <td colspan="4"
                                class="text-center text-muted py-4">

                                No Transfer History

                            </td>

                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</main>

<!-- Footer -->
<jsp:include page="footer.jsp" />

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>


