Amazon Database Project - Phase 2 🛒
📋 Overview
Phase 2 of the Amazon Database Project dives into querying the e-commerce database set up in Phase 1. With 250 SQL queries (10 per table), we explore data manipulation, analysis, and relationships across 25 tables.
Goals:

🛠️ Run queries: DDL, DML, operators, functions, joins, clauses.
📊 Analyze data for an Amazon-like platform.
🔗 Use existing schema with foreign keys.

🗂️ Database Schema
The 25-table schema from Phase 1 supports products, customers, orders, and more. Key tables and foreign keys:



Table
Purpose
Foreign Keys



Products
Product details (name, price)
category_id → Categories, supplier_id → Suppliers


Customers
Customer info (email, address)
None


Orders
Purchase tracking
customer_id → Customers, product_id → Products


Reviews
Product ratings
product_id → Products, customer_id → Customers


Payments
Order payments
order_id → Orders, customer_id → Customers


See all 25 tables in the schema diagram.
📜 Queries
Phase 2.sql includes 10 queries per table:

DDL: Add columns (e.g., status).
DML: Update data (e.g., uppercase names).
Operators: Filter records (e.g., WHERE status = 'Delivered').
Functions: Aggregations (e.g., AVG(price)).
Joins: Combine tables (e.g., Products + Categories).
Clauses: Group/sort (e.g., GROUP BY category_id).

⚙️ Setup

Run Phase 1:
Use Phase 1.sql to create and populate the database (MySQL/PostgreSQL).


Execute Queries:
Run Phase 2.sql in your DBMS client (e.g., MySQL Workbench).


Verify:
Check results (e.g., SELECT * FROM Products;).



🛠️ Prerequisites

DBMS (MySQL/PostgreSQL).
Phase 1 database.
SQL knowledge.

🤝 Contributing

Fork repo.
Branch: git checkout -b feature/your-feature.
Commit: git commit -m "Add feature".
Push: git push origin feature/your-feature.
Open pull request.

📜 License
MIT License.
📬 Contact
Open an issue or email your- atharvamayekar7673@example.com.

🌟 Query the future of e-commerce! 🌟
