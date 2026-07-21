<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <footer class="mt-auto py-4">
        <div class="container text-center">
            <p class="mb-1 text-white-50">Stock Management System &copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> - Web Technology B.Tech Project Submission</p>
            <small class="text-muted">Built with Java Servlet, JSP, JDBC, MySQL, & Bootstrap 5</small>
        </div>
    </footer>

    <!-- Bootstrap Bundle with Popper (v5.3+) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Bootstrap Icons (Optional fallback, loaded in page headers) -->
    <!-- Custom validation & UI helper script -->
    <script src="<%= request.getContextPath() %>/js/validation.js"></script>
    
</body>
</html>
