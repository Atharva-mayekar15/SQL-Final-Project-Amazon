# 🛒💻 Amazon Database - Phase 3 SQL Queries

![Amazon SQL Banner](https://i.imgur.com/Qv2xQo3.png)  
*A mega set of SQL queries for mastering real-world e-commerce databases!*

---

## 🔤 TL;DR

> This `.sql` file = 📦 Amazon DB x 🔥 SQL skills  
> Includes ➡️ Joins 🔁 | Subqueries 🧩 | Functions 🧠 | CRUD Ops 🛠️  
> Perfect for practice, portfolios, and flexing data logic skills 💪

---

## 🧱 Database Vibes

This is a **mock Amazon-style** e-commerce database with all the essentials:

🛍️ **Tables include**:
- `Products`, `Customers`, `Orders`, `Payments`
- `Reviews`, `Suppliers`, `Categories`, `Shipments`
- `Inventory`, `Employees`, `Departments`, and more...

![Database Schema](https://i.imgur.com/WKcMdbS.png)

---

## 🚀 Query Categories

> **A < Joins < SQ < Fun < B&UD**  
> *(A = Basic, SQ = Subqueries, Fun = Functions, B&UD = Basic + Update/Delete)*

### 🔗 Joins (INNER / LEFT / RIGHT / FULL)
```sql
SELECT p.product_name, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;
```
✅ Emulated FULL JOINS using `UNION` for platforms that don't support native ones.

---

### 🧩 Subqueries
- **Simple**: `WHERE price > (SELECT AVG(price))`
- **Complex**: `EXISTS`, `IN`, and nested SELECTs

```sql
SELECT product_name
FROM Products
WHERE stock_quantity > (SELECT AVG(stock_quantity) FROM Products);
```

---

### 🧠 Functions
- `COUNT()`, `SUM()`, `AVG()`, `CONCAT()`, `DATEDIFF()`, `FORMAT()` and more!
- Show off those Power BI-style summaries 💥

```sql
SELECT city, COUNT(*) AS customer_count
FROM Customers
GROUP BY city;
```

---

### ✍️ Basic + Update/Delete
- 🔹 `INSERT INTO ...`
- 🔄 `UPDATE ... SET ...`
- ❌ `DELETE FROM ...`

```sql
INSERT INTO Products (product_id, product_name, ...)
VALUES (21, 'Wireless Keyboard', ...);
```

---

## 📁 File Details

| Property       | Value                  |
|----------------|------------------------|
| **File Name**  | `Phase 3.sql`          |
| **Total Queries** | ~300+ SQL 🔥          |
| **Tables Covered** | 25+ 🧱                |
| **Skill Level** | Intermediate to Advanced 👨‍💻 |

---

## 🧠 Use It For:

🎓 SQL Practice  
💼 Portfolio Projects  
🧪 Test Data Analytics Logic  
🎯 Interview Preparation  


---

## 🙌 Author

Made with 💙 by **Atharva Rajesh Mayekar**  
🎓 BSc-IT | 🧠 Data Analytics Explorer | 🧑‍💻 Frontend Dev in Progress

> Wanna collab or need help? Hit me up on [LinkedIn](https://linkedin.com) or drop a DM 📬

---

## 🏁 Ready to Run?

1. Open your SQL editor (MySQL Workbench, phpMyAdmin, DBeaver etc.)
2. Load `Phase 3.sql`
3. Execute section by section or table by table
4. Watch the magic happen! 💫

---

## 🧊 Bonus Tip

If you're tryna build a frontend dashboard using this DB:
- Pair this SQL with **Power BI**, **Tableau**, or even a **React + Express** app 🔥

---

![Thanks](https://i.imgur.com/gU8iYHX.png)
*Thanks for scrolling!*

