# 🧠 Amazon Database System – SQL Project (Phase 2)

📆 **Phase 2 – (DDL<ML<QL<C&C<Op) 
👨‍💻 **By Atharva Rajesh Mayekar** 

---

## 📌 Phase 2 Objective

This phase focuses on applying **advanced SQL concepts** to the previously designed Amazon E-Commerce Database. It demonstrates a deeper understanding of query operations, joins, subqueries, constraints like CASCADE, and clean code documentation.

---

## ✅ Requirements Covered

| Feature                                | Status     |
|----------------------------------------|------------|
| 🔹 DDL, DML, DQL                        | ✅ Applied |
| 🔹 Operators, Clauses, Alias, Functions| ✅ Used    |
| 🔹 Joins & Subqueries                  | ✅ Done    |
| 🔹 ON DELETE / UPDATE CASCADE         | ✅ Included|
| 🔹 Neatly Commented Queries            | ✅ Followed|

---

## 🧠 What’s Included in `Phase 2.sql`

### 🔨 DDL (Data Definition Language)
- Table updates and structure alterations
- Added CASCADE constraints


✍️ DML (Data Manipulation Language)
Insert new records for testing joins and subqueries

Update and delete statements with cascading effect


🔍 DQL (Data Query Language)
Includes:

SELECT with WHERE, ORDER BY, LIMIT, GROUP BY, HAVING

Aliases using AS

Functions like COUNT(), AVG(), SUM(), NOW(), CONCAT(), ROUND()

-- Example: Find total revenue per seller
SELECT s.name AS SellerName, SUM(p.amount) AS TotalRevenue
FROM payments p
JOIN orders o ON p.order_id = o.id
JOIN sellers s ON o.seller_id = s.id
GROUP BY s.name
ORDER BY TotalRevenue DESC;


🔗 Joins & Subqueries
INNER, LEFT, RIGHT, FULL OUTER joins

Nested queries inside SELECT, WHERE, FROM


🧼 Clean Query Formatting & Commenting
✅ All queries are clearly labeled with comments

✅ Used single-line (--) and multi-line (/* */) comments

✅ Queries grouped logically for clarity


💡 What You’ll See in the Code
📌 100+ lines of advanced SQL demonstrating:

Logical joins

Use of aliases and functions

Smart use of subqueries

Cascading behavior in action

Production-ready formatting


## 🙌 Author Info
Built with 💙 by Atharva Rajesh Mayekar
🎓 BSc IT | SQL Enthusiast | 2025
