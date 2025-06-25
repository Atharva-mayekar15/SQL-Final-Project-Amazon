-- Project Phase-3 (A<Joins<SQ<Fun<B&UD)

-- Table 1: Products Table Queries
-- Query 1: JOIN - Products with Categories and Suppliers
SELECT p.product_id, p.product_name, c.category_name, s.supplier_name, p.price
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE
LIMIT 5;

-- Query 2: JOIN - Products with Orders and Customers
SELECT p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_date, o.quantity
FROM Products p
INNER JOIN Orders o ON p.product_id = o.product_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
LIMIT 5;

-- Query 3: JOIN - Products with Reviews and Customers
SELECT p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS reviewer, r.rating, r.comment
FROM Products p
INNER JOIN Reviews r ON p.product_id = r.product_id
INNER JOIN Customers c ON r.customer_id = c.customer_id
WHERE r.is_verified = TRUE
LIMIT 5;

-- Query 4: JOIN - Products with Inventory and Warehouses
SELECT p.product_name, w.warehouse_name, i.quantity, i.status
FROM Products p
INNER JOIN Inventory i ON p.product_id = i.product_id
INNER JOIN Warehouses w ON i.warehouse_id = w.warehouse_id
WHERE i.quantity < i.min_stock_level
LIMIT 5;

-- Query 5: JOIN - Products with Promotions and Discounts
SELECT p.product_name, pr.promotion_name, d.discount_percentage, p.price
FROM Products p
INNER JOIN Promotions pr ON p.product_id = pr.product_id
INNER JOIN Discounts d ON p.product_id = d.product_id
WHERE pr.is_active = TRUE AND d.is_active = TRUE
LIMIT 5;

-- Query 6: Subquery - Products with above-average price
SELECT product_id, product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
LIMIT 5;

