-- Project Phase-2(DDL<ML<QL<C&C<Op)

-- Products Table Queries
-- Query 1: DDL - Add column for product status
ALTER TABLE Products
ADD status VARCHAR(20) DEFAULT 'Available';

-- Query 2: DML - Update product_name to uppercase
UPDATE Products
SET product_name = UPPER(product_name)
WHERE price < 50.00;

-- Query 3: Operator - Select low-priced products
SELECT product_name, price
FROM Products
WHERE price < 100.00;

-- Query 4: Operator - Select active products
SELECT product_name, stock_quantity
FROM Products
WHERE is_active = TRUE;

-- Query 5: Function - Average product price
SELECT AVG(price) AS avg_price
FROM Products;

-- Query 6: Function - Maximum product rating
SELECT MAX(rating) AS max_rating
FROM Products;

-- Query 7: Join - Join with Categories
SELECT p.product_name,c.category_name
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 8: Join - Join with Suppliers
SELECT p.product_name, 
       s.supplier_name
FROM Products p
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 9: Clause with Alias - Count products by category
SELECT category_id AS CatID,COUNT(*) AS ProductCount
FROM Products
GROUP BY CatID;

-- Query 10: Clause with Alias - Order by price
SELECT product_name AS Product,price AS Price
FROM Products
ORDER BY Price DESC;



-- Customers Table Queries
-- Query 1: DDL - Add column for loyalty status
ALTER TABLE Customers
ADD loyalty_status VARCHAR(20) DEFAULT 'Regular' COMMENT 'Customer loyalty level';

-- Query 2: DML - Update email to lowercase
UPDATE Customers
SET email = LOWER(email) WHERE state = 'CA';

-- Query 3: Operator - Select customers from Texas
SELECT first_name, last_name FROM Customers
WHERE state = 'TX';

-- Query 4: Operator - Select recent customers
SELECT first_name, email FROM Customers
WHERE registration_date > '2024-01-01';

-- Query 5: Function - Count customers
SELECT COUNT(*) AS total_customers
FROM Customers;

-- Query 6: Function - Minimum registration date
SELECT MIN(registration_date) AS earliest_registration
FROM Customers;

-- Query 7: Join - Join with Orders
SELECT c.first_name,o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Query 8: Join - Join with Subscriptions
SELECT c.last_name,s.plan_name
FROM Customers c
LEFT JOIN Subscriptions s ON c.customer_id = s.customer_id;

-- Query 9: Clause with Alias - Group by city
SELECT city AS City,COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City;

-- Query 10: Clause with Alias - Order by registration date
SELECT first_name AS Name,registration_date AS RegDate
FROM Customers
ORDER BY RegDate DESC;


-- Orders Table Queries
-- Query 1: DDL - Add column for order priority
ALTER TABLE Orders
ADD priority VARCHAR(10) DEFAULT 'Normal' COMMENT 'Order priority level';

-- Query 2: DML - Update status to uppercase
UPDATE Orders
SET status = UPPER(status)
WHERE total_price > 500.00;

-- Query 3: Operator - Select delivered orders
SELECT order_id, total_price
FROM Orders
WHERE status = 'Delivered';

-- Query 4: Operator - Select recent orders
SELECT order_id, order_date
FROM Orders
WHERE order_date > '2024-01-01';

-- Query 5: Function - Sum of total prices
SELECT SUM(total_price) AS total_revenue
FROM Orders;

-- Query 6: Function - Average order quantity
SELECT AVG(quantity) AS avg_quantity
FROM Orders;

-- Query 7: Join - Join with Customers
SELECT o.order_id,c.first_name
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 8: Join - Join with Products
SELECT o.order_id,p.product_name
FROM Orders o
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS OrderStatus,COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderStatus;

-- Query 10: Clause with Alias - Order by total price
SELECT order_id AS OrderID,total_price AS Total
FROM Orders
ORDER BY Total DESC;



-- Suppliers Table Queries
-- Query 1: DDL - Add column for supplier type
ALTER TABLE Suppliers
ADD supplier_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of supplier';

-- Query 2: DML - Update supplier_name to uppercase
UPDATE Suppliers
SET supplier_name = UPPER(supplier_name)
WHERE city = 'San Francisco';

-- Query 3: Operator - Select suppliers from California
SELECT supplier_name, city
FROM Suppliers
WHERE state = 'CA';

-- Query 4: Operator - Select recent suppliers
SELECT supplier_name, contract_date
FROM Suppliers
WHERE contract_date > '2023-01-01';

