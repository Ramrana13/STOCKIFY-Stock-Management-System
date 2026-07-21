package com.stock.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.stock.dao.UserDAO;
import com.stock.model.User;

/**
 * Controller Servlet for handling User Authentications.
 * Maps to /LoginServlet url. Compatible with Tomcat 10 (Jakarta Servlet namespace).
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic server side validation
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Username or Password cannot be blank");
            return;
        }

        // Validate user against DB
        User user = userDAO.validateUser(username.trim(), password.trim());

        if (user != null) {
            // Credentials match: Bind to session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            // Credentials don't match
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect to login page if user tries to access this servlet via GET
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
