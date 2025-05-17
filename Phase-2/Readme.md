Amazon Database Project - Phase 2 🛒


📋 Overview
Welcome to Phase 2 of the Amazon Database Project! This phase builds upon the foundation laid in Phase 1 by enhancing the Amazon database with foreign key constraints, inserting sample data, and implementing a variety of SQL queries to demonstrate functionality. The database simulates a comprehensive e-commerce platform, supporting entities like products, customers, orders, and more.
Key Objectives:

🔗 Add foreign key constraints to enforce data relationships.
📊 Insert 20 sample records per table for testing.
🛠️ Execute 10 queries per table (DDL, DML, operators, functions, joins, and clauses).

🗂️ Project Scope
Phase 2 focuses on:

Enhancing the database schema with referential integrity through foreign keys.
Populating all 25 tables with realistic sample data.
Demonstrating database operations with queries for data manipulation, retrieval, and analysis.



Note: Add a database schema diagram to the images/ folder as database-schema-phase2.png to visualize table relationships with foreign keys. Use tools like MySQL Workbench or Lucidchart to generate the diagram.

🛠️ Database Schema
The Amazon database consists of 25 tables, each designed to support e-commerce operations. Below is a summary of the tables and their purposes, with foreign key relationships added in Phase 2:



Table Name
Purpose
Foreign Keys



Products
Stores product details (e.g., name, price, stock).
category_id → Categories, supplier_id → Suppliers


Customers
Holds customer info (e.g., name, email, address).
None


Orders
Tracks customer purchases and order status.
customer_id → Customers, product_id → Products


Suppliers
Manages supplier information for product sourcing.
None


Categories
Organizes products into categories and subcategories.
parent_category_id → Categories (self-referential)


Reviews
Captures customer product reviews and ratings.
product_id → Products, customer_id → Customers


Payments
Records payment details for orders.
order_id → Orders, customer_id → Customers


Shipments
Manages shipping info, including carriers and tracking.
order_id → Orders, warehouse_id → Warehouses


Warehouses
Stores warehouse details for inventory.
None


Inventory
Tracks product stock across warehouses.
product_id → Products, warehouse_id → Warehouses


Promotions
Manages discounts and promotional campaigns.
product_id → Products


Returns
Handles product returns and refunds.
order_id → Orders, product_id → Products


Wishlists
Stores customer wishlists for future purchases.
customer_id → Customers, product_id → Products


Carts
Manages customer shopping carts.
customer_id → Customers, product_id → Products


Employees
Contains employee details (e.g., roles, salaries).
department_id → Departments


Departments
Organizes company departments and budgets.
manager_id → Employees


Transactions
Logs financial transactions for orders.
payment_id → Payments, order_id → Orders, customer_id → Customers


Discounts
Tracks discount codes and their applicability.
product_id → Products


Taxes
Records tax details based on region.
order_id → Orders, product_id → Products


Addresses
Stores customer billing and shipping addresses.
customer_id → Customers


Subscriptions
Manages subscriptions (e.g., Prime, Music).
customer_id → Customers


GiftCards
Tracks gift card issuance and balances.
customer_id → Customers, order_id → Orders


Coupons
Manages coupon codes and usage.
order_id → Orders


Feedback
Captures customer feedback on orders and services.
customer_id → Customers, order_id → Orders


Logs
Logs system actions for auditing.
user_id → Employees


Each table includes appropriate columns, data types, and constraints (e.g., ON DELETE CASCADE, ON UPDATE CASCADE) to ensure data integrity.
📜 SQL Scripts
The primary script for Phase 2 is Phase 2.sql, which includes:

Database Creation: Initializes the Amazon database.
Table Creation: Defines schemas for all 25 tables with primary and foreign keys.
Data Insertion: Inserts 20 sample records per table to simulate a working dataset.
Queries: Executes 10 queries per table, covering:
DDL: Adding columns (e.g., status, type).
DML: Updating records (e.g., converting text to uppercase).
Operators: Filtering data (e.g., WHERE conditions).
Functions: Aggregations (e.g., AVG, COUNT, MAX).
Joins: Combining tables (e.g., LEFT JOIN with related tables).
Clauses with Aliases: Grouping and ordering (e.g., GROUP BY, ORDER BY).


⚙️ Setup Instructions
To set up the database locally:

Install a DBMS:

Use MySQL, PostgreSQL, or any SQL-compatible system.
Download from MySQL or PostgreSQL.


Run the SQL Script:

Open your DBMS client (e.g., MySQL Workbench, pgAdmin).
Copy and paste the contents of Phase 2.sql.
Execute the script to create the database, tables, insert records, and run queries.
Note: Ensure tables are created in the correct order to satisfy foreign key dependencies (e.g., Customers before Orders).


Verify the Data:

Run queries like SELECT * FROM Products; to check records.
Inspect foreign key constraints using SHOW CREATE TABLE Orders;.
Test sample queries from Phase 2.sql to verify functionality.




🛠️ Prerequisites

A SQL-compatible DBMS (e.g., MySQL, PostgreSQL).
Basic SQL knowledge for script execution and verification.
Permissions to create databases and tables in your DBMS.
(Optional) Tools for schema visualization (e.g., MySQL Workbench, Lucidchart).

📈 Sample Data
Each table contains 20 records to simulate realistic e-commerce scenarios:

Products: Includes items like laptops, smartphones, and accessories (e.g., "Laptop Pro", $999.99, 50 in stock).
Customers: Lists customers across U.S. cities (e.g., John Doe, New York, NY).
Orders: Tracks purchases with details like quantities and shipping addresses (e.g., Order #1, Laptop Pro, $999.99).
Queries: Demonstrate operations like updating product names to uppercase, joining tables, and calculating averages.

This data supports testing and development for future phases.
📊 Query Highlights
Each table includes 10 queries to showcase database capabilities