-- Query 5: Function - Count suppliers
SELECT COUNT(*) AS total_suppliers
FROM Suppliers;

-- Query 6: Function - Earliest contract date
SELECT MIN(contract_date) AS earliest_contract
FROM Suppliers;

-- Query 7: Join - Join with Products
SELECT s.supplier_name,p.product_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id;

-- Query 8: Join - Join with Products (count products)
SELECT s.supplier_name,p.product_id AS product_count
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name;

-- Query 9: Clause with Alias - Group by city
SELECT city AS City,COUNT(*) AS SupplierCount
FROM Suppliers
GROUP BY City;

-- Query 10: Clause with Alias - Order by contract date
SELECT supplier_name AS Supplier,contract_date AS ContractDate
FROM Suppliers
ORDER BY ContractDate DESC;



-- Categories Table Queries
-- Query 1: DDL - Add column for category status
ALTER TABLE Categories
ADD status VARCHAR(20) DEFAULT 'Active' COMMENT 'Category status';

-- Query 2: DML - Update category_name to uppercase
UPDATE Categories
SET category_name = UPPER(category_name)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active categories
SELECT category_name, display_order
FROM Categories
WHERE is_active = TRUE;

-- Query 4: Operator - Select top-level categories
SELECT category_name, category_id
FROM Categories
WHERE parent_category_id IS NULL;

-- Query 5: Function - Maximum display order
SELECT MAX(display_order) AS max_display_order
FROM Categories;

-- Query 6: Function - Count categories
SELECT COUNT(*) AS total_categories
FROM Categories;

-- Query 7: Join - Join with Products
SELECT c.category_name,p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id;

-- Query 8: Join - Self-join for parent categories
SELECT c.category_name,p.category_name AS parent_name
FROM Categories c
LEFT JOIN Categories p ON c.parent_category_id = p.category_id;

-- Query 9: Clause with Alias - Group by parent category
SELECT parent_category_id AS ParentID,COUNT(*) AS CategoryCount
FROM Categories
GROUP BY ParentID;

-- Query 10: Clause with Alias - Order by display order
SELECT category_name AS Category,display_order AS DisplayOrder
FROM Categories
ORDER BY DisplayOrder ASC;


-- Reviews Table Queries
-- Query 1: DDL - Add column for review type
ALTER TABLE Reviews
ADD review_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of review';

-- Query 2: DML - Update comment to uppercase
UPDATE Reviews
SET comment = UPPER(comment)
WHERE rating > 4;

-- Query 3: Operator - Select high-rated reviews
SELECT comment, rating
FROM Reviews
WHERE rating >= 4;

-- Query 4: Operator - Select verified reviews
SELECT comment, review_date
FROM Reviews
WHERE is_verified = TRUE;

-- Query 5: Function - Average review rating
SELECT AVG(rating) AS avg_rating
FROM Reviews;

-- Query 6: Function - Maximum helpful votes
SELECT MAX(helpful_votes) AS max_votes
FROM Reviews;

-- Query 7: Join - Join with Products
SELECT r.comment,p.product_name
FROM Reviews r
LEFT JOIN Products p ON r.product_id = p.product_id;

-- Query 8: Join - Join with Customers
SELECT r.rating,c.first_name
FROM Reviews r
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS ReviewStatus,COUNT(*) AS ReviewCount
FROM Reviews
GROUP BY ReviewStatus;

-- Query 10: Clause with Alias - Order by review date
SELECT comment AS Comment,review_date AS ReviewDate
FROM Reviews
ORDER BY ReviewDate DESC;




-- Payments Table Queries
-- Query 1: DDL - Add column for payment type
ALTER TABLE Payments
ADD payment_type VARCHAR(20) DEFAULT 'Online' COMMENT 'Type of payment';

-- Query 2: DML - Update payment_method to uppercase
UPDATE Payments
SET payment_method = UPPER(payment_method)
WHERE amount > 200.00;

-- Query 3: Operator - Select completed payments
SELECT payment_id, amount
FROM Payments
WHERE status = 'Completed';

-- Query 4: Operator - Select high-value payments
SELECT payment_id, payment_date
FROM Payments
WHERE amount > 500.00;

-- Query 5: Function - Sum of payment amounts
SELECT SUM(amount) AS total_payments
FROM Payments;

-- Query 6: Function - Minimum payment amount
SELECT MIN(amount) AS min_payment
FROM Payments;

-- Query 7: Join - Join with Orders
SELECT p.payment_id,o.order_id
FROM Payments p
LEFT JOIN Orders o ON p.order_id = o.order_id;