-- Query 7: Subquery - Products with recent reviews
SELECT p.product_name, 
       (SELECT COUNT(*) FROM Reviews r WHERE r.product_id = p.product_id AND r.review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS review_count
FROM Products p
WHERE (SELECT COUNT(*) FROM Reviews r WHERE r.product_id = p.product_id AND r.review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Products in stock at multiple warehouses
SELECT p.product_name, 
       (SELECT COUNT(*) FROM Inventory i WHERE i.product_id = p.product_id AND i.quantity > 0) AS warehouse_count
FROM Products p
WHERE (SELECT COUNT(*) FROM Inventory i WHERE i.product_id = p.product_id AND i.quantity > 0) >= 2
LIMIT 5;

-- Query 9: Subquery - Products with no orders
SELECT product_id, product_name
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM Orders)
LIMIT 5;

-- Query 10: Subquery - Products with high ratings
SELECT p.product_name, 
       (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = p.product_id) AS avg_rating
FROM Products p
WHERE (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = p.product_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Product name length
SELECT product_name, LENGTH(product_name) AS name_length
FROM Products
WHERE LENGTH(product_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Formatted release date
SELECT product_name, DATE_FORMAT(release_date, '%M %d, %Y') AS formatted_date
FROM Products
WHERE release_date IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Rounded price
SELECT product_name, ROUND(price) AS rounded_price
FROM Products
WHERE price > 100
LIMIT 5;

-- Query 14: Built-in Function - Uppercase product name
SELECT UPPER(product_name) AS uppercase_name
FROM Products
LIMIT 5;

-- Query 15: Built-in Function - Stock quantity status
SELECT product_name, 
       CASE 
           WHEN stock_quantity < 50 THEN 'Low'
           WHEN stock_quantity BETWEEN 50 AND 100 THEN 'Medium'
           ELSE 'High'
       END AS stock_status
FROM Products
LIMIT 5;

-- Query 16: User-Defined Function - Calculate discounted price
DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount_percentage DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (1 - discount_percentage / 100);
END //
DELIMITER ;
SELECT product_name, price, GetDiscountedPrice(price, 10.00) AS discounted_price
FROM Products
WHERE price > 50
LIMIT 5;

-- Query 17: User-Defined Function - Get stock status
DELIMITER //
CREATE FUNCTION GetStockStatus(quantity INT, min_level INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF quantity < min_level THEN
        RETURN 'Low Stock';
    ELSE
        RETURN 'In Stock';
    END IF;
END //
DELIMITER ;
SELECT product_name, stock_quantity, GetStockStatus(stock_quantity, 50) AS stock_status
FROM Products
LIMIT 5;

-- Query 18: User-Defined Function - Format product name
DELIMITER //
CREATE FUNCTION FormatProductName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT product_name, FormatProductName(product_name) AS formatted_name
FROM Products
LIMIT 5;

-- Query 19: User-Defined Function - Calculate tax amount
DELIMITER //
CREATE FUNCTION CalculateTaxAmount(price DECIMAL(10,2), tax_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (tax_rate / 100);
END //
DELIMITER ;
SELECT product_name, price, CalculateTaxAmount(price, 8.00) AS tax_amount
FROM Products
WHERE price > 50
LIMIT 5;

-- Query 20: User-Defined Function - Calculate product age
DELIMITER //
CREATE FUNCTION GetProductAge(release_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), release_date);
END //
DELIMITER ;
SELECT product_name, release_date, GetProductAge(release_date) AS product_age_in_days
FROM Products
WHERE release_date IS NOT NULL
LIMIT 5;

-- Table 2: Customers Table Queries
-- Query 1: JOIN - Customers with Orders and Payments
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, o.order_id, p.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Payments p ON o.order_id = p.order_id
WHERE p.status = 'Completed'
LIMIT 5;

-- Query 2: JOIN - Customers with Reviews and Products
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, p.product_name, r.rating
FROM Customers c
INNER JOIN Reviews r ON c.customer_id = r.customer_id
INNER JOIN Products p ON r.product_id = p.product_id
WHERE r.is_verified = TRUE
LIMIT 5;

-- Query 3: JOIN - Customers with Wishlists and Products
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, p.product_name
FROM Customers c
INNER JOIN Wishlists w ON c.customer_id = w.customer_id
INNER JOIN Products p ON w.product_id = p.product_id
LIMIT 5;

-- Query 4: JOIN - Customers with Addresses and Orders
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, a.street, o.order_id
FROM Customers c
INNER JOIN Addresses a ON c.customer_id = a.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
WHERE a.is_default = TRUE
LIMIT 5;

-- Query 5: JOIN - Customers with Subscriptions and Payments
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, s.subscription_type, p.amount
FROM Customers c
INNER JOIN Subscriptions s ON c.customer_id = s.customer_id
INNER JOIN Payments p ON s.subscription_id = p.subscription_id
WHERE s.is_active = TRUE
LIMIT 5;

-- Query 6: Subquery - Customers with multiple orders
SELECT customer_id, first_name, last_name
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Orders GROUP BY customer_id HAVING COUNT(*) > 1)
LIMIT 5;

-- Query 7: Subquery - Customers with recent reviews
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       (SELECT COUNT(*) FROM Reviews r WHERE r.customer_id = c.customer_id AND r.review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS review_count
FROM Customers c
WHERE (SELECT COUNT(*) FROM Reviews r WHERE r.customer_id = c.customer_id AND r.review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Customers with high order totals
SELECT customer_id, first_name, last_name,
       (SELECT SUM(total_price) FROM Orders o WHERE o.customer_id = c.customer_id) AS total_spent
FROM Customers c
WHERE (SELECT SUM(total_price) FROM Orders o WHERE o.customer_id = c.customer_id) > 1000
LIMIT 5;

-- Query 9: Subquery - Customers with no returns
SELECT customer_id, first_name, last_name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Returns)
LIMIT 5;

-- Query 10: Subquery - Customers with active subscriptions
SELECT customer_id, first_name, last_name
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Subscriptions WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Customer name length
SELECT first_name, last_name, LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length
FROM Customers
WHERE LENGTH(CONCAT(first_name, ' ', last_name)) > 15
LIMIT 5;

-- Query 12: Built-in Function - Formatted registration date
SELECT first_name, last_name, DATE_FORMAT(registration_date, '%M %d, %Y') AS reg_date
FROM Customers
WHERE registration_date IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase email
SELECT first_name, last_name, UPPER(email) AS uppercase_email
FROM Customers
LIMIT 5;

-- Query 14: Built-in Function - Customer status
SELECT first_name, last_name,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Customers
LIMIT 5;

-- Query 15: Built-in Function - Email domain
SELECT first_name, last_name, SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM Customers
LIMIT 5;

-- Query 16: User-Defined Function - Get full name
DELIMITER //
CREATE FUNCTION GetFullName(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END //
DELIMITER ;
SELECT customer_id, GetFullName(first_name, last_name) AS full_name
FROM Customers
LIMIT 5;

-- Query 17: User-Defined Function - Get customer tenure
DELIMITER //
CREATE FUNCTION GetCustomerTenure(reg_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), reg_date);
END //
DELIMITER ;
SELECT first_name, last_name, GetCustomerTenure(registration_date) AS tenure_days
FROM Customers
WHERE registration_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get email domain
DELIMITER //
CREATE FUNCTION GetEmailDomain(email VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN SUBSTRING_INDEX(email, '@', -1);
END //
DELIMITER ;
SELECT first_name, last_name, GetEmailDomain(email) AS email_domain
FROM Customers
LIMIT 5;

-- Query 19: User-Defined Function - Get total spent
DELIMITER //
CREATE FUNCTION GetTotalSpent(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(total_price), 0) FROM Orders WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT customer_id, first_name, last_name, GetTotalSpent(customer_id) AS total_spent
FROM Customers
LIMIT 5;

-- Query 20: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetOrderCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT customer_id, first_name, last_name, GetOrderCount(customer_id) AS order_count
FROM Customers
LIMIT 5;

-- Table 3: Orders Table Queries
-- Query 1: JOIN - Orders with Customers and Products
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name, o.total_price
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Products p ON o.product_id = p.product_id
WHERE o.status = 'Delivered'
LIMIT 5;

-- Query 2: JOIN - Orders with Payments and Shipments
SELECT o.order_id, p.amount, s.carrier, s.tracking_number
FROM Orders o
INNER JOIN Payments p ON o.order_id = p.order_id
INNER JOIN Shipments s ON o.order_id = s.order_id
WHERE p.status = 'Completed'
LIMIT 5;

-- Query 3: JOIN - Orders with Returns and Customers
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, r.reason
FROM Orders o
INNER JOIN Returns r ON o.order_id = r.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 4: JOIN - Orders with Addresses and Customers
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, a.street
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Addresses a ON o.shipping_address_id = a.address_id
LIMIT 5;

-- Query 5: JOIN - Orders with Discounts and Products
SELECT o.order_id, p.product_name, d.discount_percentage
FROM Orders o
INNER JOIN Products p ON o.product_id = p.product_id
INNER JOIN Discounts d ON p.product_id = d.product_id
WHERE d.is_active = TRUE
LIMIT 5;

-- Query 6: Subquery - Orders with high total price
SELECT order_id, customer_id, total_price
FROM Orders
WHERE total_price > (SELECT AVG(total_price) FROM Orders)
LIMIT 5;

-- Query 7: Subquery - Orders with recent shipments
SELECT order_id, order_date,
       (SELECT COUNT(*) FROM Shipments s WHERE s.order_id = o.order_id AND s.ship_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS shipment_count
FROM Orders o
WHERE (SELECT COUNT(*) FROM Shipments s WHERE s.order_id = o.order_id AND s.ship_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Orders with no returns
SELECT order_id, customer_id
FROM Orders
WHERE order_id NOT IN (SELECT order_id FROM Returns)
LIMIT 5;

-- Query 9: Subquery - Orders with high quantity
SELECT order_id, product_id, quantity
FROM Orders
WHERE quantity > (SELECT AVG(quantity) FROM Orders)
LIMIT 5;

-- Query 10: Subquery - Orders with completed payments
SELECT order_id, customer_id
FROM Orders
WHERE order_id IN (SELECT order_id FROM Payments WHERE status = 'Completed')
LIMIT 5;

-- Query 11: Built-in Function - Order date formatting
SELECT order_id, DATE_FORMAT(order_date, '%M %d, %Y') AS formatted_date
FROM Orders
WHERE order_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded total price
SELECT order_id, ROUND(total_price) AS rounded_price
FROM Orders
WHERE total_price > 100
LIMIT 5;

-- Query 13: Built-in Function - Uppercase status
SELECT order_id, UPPER(status) AS uppercase_status
FROM Orders
LIMIT 5;

-- Query 14: Built-in Function - Order status categorization
SELECT order_id,
       CASE 
           WHEN status = 'Delivered' THEN 'Complete'
           WHEN status = 'Pending' THEN 'In Progress'
           ELSE 'Other'
       END AS order_status
FROM Orders
LIMIT 5;

-- Query 15: Built-in Function - Order price length
SELECT order_id, LENGTH(CAST(total_price AS CHAR)) AS price_length
FROM Orders
LIMIT 5;

-- Query 16: User-Defined Function - Calculate order tax
DELIMITER //
CREATE FUNCTION CalculateOrderTax(total_price DECIMAL(10,2), tax_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN total_price * (tax_rate / 100);
END //
DELIMITER ;
SELECT order_id, total_price, CalculateOrderTax(total_price, 8.00) AS tax_amount
FROM Orders
WHERE total_price > 50
LIMIT 5;

-- Query 17: User-Defined Function - Format order status
DELIMITER //
CREATE FUNCTION FormatOrderStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(status, 1)), LOWER(SUBSTRING(status, 2)));
END //
DELIMITER ;
SELECT order_id, status, FormatOrderStatus(status) AS formatted_status
FROM Orders
LIMIT 5;

-- Query 18: User-Defined Function - Get shipping days
DELIMITER //
CREATE FUNCTION GetShippingDays(order_date DATE, delivery_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(delivery_date, order_date);
END //
DELIMITER ;
SELECT order_id, order_date, delivery_date, GetShippingDays(order_date, delivery_date) AS shipping_days
FROM Orders
WHERE delivery_date IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get payment status
DELIMITER //
CREATE FUNCTION GetPaymentStatus(order_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN (SELECT status FROM Payments WHERE Payments.order_id = Orders.order_id LIMIT 1);
END //
DELIMITER ;
SELECT order_id, GetPaymentStatus(order_id) AS payment_status
FROM Orders
LIMIT 5;

-- Query 20: User-Defined Function - Estimate delivery date
DELIMITER //
CREATE FUNCTION EstimateDeliveryDate(order_date DATE)
RETURNS DATE
DETERMINISTIC
BEGIN
    RETURN DATE_ADD(order_date, INTERVAL 7 DAY);
END //
DELIMITER ;
SELECT order_id, order_date, EstimateDeliveryDate(order_date) AS estimated_delivery
FROM Orders
LIMIT 5;

-- Table 4: Suppliers Table Queries
-- Query 1: JOIN - Suppliers with Products and Categories
SELECT s.supplier_id, s.supplier_name, p.product_name, c.category_name
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 2: JOIN - Suppliers with Inventory and Warehouses
SELECT s.supplier_name, w.warehouse_name, i.quantity
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id
INNER JOIN Inventory i ON p.product_id = i.product_id
INNER JOIN Warehouses w ON i.warehouse_id = w.warehouse_id
LIMIT 5;

-- Query 3: JOIN - Suppliers with Orders and Products
SELECT s.supplier_id, s.supplier_name, o.order_id, p.product_name
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 4: JOIN - Suppliers with Promotions and Products
SELECT s.supplier_name, pr.promotion_name, p.product_name
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id
INNER JOIN Promotions pr ON p.product_id = pr.product_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 5: JOIN - Suppliers with Discounts and Products
SELECT s.supplier_name, d.discount_percentage, p.product_name
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id
INNER JOIN Discounts d ON p.product_id = d.product_id
WHERE d.is_active = TRUE
LIMIT 5;

-- Query 6: Subquery - Suppliers with multiple products
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE supplier_id IN (SELECT supplier_id FROM Products GROUP BY supplier_id HAVING COUNT(*) > 1)
LIMIT 5;

-- Query 7: Subquery - Suppliers with recent orders
SELECT supplier_id, supplier_name,
       (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.supplier_id = s.supplier_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Suppliers s
WHERE (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.supplier_id = s.supplier_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Suppliers with high-value products
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE supplier_id IN (SELECT supplier_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Suppliers with no returns
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE supplier_id NOT IN (SELECT p.supplier_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id JOIN Products p ON o.product_id = p.product_id)
LIMIT 5;

-- Query 10: Subquery - Suppliers with active products
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE supplier_id IN (SELECT supplier_id FROM Products WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Supplier name length
SELECT supplier_name, LENGTH(supplier_name) AS name_length
FROM Suppliers
WHERE LENGTH(supplier_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Uppercase supplier name
SELECT UPPER(supplier_name) AS uppercase_name
FROM Suppliers
LIMIT 5;

-- Query 13: Built-in Function - Contact email domain
SELECT supplier_name, SUBSTRING_INDEX(contact_email, '@', -1) AS email_domain
FROM Suppliers
LIMIT 5;

-- Query 14: Built-in Function - Supplier status
SELECT supplier_name,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Suppliers
LIMIT 5;

-- Query 15: Built-in Function - Formatted contact phone
SELECT supplier_name, REPLACE(contact_phone, '-', '') AS formatted_phone
FROM Suppliers
LIMIT 5;

-- Query 16: User-Defined Function - Format supplier name
DELIMITER //
CREATE FUNCTION FormatSupplierName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT supplier_name, FormatSupplierName(supplier_name) AS formatted_name
FROM Suppliers
LIMIT 5;

-- Query 17: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetProductCount(supp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Products WHERE supplier_id = supp_id);
END //
DELIMITER ;
SELECT supplier_id, supplier_name, GetProductCount(supplier_id) AS product_count
FROM Suppliers
LIMIT 5;

-- Query 18: User-Defined Function - Get email domain
DELIMITER //
CREATE FUNCTION GetSupplierEmailDomain(email VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN SUBSTRING_INDEX(email, '@', -1);
END //
DELIMITER ;
SELECT supplier_name, GetSupplierEmailDomain(contact_email) AS email_domain
FROM Suppliers
LIMIT 5;

-- Query 19: User-Defined Function - Get total product value
DELIMITER //
CREATE FUNCTION GetTotalProductValue(supp_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(price), 0) FROM Products WHERE supplier_id = supp_id);
END //
DELIMITER ;
SELECT supplier_id, supplier_name, GetTotalProductValue(supplier_id) AS total_value
FROM Suppliers
LIMIT 5;

-- Query 20: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetSupplierOrderCount(supp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.supplier_id = supp_id);
END //
DELIMITER ;
SELECT supplier_id, supplier_name, GetSupplierOrderCount(supplier_id) AS order_count
FROM Suppliers
LIMIT 5;

-- Table 5: Categories Table Queries
-- Query 1: JOIN - Categories with Products and Suppliers
SELECT c.category_id, c.category_name, p.product_name, s.supplier_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 2: JOIN - Categories with Promotions and Products
SELECT c.category_name, pr.promotion_name, p.product_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Promotions pr ON p.product_id = pr.product_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 3: JOIN - Categories with Orders and Products
SELECT c.category_name, o.order_id, p.product_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 4: JOIN - Categories with Discounts and Products
SELECT c.category_name, d.discount_percentage, p.product_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Discounts d ON p.product_id = d.product_id
WHERE d.is_active = TRUE
LIMIT 5;

-- Query 5: JOIN - Categories with Reviews and Products
SELECT c.category_name, r.rating, p.product_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id
INNER JOIN Reviews r ON p.product_id = r.product_id
WHERE r.is_verified = TRUE
LIMIT 5;

-- Query 6: Subquery - Categories with multiple products
SELECT category_id, category_name
FROM Categories
WHERE category_id IN (SELECT category_id FROM Products GROUP BY category_id HAVING COUNT(*) > 1)
LIMIT 5;

-- Query 7: Subquery - Categories with high-priced products
SELECT category_id, category_name
FROM Categories
WHERE category_id IN (SELECT category_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 8: Subquery - Categories with recent orders
SELECT category_name,
       (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.category_id = c.category_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Categories c
WHERE (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.category_id = c.category_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 9: Subquery - Categories with no returns
SELECT category_id, category_name
FROM Categories
WHERE category_id NOT IN (SELECT p.category_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id JOIN Products p ON o.product_id = p.product_id)
LIMIT 5;

-- Query 10: Subquery - Categories with high-rated products
SELECT category_name,
       (SELECT AVG(rating) FROM Reviews r JOIN Products p ON r.product_id = p.product_id WHERE p.category_id = c.category_id) AS avg_rating
FROM Categories c
WHERE (SELECT AVG(rating) FROM Reviews r JOIN Products p ON r.product_id = p.product_id WHERE p.category_id = c.category_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Category name length
SELECT category_name, LENGTH(category_name) AS name_length
FROM Categories
WHERE LENGTH(category_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Uppercase category name
SELECT UPPER(category_name) AS uppercase_name
FROM Categories
LIMIT 5;

-- Query 13: Built-in Function - Description length
SELECT category_name, LENGTH(description) AS desc_length
FROM Categories
WHERE description IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Category status
SELECT category_name,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Categories
LIMIT 5;

-- Query 15: Built-in Function - Formatted parent category
SELECT category_name, COALESCE(CAST(parent_category_id AS CHAR), 'None') AS parent_category
FROM Categories
LIMIT 5;

-- Query 16: User-Defined Function - Format category name
DELIMITER //
CREATE FUNCTION FormatCategoryName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT category_name, FormatCategoryName(category_name) AS formatted_name
FROM Categories
LIMIT 5;

-- Query 17: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetCategoryProductCount(cat_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Products WHERE category_id = cat_id);
END //
DELIMITER ;
SELECT category_id, category_name, GetCategoryProductCount(category_id) AS product_count
FROM Categories
LIMIT 5;

-- Query 18: User-Defined Function - Get average product price
DELIMITER //
CREATE FUNCTION GetAvgProductPrice(cat_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(AVG(price), 0) FROM Products WHERE category_id = cat_id);
END //
DELIMITER ;
SELECT category_id, category_name, GetAvgProductPrice(category_id) AS avg_price
FROM Categories
LIMIT 5;

-- Query 19: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetCategoryOrderCount(cat_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.category_id = cat_id);
END //
DELIMITER ;
SELECT category_id, category_name, GetCategoryOrderCount(category_id) AS order_count
FROM Categories
LIMIT 5;

-- Query 20: User-Defined Function - Get review count
DELIMITER //
CREATE FUNCTION GetCategoryReviewCount(cat_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Reviews r JOIN Products p ON r.product_id = p.product_id WHERE p.category_id = cat_id);
END //
DELIMITER ;
SELECT category_id, category_name, GetCategoryReviewCount(category_id) AS review_count
FROM Categories
LIMIT 5;

-- Table 6: Reviews Table Queries
-- Query 1: JOIN - Reviews with Products and Customers
SELECT r.review_id, p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, r.rating
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id
INNER JOIN Customers c ON r.customer_id = c.customer_id
WHERE r.is_verified = TRUE
LIMIT 5;

-- Query 2: JOIN - Reviews with Orders and Customers
SELECT r.review_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Reviews r
INNER JOIN Orders o ON r.customer_id = o.customer_id
INNER JOIN Customers c ON r.customer_id = c.customer_id
LIMIT 5;

-- Query 3: JOIN - Reviews with Products and Categories
SELECT r.review_id, p.product_name, c.category_name, r.rating
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 4: JOIN - Reviews with Customers and Wishlists
SELECT r.review_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, w.product_id
FROM Reviews r
INNER JOIN Customers c ON r.customer_id = c.customer_id
INNER JOIN Wishlists w ON c.customer_id = w.customer_id
LIMIT 5;

-- Query 5: JOIN - Reviews with Products and Suppliers
SELECT r.review_id, p.product_name, s.supplier_name, r.rating
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 6: Subquery - Reviews with high ratings
SELECT review_id, product_id, rating
FROM Reviews
WHERE rating > (SELECT AVG(rating) FROM Reviews)
LIMIT 5;

-- Query 7: Subquery - Recent reviews
SELECT review_id, product_id,
       (SELECT COUNT(*) FROM Reviews r2 WHERE r2.product_id = r.product_id AND r2.review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS recent_count
FROM Reviews r
WHERE review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Reviews by verified customers
SELECT review_id, customer_id
FROM Reviews
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 9: Subquery - Reviews for popular products
SELECT review_id, product_id
FROM Reviews
WHERE product_id IN (SELECT product_id FROM Orders GROUP BY product_id HAVING COUNT(*) > 5)
LIMIT 5;

-- Query 10: Subquery - Reviews with no returns
SELECT review_id, customer_id
FROM Reviews
WHERE order_id NOT IN (SELECT order_id FROM Returns)
LIMIT 5;

-- Query 11: Built-in Function - Review comment length
SELECT review_id, LENGTH(comment) AS comment_length
FROM Reviews
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Formatted review date
SELECT review_id, DATE_FORMAT(review_date, '%M %d, %Y') AS formatted_date
FROM Reviews
WHERE review_date IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Rounded rating
SELECT review_id, ROUND(rating) AS rounded_rating
FROM Reviews
LIMIT 5;

-- Query 14: Built-in Function - Review status
SELECT review_id,
       CASE 
           WHEN is_verified = TRUE THEN 'Verified'
           ELSE 'Not Verified'
       END AS status
FROM Reviews
LIMIT 5;

-- Query 15: Built-in Function - Uppercase comment
SELECT review_id, UPPER(comment) AS uppercase_comment
FROM Reviews
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format review comment
DELIMITER //
CREATE FUNCTION FormatReviewComment(comment TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(comment, 1)), LOWER(SUBSTRING(comment, 2)));
END //
DELIMITER ;
SELECT review_id, FormatReviewComment(comment) AS formatted_comment
FROM Reviews
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get review age
DELIMITER //
CREATE FUNCTION GetReviewAge(review_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), review_date);
END //
DELIMITER ;
SELECT review_id, review_date, GetReviewAge(review_date) AS review_age_days
FROM Reviews
WHERE review_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get product review count
DELIMITER //
CREATE FUNCTION GetProductReviewCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Reviews WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT review_id, product_id, GetProductReviewCount(product_id) AS review_count
FROM Reviews
LIMIT 5;

-- Query 19: User-Defined Function - Get customer review count
DELIMITER //
CREATE FUNCTION GetCustomerReviewCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Reviews WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT review_id, customer_id, GetCustomerReviewCount(customer_id) AS review_count
FROM Reviews
LIMIT 5;

-- Query 20: User-Defined Function - Get average product rating
DELIMITER //
CREATE FUNCTION GetAvgProductRating(prod_id INT)
RETURNS DECIMAL(3,1)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(AVG(rating), 0) FROM Reviews WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT review_id, product_id, GetAvgProductRating(product_id) AS avg_rating
FROM Reviews
LIMIT 5;

-- Table 7: Payments Table Queries
-- Query 1: JOIN - Payments with Orders and Customers
SELECT p.payment_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.amount
FROM Payments p
INNER JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
WHERE p.status = 'Completed'
LIMIT 5;

-- Query 2: JOIN - Payments with Subscriptions and Customers
SELECT p.payment_id, s.subscription_type, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Payments p
INNER JOIN Subscriptions s ON p.subscription_id = s.subscription_id
INNER JOIN Customers c ON s.customer_id = c.customer_id
LIMIT 5;

-- Query 3: JOIN - Payments with Orders and Products
SELECT p.payment_id, o.order_id, p.product_name
FROM Payments p
INNER JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Products pr ON o.product_id = pr.product_id
LIMIT 5;

-- Query 4: JOIN - Payments with Transactions and Customers
SELECT p.payment_id, t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Payments p
INNER JOIN Transactions t ON p.payment_id = t.payment_id
INNER JOIN Customers c ON t.customer_id = c.customer_id
LIMIT 5;

-- Query 5: JOIN - Payments with Orders and Shipments
SELECT p.payment_id, o.order_id, s.tracking_number
FROM Payments p
INNER JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Shipments s ON o.order_id = s.order_id
LIMIT 5;

-- Query 6: Subquery - Payments with high amounts
SELECT payment_id, amount
FROM Payments
WHERE amount > (SELECT AVG(amount) FROM Payments)
LIMIT 5;

-- Query 7: Subquery - Recent payments
SELECT payment_id, payment_date,
       (SELECT COUNT(*) FROM Payments p2 WHERE p2.order_id = p.order_id AND p2.payment_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS payment_count
FROM Payments p
WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Payments for active orders
SELECT payment_id, order_id
FROM Payments
WHERE order_id IN (SELECT order_id FROM Orders WHERE status = 'Pending')
LIMIT 5;

-- Query 9: Subquery - Payments with no refunds
SELECT payment_id, amount
FROM Payments
WHERE payment_id NOT IN (SELECT payment_id FROM Transactions WHERE transaction_type = 'Refund')
LIMIT 5;

-- Query 10: Subquery - Payments for subscriptions
SELECT payment_id, subscription_id
FROM Payments
WHERE subscription_id IN (SELECT subscription_id FROM Subscriptions WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted payment date
SELECT payment_id, DATE_FORMAT(payment_date, '%M %d, %Y') AS formatted_date
FROM Payments
WHERE payment_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded payment amount
SELECT payment_id, ROUND(amount) AS rounded_amount
FROM Payments
WHERE amount > 100
LIMIT 5;

-- Query 13: Built-in Function - Uppercase payment method
SELECT payment_id, UPPER(payment_method) AS uppercase_method
FROM Payments
LIMIT 5;

-- Query 14: Built-in Function - Payment status
SELECT payment_id,
       CASE 
           WHEN status = 'Completed' THEN 'Success'
           ELSE 'Pending'
       END AS status_category
FROM Payments
LIMIT 5;

-- Query 15: Built-in Function - Amount length
SELECT payment_id, LENGTH(CAST(amount AS CHAR)) AS amount_length
FROM Payments
LIMIT 5;

-- Query 16: User-Defined Function - Format payment method
DELIMITER //
CREATE FUNCTION FormatPaymentMethod(method VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(method, 1)), LOWER(SUBSTRING(method, 2)));
END //
DELIMITER ;
SELECT payment_id, payment_method, FormatPaymentMethod(payment_method) AS formatted_method
FROM Payments
LIMIT 5;

-- Query 17: User-Defined Function - Get payment age
DELIMITER //
CREATE FUNCTION GetPaymentAge(payment_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), payment_date);
END //
DELIMITER ;
SELECT payment_id, payment_date, GetPaymentAge(payment_date) AS payment_age_days
FROM Payments
WHERE payment_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get order payment count
DELIMITER //
CREATE FUNCTION GetOrderPaymentCount(order_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Payments WHERE Payments.order_id = Orders.order_id);
END //
DELIMITER ;
SELECT payment_id, order_id, GetOrderPaymentCount(order_id) AS payment_count
FROM Payments
WHERE order_id IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get total payment amount
DELIMITER //
CREATE FUNCTION GetTotalPaymentAmount(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(amount), 0) FROM Payments p JOIN Orders o ON p.order_id = o.order_id WHERE o.customer_id = cust_id);
END //
DELIMITER ;
SELECT payment_id, GetTotalPaymentAmount((SELECT customer_id FROM Orders o WHERE o.order_id = p.order_id)) AS total_amount
FROM Payments p
WHERE order_id IS NOT NULL
LIMIT 5;

-- Query 20: User-Defined Function - Get payment status
DELIMITER //
CREATE FUNCTION GetPaymentStatus(payment_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN (SELECT status FROM Payments WHERE Payments.payment_id = payment_id);
END //
DELIMITER ;
SELECT payment_id, GetPaymentStatus(payment_id) AS payment_status
FROM Payments
LIMIT 5;

-- Table 8: Shipments Table Queries
-- Query 1: JOIN - Shipments with Orders and Customers
SELECT s.shipment_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Shipments s
INNER JOIN Orders o ON s.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 2: JOIN - Shipments with Payments and Orders
SELECT s.shipment_id, p.payment_id, o.order_id
FROM Shipments s
INNER JOIN Orders o ON s.order_id = o.order_id
INNER JOIN Payments p ON o.order_id = p.order_id
WHERE p.status = 'Completed'
LIMIT 5;

-- Query 3: JOIN - Shipments with Addresses and Orders
SELECT s.shipment_id, a.street, o.order_id
FROM Shipments s
INNER JOIN Orders o ON s.order_id = o.order_id
INNER JOIN Addresses a ON o.shipping_address_id = a.address_id
LIMIT 5;

-- Query 4: JOIN - Shipments with Products and Orders
SELECT s.shipment_id, p.product_name, o.order_id
FROM Shipments s
INNER JOIN Orders o ON s.order_id = o.order_id
INNER JOIN Products p ON o.product_id = p.product_id
LIMIT 5;

-- Query 5: JOIN - Shipments with Returns and Orders
SELECT s.shipment_id, r.return_id, o.order_id
FROM Shipments s
INNER JOIN Orders o ON s.order_id = o.order_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 6: Subquery - Recent shipments
SELECT shipment_id, ship_date
FROM Shipments
WHERE ship_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 7: Subquery - Shipments for high-value orders
SELECT shipment_id, order_id
FROM Shipments
WHERE order_id IN (SELECT order_id FROM Orders WHERE total_price > 1000)
LIMIT 5;

-- Query 8: Subquery - Shipments with no returns
SELECT shipment_id, order_id
FROM Shipments
WHERE order_id NOT IN (SELECT order_id FROM Returns)
LIMIT 5;

-- Query 9: Subquery - Shipments by carrier
SELECT shipment_id, carrier
FROM Shipments
WHERE carrier IN (SELECT carrier FROM Shipments GROUP BY carrier HAVING COUNT(*) > 5)
LIMIT 5;

-- Query 10: Subquery - Shipments for active customers
SELECT shipment_id, order_id
FROM Shipments
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id WHERE c.is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted ship date
SELECT shipment_id, DATE_FORMAT(ship_date, '%M %d, %Y') AS formatted_date
FROM Shipments
WHERE ship_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Uppercase carrier
SELECT shipment_id, UPPER(carrier) AS uppercase_carrier
FROM Shipments
LIMIT 5;

-- Query 13: Built-in Function - Tracking number length
SELECT shipment_id, LENGTH(tracking_number) AS tracking_length
FROM Shipments
WHERE tracking_number IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Shipment status
SELECT shipment_id,
       CASE 
           WHEN delivery_date IS NOT NULL THEN 'Delivered'
           ELSE 'In Transit'
       END AS status
FROM Shipments
LIMIT 5;

-- Query 15: Built-in Function - Formatted delivery date
SELECT shipment_id, DATE_FORMAT(delivery_date, '%M %d, %Y') AS formatted_delivery
FROM Shipments
WHERE delivery_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format carrier name
DELIMITER //
CREATE FUNCTION FormatCarrierName(carrier VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(carrier, 1)), LOWER(SUBSTRING(carrier, 2)));
END //
DELIMITER ;
SELECT shipment_id, carrier, FormatCarrierName(carrier) AS formatted_carrier
FROM Shipments
LIMIT 5;

-- Query 17: User-Defined Function - Get shipment age
DELIMITER //
CREATE FUNCTION GetShipmentAge(ship_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), ship_date);
END //
DELIMITER ;
SELECT shipment_id, ship_date, GetShipmentAge(ship_date) AS shipment_age_days
FROM Shipments
WHERE ship_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get delivery days
DELIMITER //
CREATE FUNCTION GetDeliveryDays(ship_date DATE, delivery_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(delivery_date, ship_date);
END //
DELIMITER ;
SELECT shipment_id, ship_date, delivery_date, GetDeliveryDays(ship_date, delivery_date) AS delivery_days
FROM Shipments
WHERE delivery_date IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get shipment count
DELIMITER //
CREATE FUNCTION GetShipmentCount(order_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Shipments WHERE Shipments.order_id = Orders.order_id);
END //
DELIMITER ;
SELECT shipment_id, order_id, GetShipmentCount(order_id) AS shipment_count
FROM Shipments
LIMIT 5;

-- Query 20: User-Defined Function - Get carrier shipment count
DELIMITER //
CREATE FUNCTION GetCarrierShipmentCount(carrier VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Shipments WHERE Shipments.carrier = carrier);
END //
DELIMITER ;
SELECT shipment_id, carrier, GetCarrierShipmentCount(carrier) AS carrier_shipments
FROM Shipments
LIMIT 5;

-- Table 9: Warehouses Table Queries
-- Query 1: JOIN - Warehouses with Inventory and Products
SELECT w.warehouse_id, w.warehouse_name, p.product_name, i.quantity
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id
INNER JOIN Products p ON i.product_id = p.product_id
LIMIT 5;

-- Query 2: JOIN - Warehouses with Orders and Products
SELECT w.warehouse_name, o.order_id, p.product_name
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 3: JOIN - Warehouses with Suppliers and Products
SELECT w.warehouse_name, s.supplier_name, p.product_name
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 4: JOIN - Warehouses with Categories and Products
SELECT w.warehouse_name, c.category_name, p.product_name
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 5: JOIN - Warehouses with Returns and Orders
SELECT w.warehouse_name, r.return_id, o.order_id
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id
INNER JOIN Orders o ON i.product_id = o.product_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 6: Subquery - Warehouses with low stock
SELECT warehouse_id, warehouse_name
FROM Warehouses
WHERE warehouse_id IN (SELECT warehouse_id FROM Inventory WHERE quantity < min_stock_level)
LIMIT 5;

-- Query 7: Subquery - Warehouses with multiple products
SELECT warehouse_id, warehouse_name,
       (SELECT COUNT(*) FROM Inventory i WHERE i.warehouse_id = w.warehouse_id) AS product_count
FROM Warehouses w
WHERE (SELECT COUNT(*) FROM Inventory i WHERE i.warehouse_id = w.warehouse_id) > 1
LIMIT 5;

-- Query 8: Subquery - Warehouses with high-value products
SELECT warehouse_id, warehouse_name
FROM Warehouses
WHERE warehouse_id IN (SELECT i.warehouse_id FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE p.price > 100)
LIMIT 5;

-- Query 9: Subquery - Warehouses with no returns
SELECT warehouse_id, warehouse_name
FROM Warehouses
WHERE warehouse_id NOT IN (SELECT i.warehouse_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id JOIN Inventory i ON o.product_id = i.product_id)
LIMIT 5;

-- Query 10: Subquery - Warehouses with active products
SELECT warehouse_id, warehouse_name
FROM Warehouses
WHERE warehouse_id IN (SELECT i.warehouse_id FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE p.is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Warehouse name length
SELECT warehouse_name, LENGTH(warehouse_name) AS name_length
FROM Warehouses
WHERE LENGTH(warehouse_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Uppercase warehouse name
SELECT UPPER(warehouse_name) AS uppercase_name
FROM Warehouses
LIMIT 5;

-- Query 13: Built-in Function - Address formatting
SELECT warehouse_name, REPLACE(address, ' ', '-') AS formatted_address
FROM Warehouses
LIMIT 5;

-- Query 14: Built-in Function - Warehouse capacity status
SELECT warehouse_name,
       CASE 
           WHEN capacity > 1000 THEN 'Large'
           ELSE 'Small'
       END AS capacity_status
FROM Warehouses
LIMIT 5;

-- Query 15: Built-in Function - Warehouse location
SELECT warehouse_name, SUBSTRING_INDEX(address, ',', -1) AS location
FROM Warehouses
LIMIT 5;

-- Query 16: User-Defined Function - Format warehouse name
DELIMITER //
CREATE FUNCTION FormatWarehouseName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT warehouse_name, FormatWarehouseName(warehouse_name) AS formatted_name
FROM Warehouses
LIMIT 5;

-- Query 17: User-Defined Function - Get inventory count
DELIMITER //
CREATE FUNCTION GetInventoryCount(ware_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Inventory WHERE warehouse_id = ware_id);
END //
DELIMITER ;
SELECT warehouse_id, warehouse_name, GetInventoryCount(warehouse_id) AS inventory_count
FROM Warehouses
LIMIT 5;

-- Query 18: User-Defined Function - Get total stock value
DELIMITER //
CREATE FUNCTION GetTotalStockValue(ware_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(p.price * i.quantity), 0) FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE i.warehouse_id = ware_id);
END //
DELIMITER ;
SELECT warehouse_id, warehouse_name, GetTotalStockValue(warehouse_id) AS stock_value
FROM Warehouses
LIMIT 5;

-- Query 19: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetWarehouseProductCount(ware_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(DISTINCT product_id) FROM Inventory WHERE warehouse_id = ware_id);
END //
DELIMITER ;
SELECT warehouse_id, warehouse_name, GetWarehouseProductCount(warehouse_id) AS product_count
FROM Warehouses
LIMIT 5;

-- Query 20: User-Defined Function - Get low stock count
DELIMITER //
CREATE FUNCTION GetLowStockCount(ware_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Inventory WHERE warehouse_id = ware_id AND quantity < min_stock_level);
END //
DELIMITER ;
SELECT warehouse_id, warehouse_name, GetLowStockCount(warehouse_id) AS low_stock_count
FROM Warehouses
LIMIT 5;

-- Table 10: Inventory Table Queries
-- Query 1: JOIN - Inventory with Products and Warehouses
SELECT i.inventory_id, p.product_name, w.warehouse_name, i.quantity
FROM Inventory i
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Warehouses w ON i.warehouse_id = w.warehouse_id
LIMIT 5;

-- Query 2: JOIN - Inventory with Orders and Products
SELECT i.inventory_id, o.order_id, p.product_name
FROM Inventory i
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 3: JOIN - Inventory with Suppliers and Products
SELECT i.inventory_id, s.supplier_name, p.product_name
FROM Inventory i
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 4: JOIN - Inventory with Categories and Products
SELECT i.inventory_id, c.category_name, p.product_name
FROM Inventory i
INNER JOIN Products p ON i.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 5: JOIN - Inventory with Returns and Orders
SELECT i.inventory_id, r.return_id, o.order_id
FROM Inventory i
INNER JOIN Orders o ON i.product_id = o.product_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 6: Subquery - Low stock inventory
SELECT inventory_id, product_id, quantity
FROM Inventory
WHERE quantity < min_stock_level
LIMIT 5;

-- Query 7: Subquery - Inventory with recent orders
SELECT inventory_id, product_id,
       (SELECT COUNT(*) FROM Orders o WHERE o.product_id = i.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Inventory i
WHERE (SELECT COUNT(*) FROM Orders o WHERE o.product_id = i.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Inventory for high-priced products
SELECT inventory_id, product_id
FROM Inventory
WHERE product_id IN (SELECT product_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Inventory with no returns
SELECT inventory_id, product_id
FROM Inventory
WHERE product_id NOT IN (SELECT o.product_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id)
LIMIT 5;

-- Query 10: Subquery - Inventory in multiple warehouses
SELECT inventory_id, product_id,
       (SELECT COUNT(*) FROM Inventory i2 WHERE i2.product_id = i.product_id) AS warehouse_count
FROM Inventory i
WHERE (SELECT COUNT(*) FROM Inventory i2 WHERE i2.product_id = i.product_id) > 1
LIMIT 5;

-- Query 11: Built-in Function - Quantity status
SELECT inventory_id,
       CASE 
           WHEN quantity < min_stock_level THEN 'Low'
           ELSE 'Sufficient'
       END AS stock_status
FROM Inventory
LIMIT 5;

-- Query 12: Built-in Function - Formatted last updated
SELECT inventory_id, DATE_FORMAT(last_updated, '%M %d, %Y') AS formatted_date
FROM Inventory
WHERE last_updated IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase status
SELECT inventory_id, UPPER(status) AS uppercase_status
FROM Inventory
LIMIT 5;

-- Query 14: Built-in Function - Quantity length
SELECT inventory_id, LENGTH(CAST(quantity AS CHAR)) AS quantity_length
FROM Inventory
LIMIT 5;

-- Query 15: Built-in Function - Min stock level
SELECT inventory_id, ROUND(min_stock_level) AS rounded_min_stock
FROM Inventory
LIMIT 5;

-- Query 16: User-Defined Function - Get stock status
DELIMITER //
CREATE FUNCTION GetInventoryStockStatus(quantity INT, min_level INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF quantity < min_level THEN
        RETURN 'Low Stock';
    ELSE
        RETURN 'In Stock';
    END IF;
END //
DELIMITER ;
SELECT inventory_id, quantity, GetInventoryStockStatus(quantity, min_stock_level) AS stock_status
FROM Inventory
LIMIT 5;

-- Query 17: User-Defined Function - Get stock value
DELIMITER //
CREATE FUNCTION GetStockValue(prod_id INT, quantity INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(price * quantity, 0) FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT inventory_id, product_id, quantity, GetStockValue(product_id, quantity) AS stock_value
FROM Inventory
LIMIT 5;

-- Query 18: User-Defined Function - Get days since update
DELIMITER //
CREATE FUNCTION GetDaysSinceUpdate(last_updated DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), last_updated);
END //
DELIMITER ;
SELECT inventory_id, last_updated, GetDaysSinceUpdate(last_updated) AS days_since_update
FROM Inventory
WHERE last_updated IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get warehouse count
DELIMITER //
CREATE FUNCTION GetWarehouseCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Inventory WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT inventory_id, product_id, GetWarehouseCount(product_id) AS warehouse_count
FROM Inventory
LIMIT 5;

-- Query 20: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetInventoryOrderCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT inventory_id, product_id, GetInventoryOrderCount(product_id) AS order_count
FROM Inventory
LIMIT 5;

-- Table 11: Promotions Table Queries
-- Query 1: JOIN - Promotions with Products and Categories
SELECT pr.promotion_id, pr.promotion_name, p.product_name, c.category_name
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 2: JOIN - Promotions with Orders and Products
SELECT pr.promotion_id, pr.promotion_name, o.order_id
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 3: JOIN - Promotions with Discounts and Products
SELECT pr.promotion_id, pr.promotion_name, d.discount_percentage
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id
INNER JOIN Discounts d ON p.product_id = d.product_id
WHERE d.is_active = TRUE
LIMIT 5;

-- Query 4: JOIN - Promotions with Suppliers and Products
SELECT pr.promotion_id, pr.promotion_name, s.supplier_name
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 5: JOIN - Promotions with Reviews and Products
SELECT pr.promotion_id, pr.promotion_name, r.rating
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id
INNER JOIN Reviews r ON p.product_id = r.product_id
LIMIT 5;

-- Query 6: Subquery - Active promotions
SELECT promotion_id, promotion_name
FROM Promotions
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Promotions with recent orders
SELECT promotion_id, promotion_name,
       (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.product_id = pr.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Promotions pr
WHERE (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.product_id = pr.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Promotions for high-priced products
SELECT promotion_id, promotion_name
FROM Promotions
WHERE product_id IN (SELECT product_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Promotions with no returns
SELECT promotion_id, promotion_name
FROM Promotions
WHERE product_id NOT IN (SELECT o.product_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id)
LIMIT 5;

-- Query 10: Subquery - Promotions with high ratings
SELECT promotion_id, promotion_name,
       (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = pr.product_id) AS avg_rating
FROM Promotions pr
WHERE (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = pr.product_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Promotion name length
SELECT promotion_name, LENGTH(promotion_name) AS name_length
FROM Promotions
WHERE LENGTH(promotion_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Formatted start date
SELECT promotion_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_start
FROM Promotions
WHERE start_date IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase promotion name
SELECT UPPER(promotion_name) AS uppercase_name
FROM Promotions
LIMIT 5;

-- Query 14: Built-in Function - Promotion status
SELECT promotion_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Promotions
LIMIT 5;

-- Query 15: Built-in Function - Formatted end date
SELECT promotion_id, DATE_FORMAT(end_date, '%M %d, %Y') AS formatted_end
FROM Promotions
WHERE end_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format promotion name
DELIMITER //
CREATE FUNCTION FormatPromotionName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT promotion_id, promotion_name, FormatPromotionName(promotion_name) AS formatted_name
FROM Promotions
LIMIT 5;

-- Query 17: User-Defined Function - Get promotion duration
DELIMITER //
CREATE FUNCTION GetPromotionDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END //
DELIMITER ;
SELECT promotion_id, start_date, end_date, GetPromotionDuration(start_date, end_date) AS duration_days
FROM Promotions
WHERE end_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get promotion order count
DELIMITER //
CREATE FUNCTION GetPromotionOrderCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT promotion_id, product_id, GetPromotionOrderCount(product_id) AS order_count
FROM Promotions
LIMIT 5;

-- Query 19: User-Defined Function - Get promotion review count
DELIMITER //
CREATE FUNCTION GetPromotionReviewCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Reviews WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT promotion_id, product_id, GetPromotionReviewCount(product_id) AS review_count
FROM Promotions
LIMIT 5;

-- Query 20: User-Defined Function - Get days since promotion start
DELIMITER //
CREATE FUNCTION GetDaysSincePromoStart(start_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), start_date);
END //
DELIMITER ;
SELECT promotion_id, start_date, GetDaysSincePromoStart(start_date) AS days_since_start
FROM Promotions
WHERE start_date IS NOT NULL
LIMIT 5;

-- Table 12: Returns Table Queries
-- Query 1: JOIN - Returns with Orders and Customers
SELECT r.return_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 2: JOIN - Returns with Products and Orders
SELECT r.return_id, p.product_name, o.order_id
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id
INNER JOIN Products p ON o.product_id = p.product_id
LIMIT 5;

-- Query 3: JOIN - Returns with Shipments and Orders
SELECT r.return_id, s.tracking_number, o.order_id
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id
INNER JOIN Shipments s ON o.order_id = s.order_id
LIMIT 5;

-- Query 4: JOIN - Returns with Payments and Orders
SELECT r.return_id, p.payment_id, o.order_id
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id
INNER JOIN Payments p ON o.order_id = p.order_id
LIMIT 5;

-- Query 5: JOIN - Returns with Inventory and Products
SELECT r.return_id, i.quantity, p.product_name
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id
INNER JOIN Products p ON o.product_id = p.product_id
INNER JOIN Inventory i ON p.product_id = i.product_id
LIMIT 5;

-- Query 6: Subquery - Recent returns
SELECT return_id, return_date
FROM Returns
WHERE return_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 7: Subquery - Returns for high-value orders
SELECT return_id, order_id
FROM Returns
WHERE order_id IN (SELECT order_id FROM Orders WHERE total_price > 1000)
LIMIT 5;

-- Query 8: Subquery - Returns by active customers
SELECT return_id, customer_id
FROM Returns
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 9: Subquery - Returns with refunds
SELECT return_id, order_id
FROM Returns
WHERE order_id IN (SELECT order_id FROM Payments p JOIN Transactions t ON p.payment_id = t.payment_id WHERE t.transaction_type = 'Refund')
LIMIT 5;

-- Query 10: Subquery - Returns for popular products
SELECT return_id, order_id
FROM Returns
WHERE order_id IN (SELECT order_id FROM Orders GROUP BY product_id HAVING COUNT(*) > 5)
LIMIT 5;

-- Query 11: Built-in Function - Formatted return date
SELECT return_id, DATE_FORMAT(return_date, '%M %d, %Y') AS formatted_date
FROM Returns
WHERE return_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Uppercase reason
SELECT return_id, UPPER(reason) AS uppercase_reason
FROM Returns
WHERE reason IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Reason length
SELECT return_id, LENGTH(reason) AS reason_length
FROM Returns
WHERE reason IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Return status
SELECT return_id,
       CASE 
           WHEN status = 'Approved' THEN 'Processed'
           ELSE 'Pending'
       END AS status_category
FROM Returns
LIMIT 5;

-- Query 15: Built-in Function - Formatted refund amount
SELECT return_id, ROUND(refunded_amount) AS rounded_refunded
FROM Returns
WHERE refunded_amount IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format return reason
DELIMITER //
CREATE FUNCTION FormatReturnReason(reason TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(reason, 1)), LOWER(SUBSTRING(reason, 2)));
END //
DELIMITER ;
SELECT return_id, reason, FormatReturnReason(reason) AS formatted_reason
FROM Returns
WHERE reason IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get return age
DELIMITER //
CREATE FUNCTION GetReturnAge(return_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), return_date);
END //
DELIMITER ;
SELECT return_id, return_date, GetReturnAge(return_date) AS return_age_days
FROM Returns
WHERE return_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get return count by customer
DELIMITER //
CREATE FUNCTION GetCustomerReturnCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Returns r JOIN Orders o ON r.order_id = o.order_id WHERE o.customer_id = cust_id);
END //
DELIMITER ;
SELECT return_id, GetCustomerReturnCount((SELECT customer_id FROM Orders o WHERE o.order_id = r.order_id)) AS return_count
FROM Returns r
LIMIT 5;

-- Query 19: User-Defined Function - Get refund status
DELIMITER //
CREATE FUNCTION GetRefundStatus(return_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN (SELECT CASE WHEN refunded_amount > 0 THEN 'Refunded' ELSE 'Not Refunded' END FROM Returns WHERE Returns.return_id = return_id);
END //
DELIMITER ;
SELECT return_id, GetRefundStatus(return_id) AS refund_status
FROM Returns
LIMIT 5;

-- Query 20: User-Defined Function - Get product return count
DELIMITER //
CREATE FUNCTION GetProductReturnCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Returns r JOIN Orders o ON r.order_id = o.order_id WHERE o.product_id = prod_id);
END //
DELIMITER ;
SELECT return_id, GetProductReturnCount((SELECT product_id FROM Orders o WHERE o.order_id = r.order_id)) AS return_count
FROM Returns r
LIMIT 5;

-- Table 13: Wishlists Table Queries
-- Query 1: JOIN - Wishlists with Customers and Products
SELECT w.wishlist_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Wishlists w
INNER JOIN Customers c ON w.customer_id = c.customer_id
INNER JOIN Products p ON w.product_id = p.product_id
LIMIT 5;

-- Query 2: JOIN - Wishlists with Categories and Products
SELECT w.wishlist_id, c.category_name, p.product_name
FROM Wishlists w
INNER JOIN Products p ON w.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 3: JOIN - Wishlists with Orders and Customers
SELECT w.wishlist_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Wishlists w
INNER JOIN Customers c ON w.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 4: JOIN - Wishlists with Reviews and Products
SELECT w.wishlist_id, r.rating, p.product_name
FROM Wishlists w
INNER JOIN Products p ON w.product_id = p.product_id
INNER JOIN Reviews r ON p.product_id = r.product_id
LIMIT 5;

-- Query 5: JOIN - Wishlists with Promotions and Products
SELECT w.wishlist_id, pr.promotion_name, p.product_name
FROM Wishlists w
INNER JOIN Products p ON w.product_id = p.product_id
INNER JOIN Promotions pr ON p.product_id = pr.product_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 6: Subquery - Wishlists with active products
SELECT wishlist_id, product_id
FROM Wishlists
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE)
LIMIT 5;

-- Query 7: Subquery - Wishlists with recent additions
SELECT wishlist_id, customer_id,
       (SELECT COUNT(*) FROM Wishlists w2 WHERE w2.customer_id = w.customer_id AND w2.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS item_count
FROM Wishlists w
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Wishlists for high-priced products
SELECT wishlist_id, product_id
FROM Wishlists
WHERE product_id IN (SELECT product_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Wishlists with no orders
SELECT wishlist_id, product_id
FROM Wishlists
WHERE product_id NOT IN (SELECT product_id FROM Orders WHERE customer_id = w.customer_id)
FROM Wishlists w
LIMIT 5;

-- Query 10: Subquery - Wishlists with high-rated products
SELECT wishlist_id, product_id,
       (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = w.product_id) AS avg_rating
FROM Wishlists w
WHERE (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = w.product_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Formatted created date
SELECT wishlist_id, DATE_FORMAT(created_at, '%M %d, %Y') AS formatted_date
FROM Wishlists
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Product name length
SELECT wishlist_id, product_id, LENGTH((SELECT product_name FROM Products p WHERE p.product_id = w.product_id)) AS name_length
FROM Wishlists w
WHERE LENGTH((SELECT product_name FROM Products p WHERE p.product_id = w.product_id)) > 10
LIMIT 5;

-- Query 13: Built-in Function - Uppercase customer name
SELECT wishlist_id, UPPER((SELECT CONCAT(first_name, ' ', last_name) FROM Customers c WHERE c.customer_id = w.customer_id)) AS uppercase_name
FROM Wishlists w
LIMIT 5;

-- Query 14: Built-in Function - Wishlist item status
SELECT wishlist_id,
       CASE 
           WHEN (SELECT is_active FROM Products p WHERE p.product_id = w.product_id) = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS product_status
FROM Wishlists w
LIMIT 5;

-- Query 15: Built-in Function - Formatted updated date
SELECT wishlist_id, DATE_FORMAT(updated_at, '%M %d, %Y') AS formatted_updated
FROM Wishlists
WHERE updated_at IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Get wishlist age
DELIMITER //
CREATE FUNCTION GetWishlistAge(created_at DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_at);
END //
DELIMITER ;
SELECT wishlist_id, created_at, GetWishlistAge(created_at) AS wishlist_age_days
FROM Wishlists
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get wishlist item count
DELIMITER //
CREATE FUNCTION GetWishlistItemCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Wishlists WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT wishlist_id, customer_id, GetWishlistItemCount(customer_id) AS item_count
FROM Wishlists
LIMIT 5;

-- Query 18: User-Defined Function - Format product name
DELIMITER //
CREATE FUNCTION FormatWishlistProductName(prod_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN (SELECT CONCAT(UPPER(LEFT(product_name, 1)), LOWER(SUBSTRING(product_name, 2))) FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT wishlist_id, product_id, FormatWishlistProductName(product_id) AS formatted_name
FROM Wishlists
LIMIT 5;

-- Query 19: User-Defined Function - Get product price
DELIMITER //
CREATE FUNCTION GetWishlistProductPrice(prod_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT price FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT wishlist_id, product_id, GetWishlistProductPrice(product_id) AS product_price
FROM Wishlists
LIMIT 5;

-- Query 20: User-Defined Function - Get wishlist order count
DELIMITER //
CREATE FUNCTION GetWishlistOrderCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT wishlist_id, product_id, GetWishlistOrderCount(product_id) AS order_count
FROM Wishlists
LIMIT 5;

-- Table 14: Cart Table Queries
-- Query 1: JOIN - Cart with Customers and Products
SELECT ca.cart_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Cart ca
INNER JOIN Customers c ON ca.customer_id = c.customer_id
INNER JOIN Products p ON ca.product_id = p.product_id
LIMIT 5;

-- Query 2: JOIN - Cart with Orders and Customers
SELECT ca.cart_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Cart ca
INNER JOIN Customers c ON ca.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 3: JOIN - Cart with Promotions and Products
SELECT ca.cart_id, pr.promotion_name, p.product_name
FROM Cart ca
INNER JOIN Products p ON ca.product_id = p.product_id
INNER JOIN Promotions pr ON p.product_id = pr.product_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 4: JOIN - Cart with Categories and Products
SELECT ca.cart_id, c.category_name, p.product_name
FROM Cart ca
INNER JOIN Products p ON ca.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
LIMIT 5;

-- Query 5: JOIN - Cart with Reviews and Products
SELECT ca.cart_id, r.rating, p.product_name
FROM Cart ca
INNER JOIN Products p ON ca.product_id = p.product_id
INNER JOIN Reviews r ON p.product_id = r.product_id
LIMIT 5;

-- Query 6: Subquery - Cart with active products
SELECT cart_id, product_id
FROM Cart
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE)
LIMIT 5;

-- Query 7: Subquery - Cart with recent additions
SELECT cart_id, customer_id,
       (SELECT COUNT(*) FROM Cart ca2 WHERE ca2.customer_id = ca.customer_id AND ca2.added_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS item_count
FROM Cart ca
WHERE added_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Cart for high-priced products
SELECT cart_id, product_id
FROM Cart
WHERE product_id IN (SELECT product_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Cart items not ordered
SELECT cart_id, product_id
FROM Cart ca
WHERE product_id NOT IN (SELECT product_id FROM Orders WHERE customer_id = ca.customer_id)
LIMIT 5;

-- Query 10: Subquery - Cart with high-rated products
SELECT cart_id, product_id,
       (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = ca.product_id) AS avg_rating
FROM Cart ca
WHERE (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = ca.product_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Formatted added date
SELECT cart_id, DATE_FORMAT(added_at, '%M %d, %Y') AS formatted_date
FROM Cart
WHERE added_at IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Quantity status
SELECT cart_id,
       CASE 
           WHEN quantity > 5 THEN 'High'
           ELSE 'Low'
       END AS quantity_status
FROM Cart
LIMIT 5;

-- Query 13: Built-in Function - Uppercase product name
SELECT cart_id, UPPER((SELECT product_name FROM Products p WHERE p.product_id = ca.product_id)) AS uppercase_name
FROM Cart ca
LIMIT 5;

-- Query 14: Built-in Function - Product name length
SELECT cart_id, LENGTH((SELECT product_name FROM Products p WHERE p.product_id = ca.product_id)) AS name_length
FROM Cart ca
WHERE LENGTH((SELECT product_name FROM Products p WHERE p.product_id = ca.product_id)) > 10
LIMIT 5;

-- Query 15: Built-in Function - Rounded total price
SELECT cart_id, ROUND((SELECT price FROM Products p WHERE p.product_id = ca.product_id) * ca.quantity) AS total_price
FROM Cart ca
LIMIT 5;

-- Query 16: User-Defined Function - Get cart total
DELIMITER //
CREATE FUNCTION GetCartTotal(prod_id INT, quantity INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT price * quantity FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT cart_id, product_id, quantity, GetCartTotal(product_id, quantity) AS total_price
FROM Cart
LIMIT 5;

-- Query 17: User-Defined Function - Get cart age
DELIMITER //
CREATE FUNCTION GetCartAge(added_at DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), added_at);
END //
DELIMITER ;
SELECT cart_id, added_at, GetCartAge(added_at) AS cart_age_days
FROM Cart
WHERE added_at IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get cart item count
DELIMITER //
CREATE FUNCTION GetCartItemCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Cart WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT cart_id, customer_id, GetCartItemCount(customer_id) AS item_count
FROM Cart
LIMIT 5;

-- Query 19: User-Defined Function - Format cart product name
DELIMITER //
CREATE FUNCTION FormatCartProductName(prod_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN (SELECT CONCAT(UPPER(LEFT(product_name, 1)), LOWER(SUBSTRING(product_name, 2))) FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT cart_id, product_id, FormatCartProductName(product_id) AS formatted_name
FROM Cart
LIMIT 5;

-- Query 20: User-Defined Function - Get cart order count
DELIMITER //
CREATE FUNCTION GetCartOrderCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT cart_id, product_id, GetCartOrderCount(product_id) AS order_count
FROM Cart
LIMIT 5;

-- Table 15: Employees Table Queries
-- Query 1: JOIN - Employees with Departments and Addresses
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.department_name, a.street
FROM Employees e
INNER JOIN Departments d ON e.department_id = d.department_id
INNER JOIN Addresses a ON e.address_id = a.address_id
LIMIT 5;

-- Query 2: JOIN - Employees with Orders and Customers
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, o.order_id, c.first_name
FROM Employees e
INNER JOIN Orders o ON e.employee_id = o.employee_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 3: JOIN - Employees with Returns and Orders
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, r.return_id
FROM Employees e
INNER JOIN Orders o ON e.employee_id = o.employee_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 4: JOIN - Employees with Transactions and Payments
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, t.transaction_id
FROM Employees e
INNER JOIN Transactions t ON e.employee_id = t.employee_id
INNER JOIN Payments p ON t.payment_id = p.payment_id
LIMIT 5;

-- Query 5: JOIN - Employees with Feedback and Customers
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, f.feedback_id
FROM Employees e
INNER JOIN Feedback f ON e.employee_id = f.employee_id
INNER JOIN Customers c ON f.customer_id = c.customer_id
LIMIT 5;

-- Query 6: Subquery - Active employees
SELECT employee_id, first_name, last_name
FROM Employees
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Employees with recent orders
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name,
       (SELECT COUNT(*) FROM Orders o WHERE o.employee_id = e.employee_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Employees e
WHERE (SELECT COUNT(*) FROM Orders o WHERE o.employee_id = e.employee_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Employees with high salary
SELECT employee_id, first_name, last_name
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees)
LIMIT 5;

-- Query 9: Subquery - Employees with no returns
SELECT employee_id, first_name, last_name
FROM Employees
WHERE employee_id NOT IN (SELECT employee_id FROM Orders o JOIN Returns r ON o.order_id = r.order_id)
LIMIT 5;

-- Query 10: Subquery - Employees in specific department
SELECT employee_id, first_name, last_name
FROM Employees
WHERE department_id IN (SELECT department_id FROM Departments WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted hire date
SELECT employee_id, DATE_FORMAT(hire_date, '%M %d, %Y') AS formatted_date
FROM Employees
WHERE hire_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Uppercase employee name
SELECT employee_id, UPPER(CONCAT(first_name, ' ', last_name)) AS uppercase_name
FROM Employees
LIMIT 5;

-- Query 13: Built-in Function - Salary rounded
SELECT employee_id, ROUND(salary) AS rounded_salary
FROM Employees
WHERE salary IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Employee status
SELECT employee_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Employees
LIMIT 5;

-- Query 15: Built-in Function - Email domain
SELECT employee_id, SUBSTRING_INDEX(email, '@', -1) AS email_domain
FROM Employees
LIMIT 5;

-- Query 16: User-Defined Function - Get full employee name
DELIMITER //
CREATE FUNCTION GetEmployeeFullName(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END //
DELIMITER ;
SELECT employee_id, GetEmployeeFullName(first_name, last_name) AS full_name
FROM Employees
LIMIT 5;

-- Query 17: User-Defined Function - Get employee tenure
DELIMITER //
CREATE FUNCTION GetEmployeeTenure(hire_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), hire_date);
END //
DELIMITER ;
SELECT employee_id, hire_date, GetEmployeeTenure(hire_date) AS tenure_days
FROM Employees
WHERE hire_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetEmployeeOrderCount(emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE employee_id = emp_id);
END //
DELIMITER ;
SELECT employee_id, GetEmployeeOrderCount(employee_id) AS order_count
FROM Employees
LIMIT 5;

-- Query 19: User-Defined Function - Format employee email
DELIMITER //
CREATE FUNCTION FormatEmployeeEmail(email VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN LOWER(email);
END //
DELIMITER ;
SELECT employee_id, email, FormatEmployeeEmail(email) AS formatted_email
FROM Employees
LIMIT 5;

-- Query 20: User-Defined Function - Get transaction count
DELIMITER //
CREATE FUNCTION GetEmployeeTransactionCount(emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Transactions WHERE employee_id = emp_id);
END //
DELIMITER ;
SELECT employee_id, GetEmployeeTransactionCount(employee_id) AS transaction_count
FROM Employees
LIMIT 5;

-- Table 16: Departments Table Queries
-- Query 1: JOIN - Departments with Employees and Addresses
SELECT d.department_id, d.department_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, a.street
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Addresses a ON e.address_id = a.address_id
LIMIT 5;

-- Query 2: JOIN - Departments with Orders and Employees
SELECT d.department_name, o.order_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Orders o ON e.employee_id = o.employee_id
LIMIT 5;

-- Query 3: JOIN - Departments with Transactions and Employees
SELECT d.department_name, t.transaction_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Transactions t ON e.employee_id = t.employee_id
LIMIT 5;

-- Query 4: JOIN - Departments with Feedback and Employees
SELECT d.department_name, f.feedback_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Feedback f ON e.employee_id = f.employee_id
LIMIT 5;

-- Query 5: JOIN - Departments with Returns and Employees
SELECT d.department_name, r.return_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
INNER JOIN Employees e ON d.department_id = e.department_id
INNER JOIN Orders o ON e.employee_id = o.employee_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 6: Subquery - Active departments
SELECT department_id, department_name
FROM Departments
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Departments with multiple employees
SELECT department_id, department_name,
       (SELECT COUNT(*) FROM Employees e WHERE e.department_id = d.department_id) AS employee_count
FROM Departments d
WHERE (SELECT COUNT(*) FROM Employees e WHERE e.department_id = d.department_id) > 1
LIMIT 5;

-- Query 8: Subquery - Departments with high-budget
SELECT department_id, department_name
FROM Departments
WHERE budget > (SELECT AVG(budget) FROM Departments)
LIMIT 5;

-- Query 9: Subquery - Departments with no orders
SELECT department_id, department_name
FROM Departments
WHERE department_id NOT IN (SELECT department_id FROM Employees e JOIN Orders o ON e.employee_id = o.employee_id)
LIMIT 5;

-- Query 10: Subquery - Departments with active employees
SELECT department_id, department_name
FROM Departments
WHERE department_id IN (SELECT department_id FROM Employees WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Department name length
SELECT department_name, LENGTH(department_name) AS name_length
FROM Departments
WHERE LENGTH(department_name) > 10
LIMIT 5;

-- Query 12: Built-in Function - Uppercase department name
SELECT UPPER(department_name) AS uppercase_name
FROM Departments
LIMIT 5;

-- Query 13: Built-in Function - Rounded budget
SELECT department_id, ROUND(budget) AS rounded_budget
FROM Departments
WHERE budget IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Department status
SELECT department_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Departments
LIMIT 5;

-- Query 15: Built-in Function - Formatted location
SELECT department_name, REPLACE(location, ' ', '-') AS formatted_location
FROM Departments
LIMIT 5;

-- Query 16: User-Defined Function - Format department name
DELIMITER //
CREATE FUNCTION FormatDepartmentName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT department_id, department_name, FormatDepartmentName(department_name) AS formatted_name
FROM Departments
LIMIT 5;

-- Query 17: User-Defined Function - Get employee count
DELIMITER //
CREATE FUNCTION GetDepartmentEmployeeCount(dept_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Employees WHERE department_id = dept_id);
END //
DELIMITER ;
SELECT department_id, department_name, GetDepartmentEmployeeCount(department_id) AS employee_count
FROM Departments
LIMIT 5;

-- Query 18: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetDepartmentOrderCount(dept_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders o JOIN Employees e ON o.employee_id = e.employee_id WHERE e.department_id = dept_id);
END //
DELIMITER ;
SELECT department_id, department_name, GetDepartmentOrderCount(department_id) AS order_count
FROM Departments
LIMIT 5;

-- Query 19: User-Defined Function - Get budget status
DELIMITER //
CREATE FUNCTION GetBudgetStatus(budget DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF budget > 100000 THEN
        RETURN 'High';
    ELSE
        RETURN 'Low';
    END IF;
END //
DELIMITER ;
SELECT department_id, budget, GetBudgetStatus(budget) AS budget_status
FROM Departments
LIMIT 5;

-- Query 20: User-Defined Function - Get transaction count
DELIMITER //
CREATE FUNCTION GetDepartmentTransactionCount(dept_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Transactions t JOIN Employees e ON t.employee_id = e.employee_id WHERE e.department_id = dept_id);
END //
DELIMITER ;
SELECT department_id, department_name, GetDepartmentTransactionCount(department_id) AS transaction_count
FROM Departments
LIMIT 5;

-- Table 17: Transactions Table Queries
-- Query 1: JOIN - Transactions with Payments and Customers
SELECT t.transaction_id, p.payment_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Transactions t
INNER JOIN Payments p ON t.payment_id = p.payment_id
INNER JOIN Customers c ON t.customer_id = c.customer_id
LIMIT 5;

-- Query 2: JOIN - Transactions with Employees and Departments
SELECT t.transaction_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, d.department_name
FROM Transactions t
INNER JOIN Employees e ON t.employee_id = e.employee_id
INNER JOIN Departments d ON e.department_id = d.department_id
LIMIT 5;

-- Query 3: JOIN - Transactions with Orders and Payments
SELECT t.transaction_id, o.order_id, p.payment_amount
FROM Transactions t
INNER JOIN Payments p ON t.payment_id = p.payment_id
INNER JOIN Orders o ON p.order_id = o.order_id
LIMIT 5;

-- Query 4: JOIN - Transactions with Returns and Orders
SELECT t.transaction_id, r.return_id, o.order_id
FROM Transactions t
INNER JOIN Payments p ON t.payment_id = p.payment_id
INNER JOIN Orders o ON p.order_id = o.order_id
INNER JOIN Returns r ON o.order_id = r.order_id
LIMIT 5;

-- Query 5: JOIN - Transactions with Customers and Addresses
SELECT t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, a.street
FROM Transactions t
INNER JOIN Customers c ON t.customer_id = c.customer_id
INNER JOIN Addresses a ON c.customer_id = a.customer_id
LIMIT 5;

-- Query 6: Subquery - Recent transactions
SELECT transaction_id, transaction_date
FROM Transactions
WHERE transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 7: Subquery - Transactions with high amounts
SELECT transaction_id, amount,
       (SELECT COUNT(*) FROM Transactions t2 WHERE t2.customer_id = t.customer_id AND t2.amount > 100) AS high_amount_count
FROM Transactions t
WHERE amount > 100
LIMIT 5;

-- Query 8: Subquery - Refund transactions
SELECT transaction_id, amount
FROM Transactions
WHERE transaction_type = 'Refund'
LIMIT 5;

-- Query 9: Subquery - Transactions with no returns
SELECT transaction_id, payment_id
FROM Transactions
WHERE payment_id NOT IN (SELECT payment_id FROM Payments p JOIN Orders o ON p.order_id = o.order_id JOIN Returns r ON o.order_id = r.order_id)
LIMIT 5;

-- Query 10: Subquery - Transactions by active employees
SELECT transaction_id, employee_id
FROM Transactions
WHERE employee_id IN (SELECT employee_id FROM Employees WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted transaction date
SELECT transaction_id, DATE_FORMAT(transaction_date, '%M %d, %Y') AS formatted_date
FROM Transactions
WHERE transaction_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded amount
SELECT transaction_id, ROUND(amount) AS rounded_amount
FROM Transactions
WHERE amount IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase transaction type
SELECT transaction_id, UPPER(transaction_type) AS uppercase_type
FROM Transactions
LIMIT 5;

-- Query 14: Built-in Function - Transaction status
SELECT transaction_id,
       CASE 
           WHEN status = 'Completed' THEN 'Success'
           ELSE 'Pending'
       END AS status_category
FROM Transactions
LIMIT 5;

-- Query 15: Built-in Function - Amount length
SELECT transaction_id, LENGTH(CAST(amount AS CHAR)) AS amount_length
FROM Transactions
LIMIT 5;

-- Query 16: User-Defined Function - Format transaction type
DELIMITER //
CREATE FUNCTION FormatTransactionType(transaction_type VARCHAR(50))
RETURNS VARCHAR(10,2)
DETERMINISTIC
SELECT
    RETURN CONCAT(UPPER(LEFT(transaction_type, 1)), LOWER(SUBSTRING(transaction_type, 2)));
-- Expected Output: transaction_id, transaction_type, formatted_type (e.g., "Refund" -> "Refund")
END //
DELIMITER ;
SELECT transaction_id, FormatTransactionType(transaction_type) AS formatted_type
FROM Transactions
LIMIT 5;

-- Query 17: User-Defined Function - Get transaction age
DELIMITER //
CREATE FUNCTION GetTransactionAge(transaction_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), transaction_date);
END //
DELIMITER ;
SELECT transaction_id, transaction_date, GetTransactionAge(transaction_date) AS transaction_age_days
FROM Transactions
WHERE transaction_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get customer transactions
DELIMITER //
CREATE FUNCTION GetCustomerTransactionCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Transactions WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT transaction_id, customer_id, GetCustomerTransactionCount(customer_id) AS transaction_count
FROM Transactions
LIMIT 5;

-- Query 19: User-Defined Function - Get payment amount
DELIMITER //
CREATE FUNCTION GetTransactionPaymentAmount(payment_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT amount FROM Payments WHERE payment_id = payment_id);
END //
DELIMITER ;
SELECT transaction_id, payment_id, GetTransactionPaymentAmount(payment_id) AS payment_amount
FROM Transactions
LIMIT 5;

-- Query 20: User-Defined Function - Get employee transaction count
DELIMITER //
CREATE FUNCTION GetEmployeeTransactionCount(emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Transactions WHERE employee_id = emp_id);
END //
DELIMITER ;
SELECT transaction_id, employee_id, GetEmployeeTransactionCount(employee_id) AS transaction_count
FROM Transactions
LIMIT 5;

-- Table 18: Discounts Table Queries
-- Query 1: JOIN - Discounts with products Products and Categories
SELECT d.discount_id, d.discount_percentage, p.product_name, amountc.category_name
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id
INNER JOIN Categories c ON p.category_id = c.category_id
WHERE d.is_active = TRUE
LIMIT 5;

-- Query 2: JOIN - Discounts with promotions Promotions and products Products
SELECT d.discount_id, pr.promotion_name, p.product_name
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id
INNER JOIN Promotions pr ON p.product_id = pr.product_id
WHERE pr.is_active = TRUE
LIMIT 5;

-- Query 3: JOIN - Discounts with discounts Discounts and orders Orders
SELECT d.discount_id, o.order_id, p.product_name
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id
INNER JOIN Orders o ON p.product_id = o.product_id
LIMIT 5;

-- Query 4: JOIN - Discounts with suppliers Suppliers and products Products
SELECT d.discount_id, s.supplier_name, p.product_name
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id
INNER JOIN Suppliers s ON p.supplier_id = s.supplier_id
LIMIT 5;

-- Query 5: JOIN - Discounts with reviews Reviews and products Products
SELECT d.discount_id, r.rating, p.product_name
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id
INNER JOIN Reviews r ON p.product_id = r.product_id
LIMIT 5;

-- Query 6: Subquery - Active discounts
SELECT discount_id, discount_percentage
FROM Discounts
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Discounts with recent orders
SELECT discount_id, discount_percentage,
       (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.product_id = d.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Discounts d
WHERE (SELECT COUNT(*) FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.product_id = d.product_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Discounts for high-priced products
SELECT discount_id, product_id
FROM Discounts
WHERE product_id IN (SELECT product_id FROM Products WHERE price > 100)
LIMIT 5;

-- Query 9: Subquery - Discounts with no returns
SELECT discount_id
FROM Discounts
WHERE product_id NOT IN (SELECT o.product_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id)
LIMIT 5;

-- Query 10: Subquery - Discounts with high ratings
SELECT discount_id,
       (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = d.product_id) AS avg_rating
FROM Discounts d
WHERE (SELECT AVG(rating) FROM Reviews r WHERE r.product_id = d.product_id) > 4
LIMIT 5;

-- Query 11: Built-in Function - Discount percentage rounded
SELECT discount_id, ROUND(discount_percentage) AS rounded_percentage
FROM Discounts
LIMIT 5;

-- Query 12: Built-in Function - Formatted start date
SELECT discount_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_start
FROM Discounts
WHERE start_date IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase discount code
SELECT discount_id, UPPER(discount_code) AS uppercase_code
FROM Discounts
WHERE discount_code IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Discount status
SELECT discount_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Discounts
LIMIT 5;

-- Query 15: Built-in Function - Formatted end date
SELECT discount_id, DATE_FORMAT(end_date, '%M %d, %Y') AS formatted_end
FROM Discounts
WHERE end_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format discount code
DELIMITER //
CREATE FUNCTION FormatDiscountCode(code VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(code);
END //
DELIMITER ;
SELECT discount_id, discount_code, FormatDiscountCode(discount_code) AS formatted_code
FROM Discounts
WHERE discount_code IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get discount duration
DELIMITER //
CREATE FUNCTION GetDiscountDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END //
DELIMITER ;
SELECT discount_id, start_date, end_date, GetDiscountDuration(start_date, end_date) AS duration_days
FROM Discounts
WHERE end_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get discount order count
DELIMITER //
CREATE FUNCTION GetDiscountOrderCount(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT discount_id, product_id, GetDiscountOrderCount(product_id) AS order_count
FROM Discounts
LIMIT 5;

-- Query 19: User-Defined Function - Get discount value
DELIMITER //
CREATE FUNCTION GetDiscountValue(prod_id INT, discount_percentage DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT price * (discount_percentage / 100) FROM Products WHERE product_id = prod_id);
END //
DELIMITER ;
SELECT discount_id, product_id, discount_percentage, GetDiscountValue(product_id, discount_percentage) AS discount_value
FROM Discounts
LIMIT 5;

-- Query 20: User-Defined Function - Get days since discount start
DELIMITER //
CREATE FUNCTION GetDaysSinceDiscountStart(start_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), start_date);
END //
DELIMITER ;
SELECT discount_id, start_date, GetDaysSinceDiscountStart(start_date) AS days_since_start
FROM Discounts
WHERE start_date IS NOT NULL
LIMIT 5;

-- Table 19: Taxes Table Queries
-- Query 1: JOIN - Taxes with Orders and Customers
SELECT t.tax_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, t.tax_amount
FROM Taxes t
INNER JOIN Orders o ON t.order_id = o.order_id
INNER JOIN Customers c ON o.customer_id = c.customer_id
LIMIT 5;

-- Query 2: JOIN - Taxes with Payments and Orders
SELECT t.tax_id, p.payment_amount, o.order_id
FROM Taxes t
INNER JOIN Orders o ON t.order_id = o.order_id
INNER JOIN Payments p ON o.order_id = p.order_id
LIMIT 5;

-- Query 3: JOIN - Taxes with Products and Orders
SELECT t.tax_id, p.product_name, o.order_id
FROM Taxes t
INNER JOIN Orders o ON t.order_id = o.order_id
INNER JOIN Products p ON o.product_id = p.product_id
LIMIT 5;

-- Query 4: JOIN - Taxes with Addresses and Orders
SELECT t.tax_id, a.street_address, o.order_id
FROM Taxes t
INNER JOIN Orders o ON t.order_id = o.order_id
INNER JOIN Addresses a ON o.shipping_address_id = a.address_id
LIMIT 5;

-- Query 5: JOIN - Taxes with Transactions and Payments
SELECT t.tax_id, tr.transaction_id, p.payment_amount
FROM Taxes t
INNER JOIN Orders p ON t.order_id = p.order_id
INNER JOIN Transactions tr ON p.payment_id = tr.payment_id
LIMIT 5;

-- Query 6: Subquery - High tax amounts
SELECT tax_id, tax_amount
FROM Taxes
WHERE tax_amount > (SELECT AVG(tax_amount) FROM Taxes)
LIMIT 5;

-- Query 7: Subquery - Recent taxes
SELECT tax_id, order_id,
       (SELECT COUNT(*) FROM Taxes t2 WHERE t2.order_id = t.order_id AND t2.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS tax_count
FROM Taxes t
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Taxes for high-value orders
SELECT tax_id, order_id
FROM Taxes
WHERE order_id IN (SELECT order_id FROM Orders WHERE total_price > 1000)
LIMIT 5;

-- Query 9: Subquery - Taxes with no returns
SELECT tax_id, order_id
FROM Taxes
WHERE order_id NOT IN (SELECT order_id FROM Returns)
LIMIT 5;

-- Query 10: Subquery - Taxes by active customers
SELECT tax_id, order_id
FROM Taxes
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id WHERE c.is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Rounded tax amount
SELECT tax_id, ROUND(tax_amount) AS rounded_amount
FROM Taxes
LIMIT 5;

-- Query 12: Built-in Function - Formatted created date
SELECT tax_id, DATE_FORMAT(created_at, '%M %d, %Y') AS formatted_date
FROM Taxes
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase tax type
SELECT tax_id, UPPER(tax_type) AS uppercase_type
FROM Taxes
LIMIT 5;

-- Query 14: Built-in Function - Tax rate status
SELECT tax_id,
       CASE 
           WHEN tax_rate > 10 THEN 'High'
           ELSE 'Low'
       END AS rate_status
FROM Taxes
LIMIT 5;

-- Query 15: Built-in Function - Tax amount length
SELECT tax_id, LENGTH(CAST(tax_amount AS CHAR)) AS amount_length
FROM Taxes
LIMIT 5;

-- Query 16: User-Defined Function - Format tax type
DELIMITER //
CREATE FUNCTION FormatTaxType(tax_type VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(tax_type, 1)), LOWER(SUBSTRING(tax_type, 2)));
END //
DELIMITER ;
SELECT tax_id, tax_type, FormatTaxType(tax_amount) AS formatted_type
FROM Taxes
LIMIT 5;

-- Query 17: User-Defined Function - Get tax age
DELIMITER //
CREATE FUNCTION GetTaxAge(created_at DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_at);
END //
DELIMITER ;
SELECT tax_id, created_at, GetTaxAge(created_at) AS tax_age_days
FROM Taxes
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get order tax count
DELIMITER //
CREATE FUNCTION GetOrderTaxCount(order_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Taxes WHERE order_id = order_id);
END //
DELIMITER ;
SELECT tax_id, order_id, GetOrderTaxCount(order_id) AS tax_count
FROM Taxes
LIMIT 5;

-- Query 19: User-Defined Function - Calculate tax percentage
DELIMITER //
CREATE FUNCTION CalculateTaxPercentage(tax_amount DECIMAL(10,2), total_price DECIMAL(10,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN (tax_amount / total_price) * 100;
END //
DELIMITER ;
SELECT t.tax_id, t.tax_amount, CalculateTaxPercentage(t.tax_amount, (SELECT total_price FROM Orders o WHERE o.order_id = t.order_id)) AS tax_percentage
FROM Taxes t
LIMIT 5;

-- Query 20: User-Defined Function - Get total tax amount
DELIMITER //
CREATE FUNCTION GetTotalTaxAmount(order_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(tax_amount), 0) FROM Taxes WHERE Taxes.order_id = order_id);
END //
DELIMITER ;
SELECT tax_id, order_id, GetTotalTaxAmount(order_id) AS total_tax
FROM Taxes
LIMIT 5;

-- Table 20: Addresses Table Queries
-- Query 1: JOIN - Addresses with Customers and Orders
SELECT a.address_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id
FROM Addresses a
INNER JOIN Customers c ON a.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 2: JOIN - Addresses with Shipments and Orders
SELECT a.address_id, s.shipment_id, o.order_id
FROM Addresses a
INNER JOIN Orders o ON a.shipping_address_id = o.address_id
INNER JOIN Shipments s ON o.order_id = s.order_id
LIMIT 5;

-- Query 3: JOIN - Addresses with Employees and Departments
SELECT a.address_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, d.department_name
FROM Addresses a
INNER JOIN Employees e ON a.address_id = e.address_id
INNER JOIN Departments d ON e.department_id = d.department_id
LIMIT 5;

-- Query 4: JOIN - Addresses with Customers and Subscriptions
SELECT a.address_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, s.subscription_type
FROM Addresses a
INNER JOIN Customers c ON a.customer_id = c.customer_id
INNER JOIN Subscriptions s ON c.customer_id = s.customer_id
LIMIT 5;

-- Query 5: JOIN - Addresses with Transactions and Customers
SELECT a.address_id, t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Addresses a
INNER JOIN Customers c ON a.customer_id = c.customer_id
INNER JOIN Transactions t ON c.customer_id = t.customer_id
LIMIT 5;

-- Query 6: Subquery - Default addresses
SELECT address_id, customer_id
FROM Addresses
WHERE is_default = TRUE
LIMIT 5;

-- Query 7: Subquery - Addresses with recent orders
SELECT address_id, customer_id,
       (SELECT COUNT(*) FROM Orders o WHERE o.shipping_address_id = a.address_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS order_count
FROM Addresses a
WHERE (SELECT COUNT(*) FROM Orders o WHERE o.shipping_address_id = a.address_id AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - Addresses for active customers
SELECT address_id, customer_id
FROM Addresses
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 9: Subquery - Addresses with no returns
SELECT address_id, customer_id
FROM Addresses
WHERE address_id NOT IN (SELECT shipping_address_id FROM Orders o JOIN Returns r ON o.order_id = r.order_id)
LIMIT 5;

-- Query 10: Subquery - Addresses with multiple orders
SELECT address_id, customer_id
FROM Addresses
WHERE address_id IN (SELECT shipping_address_id FROM Orders GROUP BY shipping_address_id HAVING COUNT(*) > 1)
LIMIT 5;

-- Query 11: Built-in Function - Formatted street
SELECT address_id, REPLACE(street, ' ', '-') AS formatted_street
FROM Addresses
LIMIT 5;

-- Query 12: Built-in Function - Uppercase city
SELECT address_id, UPPER(city) AS uppercase_city
FROM Addresses
LIMIT 5;

-- Query 13: Built-in Function - Zip code length
SELECT address_id, LENGTH(zip_code) AS zip_length
FROM Addresses
WHERE zip_code IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Address status
SELECT address_id,
       CASE 
           WHEN is_default = TRUE THEN 'Default'
           ELSE 'Non-Default'
       END AS status
FROM Addresses
LIMIT 5;

-- Query 15: Built-in Function - Formatted country
SELECT address_id, UPPER(country) AS uppercase_country
FROM Addresses
LIMIT 5;

-- Query 16: User-Defined Function - Format street name
DELIMITER //
CREATE FUNCTION FormatStreetName(street VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(street, 1)), LOWER(SUBSTRING(street, 2)));
END //
DELIMITER ;
SELECT address_id, street, FormatStreetName(street) AS formatted_street
FROM Addresses
LIMIT 5;

-- Query 17: User-Defined Function - Get address age
DELIMITER //
CREATE FUNCTION GetAddressAge(created_at DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_at);
END //
DELIMITER ;
SELECT address_id, created_at, GetAddressAge(created_at) AS address_age_days
FROM Addresses
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetAddressOrderCount(addr_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE shipping_address_id = addr_id);
END //
DELIMITER ;
SELECT address_id, GetAddressOrderCount(address_id) AS order_count
FROM Addresses
LIMIT 5;

-- Query 19: User-Defined Function - Format full address
DELIMITER //
CREATE FUNCTION FormatFullAddress(street VARCHAR(100), city VARCHAR(50), country VARCHAR(50))
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    RETURN CONCAT(street, ', ', city, ', ', country);
END //
DELIMITER ;
SELECT address_id, FormatFullAddress(street, city, country) AS full_address
FROM Addresses
LIMIT 5;

-- Query 20: User-Defined Function - Get customer address count
DELIMITER //
CREATE FUNCTION GetCustomerAddressCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Addresses WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT address_id, customer_id, GetCustomerAddressCount(customer_id) AS address_count
FROM Addresses
LIMIT 5;

-- Table 21: Subscriptions Table Queries
-- Query 1: JOIN - Subscriptions with Customers and Payments
SELECT s.subscription_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.payment_amount
FROM Subscriptions s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Payments p ON s.subscription_id = p.subscription_id
LIMIT 5;

-- Query 2: JOIN - Subscriptions with Orders and Customers
SELECT s.subscription_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Subscriptions s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 3: JOIN - Subscriptions with Addresses and Customers
SELECT s.subscription_id, a.street_address, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Subscriptions s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Addresses a ON c.customer_id = a.customer_id
LIMIT 5;

-- Query 4: JOIN - Subscriptions with Transactions and Payments
SELECT s.subscription_id, t.transaction_id, p.payment_amount
FROM Subscriptions s
INNER JOIN Payments p ON s.subscription_id = p.subscription_id
INNER JOIN Transactions t ON p.payment_id = t.payment_id
LIMIT 5;

-- Query 5: JOIN - Subscriptions with Feedback and Customers
SELECT s.subscription_id, f.feedback_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Subscriptions s
INNER JOIN Customers c ON s.customer_id = c.customer_id
INNER JOIN Feedback f ON c.customer_id = f.customer_id
LIMIT 5;

-- Query 6: Subquery - Active subscriptions
SELECT subscription_id, customer_id
FROM Subscriptions
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Recent subscriptions
SELECT subscription_id, customer_id,
       (SELECT COUNT(*) FROM Subscriptions s2 WHERE s2.customer_id = s.customer_id AND s2.start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS sub_count
FROM Subscriptions s
WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Subscriptions with high fees
SELECT subscription_id, subscription_fee
FROM Subscriptions
WHERE subscription_fee > (SELECT AVG(subscription_fee) FROM Subscriptions)
LIMIT 5;

-- Query 9: Subquery - Subscriptions with no cancellations
SELECT subscription_id, customer_id
FROM Subscriptions
WHERE end_date IS NULL
LIMIT 5;

-- Query 10: Subquery - Subscriptions by active customers
SELECT subscription_id, customer_id
FROM Subscriptions
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted start date
SELECT subscription_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_start
FROM Subscriptions
WHERE start_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded subscription fee
SELECT subscription_id, ROUND(subscription_fee) AS rounded_fee
FROM Subscriptions
LIMIT 5;

-- Query 13: Built-in Function - Uppercase subscription type
SELECT subscription_id, UPPER(subscription_type) AS uppercase_type
FROM Subscriptions
LIMIT 5;

-- Query 14: Built-in Function - Subscription status
SELECT subscription_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Subscriptions
LIMIT 5;

-- Query 15: Built-in Function - Formatted end date
SELECT subscription_id, DATE_FORMAT(end_date, '%M %d, %Y') AS formatted_end
FROM Subscriptions
WHERE end_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format subscription type
DELIMITER //
CREATE FUNCTION FormatSubscriptionType(sub_type VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(sub_type, 1)), LOWER(SUBSTRING(sub_type, 2)));
END //
DELIMITER ;
SELECT subscription_id, subscription_type, FormatSubscriptionType(subscription_type) AS formatted_type
FROM Subscriptions
LIMIT 5;

-- Query 17: User-Defined Function - Get subscription duration
DELIMITER //
CREATE FUNCTION GetSubscriptionDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(COALESCE(end_date, CURDATE()), start_date);
END //
DELIMITER ;
SELECT subscription_id, start_date, end_date, GetSubscriptionDuration(start_date, end_date) AS duration_days
FROM Subscriptions
LIMIT 5;

-- Query 18: User-Defined Function - Get subscription payment count
DELIMITER //
CREATE FUNCTION GetSubscriptionPaymentCount(sub_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Payments WHERE subscription_id = sub_id);
END //
DELIMITER ;
SELECT subscription_id, GetSubscriptionPaymentCount(subscription_id) AS payment_count
FROM Subscriptions
LIMIT 5;

-- Query 19: User-Defined Function - Get total subscription fees
DELIMITER //
CREATE FUNCTION GetTotalSubscriptionFees(cust_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(SUM(subscription_fee), 0) FROM Subscriptions WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT subscription_id, customer_id, GetTotalSubscriptionFees(customer_id) AS total_fees
FROM Subscriptions
LIMIT 5;

-- Query 20: User-Defined Function - Get days since subscription start
DELIMITER //
CREATE FUNCTION GetDaysSinceSubStart(start_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), start_date);
END //
DELIMITER ;
SELECT subscription_id, start_date, GetDaysSinceSubStart(start_date) AS days_since_start
FROM Subscriptions
WHERE start_date IS NOT NULL
LIMIT 5;

-- Table 22: GiftCards Table Queries
-- Query 1: JOIN - GiftCards with Customers and Transactions
SELECT g.card_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, t.transaction_id
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id
INNER JOIN Transactions t ON g.customer_id = t.customer_id
LIMIT 5;

-- Query 2: JOIN - GiftCards with Payments and Customers
SELECT g.card_id, p.payment_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id
INNER JOIN Payments p ON c.customer_id = p.customer_id
LIMIT 5;

-- Query 3: JOIN - GiftCards with Orders and Customers
SELECT g.card_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 4: JOIN - GiftCards with Subscriptions and Customers
SELECT g.card_id, s.subscription_type, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id
INNER JOIN Subscriptions s ON c.customer_id = s.customer_id
LIMIT 5;

-- Query 5: JOIN - GiftCards with Feedback and Customers
SELECT g.card_id, f.feedback_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id
INNER JOIN Feedback f ON c.customer_id = f.customer_id
LIMIT 5;

-- Query 6: Subquery - Active gift cards
SELECT card_id, balance
FROM GiftCards
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - GiftCards with recent transactions
SELECT card_id, customer_id,
       (SELECT COUNT(*) FROM Transactions t WHERE t.customer_id = g.customer_id AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS trans_count
FROM GiftCards g
WHERE (SELECT COUNT(*) FROM Transactions t WHERE t.customer_id = g.customer_id AND t.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) > 0
LIMIT 5;

-- Query 8: Subquery - GiftCards with high balance
SELECT card_id, balance
FROM GiftCards
WHERE balance > (SELECT AVG(balance) FROM GiftCards)
LIMIT 5;

-- Query 9: Subquery - GiftCards with no orders
SELECT card_id, customer_id
FROM GiftCards
WHERE customer_id NOT IN (SELECT customer_id FROM Orders)
LIMIT 5;

-- Query 10: Subquery - GiftCards by active customers
SELECT card_id, customer_id
FROM GiftCards
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted issue date
SELECT card_id, DATE_FORMAT(issue_date, '%M %d, %Y') AS formatted_date
FROM GiftCards
WHERE issue_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded balance
SELECT card_id, ROUND(balance) AS rounded_balance
FROM GiftCards
LIMIT 5;

-- Query 13: Built-in Function - Uppercase card code
SELECT card_id, UPPER(card_code) AS uppercase_code
FROM GiftCards
WHERE card_code IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Gift card status
SELECT card_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM GiftCards
LIMIT 5;

-- Query 15: Built-in Function - Formatted expiry date
SELECT card_id, DATE_FORMAT(expiry_date, '%M %d, %Y') AS formatted_expiry
FROM GiftCards
WHERE expiry_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format card code
DELIMITER //
CREATE FUNCTION FormatCardCode(card_code VARCHAR(20))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN UPPER(card_code);
END //
DELIMITER ;
SELECT card_id, card_code, FormatCardCode(card_code) AS formatted_code
FROM GiftCards
WHERE card_code IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get gift card age
DELIMITER //
CREATE FUNCTION GetGiftCardAge(issue_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), issue_date);
END //
DELIMITER ;
SELECT card_id, issue_date, GetGiftCardAge(issue_date) AS card_age_days
FROM GiftCards
WHERE issue_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get days to expiry
DELIMITER //
CREATE FUNCTION GetDaysToExpiry(expiry_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expiry_date, CURDATE());
END //
DELIMITER ;
SELECT card_id, expiry_date, GetDaysToExpiry(expiry_date) AS days_to_expiry
FROM GiftCards
WHERE expiry_date IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get gift card transaction count
DELIMITER //
CREATE FUNCTION GetGiftCardTransactionCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Transactions WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT card_id, customer_id, GetGiftCardTransactionCount(customer_id) AS transaction_count
FROM GiftCards
LIMIT 5;

-- Query 20: User-Defined Function - Get gift card balance status
DELIMITER //
CREATE FUNCTION GetGiftCardBalanceStatus(balance DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF balance > 50 THEN
        RETURN 'High';
    ELSE
        RETURN 'Low';
    END IF;
END //
DELIMITER ;
SELECT card_id, balance, GetGiftCardBalanceStatus(balance) AS balance_status
FROM GiftCards
LIMIT 5;

-- Table 23: Coupons Table Queries
-- Query 1: JOIN - Coupons with Customers and Orders
SELECT c.coupon_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id
FROM Coupons c
INNER JOIN Customers c ON c.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 2: JOIN - Coupons with Transactions and Customers
SELECT c.coupon_id, t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Coupons c
INNER JOIN Customers c ON c.customer_id = c.customer_id
INNER JOIN Transactions t ON c.customer_id = t.customer_id
LIMIT 5;

-- Query 3: JOIN - Coupons with Payments and Customers
SELECT c.coupon_id, p.payment_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Coupons c
INNER JOIN Customers c ON c.customer_id = c.customer_id
INNER JOIN Payments p ON c.customer_id = p.customer_id
LIMIT 5;

-- Query 4: JOIN - Coupons with Subscriptions and Customers
SELECT c.coupon_id, s.subscription_type, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Coupons c
INNER JOIN Customers c ON c.customer_id = c.customer_id
INNER JOIN Subscriptions s ON c.customer_id = s.customer_id
LIMIT 5;

-- Query 5: JOIN - Coupons with Discounts and Products
SELECT c.coupon_id, d.discount_percentage, p.product_name
FROM Coupons c
INNER JOIN Discounts d ON c.coupon_id = d.coupon_id
INNER JOIN Products p ON d.product_id = p.product_id
LIMIT 5;

-- Query 6: Subquery - Active coupons
SELECT coupon_id, discount_value
FROM Coupons
WHERE is_active = TRUE
LIMIT 5;

-- Query 7: Subquery - Recent coupons
SELECT coupon_id, customer_id,
       (SELECT COUNT(*) FROM Coupons c2 WHERE c2.customer_id = c.customer_id AND c2.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS coupon_count
FROM Coupons c
WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Coupons with high discount value
SELECT coupon_id, discount_value
FROM Coupons
WHERE discount_value > (SELECT AVG(discount_value) FROM Coupons)
LIMIT 5;

-- Query 9: Subquery - Coupons not used
SELECT coupon_id, customer_id
FROM Coupons
WHERE coupon_id NOT IN (SELECT coupon_id FROM Orders)
LIMIT 5;

-- Query 10: Subquery - Coupons by active customers
SELECT coupon_id, customer_id
FROM Coupons
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted created date
SELECT coupon_id, DATE_FORMAT(created_at, '%M %d, %Y') AS formatted_date
FROM Coupons
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Rounded discount value
SELECT coupon_id, ROUND(discount_value) AS rounded_discount
FROM Coupons
LIMIT 5;

-- Query 13: Built-in Function - Uppercase coupon code
SELECT coupon_id, UPPER(coupon_code) AS uppercase_code
FROM Coupons
WHERE coupon_code IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Coupon status
SELECT coupon_id,
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Coupons
LIMIT 5;

-- Query 15: Built-in Function - Formatted expiry date
SELECT coupon_id, DATE_FORMAT(expiry_date, '%M %d, %Y') AS formatted_expiry
FROM Coupons
WHERE expiry_date IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format coupon code
DELIMITER //
CREATE FUNCTION FormatCouponCode(code VARCHAR(20))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN UPPER(code);
END //
DELIMITER ;
SELECT coupon_id, coupon_code, FormatCouponCode(coupon_code) AS formatted_code
FROM Coupons
WHERE coupon_code IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get coupon age
DELIMITER //
CREATE FUNCTION GetCouponAge(created_at DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_at);
END //
DELIMITER ;
SELECT coupon_id, created_at, GetCouponAge(created_at) AS coupon_age_days
FROM Coupons
WHERE created_at IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get days to coupon expiry
DELIMITER //
CREATE FUNCTION GetDaysToCouponExpiry(expiry_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expiry_date, CURDATE());
END //
DELIMITER ;
SELECT coupon_id, expiry_date, GetDaysToCouponExpiry(expiry_date) AS days_to_expiry
FROM Coupons
WHERE expiry_date IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get coupon usage count
DELIMITER //
CREATE FUNCTION GetCouponUsageCount(coupon_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Orders WHERE coupon_id = coupon_id);
END //
DELIMITER ;
SELECT coupon_id, GetCouponUsageCount(coupon_id) AS usage_count
FROM Coupons
LIMIT 5;

-- Query 20: User-Defined Function - Get customer coupon count
DELIMITER //
CREATE FUNCTION GetCustomerCouponCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Coupons WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT coupon_id, customer_id, GetCustomerCouponCount(customer_id) AS coupon_count
FROM Coupons
LIMIT 5;

-- Table 24: Feedback Table Queries
-- Query 1: JOIN - Feedback with Customers and Employees
SELECT f.feedback_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Feedback f
INNER JOIN Customers c ON f.customer_id = c.customer_id
INNER JOIN Employees e ON f.employee_id = e.employee_id
LIMIT 5;

-- Query 2: JOIN - Feedback with Orders and Customers
SELECT f.feedback_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Feedback f
INNER JOIN Customers c ON f.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 3: JOIN - Feedback with Departments and Employees
SELECT f.feedback_id, d.department_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Feedback f
INNER JOIN Employees e ON f.employee_id = e.employee_id
INNER JOIN Departments d ON e.department_id = d.department_id
LIMIT 5;

-- Query 4: JOIN - Feedback with Subscriptions and Customers
SELECT f.feedback_id, s.subscription_type, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Feedback f
INNER JOIN Customers c ON f.customer_id = c.customer_id
INNER JOIN Subscriptions s ON c.customer_id = s.customer_id
LIMIT 5;

-- Query 5: JOIN - Feedback with Transactions and Customers
SELECT f.feedback_id, t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Feedback f
INNER JOIN Customers c ON f.customer_id = c.customer_id
INNER JOIN Transactions t ON c.customer_id = t.customer_id
LIMIT 5;

-- Query 6: Subquery - Recent feedback
SELECT feedback_id, feedback_date
FROM Feedback
WHERE feedback_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 7: Subquery - Feedback with high ratings
SELECT feedback_id, rating,
       (SELECT COUNT(*) FROM Feedback f2 WHERE f2.customer_id = f.customer_id AND f2.rating > 4) AS high_rating_count
FROM Feedback f
WHERE rating > 4
LIMIT 5;

-- Query 8: Subquery - Feedback by active customers
SELECT feedback_id, customer_id
FROM Feedback
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 9: Subquery - Feedback with no returns
SELECT feedback_id, customer_id
FROM Feedback
WHERE customer_id NOT IN (SELECT customer_id FROM Returns r JOIN Orders o ON r.order_id = o.order_id)
LIMIT 5;

-- Query 10: Subquery - Feedback for active employees
SELECT feedback_id, employee_id
FROM Feedback
WHERE employee_id IN (SELECT employee_id FROM Employees WHERE is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted feedback date
SELECT feedback_id, DATE_FORMAT(feedback_date, '%M %d, %Y') AS formatted_date
FROM Feedback
WHERE feedback_date IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Comment length
SELECT feedback_id, LENGTH(comment) AS comment_length
FROM Feedback
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Rounded rating
SELECT feedback_id, ROUND(rating) AS rounded_rating
FROM Feedback
LIMIT 5;

-- Query 14: Built-in Function - Feedback status
SELECT feedback_id,
       CASE 
           WHEN rating > 3 THEN 'Positive'
           ELSE 'Negative'
       END AS feedback_status
FROM Feedback
LIMIT 5;

-- Query 15: Built-in Function - Uppercase comment
SELECT feedback_id, UPPER(comment) AS uppercase_comment
FROM Feedback
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format feedback comment
DELIMITER //
CREATE FUNCTION FormatFeedbackComment(comment TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(comment, 1)), LOWER(SUBSTRING(comment, 2)));
END //
DELIMITER ;
SELECT feedback_id, comment, FormatFeedbackComment(comment) AS formatted_comment
FROM Feedback
WHERE comment IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get feedback age
DELIMITER //
CREATE FUNCTION GetFeedbackAge(feedback_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), feedback_date);
END //
DELIMITER ;
SELECT feedback_id, feedback_date, GetFeedbackAge(feedback_date) AS feedback_age_days
FROM Feedback
WHERE feedback_date IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get customer feedback count
DELIMITER //
CREATE FUNCTION GetCustomerFeedbackCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Feedback WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT feedback_id, customer_id, GetCustomerFeedbackCount(customer_id) AS feedback_count
FROM Feedback
LIMIT 5;

-- Query 19: User-Defined Function - Get employee feedback count
DELIMITER //
CREATE FUNCTION GetEmployeeFeedbackCount(emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Feedback WHERE employee_id = emp_id);
END //
DELIMITER ;
SELECT feedback_id, employee_id, GetEmployeeFeedbackCount(employee_id) AS feedback_count
FROM Feedback
LIMIT 5;

-- Query 20: User-Defined Function - Get average feedback rating
DELIMITER //
CREATE FUNCTION GetAvgFeedbackRating(cust_id INT)
RETURNS DECIMAL(3,1)
DETERMINISTIC
BEGIN
    RETURN (SELECT COALESCE(AVG(rating), 0) FROM Feedback WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT feedback_id, customer_id, GetAvgFeedbackRating(customer_id) AS avg_rating
FROM Feedback
LIMIT 5;

-- Table 25: Logs Table Queries
-- Query 1: JOIN - Logs with Employees and Departments
SELECT l.log_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, d.department_name
FROM Logs l
INNER JOIN Employees e ON l.employee_id = e.employee_id
INNER JOIN Departments d ON e.department_id = d.department_id
LIMIT 5;

-- Query 2: JOIN - Logs with Customers and Orders
SELECT l.log_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id
FROM Logs l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Orders o ON c.customer_id = o.customer_id
LIMIT 5;

-- Query 3: JOIN - Logs with Transactions and Customers
SELECT l.log_id, t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Logs l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Transactions t ON c.customer_id = t.customer_id
LIMIT 5;

-- Query 4: JOIN - Logs with Payments and Customers
SELECT l.log_id, p.payment_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Logs l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Payments p ON c.customer_id = p.customer_id
LIMIT 5;

-- Query 5: JOIN - Logs with Feedback and Customers
SELECT l.log_id, f.feedback_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Logs l
INNER JOIN Customers c ON l.customer_id = c.customer_id
INNER JOIN Feedback f ON c.customer_id = f.customer_id
LIMIT 5;

-- Query 6: Subquery - Recent logs
SELECT log_id, log_timestamp
FROM Logs
WHERE log_timestamp >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 7: Subquery - Logs by employee with count
SELECT log_id, employee_id,
       (SELECT COUNT(*) FROM Logs l2 WHERE l2.employee_id = l.employee_id AND l2.log_timestamp >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS log_count
FROM Logs l
WHERE log_timestamp >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
LIMIT 5;

-- Query 8: Subquery - Logs for active customers
SELECT log_id, customer_id
FROM Logs
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE is_active = TRUE)
LIMIT 5;

-- Query 9: Subquery - Logs with no errors
SELECT log_id, action_type
FROM Logs
WHERE log_id NOT IN (SELECT log_id FROM Logs WHERE action_type LIKE '%Error%')
LIMIT 5;

-- Query 10: Subquery - Logs by active departments
SELECT log_id, employee_id
FROM Logs
WHERE employee_id IN (SELECT employee_id FROM Employees e JOIN Departments d ON e.department_id = d.department_id WHERE d.is_active = TRUE)
LIMIT 5;

-- Query 11: Built-in Function - Formatted log timestamp
SELECT log_id, DATE_FORMAT(log_timestamp, '%M %d, %Y %H:%i') AS formatted_timestamp
FROM Logs
WHERE log_timestamp IS NOT NULL
LIMIT 5;

-- Query 12: Built-in Function - Action type length
SELECT log_id, LENGTH(action_type) AS action_length
FROM Logs
WHERE action_type IS NOT NULL
LIMIT 5;

-- Query 13: Built-in Function - Uppercase action type
SELECT log_id, UPPER(action_type) AS uppercase_action
FROM Logs
WHERE action_type IS NOT NULL
LIMIT 5;

-- Query 14: Built-in Function - Log status
SELECT log_id,
       CASE 
           WHEN action_type LIKE '%Error%' THEN 'Error'
           ELSE 'Success'
       END AS log_status
FROM Logs
LIMIT 5;

-- Query 15: Built-in Function - Extract hour from timestamp
SELECT log_id, HOUR(log_timestamp) AS log_hour
FROM Logs
WHERE log_timestamp IS NOT NULL
LIMIT 5;

-- Query 16: User-Defined Function - Format action type
DELIMITER //
CREATE FUNCTION FormatLogActionType(action_type VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(action_type, 1)), LOWER(SUBSTRING(action_type, 2)));
END //
DELIMITER ;
SELECT log_id, action_type, FormatLogActionType(action_type) AS formatted_action
FROM Logs
WHERE action_type IS NOT NULL
LIMIT 5;

-- Query 17: User-Defined Function - Get log age
DELIMITER //
CREATE FUNCTION GetLogAge(log_timestamp DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(DAY, log_timestamp, NOW());
END //
DELIMITER ;
SELECT log_id, log_timestamp, GetLogAge(log_timestamp) AS log_age_days
FROM Logs
WHERE log_timestamp IS NOT NULL
LIMIT 5;

-- Query 18: User-Defined Function - Get employee log count
DELIMITER //
CREATE FUNCTION GetEmployeeLogCount(emp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Logs WHERE employee_id = emp_id);
END //
DELIMITER ;
SELECT log_id, employee_id, GetEmployeeLogCount(employee_id) AS log_count
FROM Logs
WHERE employee_id IS NOT NULL
LIMIT 5;

-- Query 19: User-Defined Function - Get customer log count
DELIMITER //
CREATE FUNCTION GetCustomerLogCount(cust_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) FROM Logs WHERE customer_id = cust_id);
END //
DELIMITER ;
SELECT log_id, customer_id, GetCustomerLogCount(customer_id) AS log_count
FROM Logs
WHERE customer_id IS NOT NULL
LIMIT 5;

-- Query 20: User-Defined Function - Get log action category
DELIMITER //
CREATE FUNCTION GetLogActionCategory(action_type VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF action_type LIKE '%Error%' THEN
        RETURN 'Error';
    ELSEIF action_type LIKE '%Login%' THEN
        RETURN 'Authentication';
    ELSE
        RETURN 'General';
    END IF;
END //
DELIMITER ;
SELECT log_id, action_type, GetLogActionCategory(action_type) AS action_category
FROM Logs
WHERE action_type IS NOT NULL
LIMIT 5;
