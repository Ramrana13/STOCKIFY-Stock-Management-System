# Stockify-Stock Management System

A complete, responsive, MVC-based **Stock Management & Inventory System** designed for B.Tech Academic Project submission. Built using core Java Web technologies (Servlets & JSPs) with a MySQL backend database, utilizing **Jakarta EE** specifications to guarantee seamless compatibility with modern servers like **Apache Tomcat 10+**.

---

## 🛠️ Technology Stack

* **Frontend**: HTML5, CSS3, JavaScript, JSP (JavaServer Pages), Bootstrap v5.3+ (CDN)
* **Backend**: Java Servlets (Jakarta EE 10 specification)
* **Database**: MySQL Server v8.0+
* **JDBC Connectivity**: Driver Manager with `PreparedStatement` transactions
* **Server Compatibility**: Apache Tomcat v10.0+ (and newer)
* **Development Environment**: Eclipse IDE for Enterprise Java Developers

---

## 📁 Project Structure

```text
StockManagementSystem/
├── WebContent/                 <- Client-side folder
│   ├── META-INF/
│   │   └── MANIFEST.MF
│   ├── WEB-INF/
│   │   ├── web.xml             <- Deployment Descriptor configurations
│   │   └── lib/                <- Place mysql-connector-j-x.x.x.jar here
│   ├── css/
│   │   └── style.css           <- Premium dashboard layout and transitions
│   ├── js/
│   │   └── validation.js       <- Client validator and CSV exporter scripts
│   ├── login.jsp               <- Authenticator portal
│   ├── dashboard.jsp           <- Executive analytical statistics dashboard
│   ├── addProduct.jsp          <- Create product form
│   ├── updateProduct.jsp       <- Modify product form
│   ├── inventory.jsp           <- Main product registry catalog
│   ├── warehouse.jsp           <- Central Warehouse levels log
│   ├── shop.jsp                <- Retail outlet floor log and sales logger
│   ├── transfers.jsp           <- Pending request panel and history audit
│   ├── reports.jsp             <- Printable report ledger with filters
│   ├── navbar.jsp              <- Shared header template
│   └── footer.jsp              <- Shared footer template
├── src/                        <- Server-side Java files
│   └── com/
│       └── stock/
│           ├── conn/
│           │   └── DBConnection.java   <- Database connection helper
│           ├── model/
│           │   ├── Product.java        <- Product Model JavaBean
│           │   ├── User.java           <- User Model JavaBean
│           │   └── Transfer.java       <- Transfer Model JavaBean
│           ├── dao/
│           │   ├── UserDAO.java        <- Authenticator queries
│           │   ├── ProductDAO.java     <- Catalog CRUD queries & stats
│           │   └── TransferDAO.java    <- Transactional inventory transfers
│           └── servlet/
│               ├── LoginServlet.java
│               ├── LogoutServlet.java
│               ├── AddProductServlet.java
│               ├── UpdateProductServlet.java
│               ├── DeleteProductServlet.java
│               ├── InventoryServlet.java
│               ├── TransferServlet.java
│               └── ReportServlet.java
├── schema.sql                  <- Database initialization script
└── README.md                   <- Setup and Running Guide
```

---

## 🚀 Step-by-Step Setup Instructions

### 1. Database Configuration
1. Open your MySQL Command Line Client or MySQL Workbench.
2. Run the queries in the `schema.sql` file located in the project folder to create the database and tables and insert sample records.
3. Open `src/com/stock/conn/DBConnection.java` and modify database credentials to match your local setup:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/stock_management_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
   private static final String USER = "root";       // Change if your MySQL username is different
   private static final String PASSWORD = "password"; // Change to your local MySQL root password
   ```

### 2. Eclipse Import & Project Configuration
1. Launch **Eclipse IDE for Enterprise Java and Web Developers**.
2. Go to **File -> Import... -> General -> Existing Projects into Workspace** -> Click **Next**.
3. Choose **Select root directory**, browse and select the `StockManagementSystem` directory, then click **Finish**.
4. **Download MySQL Connector JAR**: Download the MySQL JDBC driver (e.g., `mysql-connector-j-8.x.x.jar`) from the official MySQL website.
5. **Add JDBC Driver to Library**: Paste the downloaded JAR file into the `WebContent/WEB-INF/lib/` folder.
6. **Set Server Target**:
   - Right-click the project -> **Properties**.
   - Go to **Targeted Runtimes**.
   - Check **Apache Tomcat v10.0** (or your installed Tomcat 10 version). Click **Apply and Close**.
7. If there are red error markers:
   - Right-click the project -> **Build Path -> Configure Build Path...**
   - Click on the **Libraries** tab -> **Add Library... -> Server Runtime -> Apache Tomcat v10.0** -> Click **Finish**.

### 3. Deploying and Running on Tomcat 10
1. Open Eclipse's **Servers** tab. (If not visible: *Window -> Show View -> Servers*).
2. Right-click in the Servers area -> **New -> Server** -> Select **Apache Tomcat v10.0** and configure its local installation directory.
3. Right-click the project `StockManagementSystem` -> **Run As -> Run on Server**.
4. Choose the configured Tomcat 10 server and click **Finish**.
5. The application will start. Open your web browser and navigate to:
   `http://localhost:8080/StockManagementSystem/login.jsp`

