Amazon Database Project - Phase 1 🚀


📋 Overview
Welcome to the Amazon Database Project! This repository hosts the SQL scripts for Phase 1, where we establish the foundation of an e-commerce database inspired by Amazon. This phase focuses on creating the database schema and populating it with sample data to simulate a fully functional online store.
Key Objectives:

🛠️ Create the Amazon database.
📊 Define 25 tables to support e-commerce operations.
📝 Insert 20 sample records per table for testing and development.

🗂️ Project Scope
In Phase 1, we lay the groundwork for a robust e-commerce database by:

Initializing the Amazon database.
Designing tables for core entities like products, customers, orders, and more.
Populating each table with sample data to mimic real-world scenarios.


🛠️ Database Schema
The database comprises 25 tables, each tailored to a specific e-commerce function:



Table Name
Purpose



Products
Stores product details (e.g., name, price, stock).


Customers
Holds customer info (e.g., name, email, address).


Orders
Tracks customer purchases and order status.


Suppliers
Manages supplier information for product sourcing.


Categories
Organizes products into categories and subcategories.


Reviews
Captures customer product reviews and ratings.


Payments
Records payment details for orders.


Shipments
Manages shipping info, including carriers and tracking.


Warehouses
Stores warehouse details for inventory.


Inventory
Tracks product stock across warehouses.


Promotions
Manages discounts and promotional campaigns.


Returns
Handles product returns and refunds.


Wishlists
Stores customer wishlists for future purchases.


Carts
Manages customer shopping carts.


Employees
Contains employee details (e.g., roles, salaries).


Departments
Organizes company departments and budgets.


Transactions
Logs financial transactions for orders.


Discounts
Tracks discount codes and their applicability.


Taxes
Records tax details based on region.


Addresses
Stores customer billing and shipping addresses.


Subscriptions
Manages subscriptions (e.g., Prime, Music).


GiftCards
Tracks gift card issuance and balances.


Coupons
Manages coupon codes and usage.


Feedback
Captures customer feedback on orders and services.


Logs
Logs system actions for auditing.


Each table includes appropriate columns, data types, and constraints to ensure data integrity.
📜 SQL Scripts
The core script for Phase 1 is Phase 1.sql, which includes:

Database Creation: Initializes the Amazon database.
Table Creation: Defines schemas for all 25 tables with primary keys and constraints.
Data Insertion: Adds 20 sample records per table to simulate a working dataset.



⚙️ Setup Instructions
To set up the database locally:

Install a DBMS:

Use MySQL, PostgreSQL, or any SQL-compatible system.
Download from MySQL or PostgreSQL.


Run the SQL Script:

Open your DBMS client (e.g., MySQL Workbench, pgAdmin).
Copy and paste the contents of Phase 1.sql.
Execute the script to create the database, tables, and insert records.


Verify the Data:

Run queries like SELECT * FROM Products; to check records.
Inspect the schema to confirm table structures and constraints.




🛠️ Prerequisites

A SQL-compatible DBMS (e.g., MySQL, PostgreSQL).
Basic SQL knowledge for script execution and verification.
Permissions to create databases and tables in your DBMS.
(Optional) A tool to generate a schema diagram (e.g., MySQL Workbench, Lucidchart).

📈 Sample Data
Each table contains 20 records to simulate realistic e-commerce scenarios:

Products: Includes items like laptops, smartphones, and accessories with details like price and stock.
Customers: Lists customers from various U.S. cities with contact info.
Orders: Tracks purchases with quantities, prices, and shipping details.

This data provides a solid foundation for testing and future development.
🚀 Next Steps
Phase 2 will expand the project by:

🔗 Adding foreign key constraints for table relationships.
🛠️ Creating stored procedures and triggers for automation.
📊 Developing queries for reporting and analytics.
⚡ Optimizing the database with indexes and performance tweaks.

🤝 Contributing
We welcome contributions! To get started:

Fork the repository.
Create a branch: git checkout -b feature/your-feature.
Commit changes: git commit -m "Add your feature".
Push to your branch: git push origin feature/your-feature.
Open a pull request with a clear description.

Ensure changes align with SQL best practices and project goals.
📜 License
This project is licensed under the MIT License. See the LICENSE file for details.
📬 Contact
For questions or feedback:

Open an issue in the repository.
Contact the maintainer at your-email@example.com.


🌟 Let's build a world-class e-commerce database together! 🌟