-- Query 8: Join - Join with Customers
SELECT p.amount,c.first_name
FROM Payments p
LEFT JOIN Customers c ON p.customer_id = c.customer_id;

-- Query 9: Clause with Alias - Group by payment method
SELECT payment_method AS Method,COUNT(*) AS PaymentCount
FROM Payments
GROUP BY Method;

-- Query 10: Clause with Alias - Order by payment date
SELECT payment_id AS PaymentID,payment_date AS PayDate
FROM Payments
ORDER BY PayDate DESC;



-- Shipments Table Queries
-- Query 1: DDL - Add column for shipment priority
ALTER TABLE Shipments
ADD priority VARCHAR(10) DEFAULT 'Standard' COMMENT 'Shipment priority';

-- Query 2: DML - Update carrier to uppercase
UPDATE Shipments
SET carrier = UPPER(carrier)
WHERE shipping_cost > 12.00;

-- Query 3: Operator - Select delivered shipments
SELECT shipment_id, carrier
FROM Shipments
WHERE status = 'Delivered';

-- Query 4: Operator - Select expensive shipments
SELECT shipment_id, shipping_date
FROM Shipments
WHERE shipping_cost > 10.00;

-- Query 5: Function - Average shipping cost
SELECT AVG(shipping_cost) AS avg_cost
FROM Shipments;

-- Query 6: Function - Maximum shipping cost
SELECT MAX(shipping_cost) AS max_cost
FROM Shipments;

-- Query 7: Join - Join with Orders
SELECT s.shipment_id,o.order_id
FROM Shipments s
LEFT JOIN Orders o ON s.order_id = o.order_id;

-- Query 8: Join - Join with Warehouses
SELECT s.tracking_number,w.warehouse_name
FROM Shipments s
LEFT JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;

-- Query 9: Clause with Alias - Group by carrier
SELECT carrier AS Carrier,COUNT(*) AS ShipmentCount
FROM Shipments
GROUP BY Carrier;

-- Query 10: Clause with Alias - Order by shipping date
SELECT shipment_id AS ShipmentID,shipping_date AS ShipDate
FROM Shipments
ORDER BY ShipDate DESC;



-- Warehouses Table Queries
-- Query 1: DDL - Add column for warehouse type
ALTER TABLE Warehouses
ADD warehouse_type VARCHAR(20) DEFAULT 'Distribution' COMMENT 'Type of warehouse';

-- Query 2: DML - Update warehouse_name to uppercase
UPDATE Warehouses
SET warehouse_name = UPPER(warehouse_name)
WHERE capacity > 8000;

-- Query 3: Operator - Select warehouses in California
SELECT warehouse_name, city
FROM Warehouses
WHERE state = 'CA';

-- Query 4: Operator - Select large warehouses
SELECT warehouse_name, capacity
FROM Warehouses
WHERE capacity > 7500;

-- Query 5: Function - Total warehouse capacity
SELECT SUM(capacity) AS total_capacity
FROM Warehouses;

-- Query 6: Function - Minimum warehouse capacity
SELECT MIN(capacity) AS min_capacity
FROM Warehouses;

-- Query 7: Join - Join with Shipments
SELECT w.warehouse_name,s.shipment_id
FROM Warehouses w
LEFT JOIN Shipments s ON w.warehouse_id = s.warehouse_id;

-- Query 8: Join - Join with Inventory
SELECT w.warehouse_name,i.quantity
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id;

-- Query 9: Clause with Alias - Group by city
SELECT city AS City,COUNT(*) AS WarehouseCount
FROM Warehouses
GROUP BY City;

-- Query 10: Clause with Alias - Order by operational date
SELECT warehouse_name AS Warehouse,operational_since AS StartDate
FROM Warehouses
ORDER BY StartDate ASC;


-- Inventory Table Queries
-- Query 1: DDL - Add column for stock status
ALTER TABLE Inventory
ADD stock_status VARCHAR(20) DEFAULT 'Normal' COMMENT 'Stock status';

-- Query 2: DML - Update status to uppercase
UPDATE Inventory
SET status = UPPER(status)
WHERE quantity < 50;

-- Query 3: Operator - Select low stock items
SELECT product_id, quantity
FROM Inventory
WHERE quantity < 50;

-- Query 4: Operator - Select in-stock items
SELECT product_id, status
FROM Inventory
WHERE status = 'In Stock';

-- Query 5: Function - Total inventory quantity
SELECT SUM(quantity) AS total_stock
FROM Inventory;

