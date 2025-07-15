# 🛒 Amazon Database System – SQL Project

📆 **Phase 1 – SQL Database Design, Development & Documentation**  
👨‍💻 **By Atharva Rajesh Mayekar**  

---

## 📌 Objective

Design and implement a complete SQL database system for an Amazon-like e-commerce platform. This project demonstrates core DBMS concepts: table design, relationships, query writing, and real-world data modeling.

---

## 🧠 Domain Overview – Amazon E-Commerce

> **Amazon** is the world’s largest e-commerce platform, connecting millions of users and sellers daily. This project simulates its core functionalities like user registration, product listings, orders, payments, reviews, and logistics — all structured in a relational SQL database.

---

## 🗃️ Database Summary

| Feature                 | Details                          |
|------------------------|----------------------------------|
| 📂 Database Name        | `amazon_db`                      |
| 🧾 Total Tables          | `25`                             |
| 📋 Records per Table     | `20+`                            |
| ✅ Constraints Used      | `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `DEFAULT`, `CHECK` |

---

## 🧱 Sample Tables & Entities

| Table Name     | Description                            |
|----------------|----------------------------------------|
| `customers`    | Stores user details                    |
| `products`     | Product listings across categories     |
| `orders`       | Order history with delivery info       |
| `sellers`      | Seller profiles and inventory          |
| `payments`     | Payment status per order               |
| `reviews`      | Customer feedback & ratings            |

> ✅ All 25 tables follow relational structure with valid constraints and normalization.

---

## 💾 Data Insertion

All tables are populated with at least 20+ meaningful records:
- Logical relationships between IDs
- Realistic email addresses, usernames, prices, and order timestamps
- Constraints respected (FK/PK, UNIQUE, CHECK)

---

## 🔍 SQL Queries Executed

### 🔨 DDL (Data Definition Language)
- `CREATE TABLE`, `DROP TABLE`, `ALTER TABLE`

### ✍️ DML (Data Manipulation Language)
- `INSERT INTO`, `UPDATE`, `DELETE`

### 🔎 DQL (Data Query Language)
- `SELECT`, `JOIN`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`
- Aggregates: `SUM`, `AVG`, `COUNT`, `MAX`, `MIN`

---

## 🧠 Real-World Use Cases

| Use Case                          | Query Technique             |
|----------------------------------|-----------------------------|
| 🛒 View all purchases by user     | `SELECT`, `JOIN`, `WHERE`   |
| 💰 Calculate seller revenue      | `GROUP BY`, `SUM`           |
| 🧾 Generate invoice per order     | `JOIN`, `ORDER BY`          |
| 🔍 Filter products by keyword     | `WHERE`, `LIKE`, `LIMIT`    |
| ⭐ List top-rated items           | `GROUP BY`, `AVG`, `ORDER`  |

---

## 💡 Reflection

### 🧱 Challenges
- Designing 25 meaningful, interconnected tables
- Keeping all constraints valid during insertions
- Writing JOIN-heavy queries with accurate output

### 🔧 Solutions
- Started with ER diagram and schema planning
- Inserted data in FK-friendly order
- Verified query output step-by-step

---

## 🧰 Tool Used

- 💻 MySQL 

---

## 🙌 Author Info

Built with 💙 by **Atharva Rajesh Mayekar**  
🎓 BSc IT | SQL & Data Analyst Enthusiast | 2025  

> _All data in this project is fictional and created for academic purposes only._

