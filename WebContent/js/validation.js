/**
 * Form validations and interactive UI scripts for the Stock Management System.
 */

document.addEventListener("DOMContentLoaded", function () {
    // Enable Bootstrap tooltips if any
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

/**
 * Validates the Admin Login Form
 */
function validateLoginForm() {
    var username = document.getElementById("username").value.trim();
    var password = document.getElementById("password").value.trim();
    
    if (username === "") {
        showAlert("Username cannot be empty", "danger");
        return false;
    }
    
    if (password === "") {
        showAlert("Password cannot be empty", "danger");
        return false;
    }
    
    if (password.length < 5) {
        showAlert("Password must be at least 5 characters long", "danger");
        return false;
    }
    
    return true;
}

/**
 * Validates the Product Details Form (Add/Update)
 */
function validateProductForm() {
    var name = document.getElementById("name").value.trim();
    var sku = document.getElementById("sku").value.trim();
    var category = document.getElementById("category").value.trim();
    var price = document.getElementById("price").value;
    var minStock = document.getElementById("minStock").value;

    if (name === "") {
        showAlert("Product Name is required", "danger");
        return false;
    }

    if (sku === "") {
        showAlert("SKU/Code is required", "danger");
        return false;
    }

    if (!/^[a-zA-Z0-9\-_]+$/.test(sku)) {
        showAlert("SKU can only contain letters, numbers, hyphens, and underscores", "danger");
        return false;
    }

    if (category === "") {
        showAlert("Category is required", "danger");
        return false;
    }

    if (price === "" || parseFloat(price) <= 0) {
        showAlert("Price must be a valid number greater than 0", "danger");
        return false;
    }

    if (minStock === "" || parseInt(minStock) < 0) {
        showAlert("Minimum Safety Stock must be a non-negative integer", "danger");
        return false;
    }

    return true;
}

/**
 * Validates Stock Adjustments (Warehouse / Shop / Transfers)
 */
function validateTransferForm(maxStock) {
    var qty = document.getElementById("quantity").value;

    if (qty === "" || parseInt(qty) <= 0) {
        showAlert("Transfer quantity must be greater than 0", "danger");
        return false;
    }

    if (maxStock !== undefined && parseInt(qty) > maxStock) {
        showAlert("Transfer quantity (" + qty + ") exceeds available Warehouse stock (" + maxStock + ")", "danger");
        return false;
    }

    return true;
}

/**
 * Client-Side table search filter (real-time filtering)
 * @param {string} inputId ID of search input field
 * @param {string} tableId ID of table to filter
 */
function filterTable(inputId, tableId) {
    var input = document.getElementById(inputId);
    var filter = input.value.toLowerCase();
    var table = document.getElementById(tableId);
    var tr = table.getElementsByTagName("tr");

    for (var i = 1; i < tr.length; i++) { // Skip headers
        var showRow = false;
        var tdArray = tr[i].getElementsByTagName("td");
        
        for (var j = 0; j < tdArray.length; j++) {
            var td = tdArray[j];
            if (td) {
                var txtValue = td.textContent || td.innerText;
                if (txtValue.toLowerCase().indexOf(filter) > -1) {
                    showRow = true;
                    break;
                }
            }
        }
        tr[i].style.display = showRow ? "" : "none";
    }
}

/**
 * Shows an alert message dynamically in the UI
 */
function showAlert(message, type) {
    var alertContainer = document.getElementById("alertContainer");
    if (!alertContainer) {
        // Fallback to basic browser alert if container not found
        alert(message);
        return;
    }

    var alertHtml = '<div class="alert alert-' + type + ' alert-dismissible fade show animate-fade-in" role="alert">' +
                    message +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                    '</div>';
    
    alertContainer.innerHTML = alertHtml;
    
    // Auto-dismiss alert after 4 seconds
    setTimeout(function() {
        var alertElement = document.querySelector(".alert");
        if (alertElement) {
            var bsAlert = new bootstrap.Alert(alertElement);
            bsAlert.close();
        }
    }, 4000);
}

/**
 * Triggers browser Print dialog on targeted elements (suitable for reports printing)
 */
function printReport() {
    window.print();
}

/**
 * Export table data to CSV/Excel format (Client-Side)
 * @param {string} tableId ID of the table to export
 * @param {string} filename Output file name
 */
function exportTableToExcel(tableId, filename = 'stock-report.csv') {
    var csv = [];
    var rows = document.querySelectorAll("#" + tableId + " tr");
    
    for (var i = 0; i < rows.length; i++) {
        // Filter rows that are currently visible (important when search filter is active)
        if (rows[i].style.display === "none") continue;
        
        var row = [], cols = rows[i].querySelectorAll("td, th");
        
        for (var j = 0; j < cols.length; j++) {
            // Remove comma from text to avoid breaking CSV format
            var data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, "").replace(/(\s\s)/gm, ' ');
            data = data.replace(/"/g, '""');
            row.push('"' + data + '"');
        }
        // Exclude the last action column if it exists
        if (cols.length > 0 && (cols[cols.length-1].innerText.toLowerCase().includes("action") || cols[cols.length-1].querySelector("a, button"))) {
            row.pop();
        }
        csv.push(row.join(","));
    }

    // Download CSV file
    var csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
    var downloadLink = document.createElement("a");
    downloadLink.download = filename;
    downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.style.display = "none";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
}