-- Query 6: Function - Minimum inventory quantity
SELECT MIN(quantity) AS min_stock
FROM Inventory;

-- Query 7: Join - Join with Products
SELECT i.quantity,p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id;

-- Query 8: Join - Join with Warehouses
SELECT i.quantity,w.warehouse_name
FROM Inventory i
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- Query 9: Clause with Alias - Group by warehouse
SELECT warehouse_id AS WarehouseID,SUM(quantity) AS TotalStock
FROM Inventory
GROUP BY WarehouseID;

-- Query 10: Clause with Alias - Order by quantity
SELECT product_id AS ProductID,quantity AS Stock
FROM Inventory
ORDER BY Stock DESC;


-- Promotions Table Queries
-- Query 1: DDL - Add column for promotion type
ALTER TABLE Promotions
ADD promotion_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of promotion';

-- Query 2: DML - Update promotion_name to uppercase
UPDATE Promotions
SET promotion_name = UPPER(promotion_name)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active promotions
SELECT promotion_name, discount_percentage
FROM Promotions
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-discount promotions
SELECT promotion_name, discount_percentage
FROM Promotions
WHERE discount_percentage > 15.00;

-- Query 5: Function - Average discount percentage
SELECT AVG(discount_percentage) AS avg_discount
FROM Promotions;

-- Query 6: Function - Maximum discount percentage
SELECT MAX(discount_percentage) AS max_discount
FROM Promotions;

-- Query 7: Join - Join with Products
SELECT pr.promotion_name,p.product_name
FROM Promotions pr
LEFT JOIN Products p ON pr.product_id = p.product_id;

-- Query 8: Join - Join with Products (count promotions)
SELECT p.product_name,COUNT(pr.promotion_id) AS promo_count
FROM Products p
LEFT JOIN Promotions pr ON p.product_id = pr.product_id
GROUP BY p.product_name;

-- Query 9: Clause with Alias - Group by is_active
SELECT is_active AS ActiveStatus,COUNT(*) AS PromoCount
FROM Promotions
GROUP BY ActiveStatus;

-- Query 10: Clause with Alias - Order by start date
SELECT promotion_name AS Promo,start_date AS StartDate
FROM Promotions
ORDER BY StartDate DESC;


-- Returns Table Queries
-- Query 1: DDL - Add column for return type
ALTER TABLE Returns
ADD return_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of return';

-- Query 2: DML - Update reason to uppercase
UPDATE Returns
SET reason = UPPER(reason)
WHERE refund_amount > 200.00;

-- Query 3: Operator - Select approved returns
SELECT return_id, refund_amount
FROM Returns
WHERE status = 'Approved';

-- Query 4: Operator - Select high-value returns
SELECT return_id, return_date
FROM Returns
WHERE refund_amount > 500.00;

-- Query 5: Function - Sum of refund amounts
SELECT SUM(refund_amount) AS total_refunded
FROM Returns;

-- Query 6: Function - Minimum refund amount
SELECT MIN(refund_amount) AS min_refunded
FROM Returns;

-- Query 7: Join - Join with Orders
SELECT r.return_id,o.order_id
FROM Returns r
LEFT JOIN Orders o ON r.order_id = o.order_id;

-- Query 8: Join - Join with Customers
SELECT r.refund_amount,c.first_name
FROM Returns r
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS ReturnStatus,COUNT(*) AS ReturnCount
FROM Returns
GROUP BY ReturnStatus;

-- Query 10: Clause with Alias - Order by return date
SELECT return_id AS ReturnID,return_date AS ReturnDate
FROM Returns
ORDER BY ReturnDate DESC;




-- Wishlists Table Queries
-- Query 1: DDL - Add column for wishlist type
ALTER TABLE Wishlists
ADD wishlist_type VARCHAR(20) DEFAULT 'Personal' COMMENT 'Type of wishlist';

-- Query 2: DML - Update notes to uppercase
UPDATE Wishlists
SET notes = UPPER(notes)
WHERE quantity > 2;

-- Query 3: Operator - Select active wishlists
SELECT product_id, quantity
FROM Wishlists
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-priority wishlists
SELECT product_id, priority
FROM Wishlists
WHERE priority > 3;

-- Query 5: Function - Average wishlist quantity
SELECT AVG(quantity) AS avg_quantity
FROM Wishlists;

-- Query 6: Function - Maximum wishlist priority
SELECT MAX(priority) AS max_priority
FROM Wishlists;

