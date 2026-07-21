<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.stock.dao.ProductDAO"%>
<%@ page import="com.stock.model.Product"%>

<%
    String idStr = request.getParameter("id");

    if(idStr == null){
        response.sendRedirect("InventoryServlet?action=shop");
        return;
    }

    int id = Integer.parseInt(idStr);

    ProductDAO dao = new ProductDAO();
    Product p = dao.getProductById(id);

    if(p == null){
        response.sendRedirect("InventoryServlet?action=shop");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Transfer Stock</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-md-6">

            <div class="card shadow">

                <div class="card-header bg-primary text-white">

                    <h4>
                        Request Stock Transfer
                    </h4>

                </div>

                <div class="card-body">

                    <form action="TransferServlet" method="POST">

                        <input type="hidden" name="action" value="create">

                        <input type="hidden"
                               name="productId"
                               value="<%= p.getId() %>">

                        <div class="mb-3">

                            <label class="form-label">
                                Product
                            </label>

                            <input type="text"
                                   class="form-control"
                                   value="<%= p.getName() %>"
                                   readonly>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Warehouse Stock
                            </label>

                            <input type="text"
                                   class="form-control"
                                   value="<%= p.getWarehouseQuantity() %> Units"
                                   readonly>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Current Shop Stock
                            </label>

                            <input type="text"
                                   class="form-control"
                                   value="<%= p.getShopQuantity() %> Units"
                                   readonly>

                        </div>

                        <div class="mb-3">

                            <label class="form-label">
                                Transfer Quantity
                            </label>

                            <input type="number"
                                   name="quantity"
                                   min="1"
                                   max="<%= p.getWarehouseQuantity() %>"
                                   class="form-control"
                                   required>

                        </div>

                        <button type="submit"
                                class="btn btn-primary">

                            Submit Request

                        </button>

                        <a href="InventoryServlet?action=shop"
                           class="btn btn-secondary">

                            Back

                        </a>

                    </form>

                </div>

            </div>

        </div>

    </div>

</div>

</body>
</html>

