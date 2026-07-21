package com.stock.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.stock.dao.TransferDAO;
import com.stock.model.Transfer;

/**
 * Controller Servlet managing stock movement transfers between warehouse and shop.
 */
@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TransferDAO transferDAO;

    @Override
    public void init() throws ServletException {
        this.transferDAO = new TransferDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session security check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            listTransfers(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/TransferServlet?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session validation
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?msg=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/TransferServlet?action=list");
            return;
        }

        switch (action) {
            case "create":
                createTransfer(request, response);
                break;
            case "approve":
                approveTransfer(request, response);
                break;
            case "reject":
                rejectTransfer(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/TransferServlet?action=list");
                break;
        }
    }

    // --- Action Handlers ---

    private void listTransfers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Transfer> pending = transferDAO.getPendingTransfers();
        List<Transfer> history = transferDAO.getTransferHistory();
        
        request.setAttribute("pendingTransfers", pending);
        request.setAttribute("transferHistory", history);
        request.getRequestDispatcher("/transfers.jsp").forward(request, response);
    }

    private void createTransfer(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int qty = Integer.parseInt(request.getParameter("quantity"));

            if (qty <= 0) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Transfer quantity must be positive");
                return;
            }

            boolean success = transferDAO.createTransferRequest(productId, qty);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&success=Transfer request created. Awaiting Admin Approval.");
            } else {
                response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Failed to submit transfer request");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/InventoryServlet?action=shop&error=Invalid product or quantity parameter");
        }
    }

    private void approveTransfer(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String redirectDest = request.getParameter("redirect"); // Optional (dashboard or transfers list)

            boolean success = transferDAO.approveTransfer(id);
            String redirectUrl = "dashboard".equals(redirectDest) ? "/dashboard.jsp" : "/TransferServlet?action=list";

            if (success) {
                response.sendRedirect(request.getContextPath() + redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "success=Transfer approved successfully");
            } else {
                response.sendRedirect(request.getContextPath() + redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "error=Failed to approve transfer. Check warehouse stock levels.");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/TransferServlet?action=list&error=Invalid transfer ID format");
        }
    }

    private void rejectTransfer(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String redirectDest = request.getParameter("redirect");

            boolean success = transferDAO.rejectTransfer(id);
            String redirectUrl = "dashboard".equals(redirectDest) ? "/dashboard.jsp" : "/TransferServlet?action=list";

            if (success) {
                response.sendRedirect(request.getContextPath() + redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "success=Transfer request rejected");
            } else {
                response.sendRedirect(request.getContextPath() + redirectUrl + (redirectUrl.contains("?") ? "&" : "?") + "error=Failed to reject transfer");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/TransferServlet?action=list&error=Invalid transfer ID format");
        }
    }
}