-- Query 7: Join - Join with Customers
SELECT w.product_id,c.first_name
FROM Wishlists w
LEFT JOIN Customers c ON w.customer_id = c.customer_id;

-- Query 8: Join - Join with Products
SELECT w.quantity,p.product_name
FROM Wishlists w
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by priority
SELECT priority AS PriorityLevel,COUNT(*) AS WishlistCount
FROM Wishlists
GROUP BY PriorityLevel;

-- Query 10: Clause with Alias - Order by added date
SELECT product_id AS ProductID,added_date AS AddedDate
FROM Wishlists
ORDER BY AddedDate DESC;


-- Carts Table Queries
-- Query 1: DDL - Add column for cart status
ALTER TABLE Carts
ADD cart_status VARCHAR(20) DEFAULT 'Open' COMMENT 'Status of cart';

-- Query 2: DML - Update status to uppercase
UPDATE Carts
SET status = UPPER(status)
WHERE total_price > 100.00;

-- Query 3: Operator - Select active carts
SELECT cart_id, total_price
FROM Carts
WHERE is_active = TRUE;

-- Query 4: Operator - Select large carts
SELECT cart_id, quantity
FROM Carts
WHERE quantity > 3;

-- Query 5: Function - Sum of cart total prices
SELECT SUM(total_price) AS total_cart_value
FROM Carts;

-- Query 6: Function - Minimum cart quantity
SELECT MIN(quantity) AS min_quantity
FROM Carts;

-- Query 7: Join - Join with Customers
SELECT ca.cart_id,c.first_name
FROM Carts ca
LEFT JOIN Customers c ON ca.customer_id = c.customer_id;

-- Query 8: Join - Join with Products
SELECT ca.quantity,p.product_name
FROM Carts ca
LEFT JOIN Products p ON ca.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by customer
SELECT customer_id AS CustomerID,SUM(quantity) AS TotalItems
FROM Carts
GROUP BY CustomerID;

-- Query 10: Clause with Alias - Order by total price
SELECT cart_id AS CartID,total_price AS Total
FROM Carts
ORDER BY Total DESC;



-- Employees Table Queries
-- Query 1: DDL - Add column for employee type
ALTER TABLE Employees
ADD employee_type VARCHAR(20) DEFAULT 'Full-Time' COMMENT 'Type of employee';

-- Query 2: DML - Update role to uppercase
UPDATE Employees
SET role = UPPER(role)
WHERE salary > 60000.00;

-- Query 3: Operator - Select active employees
SELECT first_name, role
FROM Employees
WHERE status = 'Active';

-- Query 4: Operator - Select high-salary employees
SELECT first_name, salary
FROM Employees
WHERE salary > 70000.00;

-- Query 5: Function - Average employee salary
SELECT AVG(salary) AS avg_salary
FROM Employees;

-- Query 6: Function - Maximum employee salary
SELECT MAX(salary) AS max_salary
FROM Employees;

-- Query 7: Join - Join with Departments
SELECT e.first_name,d.department_name
FROM Employees e
LEFT JOIN Departments d ON e.department_id = d.department_id;

-- Query 8: Join - Join with Departments (count employees)
SELECT d.department_name,COUNT(e.employee_id) AS emp_count
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Query 9: Clause with Alias - Group by role
SELECT role AS Role,COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Role;

-- Query 10: Clause with Alias - Order by hire date
SELECT first_name AS Name,hire_date AS HireDate
FROM Employees
ORDER BY HireDate ASC;


-- Departments Table Queries
-- Query 1: DDL - Add column for department type
ALTER TABLE Departments
ADD dept_type VARCHAR(20) DEFAULT 'Operational' COMMENT 'Type of department';

-- Query 2: DML - Update department_name to uppercase
UPDATE Departments
SET department_name = UPPER(department_name)
WHERE budget > 200000.00;

-- Query 3: Operator - Select active departments
SELECT department_name, budget
FROM Departments
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-budget departments
SELECT department_name, budget
FROM Departments
WHERE budget > 250000.00;

-- Query 5: Function - Total department budget
SELECT SUM(budget) AS total_budget
FROM Departments;

-- Query 6: Function - Minimum department budget
SELECT MIN(budget) AS min_budget
FROM Departments;

-- Query 7: Join - Join with Employees
SELECT d.department_name,e.first_name
FROM Departments d
LEFT JOIN Employees e ON d.manager_id = e.employee_id;

-- Query 8: Join - Join with Employees (count)
SELECT d.department_name,e.employee_id AS emp_count
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- Query 9: Clause with Alias - Group by location
SELECT location AS Location,COUNT(*) AS DeptCount
FROM Departments
GROUP BY Location;