---

## 🔑 Test Credentials

Use the following admin credentials to sign in:
* **Username**: `admin`
* **Password**: `admin123`

---

## 💡 Operational Guide & Walkthrough

1. **Dashboard Analytics**: Check product totals, warehouse counts, low stock counts, and approve pending transfer requests directly.
2. **Catalog (CRUD)**: Manage product metadata, adjust price details, SKU labels, and safety stock targets.
3. **Warehouse Stocks**: Keep track of bulk inventories in the central hub. Use the inline edit boxes to update quantities.
4. **Shop Stock & Retail Sales**: Check quantities available on the shop floor. Click **Sell** to log a customer purchase, which decrements available shop floor stocks and logs sales counters.
5. **Transfers Requests (Transactions)**: If shop floor stocks are low, click **Request Stock** on the Shop floor page. A modal will open. Set a quantity (capped by warehouse availability) and submit. Go to the **Transfers** tab to approve it. Stock will deduct from the warehouse and add to the shop in a single transaction.
6. **Reporting Audit**: Filter reports client-side for low stock warnings. Click **Export CSV** to download a ledger file or click **Print/PDF** to export a clean document with hidden control buttons.

---

## 📸 Application Screenshots

The following screenshots demonstrate the major modules and workflow of the Stockify Stock Management System.

### 🔐 Admin Login
Secure administrator authentication for accessing the Stockify inventory management system.
<img width="1917" height="970" alt="image" src="https://github.com/user-attachments/assets/f66b6bf4-d0a5-4a33-90c0-d7bba078f3e9" />

### 📊 Dashboard
Provides an overview of total products, stock quantities, low-stock alerts, and pending stock transfers.
<img width="1917" height="905" alt="image" src="https://github.com/user-attachments/assets/a9233a2a-6f85-4405-8d48-df42ed4a87af" />

### 📦 Product Management
Manage product details including SKU, category, price, description, and minimum safety stock.
<img width="1917" height="896" alt="image" src="https://github.com/user-attachments/assets/6e9b61fb-d62b-4928-b5bb-c257b6c56ae9" />

### 🏢 Warehouse Inventory
Monitor and update product quantities available in the central warehouse.
<img width="1917" height="906" alt="image" src="https://github.com/user-attachments/assets/26d9b756-d229-4654-b322-25b8a87baa37" />

### 🏪 Shop Floor Inventory
Monitor shop stock, record product sales, and request additional stock from the warehouse.
<img width="1917" height="882" alt="image" src="https://github.com/user-attachments/assets/cd8b83a7-436c-4c9a-b03e-83ce1ccee4c2" />

### 🔄 Stock Transfer Management
Request, approve, or reject stock transfers between the warehouse and shop.
<img width="1917" height="907" alt="image" src="https://github.com/user-attachments/assets/8fd85ca6-fd9b-481a-8d12-ffc8ad696755" />

### 📊 Report Center
View inventory statistics, search and filter records, and monitor estimated asset valuation.
<img width="1917" height="907" alt="image" src="https://github.com/user-attachments/assets/1a21c26e-0825-4889-b954-a69dae6ebbd6" />

### 📄 Report Export
Generate inventory reports using PDF and CSV/Excel export functionality.
<img width="1917" height="910" alt="image" src="https://github.com/user-attachments/assets/cc273f24-d063-4516-9247-1948cd2a4974" />
<img width="1917" height="1015" alt="image" src="https://github.com/user-attachments/assets/542f5d49-3ac2-42c2-9f46-657ed073efc2" />


   