-- Query 10: Clause with Alias - Order by budget
SELECT department_name AS Dept,budget AS Budget
FROM Departments
ORDER BY Budget DESC;



-- Transactions Table Queries
-- Query 1: DDL - Add column for transaction type
ALTER TABLE Transactions
ADD transaction_type VARCHAR(20) DEFAULT 'Sale' COMMENT 'Type of transaction';

-- Query 2: DML - Update status to uppercase
UPDATE Transactions
SET status = UPPER(status)
WHERE amount > 300.00;

-- Query 3: Operator - Select successful transactions
SELECT transaction_id, amount
FROM Transactions
WHERE status = 'Success';

-- Query 4: Operator - Select high-value transactions
SELECT transaction_id, transaction_date
FROM Transactions
WHERE amount > 500.00;

-- Query 5: Function - Sum of transaction amounts
SELECT SUM(amount) AS total_transactions
FROM Transactions;

-- Query 6: Function - Minimum transaction amount
SELECT MIN(amount) AS min_transaction
FROM Transactions;

-- Query 7: Join - Join with Payments
SELECT t.transaction_id,p.payment_method
FROM Transactions t
LEFT JOIN Payments p ON t.payment_id = p.payment_id;

-- Query 8: Join - Join with Customers
SELECT t.amount,c.first_name
FROM Transactions t
LEFT JOIN Customers c ON t.customer_id = c.customer_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS TransStatus,COUNT(*) AS TransCount
FROM Transactions
GROUP BY TransStatus;

-- Query 10: Clause with Alias - Order by transaction date
SELECT transaction_id AS TransID,transaction_date AS TransDate
FROM Transactions
ORDER BY TransDate DESC;



-- Discounts Table Queries
-- Query 1: DDL - Add column for discount type
ALTER TABLE Discounts
ADD discount_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of discount';

-- Query 2: DML - Update discount_code to uppercase
UPDATE Discounts
SET discount_code = UPPER(discount_code)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active discounts
SELECT discount_code, percentage
FROM Discounts
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-percentage discounts
SELECT discount_code, percentage
FROM Discounts
WHERE percentage > 15.00;

-- Query 5: Function - Average discount percentage
SELECT AVG(percentage) AS avg_discount
FROM Discounts;

-- Query 6: Function - Maximum discount percentage
SELECT MAX(percentage) AS max_discount
FROM Discounts;

-- Query 7: Join - Join with Products
SELECT d.discount_code,p.product_name
FROM Discounts d
LEFT JOIN Products p ON d.product_id = p.product_id;

-- Query 8: Join - Join with Products (count discounts)
SELECT p.product_name,COUNT(d.discount_id) AS discount_count
FROM Products p
LEFT JOIN Discounts d ON p.product_id = d.product_id
GROUP BY p.product_name;

-- Query 9: Clause with Alias - Group by is_active
SELECT is_active AS ActiveStatus,COUNT(*) AS DiscountCount
FROM Discounts
GROUP BY ActiveStatus;

-- Query 10: Clause with Alias - Order by start date
SELECT discount_code AS Code,start_date AS StartDate
FROM Discounts
ORDER BY StartDate DESC;


-- Taxes Table Queries
-- Query 1: DDL - Add column for tax category
ALTER TABLE Taxes
ADD tax_category VARCHAR(20) DEFAULT 'Standard' COMMENT 'Category of tax';

-- Query 2: DML - Update tax_type to uppercase
UPDATE Taxes
SET tax_type = UPPER(tax_type)
WHERE tax_amount > 20.00;

-- Query 3: Operator - Select applied taxes
SELECT tax_id, tax_amount
FROM Taxes
WHERE status = 'Applied';

-- Query 4: Operator - Select high-rate taxes
SELECT tax_id, tax_rate
FROM Taxes
WHERE tax_rate > 7.50;

-- Query 5: Function - Sum of tax amounts
SELECT SUM(tax_amount) AS total_tax
FROM Taxes;

-- Query 6: Function - Minimum tax rate
SELECT MIN(tax_rate) AS min_tax_rate
FROM Taxes;

-- Query 7: Join - Join with Orders
SELECT t.tax_id,o.order_id
FROM Taxes t
LEFT JOIN Orders o ON t.order_id = o.order_id;

-- Query 8: Join - Join with Products
SELECT t.tax_amount,p.product_name
FROM Taxes t
LEFT JOIN Products p ON t.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by region
SELECT region,SUM(tax_amount) AS TotalTax
FROM Taxes
GROUP BY Region;

-- Query 10: Clause with Alias - Order by tax date
SELECT tax_id,tax_date AS TaxDate
FROM Taxes
ORDER BY TaxDate DESC;



-- Addresses Table Queries
-- Query 1: DDL - Add column for address status
ALTER TABLE Addresses
ADD address_status VARCHAR(20) DEFAULT 'Valid' COMMENT 'Status of address';

-- Query 2: DML - Update street to uppercase
UPDATE Addresses
SET street = UPPER(street)
WHERE is_default = TRUE;

-- Query 3: Operator - Select billing addresses
SELECT street, city
FROM Addresses
WHERE address_type = 'Billing';

-- Query 4: Operator - Select default addresses
SELECT street, state
FROM Addresses
WHERE is_default = TRUE;

-- Query 5: Function - Count addresses
SELECT COUNT(*) AS total_addresses
FROM Addresses;

-- Query 6: Function - Count addresses by state
SELECT state, 
       COUNT(*) AS address_count
FROM Addresses
GROUP BY state;

-- Query 7: Join - Join with Customers
SELECT a.street,c.first_name
FROM Addresses a
LEFT JOIN Customers c ON a.customer_id = c.customer_id;

-- Query 8: Join - Join with Orders
SELECT a.city,o.order_id
FROM Addresses a
LEFT JOIN Orders o ON a.customer_id = o.customer_id;

-- Query 9: Clause with Alias - Group by address type
SELECT address_type,COUNT(*) AS AddressCount
FROM Addresses
GROUP BY Type;

-- Query 10: Clause with Alias - Order by city
SELECT street,city
FROM Addresses
ORDER BY City ASC;


-- Subscriptions Table Queries
-- Query 1: DDL - Add column for subscription type
ALTER TABLE Subscriptions
ADD sub_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of subscription';

-- Query 2: DML - Update plan_name to uppercase
UPDATE Subscriptions
SET plan_name = UPPER(plan_name)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active subscriptions
SELECT plan_name, amount
FROM Subscriptions
WHERE is_active = TRUE;

-- Query 4: Operator - Select annual subscriptions
SELECT plan_name, billing_cycle
FROM Subscriptions
WHERE billing_cycle = 'Annual';

-- Query 5: Function - Average subscription amount
SELECT AVG(amount) AS avg_subscription
FROM Subscriptions;

-- Query 6: Function - Maximum subscription amount
SELECT MAX(amount) AS max_subscription
FROM Subscriptions;

-- Query 7: Join - Join with Customers
SELECT s.plan_name,c.first_name
FROM Subscriptions s
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 8: Join - Join with Customers (count subscriptions)
SELECT c.first_name,s.subscription_id AS sub_count
FROM Customers c
LEFT JOIN Subscriptions s ON c.customer_id = s.customer_id
GROUP BY c.first_name;

-- Query 9: Clause with Alias - Group by plan name
SELECT plan_name AS Plan,COUNT(*) AS SubCount
FROM Subscriptions
GROUP BY Plan;

-- Query 10: Clause with Alias - Order by start date
SELECT plan_name,start_date
FROM Subscriptions
ORDER BY StartDate DESC;




-- GiftCards Table Queries
-- Query 1: DDL - Add column for card type
ALTER TABLE GiftCards
ADD card_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of gift card';

-- Query 2: DML - Update status to uppercase
UPDATE GiftCards
SET status = UPPER(status)
WHERE balance > 50.00;

-- Query 3: Operator - Select active gift cards
SELECT card_number, balance
FROM GiftCards
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-balance gift cards
SELECT card_number, balance
FROM GiftCards
WHERE balance > 75.00;

-- Query 5: Function - Sum of gift card balances
SELECT SUM(balance) AS total_balance
FROM GiftCards;

-- Query 6: Function - Minimum gift card balance
SELECT MIN(balance) AS min_balance
FROM GiftCards;

-- Query 7: Join - Join with Customers
SELECT g.card_number,c.first_name
FROM GiftCards g
LEFT JOIN Customers c ON g.customer_id = c.customer_id;

-- Query 8: Join - Join with Orders
SELECT g.balance,o.order_id
FROM GiftCards g
LEFT JOIN Orders o ON g.order_id = o.order_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS CardStatus,COUNT(*) AS CardCount
FROM GiftCards
GROUP BY CardStatus;

-- Query 10: Clause with Alias - Order by issue date
SELECT card_number,issue_date
FROM GiftCards
ORDER BY IssueDate DESC;



-- Coupons Table Queries
-- Query 1: DDL - Add column for coupon type
ALTER TABLE Coupons
ADD coupon_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of coupon';

-- Query 2: DML - Update coupon_code to uppercase
UPDATE Coupons
SET coupon_code = UPPER(coupon_code)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active coupons
SELECT coupon_code, discount_amount
FROM Coupons
WHERE is_active = TRUE;

-- Query 4: Operator - Select high-discount coupons
SELECT coupon_code, discount_amount
FROM Coupons
WHERE discount_amount > 20.00;

-- Query 5: Function - Sum of coupon discounts
SELECT SUM(discount_amount) AS total_discount
FROM Coupons;

-- Query 6: Function - Maximum coupon discount
SELECT MAX(discount_amount) AS max_discount
FROM Coupons;

-- Query 7: Join - Join with Orders
SELECT co.coupon_code,o.order_id
FROM Coupons co
LEFT JOIN Orders o ON co.order_id = o.order_id;

-- Query 8: Join - Join with Orders (sum discounts)
SELECT o.order_id,SUM(co.discount_amount) AS total_discount
FROM Orders o
LEFT JOIN Coupons co ON o.order_id = co.order_id
GROUP BY o.order_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS CouponStatus,COUNT(*) AS CouponCount
FROM Coupons
GROUP BY CouponStatus;

-- Query 10: Clause with Alias - Order by issue date
SELECT coupon_code,issue_date
FROM Coupons
ORDER BY IssueDate DESC;




-- Feedback Table Queries
-- Query 1: DDL - Add column for feedback type
ALTER TABLE Feedback
ADD feedback_type VARCHAR(20) DEFAULT 'Standard' COMMENT 'Type of feedback';

-- Query 2: DML - Update comment to uppercase
UPDATE Feedback
SET comment = UPPER(comment)
WHERE rating > 4;

-- Query 3: Operator - Select high-rated feedback
SELECT comment, rating
FROM Feedback
WHERE rating >= 4;

-- Query 4: Operator - Select non-anonymous feedback
SELECT comment, feedback_date
FROM Feedback
WHERE is_anonymous = FALSE;

-- Query 5: Function - Average feedback rating
SELECT AVG(rating) AS avg_rating
FROM Feedback;

-- Query 6: Function - Maximum feedback rating
SELECT MAX(rating) AS max_rating
FROM Feedback;

-- Query 7: Join - Join with Customers
SELECT f.comment,c.first_name
FROM Feedback f
LEFT JOIN Customers c ON f.customer_id = c.customer_id;

-- Query 8: Join - Join with Orders
SELECT f.rating,o.order_id
FROM Feedback f
LEFT JOIN Orders o ON f.order_id = o.order_id;

-- Query 9: Clause with Alias - Group by category
SELECT category,COUNT(*) AS FeedbackCount
FROM Feedback
GROUP BY Category;

-- Query 10: Clause with Alias - Order by feedback date
SELECT comment,feedback_date
FROM Feedback
ORDER BY FeedbackDate DESC;



-- Logs Table Queries
-- Query 1: DDL - Add column for log type
ALTER TABLE Logs
ADD log_type VARCHAR(20) DEFAULT 'System' COMMENT 'Type of log';

-- Query 2: DML - Update action to uppercase
UPDATE Logs
SET action = UPPER(action)
WHERE status = 'Success';

-- Query 3: Operator - Select successful logs
SELECT log_id, action
FROM Logs
WHERE status = 'Success';

-- Query 4: Operator - Select recent logs
SELECT log_id, log_date
FROM Logs
WHERE log_date > '2024-01-01';

-- Query 5: Function - Count logs
SELECT COUNT(*) AS total_logs
FROM Logs;

-- Query 6: Function - Earliest log date
SELECT MIN(log_date) AS earliest_log
FROM Logs;

-- Query 7: Join - Join with Employees
SELECT l.action,e.first_name
FROM Logs l
LEFT JOIN Employees e ON l.user_id = e.employee_id;

-- Query 8: Join - Join with Employees (count logs)
SELECT e.first_name,COUNT(l.log_id) AS log_count
FROM Employees e
LEFT JOIN Logs l ON e.employee_id = l.user_id
GROUP BY e.first_name;

-- Query 9: Clause with Alias - Group by category
SELECT category,COUNT(*) AS LogCount
FROM Logs
GROUP BY LogCategory;

-- Query 10: Clause with Alias - Order by log date
SELECT action,log_date
FROM Logs
ORDER BY LogDate DESC;

