-- Project Phase-3 (A<Joins<SQ<Fun<B&UD)

-- Table 1: Products
-- Query 1: JOIN - Products with Categories and Suppliers
SELECT p.product_id, p.product_name, c.category_name, s.supplier_name, p.price
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.category_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE;

-- Query 2: JOIN - Products with Orders and Customers
SELECT p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_date, o.quantity
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 3: JOIN - Products with Reviews and Customers
SELECT p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS reviewer, r.rating, r.comment
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- Query 4: JOIN - Products with Inventory and Warehouses
SELECT p.product_name, w.warehouse_name, i.quantity, i.status
FROM Products p
LEFT JOIN Inventory i ON p.product_id = i.product_id
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- Query 5: JOIN - Products with Promotions and Discounts
SELECT p.product_name, pr.promotion_name, d.discount_percentage, p.price
FROM Products p
LEFT JOIN Promotions pr ON p.product_id = pr.product_id
LEFT JOIN Discounts d ON p.product_id = d.product_id;

-- Query 6: Subquery - Products in a specific category
SELECT product_id, product_name
FROM Products
WHERE category_id IN (SELECT category_id FROM Categories);

-- Query 7: Subquery - Products with any reviews
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Reviews r WHERE r.product_id = Products.product_id);

-- Query 8: Subquery - Products with any orders
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Products.product_id);

-- Query 9: Subquery - Products with stock in inventory
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Inventory i WHERE i.product_id = Products.product_id AND i.quantity > 0);

-- Query 10: Subquery - Products supplied by a supplier
SELECT product_name
FROM Products
WHERE supplier_id IN (SELECT supplier_id FROM Suppliers);

-- Query 11: Built-in Function - Product name length
SELECT product_name, LENGTH(product_name) AS name_length
FROM Products
WHERE LENGTH(product_name) > 5;

-- Query 12: Built-in Function - Formatted release date
SELECT product_name, DATE_FORMAT(release_date, '%M %d, %Y') AS formatted_date
FROM Products
WHERE release_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded price
SELECT product_name, ROUND(price) AS rounded_price
FROM Products
WHERE price > 0;

-- Query 14: Built-in Function - Uppercase product name
SELECT UPPER(product_name) AS uppercase_name
FROM Products;

-- Query 15: Built-in Function - Stock quantity status
SELECT product_name, 
       CASE 
           WHEN stock_quantity < 50 THEN 'Low'
           WHEN stock_quantity BETWEEN 50 AND 100 THEN 'Medium'
           ELSE 'High'
       END AS stock_status
FROM Products;

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
WHERE price > 0;

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
FROM Products;

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
FROM Products;

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
WHERE price > 0;

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
WHERE release_date IS NOT NULL;


-- Table 2: Customers Table Queries
-- Query 1: JOIN - Customers with Orders and Products
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id, p.product_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 2: JOIN - Customers with Addresses and Shipments
SELECT c.email, a.address_line1, s.tracking_number
FROM Customers c
LEFT JOIN Addresses a ON c.customer_id = a.customer_id
LEFT JOIN Shipments s ON a.address_id = s.address_id;

-- Query 3: JOIN - Customers with Reviews and Products
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name, r.rating
FROM Customers c
LEFT JOIN Reviews r ON c.customer_id = r.customer_id
LEFT JOIN Products p ON r.product_id = p.product_id;

-- Query 4: JOIN - Customers with Subscriptions and Payments
SELECT c.email, s.subscription_plan, p.payment_amount
FROM Customers c
LEFT JOIN Subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN Payments p ON s.subscription_id = p.subscription_id;

-- Query 5: JOIN - Customers with Wishlists and Products
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, w.added_date, p.product_name
FROM Customers c
LEFT JOIN Wishlists w ON c.customer_id = w.customer_id
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 6: Subquery - Customers with any orders
SELECT first_name, last_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.customer_id = Customers.customer_id);

-- Query 7: Subquery - Customers with any reviews
SELECT email
FROM Customers
WHERE EXISTS (SELECT 1 FROM Reviews r WHERE r.customer_id = Customers.customer_id);

-- Query 8: Subquery - Customers with active subscriptions
SELECT first_name, last_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Subscriptions s WHERE s.customer_id = Customers.customer_id AND s.status = 'Active');

-- Query 9: Subquery - Customers with addresses
SELECT email
FROM Customers
WHERE EXISTS (SELECT 1 FROM Addresses a WHERE a.customer_id = Customers.customer_id);

-- Query 10: Subquery - Customers with wishlists
SELECT first_name, last_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Wishlists w WHERE w.customer_id = Customers.customer_id);

-- Query 11: Built-in Function - Customer full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM Customers;

-- Query 12: Built-in Function - Email length
SELECT email, LENGTH(email) AS email_length
FROM Customers
WHERE LENGTH(email) > 5;

-- Query 13: Built-in Function - Registration date formatted
SELECT first_name, DATE_FORMAT(registration_date, '%M %d, %Y') AS formatted_date
FROM Customers
WHERE registration_date IS NOT NULL;

-- Query 14: Built-in Function - Uppercase city
SELECT UPPER(city) AS city_name
FROM Customers
WHERE city IS NOT NULL;

-- Query 15: Built-in Function - Customer status
SELECT first_name, 
       CASE 
           WHEN registration_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY) THEN 'Long-term'
           ELSE 'New'
       END AS customer_status
FROM Customers;

-- Query 16: User-Defined Function - Get customer full name
DELIMITER //
CREATE FUNCTION GetCustomerFullName(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(first_name, ' ', last_name);
END //
DELIMITER ;
SELECT first_name, last_name, GetCustomerFullName(first_name, last_name) AS full_name
FROM Customers;

-- Query 17: User-Defined Function - Check long-term customer
DELIMITER //
CREATE FUNCTION IsLongTermCustomer(reg_date DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), reg_date) > 365 THEN
        RETURN 'Long-term';
    ELSE
        RETURN 'New';
    END IF;
END //
DELIMITER ;
SELECT first_name, registration_date, IsLongTermCustomer(registration_date) AS customer_status
FROM Customers;

-- Query 18: User-Defined Function - Format email
DELIMITER //
CREATE FUNCTION FormatCustomerEmail(email VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN LOWER(email);
END //
DELIMITER ;
SELECT email, FormatCustomerEmail(email) AS formatted_email
FROM Customers;

-- Query 19: User-Defined Function - Calculate customer age
DELIMITER //
CREATE FUNCTION GetCustomerAge(reg_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), reg_date);
END //
DELIMITER ;
SELECT first_name, registration_date, GetCustomerAge(registration_date) AS days_registered
FROM Customers;

-- Query 20: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetCustomerOrderCount(customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM Orders WHERE customer_id = customer_id;
    RETURN order_count;
END //
DELIMITER ;
SELECT first_name, GetCustomerOrderCount(customer_id) AS order_count
FROM Customers;

-- Table 3: Orders Table Queries
-- Query 1: JOIN - Orders with Customers and Products
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Orders o
LEFT JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 2: JOIN - Orders with Shipments and Addresses
SELECT o.order_id, s.tracking_number, a.address_line1
FROM Orders o
LEFT JOIN Shipments s ON o.order_id = s.order_id
LEFT JOIN Addresses a ON s.address_id = a.address_id;

-- Query 3: JOIN - Orders with Payments and Customers
SELECT o.order_id, p.payment_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 4: JOIN - Orders with Returns and Products
SELECT o.order_id, r.reason, p.product_name
FROM Orders o
LEFT JOIN Returns r ON o.order_id = r.order_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 5: JOIN - Orders with Taxes and Customers
SELECT o.order_id, t.tax_amount, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Orders o
LEFT JOIN Taxes t ON o.order_id = t.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 6: Subquery - Orders with any payments
SELECT order_id, total_price
FROM Orders
WHERE EXISTS (SELECT 1 FROM Payments p WHERE p.order_id = Orders.order_id);

-- Query 7: Subquery - Orders from specific customers
SELECT order_id
FROM Orders
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Orders with shipments
SELECT order_id
FROM Orders
WHERE EXISTS (SELECT 1 FROM Shipments s WHERE s.order_id = Orders.order_id);

-- Query 9: Subquery - Orders with no returns
SELECT order_id
FROM Orders
WHERE NOT EXISTS (SELECT 1 FROM Returns r WHERE r.order_id = Orders.order_id);

-- Query 10: Subquery - Orders for specific products
SELECT order_id
FROM Orders
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 11: Built-in Function - Total price rounded
SELECT order_id, ROUND(total_price) AS rounded_total
FROM Orders
WHERE total_price > 0;

-- Query 12: Built-in Function - Order date formatted
SELECT order_id, DATE_FORMAT(order_date, '%M %d, %Y') AS formatted_date
FROM Orders
WHERE order_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS order_status
FROM Orders;

-- Query 14: Built-in Function - Order quantity status
SELECT order_id, 
       CASE 
           WHEN quantity < 5 THEN 'Small'
           WHEN quantity BETWEEN 5 AND 10 THEN 'Medium'
           ELSE 'Large'
       END AS order_size
FROM Orders;

-- Query 15: Built-in Function - Address length
SELECT order_id, LENGTH(shipping_address) AS address_length
FROM Orders
WHERE shipping_address IS NOT NULL;

-- Query 16: User-Defined Function - Calculate order total with tax
DELIMITER //
CREATE FUNCTION CalculateOrderTotalWithTax(total_price DECIMAL(10,2), tax_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN total_price * (1 + tax_rate / 100);
END //
DELIMITER ;
SELECT order_id, total_price, CalculateOrderTotalWithTax(total_price, 8.00) AS total_with_tax
FROM Orders
WHERE total_price > 0;

-- Query 17: User-Defined Function - Check order status
DELIMITER //
CREATE FUNCTION CheckOrderStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Delivered' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT order_id, status, CheckOrderStatus(status) AS order_status
FROM Orders;

-- Query 18: User-Defined Function - Format customer name
DELIMITER //
CREATE FUNCTION FormatCustomerNameForOrder(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT order_id, FormatCustomerNameForOrder(customer_id) AS customer_name
FROM Orders;

-- Query 19: User-Defined Function - Calculate order age
DELIMITER //
CREATE FUNCTION GetOrderAge(order_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), order_date);
END //
DELIMITER ;
SELECT order_id, order_date, GetOrderAge(order_date) AS order_age_in_days
FROM Orders
WHERE order_date IS NOT NULL;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetProductNameForOrder(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT order_id, GetProductNameForOrder(product_id) AS product_name
FROM Orders;

-- Table 4: Suppliers Table Queries
-- Query 1: JOIN - Suppliers with Products and Categories
SELECT s.supplier_name, p.product_name, c.category_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Suppliers with Inventory and Warehouses
SELECT s.supplier_name, i.quantity, w.warehouse_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
LEFT JOIN Inventory i ON p.product_id = i.product_id
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- Query 3: JOIN - Suppliers with Orders and Products
SELECT s.supplier_name, o.order_id, p.product_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
LEFT JOIN Orders o ON p.product_id = o.product_id;

-- Query 4: JOIN - Suppliers with Reviews and Products
SELECT s.supplier_name, r.rating, p.product_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
LEFT JOIN Reviews r ON p.product_id = r.product_id;

-- Query 5: JOIN - Suppliers with Promotions and Products
SELECT s.supplier_name, pr.promotion_name, p.product_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
LEFT JOIN Promotions pr ON p.product_id = pr.product_id;

-- Query 6: Subquery - Suppliers with active products
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Products p WHERE p.supplier_id = Suppliers.supplier_id AND p.is_active = TRUE);

-- Query 7: Subquery - Suppliers with inventory stock
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE p.supplier_id = Suppliers.supplier_id);

-- Query 8: Subquery - Suppliers with ordered products
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.supplier_id = Suppliers.supplier_id);

-- Query 9: Subquery - Suppliers with no inactive products
SELECT supplier_name
FROM Suppliers
WHERE NOT EXISTS (SELECT 1 FROM Products p WHERE p.supplier_id = Suppliers.supplier_id AND p.is_active = FALSE);

-- Query 10: Subquery - Suppliers in specific cities
SELECT supplier_name
FROM Suppliers
WHERE city IN (SELECT city FROM Warehouses);

-- Query 11: Built-in Function - Supplier name length
SELECT supplier_name, LENGTH(supplier_name) AS name_length
FROM Suppliers
WHERE LENGTH(supplier_name) > 5;

-- Query 12: Built-in Function - Contract date formatted
SELECT supplier_name, DATE_FORMAT(contract_date, '%M %d, %Y') AS formatted_date
FROM Suppliers
WHERE contract_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase supplier name
SELECT UPPER(supplier_name) AS uppercase_name
FROM Suppliers;

-- Query 14: Built-in Function - Email length
SELECT contact_email, LENGTH(contact_email) AS email_length
FROM Suppliers
WHERE contact_email IS NOT NULL;

-- Query 15: Built-in Function - Supplier status
SELECT supplier_name, 
       CASE 
           WHEN contract_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY) THEN 'Established'
           ELSE 'New'
       END AS supplier_status
FROM Suppliers;

-- Query 16: User-Defined Function - Get supplier full name
DELIMITER //
CREATE FUNCTION GetSupplierFullName(supplier_name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(supplier_name);
END //
DELIMITER ;
SELECT supplier_name, GetSupplierFullName(supplier_name) AS formatted_name
FROM Suppliers;

-- Query 17: User-Defined Function - Check established supplier
DELIMITER //
CREATE FUNCTION IsEstablishedSupplier(contract_date DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), contract_date) > 365 THEN
        RETURN 'Established';
    ELSE
        RETURN 'New';
    END IF;
END //
DELIMITER ;
SELECT supplier_name, contract_date, IsEstablishedSupplier(contract_date) AS supplier_status
FROM Suppliers;

-- Query 18: User-Defined Function - Format supplier email
DELIMITER //
CREATE FUNCTION FormatSupplierEmail(email VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN LOWER(email);
END //
DELIMITER ;
SELECT contact_email, FormatSupplierEmail(contact_email) AS formatted_email
FROM Suppliers;

-- Query 19: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetSupplierProductCount(supplier_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE prod_count INT;
    SELECT COUNT(*) INTO prod_count FROM Products WHERE supplier_id = supplier_id;
    RETURN prod_count;
END //
DELIMITER ;
SELECT supplier_name, GetSupplierProductCount(supplier_id) AS product_count
FROM Suppliers;

-- Query 20: User-Defined Function - Get supplier city
DELIMITER //
CREATE FUNCTION GetSupplierCity(supplier_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE supp_city VARCHAR(50);
    SELECT city INTO supp_city FROM Suppliers WHERE supplier_id = supplier_id;
    RETURN supp_city;
END //
DELIMITER ;
SELECT supplier_name, GetSupplierCity(supplier_id) AS city
FROM Suppliers;

-- Table 5: Categories Table Queries
-- Query 1: JOIN - Categories with Products and Suppliers
SELECT c.category_name, p.product_name, s.supplier_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 2: JOIN - Categories with Parent Categories
SELECT c.category_name, c2.category_name AS parent_category
FROM Categories c
LEFT JOIN Categories c2 ON c.parent_category_id = c2.category_id;

-- Query 3: JOIN - Categories with Orders and Products
SELECT c.category_name, o.order_id, p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Orders o ON p.product_id = o.product_id;

-- Query 4: JOIN - Categories with Inventory and Products
SELECT c.category_name, i.quantity, p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Inventory i ON p.product_id = i.product_id;

-- Query 5: JOIN - Categories with Reviews and Products
SELECT c.category_name, r.rating, p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Reviews r ON p.product_id = r.product_id;

-- Query 6: Subquery - Categories with active products
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Products p WHERE p.category_id = Categories.category_id AND p.is_active = TRUE);

-- Query 7: Subquery - Categories with ordered products
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE p.category_id = Categories.category_id);

-- Query 8: Subquery - Categories with inventory stock
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE p.category_id = Categories.category_id);

-- Query 9: Subquery - Categories with no parent
SELECT category_name
FROM Categories
WHERE parent_category_id IS NULL;

-- Query 10: Subquery - Categories with reviews
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Reviews r JOIN Products p ON r.product_id = p.product_id WHERE p.category_id = Categories.category_id);

-- Query 11: Built-in Function - Category name length
SELECT category_name, LENGTH(category_name) AS name_length
FROM Categories
WHERE LENGTH(category_name) > 5;

-- Query 12: Built-in Function - Created date formatted
SELECT category_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Categories
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase category name
SELECT UPPER(category_name) AS uppercase_name
FROM Categories;

-- Query 14: Built-in Function - Description length
SELECT category_name, LENGTH(description) AS desc_length
FROM Categories
WHERE description IS NOT NULL;

-- Query 15: Built-in Function - Category status
SELECT category_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS category_status
FROM Categories;

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
FROM Categories;

-- Query 17: User-Defined Function - Check active category
DELIMITER //
CREATE FUNCTION IsActiveCategory(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT category_name, is_active, IsActiveCategory(is_active) AS category_status
FROM Categories;

-- Query 18: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetCategoryProductCount(category_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE prod_count INT;
    SELECT COUNT(*) INTO prod_count FROM Products WHERE category_id = category_id;
    RETURN prod_count;
END //
DELIMITER ;
SELECT category_name, GetCategoryProductCount(category_id) AS product_count
FROM Categories;

-- Query 19: User-Defined Function - Get parent category
DELIMITER //
CREATE FUNCTION GetParentCategory(category_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE parent_name VARCHAR(100);
    SELECT category_name INTO parent_name FROM Categories WHERE category_id = (SELECT parent_category_id FROM Categories WHERE category_id = category_id);
    RETURN parent_name;
END //
DELIMITER ;
SELECT category_name, GetParentCategory(category_id) AS parent_category
FROM Categories;

-- Query 20: User-Defined Function - Calculate category age
DELIMITER //
CREATE FUNCTION GetCategoryAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT category_name, created_date, GetCategoryAge(created_date) AS category_age_in_days
FROM Categories
WHERE created_date IS NOT NULL;

-- Table 6: Reviews Table Queries
-- Query 1: JOIN - Reviews with Products and Customers
SELECT r.review_id, p.product_name, CONCAT(c.first_name, ' ', c.last_name) AS reviewer
FROM Reviews r
LEFT JOIN Products p ON r.product_id = p.product_id
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- Query 2: JOIN - Reviews with Orders and Products
SELECT r.review_id, o.order_id, p.product_name
FROM Reviews r
LEFT JOIN Orders o ON r.product_id = o.product_id
LEFT JOIN Products p ON r.product_id = p.product_id;

-- Query 3: JOIN - Reviews with Categories and Products
SELECT r.rating, c.category_name, p.product_name
FROM Reviews r
LEFT JOIN Products p ON r.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 4: JOIN - Reviews with Suppliers and Products
SELECT r.comment, s.supplier_name, p.product_name
FROM Reviews r
LEFT JOIN Products p ON r.product_id = p.product_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 5: JOIN - Reviews with Wishlists and Customers
SELECT r.review_id, w.added_date, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Reviews r
LEFT JOIN Wishlists w ON r.customer_id = w.customer_id
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- Query 6: Subquery - Reviews for active products
SELECT review_id, rating
FROM Reviews
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Reviews by verified customers
SELECT comment
FROM Reviews
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Reviews for ordered products
SELECT review_id
FROM Reviews
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Reviews.product_id);

-- Query 9: Subquery - Reviews with high ratings
SELECT comment
FROM Reviews
WHERE rating >= 4;

-- Query 10: Subquery - Reviews for specific categories
SELECT review_id
FROM Reviews
WHERE product_id IN (SELECT product_id FROM Products p JOIN Categories c ON p.category_id = c.category_id);

-- Query 11: Built-in Function - Comment length
SELECT review_id, LENGTH(comment) AS comment_length
FROM Reviews
WHERE comment IS NOT NULL;

-- Query 12: Built-in Function - Review date formatted
SELECT review_id, DATE_FORMAT(review_date, '%M %d, %Y') AS formatted_date
FROM Reviews
WHERE review_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase comment
SELECT UPPER(comment) AS uppercase_comment
FROM Reviews
WHERE comment IS NOT NULL;

-- Query 14: Built-in Function - Rating status
SELECT review_id, 
       CASE 
           WHEN rating >= 4 THEN 'Positive'
           WHEN rating <= 2 THEN 'Negative'
           ELSE 'Neutral'
       END AS rating_status
FROM Reviews;

-- Query 15: Built-in Function - Verified status
SELECT review_id, 
       IF(is_verified, 'Verified', 'Not Verified') AS verification_status
FROM Reviews;

-- Query 16: User-Defined Function - Format review comment
DELIMITER //
CREATE FUNCTION FormatReviewComment(comment VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(comment, 1)), LOWER(SUBSTRING(comment, 2)));
END //
DELIMITER ;
SELECT review_id, comment, FormatReviewComment(comment) AS formatted_comment
FROM Reviews
WHERE comment IS NOT NULL;

-- Query 17: User-Defined Function - Check high rating
DELIMITER //
CREATE FUNCTION IsHighRating(rating INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF rating >= 4 THEN
        RETURN 'Positive';
    ELSE
        RETURN 'Neutral or Negative';
    END IF;
END //
DELIMITER ;
SELECT review_id, rating, IsHighRating(rating) AS rating_status
FROM Reviews;

-- Query 18: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetReviewProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT review_id, GetReviewProductName(product_id) AS product_name
FROM Reviews;

-- Query 19: User-Defined Function - Calculate review age
DELIMITER //
CREATE FUNCTION GetReviewAge(review_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), review_date);
END //
DELIMITER ;
SELECT review_id, review_date, GetReviewAge(review_date) AS review_age_in_days
FROM Reviews
WHERE review_date IS NOT NULL;

-- Query 20: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetReviewCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT review_id, GetReviewCustomerName(customer_id) AS customer_name
FROM Reviews;

-- Table 7: Payments Table Queries
-- Query 1: JOIN - Payments with Orders and Customers
SELECT p.payment_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Payments p
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 2: JOIN - Payments with Subscriptions and Customers
SELECT p.payment_id, s.subscription_plan, c.email
FROM Payments p
LEFT JOIN Subscriptions s ON p.subscription_id = s.subscription_id
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 3: JOIN - Payments with Taxes and Orders
SELECT p.payment_id, t.tax_amount, o.order_id
FROM Payments p
LEFT JOIN Taxes t ON p.order_id = t.order_id
LEFT JOIN Orders o ON p.order_id = o.order_id;

-- Query 4: JOIN - Payments with GiftCards and Customers
SELECT p.payment_id, g.card_number, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Payments p
LEFT JOIN GiftCards g ON p.gift_card_id = g.gift_card_id
LEFT JOIN Customers c ON g.customer_id = c.customer_id;

-- Query 5: JOIN - Payments with Transactions and Orders
SELECT p.payment_id, t.transaction_id, o.order_id
FROM Payments p
LEFT JOIN Transactions t ON p.payment_id = t.payment_id
LEFT JOIN Orders o ON p.order_id = o.order_id;

-- Query 6: Subquery - Payments for orders
SELECT payment_id, payment_amount
FROM Payments
WHERE order_id IN (SELECT order_id FROM Orders);

-- Query 7: Subquery - Payments for subscriptions
SELECT payment_id
FROM Payments
WHERE subscription_id IN (SELECT subscription_id FROM Subscriptions WHERE status = 'Active');

-- Query 8: Subquery - Payments with transactions
SELECT payment_id
FROM Payments
WHERE EXISTS (SELECT 1 FROM Transactions t WHERE t.payment_id = Payments.payment_id);

-- Query 9: Subquery - Payments with gift cards
SELECT payment_id
FROM Payments
WHERE gift_card_id IN (SELECT gift_card_id FROM GiftCards);

-- Query 10: Subquery - Payments for verified customers
SELECT payment_id
FROM Payments
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id);

-- Query 11: Built-in Function - Payment amount rounded
SELECT payment_id, ROUND(payment_amount) AS rounded_amount
FROM Payments
WHERE payment_amount > 0;

-- Query 12: Built-in Function - Payment date formatted
SELECT payment_id, DATE_FORMAT(payment_date, '%M %d, %Y') AS formatted_date
FROM Payments
WHERE payment_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase payment method
SELECT UPPER(payment_method) AS payment_method
FROM Payments;

-- Query 14: Built-in Function - Payment status
SELECT payment_id, 
       CASE 
           WHEN status = 'Completed' THEN 'Success'
           ELSE 'Pending'
       END AS payment_status
FROM Payments;

-- Query 15: Built-in Function - Transaction ID length
SELECT payment_id, LENGTH(transaction_id) AS trans_id_length
FROM Payments
WHERE transaction_id IS NOT NULL;

-- Query 16: User-Defined Function - Calculate payment with tax
DELIMITER //
CREATE FUNCTION CalculatePaymentWithTax(amount DECIMAL(10,2), tax_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount * (1 + tax_rate / 100);
END //
DELIMITER ;
SELECT payment_id, payment_amount, CalculatePaymentWithTax(payment_amount, 8.00) AS amount_with_tax
FROM Payments
WHERE payment_amount > 0;

-- Query 17: User-Defined Function - Check payment status
DELIMITER //
CREATE FUNCTION CheckPaymentStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Completed' THEN
        RETURN 'Success';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT payment_id, status, CheckPaymentStatus(status) AS payment_status
FROM Payments;

-- Query 18: User-Defined Function - Format payment method
DELIMITER //
CREATE FUNCTION FormatPaymentMethod(method VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(method);
END //
DELIMITER ;
SELECT payment_id, payment_method, FormatPaymentMethod(payment_method) AS formatted_method
FROM Payments;

-- Query 19: User-Defined Function - Get order ID
DELIMITER //
CREATE FUNCTION GetPaymentOrderId(payment_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_id INT;
    SELECT order_id INTO ord_id FROM Payments WHERE payment_id = payment_id;
    RETURN ord_id;
END //
DELIMITER ;
SELECT payment_id, GetPaymentOrderId(payment_id) AS order_id
FROM Payments;

-- Query 20: User-Defined Function - Calculate payment age
DELIMITER //
CREATE FUNCTION GetPaymentAge(payment_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), payment_date);
END //
DELIMITER ;
SELECT payment_id, payment_date, GetPaymentAge(payment_date) AS payment_age_in_days
FROM Payments
WHERE payment_date IS NOT NULL;

-- Table 8: Shipments Table Queries
-- Query 1: JOIN - Shipments with Orders and Customers
SELECT s.tracking_number, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Shipments s
LEFT JOIN Orders o ON s.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 2: JOIN - Shipments with Addresses and Customers
SELECT s.tracking_number, a.address_line1, c.email
FROM Shipments s
LEFT JOIN Addresses a ON s.address_id = a.address_id
LEFT JOIN Customers c ON a.customer_id = c.customer_id;

-- Query 3: JOIN - Shipments with Products and Orders
SELECT s.tracking_number, p.product_name, o.order_id
FROM Shipments s
LEFT JOIN Orders o ON s.order_id = o.order_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 4: JOIN - Shipments with Warehouses and Inventory
SELECT s.tracking_number, w.warehouse_name, i.quantity
FROM Shipments s
LEFT JOIN Inventory i ON s.order_id = i.product_id
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- Query 5: JOIN - Shipments with Taxes and Orders
SELECT s.tracking_number, t.tax_amount, o.order_id
FROM Shipments s
LEFT JOIN Taxes t ON s.order_id = t.order_id
LEFT JOIN Orders o ON s.order_id = o.order_id;

-- Query 6: Subquery - Shipments for orders
SELECT tracking_number
FROM Shipments
WHERE order_id IN (SELECT order_id FROM Orders);

-- Query 7: Subquery - Shipments with addresses
SELECT tracking_number
FROM Shipments
WHERE address_id IN (SELECT address_id FROM Addresses);

-- Query 8: Subquery - Shipments with delivered status
SELECT tracking_number
FROM Shipments
WHERE status = 'Delivered';

-- Query 9: Subquery - Shipments for active customers
SELECT tracking_number
FROM Shipments
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id);

-- Query 10: Subquery - Shipments from warehouses
SELECT tracking_number
FROM Shipments
WHERE EXISTS (SELECT 1 FROM Inventory i JOIN Warehouses w ON i.warehouse_id = w.warehouse_id WHERE i.product_id = s.order_id);

-- Query 11: Built-in Function - Tracking number length
SELECT tracking_number, LENGTH(tracking_number) AS track_length
FROM Shipments
WHERE tracking_number IS NOT NULL;

-- Query 12: Built-in Function - Shipping date formatted
SELECT tracking_number, DATE_FORMAT(shipping_date, '%M %d, %Y') AS formatted_date
FROM Shipments
WHERE shipping_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS shipment_status
FROM Shipments;

-- Query 14: Built-in Function - Delivery date difference
SELECT tracking_number, DATEDIFF(delivery_date, shipping_date) AS days_to_deliver
FROM Shipments
WHERE delivery_date IS NOT NULL AND shipping_date IS NOT NULL;

-- Query 15: Built-in Function - Shipment status
SELECT tracking_number, 
       CASE 
           WHEN status = 'Delivered' THEN 'Completed'
           ELSE 'In Transit'
       END AS shipment_status
FROM Shipments;

-- Query 16: User-Defined Function - Format tracking number
DELIMITER //
CREATE FUNCTION FormatTrackingNumber(track VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(track);
END //
DELIMITER ;
SELECT tracking_number, FormatTrackingNumber(tracking_number) AS formatted_track
FROM Shipments;

-- Query 17: User-Defined Function - Check shipment status
DELIMITER //
CREATE FUNCTION CheckShipmentStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Delivered' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'In Transit';
    END IF;
END //
DELIMITER ;
SELECT tracking_number, status, CheckShipmentStatus(status) AS shipment_status
FROM Shipments;

-- Query 18: User-Defined Function - Get order ID
DELIMITER //
CREATE FUNCTION GetShipmentOrderId(tracking_number VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_id INT;
    SELECT order_id INTO ord_id FROM Shipments WHERE tracking_number = tracking_number;
    RETURN ord_id;
END //
DELIMITER ;
SELECT tracking_number, GetShipmentOrderId(tracking_number) AS order_id
FROM Shipments;

-- Query 19: User-Defined Function - Calculate shipment age
DELIMITER //
CREATE FUNCTION GetShipmentAge(shipping_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), shipping_date);
END //
DELIMITER ;
SELECT tracking_number, shipping_date, GetShipmentAge(shipping_date) AS shipment_age_in_days
FROM Shipments
WHERE shipping_date IS NOT NULL;

-- Query 20: User-Defined Function - Get address
DELIMITER //
CREATE FUNCTION GetShipmentAddress(tracking_number VARCHAR(50))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE addr VARCHAR(255);
    SELECT a.address_line1 INTO addr FROM Addresses a JOIN Shipments s ON a.address_id = s.address_id WHERE s.tracking_number = tracking_number;
    RETURN addr;
END //
DELIMITER ;
SELECT tracking_number, GetShipmentAddress(tracking_number) AS address
FROM Shipments;

-- Table 9: Warehouses Table Queries
-- Query 1: JOIN - Warehouses with Inventory and Products
SELECT w.warehouse_name, i.quantity, p.product_name
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
LEFT JOIN Products p ON i.product_id = p.product_id;

-- Query 2: JOIN - Warehouses with Suppliers and Products
SELECT w.warehouse_name, s.supplier_name, p.product_name
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 3: JOIN - Warehouses with Shipments and Orders
SELECT w.warehouse_name, s.tracking_number, o.order_id
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
LEFT JOIN Shipments s ON i.product_id = s.order_id
LEFT JOIN Orders o ON s.order_id = o.order_id;

-- Query 4: JOIN - Warehouses with Categories and Products
SELECT w.warehouse_name, c.category_name, p.product_name
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 5: JOIN - Warehouses with Employees and Departments
SELECT w.warehouse_name, e.first_name, d.department_name
FROM Warehouses w
LEFT JOIN Employees e ON w.warehouse_id = e.warehouse_id
LEFT JOIN Departments d ON e.department_id = d.department_id;

-- Query 6: Subquery - Warehouses with inventory
SELECT warehouse_name
FROM Warehouses
WHERE EXISTS (SELECT 1 FROM Inventory i WHERE i.warehouse_id = Warehouses.warehouse_id);

-- Query 7: Subquery - Warehouses with products
SELECT warehouse_name
FROM Warehouses
WHERE EXISTS (SELECT 1 FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE i.warehouse_id = Warehouses.warehouse_id);

-- Query 8: Subquery - Warehouses with employees
SELECT warehouse_name
FROM Warehouses
WHERE EXISTS (SELECT 1 FROM Employees e WHERE e.warehouse_id = Warehouses.warehouse_id);

-- Query 9: Subquery - Warehouses in specific cities
SELECT warehouse_name
FROM Warehouses
WHERE city IN (SELECT city FROM Suppliers);

-- Query 10: Subquery - Warehouses with active products
SELECT warehouse_name
FROM Warehouses
WHERE EXISTS (SELECT 1 FROM Inventory i JOIN Products p ON i.product_id = p.product_id WHERE i.warehouse_id = Warehouses.warehouse_id AND p.is_active = TRUE);

-- Query 11: Built-in Function - Warehouse name length
SELECT warehouse_name, LENGTH(warehouse_name) AS name_length
FROM Warehouses
WHERE warehouse_name IS NOT NULL;

-- Query 12: Built-in Function - Created date formatted
SELECT warehouse_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Warehouses
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase city
SELECT UPPER(city) AS city_name
FROM Warehouses
WHERE city IS NOT NULL;

-- Query 14: Built-in Function - Address length
SELECT warehouse_name, LENGTH(address) AS address_length
FROM Warehouses
WHERE address IS NOT NULL;

-- Query 15: Built-in Function - Warehouse status
SELECT warehouse_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Operational'
           ELSE 'Closed'
       END AS warehouse_status
FROM Warehouses;

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
FROM Warehouses;

-- Query 17: User-Defined Function - Check active warehouse
DELIMITER //
CREATE FUNCTION IsActiveWarehouse(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Operational';
    ELSE
        RETURN 'Closed';
    END IF;
END //
DELIMITER ;
SELECT warehouse_name, is_active, IsActiveWarehouse(is_active) AS warehouse_status
FROM Warehouses;

-- Query 18: User-Defined Function - Get inventory count
DELIMITER //
CREATE FUNCTION GetWarehouseInventoryCount(warehouse_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE inv_count INT;
    SELECT COUNT(*) INTO inv_count FROM Inventory WHERE warehouse_id = warehouse_id;
    RETURN inv_count;
END //
DELIMITER ;
SELECT warehouse_name, GetWarehouseInventoryCount(warehouse_id) AS inventory_count
FROM Warehouses;

-- Query 19: User-Defined Function - Get warehouse city
DELIMITER //
CREATE FUNCTION GetWarehouseCity(warehouse_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE w_city VARCHAR(50);
    SELECT city INTO w_city FROM Warehouses WHERE warehouse_id = warehouse_id;
    RETURN w_city;
END //
DELIMITER ;
SELECT warehouse_name, GetWarehouseCity(warehouse_id) AS city
FROM Warehouses;

-- Query 20: User-Defined Function - Calculate warehouse age
DELIMITER //
CREATE FUNCTION GetWarehouseAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT warehouse_name, created_date, GetWarehouseAge(created_date) AS warehouse_age_in_days
FROM Warehouses
WHERE created_date IS NOT NULL;

-- Table 10: Inventory Table Queries
-- Query 1: JOIN - Inventory with Products and Warehouses
SELECT i.inventory_id, p.product_name, w.warehouse_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- Query 2: JOIN - Inventory with Suppliers and Products
SELECT i.quantity, s.supplier_name, p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 3: JOIN - Inventory with Orders and Products
SELECT i.inventory_id, o.order_id, p.product_name
FROM Inventory i
LEFT JOIN Orders o ON i.product_id = o.product_id
LEFT JOIN Products p ON i.product_id = p.product_id;

-- Query 4: JOIN - Inventory with Categories and Products
SELECT i.quantity, c.category_name, p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 5: JOIN - Inventory with Shipments and Orders
SELECT i.inventory_id, s.tracking_number, o.order_id
FROM Inventory i
LEFT JOIN Orders o ON i.product_id = o.product_id
LEFT JOIN Shipments s ON o.order_id = s.order_id;

-- Query 6: Subquery - Inventory with active products
SELECT inventory_id, quantity
FROM Inventory
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Inventory in active warehouses
SELECT inventory_id
FROM Inventory
WHERE warehouse_id IN (SELECT warehouse_id FROM Warehouses WHERE is_active = TRUE);

-- Query 8: Subquery - Inventory with orders
SELECT inventory_id
FROM Inventory
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Inventory.product_id);

-- Query 9: Subquery - Inventory with low stock
SELECT inventory_id
FROM Inventory
WHERE quantity < min_stock_level;

-- Query 10: Subquery - Inventory for specific categories
SELECT inventory_id
FROM Inventory
WHERE product_id IN (SELECT product_id FROM Products p JOIN Categories c ON p.category_id = c.category_id);

-- Query 11: Built-in Function - Quantity rounded
SELECT inventory_id, ROUND(quantity) AS rounded_quantity
FROM Inventory
WHERE quantity > 0;

-- Query 12: Built-in Function - Last updated date formatted
SELECT inventory_id, DATE_FORMAT(last_updated, '%M %d, %Y') AS formatted_date
FROM Inventory
WHERE last_updated IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS inventory_status
FROM Inventory;

-- Query 14: Built-in Function - Stock level status
SELECT inventory_id, 
       CASE 
           WHEN quantity < min_stock_level THEN 'Low'
           ELSE 'Sufficient'
       END AS stock_status
FROM Inventory;

-- Query 15: Built-in Function - Product ID length
SELECT inventory_id, LENGTH(product_id) AS product_id_length
FROM Inventory;

-- Query 16: User-Defined Function - Check stock level
DELIMITER //
CREATE FUNCTION CheckStockLevel(quantity INT, min_level INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF quantity < min_level THEN
        RETURN 'Low';
    ELSE
        RETURN 'Sufficient';
    END IF;
END //
DELIMITER ;
SELECT inventory_id, quantity, CheckStockLevel(quantity, min_stock_level) AS stock_status
FROM Inventory;

-- Query 17: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetInventoryProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT inventory_id, GetInventoryProductName(product_id) AS product_name
FROM Inventory;

-- Query 18: User-Defined Function - Get warehouse name
DELIMITER //
CREATE FUNCTION GetInventoryWarehouseName(warehouse_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE w_name VARCHAR(100);
    SELECT warehouse_name INTO w_name FROM Warehouses WHERE warehouse_id = warehouse_id;
    RETURN w_name;
END //
DELIMITER ;
SELECT inventory_id, GetInventoryWarehouseName(warehouse_id) AS warehouse_name
FROM Inventory;

-- Query 19: User-Defined Function - Calculate restock cost
DELIMITER //
CREATE FUNCTION CalculateRestockCost(product_id INT, quantity INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE unit_price DECIMAL(10,2);
    SELECT price INTO unit_price FROM Products WHERE product_id = product_id;
    RETURN unit_price * quantity;
END //
DELIMITER ;
SELECT inventory_id, quantity, CalculateRestockCost(product_id, quantity) AS restock_cost
FROM Inventory;

-- Query 20: User-Defined Function - Calculate inventory age
DELIMITER //
CREATE FUNCTION GetInventoryAge(last_updated DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), last_updated);
END //
DELIMITER ;
SELECT inventory_id, last_updated, GetInventoryAge(last_updated) AS inventory_age_in_days
FROM Inventory
WHERE last_updated IS NOT NULL;

-- Table 11: Promotions Table Queries
-- Query 1: JOIN - Promotions with Products and Categories
SELECT pr.promotion_name, p.product_name, c.category_name
FROM Promotions pr
LEFT JOIN Products p ON pr.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Promotions with Discounts and Products
SELECT pr.promotion_name, d.discount_percentage, p.product_name
FROM Promotions pr
LEFT JOIN Discounts d ON pr.product_id = d.product_id
LEFT JOIN Products p ON pr.product_id = p.product_id;

-- Query 3: JOIN - Promotions with Orders and Products
SELECT pr.promotion_name, o.order_id, p.product_name
FROM Promotions pr
LEFT JOIN Orders o ON pr.product_id = o.product_id
LEFT JOIN Products p ON pr.product_id = p.product_id;

-- Query 4: JOIN - Promotions with Reviews and Products
SELECT pr.promotion_name, r.rating, p.product_name
FROM Promotions pr
LEFT JOIN Reviews r ON pr.product_id = r.product_id
LEFT JOIN Products p ON pr.product_id = p.product_id;

-- Query 5: JOIN - Promotions with Suppliers and Products
SELECT pr.promotion_name, s.supplier_name, p.product_name
FROM Promotions pr
LEFT JOIN Products p ON pr.product_id = p.product_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- Query 6: Subquery - Promotions for active products
SELECT promotion_name
FROM Promotions
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Promotions with orders
SELECT promotion_name
FROM Promotions
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Promotions.product_id);

-- Query 8: Subquery - Promotions with reviews
SELECT promotion_name
FROM Promotions
WHERE EXISTS (SELECT 1 FROM Reviews r WHERE r.product_id = Promotions.product_id);

-- Query 9: Subquery - Active promotions
SELECT promotion_name
FROM Promotions
WHERE is_active = TRUE;

-- Query 10: Subquery - Promotions for specific categories
SELECT promotion_name
FROM Promotions
WHERE product_id IN (SELECT product_id FROM Products p JOIN Categories c ON p.category_id = c.category_id);

-- Query 11: Built-in Function - Promotion name length
SELECT promotion_name, LENGTH(promotion_name) AS name_length
FROM Promotions
WHERE promotion_name IS NOT NULL;

-- Query 12: Built-in Function - Start date formatted
SELECT promotion_name, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_date
FROM Promotions
WHERE start_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase promotion name
SELECT UPPER(promotion_name) AS uppercase_name
FROM Promotions;

-- Query 14: Built-in Function - End date difference
SELECT promotion_name, DATEDIFF(end_date, start_date) AS promotion_duration
FROM Promotions
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Query 15: Built-in Function - Promotion status
SELECT promotion_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS promotion_status
FROM Promotions;

-- Query 16: User-Defined Function - Format promotion name
DELIMITER //
CREATE FUNCTION FormatPromotionName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT promotion_name, FormatPromotionName(promotion_name) AS formatted_name
FROM Promotions;

-- Query 17: User-Defined Function - Check active promotion
DELIMITER //
CREATE FUNCTION IsActivePromotion(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT promotion_name, is_active, IsActivePromotion(is_active) AS promotion_status
FROM Promotions;

-- Query 18: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetPromotionProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT promotion_name, GetPromotionProductName(product_id) AS product_name
FROM Promotions;

-- Query 19: User-Defined Function - Calculate promotion duration
DELIMITER //
CREATE FUNCTION GetPromotionDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END //
DELIMITER ;
SELECT promotion_name, start_date, end_date, GetPromotionDuration(start_date, end_date) AS duration_in_days
FROM Promotions
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Query 20: User-Defined Function - Get category name
DELIMITER //
CREATE FUNCTION GetPromotionCategoryName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cat_name VARCHAR(100);
    SELECT c.category_name INTO cat_name FROM Categories c JOIN Products p ON c.category_id = p.category_id WHERE p.product_id = product_id;
    RETURN cat_name;
END //
DELIMITER ;
SELECT promotion_name, GetPromotionCategoryName(product_id) AS category_name
FROM Promotions;

-- Table 12: Returns Table Queries
-- Query 1: JOIN - Returns with Orders and Customers
SELECT r.return_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Returns r
LEFT JOIN Orders o ON r.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 2: JOIN - Returns with Products and Orders
SELECT r.reason, p.product_name, o.order_id
FROM Returns r
LEFT JOIN Orders o ON r.order_id = o.order_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 3: JOIN - Returns with Shipments and Orders
SELECT r.return_id, s.tracking_number, o.order_id
FROM Returns r
LEFT JOIN Shipments s ON r.order_id = s.order_id
LEFT JOIN Orders o ON r.order_id = o.order_id;

-- Query 4: JOIN - Returns with Payments and Orders
SELECT r.return_id, p.payment_amount, o.order_id
FROM Returns r
LEFT JOIN Payments p ON r.order_id = p.order_id
LEFT JOIN Orders o ON r.order_id = o.order_id;

-- Query 5: JOIN - Returns with Categories and Products
SELECT r.reason, c.category_name, p.product_name
FROM Returns r
LEFT JOIN Orders o ON r.order_id = o.order_id
LEFT JOIN Products p ON o.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 6: Subquery - Returns for orders
SELECT return_id
FROM Returns
WHERE order_id IN (SELECT order_id FROM Orders);

-- Query 7: Subquery - Returns for specific products
SELECT reason
FROM Returns
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Products p ON o.product_id = p.product_id);

-- Query 8: Subquery - Returns with refunds
SELECT return_id
FROM Returns
WHERE status = 'Refunded';

-- Query 9: Subquery - Returns for active customers
SELECT return_id
FROM Returns
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id);

-- Query 10: Subquery - Returns with shipments
SELECT return_id
FROM Returns
WHERE EXISTS (SELECT 1 FROM Shipments s WHERE s.order_id = Returns.order_id);

-- Query 11: Built-in Function - Reason length
SELECT return_id, LENGTH(reason) AS reason_length
FROM Returns
WHERE reason IS NOT NULL;

-- Query 12: Built-in Function - Return date formatted
SELECT return_id, DATE_FORMAT(return_date, '%M %d, %Y') AS formatted_date
FROM Returns
WHERE return_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS return_status
FROM Returns;

-- Query 14: Built-in Function - Refund amount rounded
SELECT return_id, ROUND(refunded_amount) AS rounded_amount
FROM Returns
WHERE refunded_amount > 0;

-- Query 15: Built-in Function - Return status
SELECT return_id, 
       CASE 
           WHEN status = 'Refunded' THEN 'Completed'
           ELSE 'Pending'
       END AS return_status
FROM Returns;

-- Query 16: User-Defined Function - Format return reason
DELIMITER //
CREATE FUNCTION FormatReturnReason(reason VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(reason, 1)), LOWER(SUBSTRING(reason, 2)));
END //
DELIMITER ;
SELECT return_id, reason, FormatReturnReason(reason) AS formatted_reason
FROM Returns
WHERE reason IS NOT NULL;

-- Query 17: User-Defined Function - Check return status
DELIMITER //
CREATE FUNCTION CheckReturnStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Refunded' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT return_id, status, CheckReturnStatus(status) AS return_status
FROM Returns;

-- Query 18: User-Defined Function - Get order ID
DELIMITER //
CREATE FUNCTION GetReturnOrderId(return_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_id INT;
    SELECT order_id INTO ord_id FROM Returns WHERE return_id = return_id;
    RETURN ord_id;
END //
DELIMITER ;
SELECT return_id, GetReturnOrderId(return_id) AS order_id
FROM Returns;

-- Query 19: User-Defined Function - Calculate return age
DELIMITER //
CREATE FUNCTION GetReturnAge(return_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), return_date);
END //
DELIMITER ;
SELECT return_id, return_date, GetReturnAge(return_date) AS return_age_in_days
FROM Returns
WHERE return_date IS NOT NULL;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetReturnProductName(return_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT p.product_name INTO prod_name FROM Products p JOIN Orders o ON p.product_id = o.product_id JOIN Returns r ON o.order_id = r.order_id WHERE r.return_id = return_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT return_id, GetReturnProductName(return_id) AS product_name
FROM Returns;

-- Table 13: Wishlists Table Queries
-- Query 1: JOIN - Wishlists with Customers and Products
SELECT w.wishlist_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Wishlists w
LEFT JOIN Customers c ON w.customer_id = c.customer_id
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 2: JOIN - Wishlists with Categories and Products
SELECT w.wishlist_id, c.category_name, p.product_name
FROM Wishlists w
LEFT JOIN Products p ON w.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 3: JOIN - Wishlists with Orders and Products
SELECT w.wishlist_id, o.order_id, p.product_name
FROM Wishlists w
LEFT JOIN Orders o ON w.product_id = o.product_id
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 4: JOIN - Wishlists with Reviews and Products
SELECT w.wishlist_id, r.rating, p.product_name
FROM Wishlists w
LEFT JOIN Reviews r ON w.product_id = r.product_id
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 5: JOIN - Wishlists with Promotions and Products
SELECT w.wishlist_id, pr.promotion_name, p.product_name
FROM Wishlists w
LEFT JOIN Promotions pr ON w.product_id = pr.product_id
LEFT JOIN Products p ON w.product_id = p.product_id;

-- Query 6: Subquery - Wishlists with active products
SELECT wishlist_id
FROM Wishlists
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Wishlists for specific customers
SELECT wishlist_id
FROM Wishlists
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Wishlists with ordered products
SELECT wishlist_id
FROM Wishlists
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Wishlists.product_id);

-- Query 9: Subquery - Wishlists with reviews
SELECT wishlist_id
FROM Wishlists
WHERE EXISTS (SELECT 1 FROM Reviews r WHERE r.product_id = Wishlists.product_id);

-- Query 10: Subquery - Wishlists for specific categories
SELECT wishlist_id
FROM Wishlists
WHERE product_id IN (SELECT product_id FROM Products p JOIN Categories c ON p.category_id = c.category_id);

-- Query 11: Built-in Function - Added date formatted
SELECT wishlist_id, DATE_FORMAT(added_date, '%M %d, %Y') AS formatted_date
FROM Wishlists
WHERE added_date IS NOT NULL;

-- Query 12: Built-in Function - Product ID length
SELECT wishlist_id, LENGTH(product_id) AS product_id_length
FROM Wishlists;

-- Query 13: Built-in Function - Customer ID length
SELECT wishlist_id, LENGTH(customer_id) AS customer_id_length
FROM Wishlists;

-- Query 14: Built-in Function - Wishlist status
SELECT wishlist_id, 
       CASE 
           WHEN added_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 'Old'
           ELSE 'Recent'
       END AS wishlist_status
FROM Wishlists;

-- Query 15: Built-in Function - Product count per customer
SELECT customer_id, COUNT(*) AS wishlist_count
FROM Wishlists
GROUP BY customer_id;

-- Query 16: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetWishlistProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT wishlist_id, GetWishlistProductName(product_id) AS product_name
FROM Wishlists;

-- Query 17: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetWishlistCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT wishlist_id, GetWishlistCustomerName(customer_id) AS customer_name
FROM Wishlists;

-- Query 18: User-Defined Function - Calculate wishlist age
DELIMITER //
CREATE FUNCTION GetWishlistAge(added_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), added_date);
END //
DELIMITER ;
SELECT wishlist_id, added_date, GetWishlistAge(added_date) AS wishlist_age_in_days
FROM Wishlists
WHERE added_date IS NOT NULL;

-- Query 19: User-Defined Function - Check recent wishlist
DELIMITER //
CREATE FUNCTION IsRecentWishlist(added_date DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), added_date) < 30 THEN
        RETURN 'Recent';
    ELSE
        RETURN 'Old';
    END IF;
END //
DELIMITER ;
SELECT wishlist_id, added_date, IsRecentWishlist(added_date) AS wishlist_status
FROM Wishlists;

-- Query 20: User-Defined Function - Get category name
DELIMITER //
CREATE FUNCTION GetWishlistCategoryName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cat_name VARCHAR(100);
    SELECT c.category_name INTO cat_name FROM Categories c JOIN Products p ON c.category_id = p.category_id WHERE p.product_id = product_id;
    RETURN cat_name;
END //
DELIMITER ;
SELECT wishlist_id, GetWishlistCategoryName(product_id) AS category_name
FROM Wishlists;

-- Table 14: Carts Table Queries
-- Query 1: JOIN - Carts with Customers and Products
SELECT ca.cart_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Carts ca
LEFT JOIN Customers c ON ca.customer_id = c.customer_id
LEFT JOIN Products p ON ca.product_id = p.product_id;

-- Query 2: JOIN - Carts with Orders and Products
SELECT ca.cart_id, o.order_id, p.product_name
FROM Carts ca
LEFT JOIN Orders o ON ca.product_id = o.product_id
LEFT JOIN Products p ON ca.product_id = p.product_id;

-- Query 3: JOIN - Carts with Categories and Products
SELECT ca.cart_id, c.category_name, p.product_name
FROM Carts ca
LEFT JOIN Products p ON ca.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 4: JOIN - Carts with Promotions and Products
SELECT ca.cart_id, pr.promotion_name, p.product_name
FROM Carts ca
LEFT JOIN Promotions pr ON ca.product_id = pr.product_id
LEFT JOIN Products p ON ca.product_id = p.product_id;

-- Query 5: JOIN - Carts with Wishlists and Customers
SELECT ca.cart_id, w.added_date, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Carts ca
LEFT JOIN Wishlists w ON ca.customer_id = w.customer_id
LEFT JOIN Customers c ON ca.customer_id = c.customer_id;

-- Query 6: Subquery - Carts with active products
SELECT cart_id
FROM Carts
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Carts for specific customers
SELECT cart_id
FROM Carts
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Carts with ordered products
SELECT cart_id
FROM Carts
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Carts.product_id);

-- Query 9: Subquery - Carts with promotions
SELECT cart_id
FROM Carts
WHERE EXISTS (SELECT 1 FROM Promotions pr WHERE pr.product_id = Carts.product_id);

-- Query 10: Subquery - Carts for specific categories
SELECT cart_id
FROM Carts
WHERE product_id IN (SELECT product_id FROM Products p JOIN Categories c ON p.category_id = c.category_id);

-- Query 11: Built-in Function - Quantity rounded
SELECT cart_id, ROUND(quantity) AS rounded_quantity
FROM Carts
WHERE quantity > 0;

-- Query 12: Built-in Function - Added date formatted
SELECT cart_id, DATE_FORMAT(added_date, '%M %d, %Y') AS formatted_date
FROM Carts
WHERE added_date IS NOT NULL;

-- Query 13: Built-in Function - Product ID length
SELECT cart_id, LENGTH(product_id) AS product_id_length
FROM Carts;

-- Query 14: Built-in Function - Cart status
SELECT cart_id, 
       CASE 
           WHEN added_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 'Stale'
           ELSE 'Active'
       END AS cart_status
FROM Carts;

-- Query 15: Built-in Function - Customer ID length
SELECT cart_id, LENGTH(customer_id) AS customer_id_length
FROM Carts;

-- Query 16: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetCartProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT cart_id, GetCartProductName(product_id) AS product_name
FROM Carts;

-- Query 17: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetCartCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT cart_id, GetCartCustomerName(customer_id) AS customer_name
FROM Carts;

-- Query 18: User-Defined Function - Calculate cart age
DELIMITER //
CREATE FUNCTION GetCartAge(added_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), added_date);
END //
DELIMITER ;
SELECT cart_id, added_date, GetCartAge(added_date) AS cart_age_in_days
FROM Carts
WHERE added_date IS NOT NULL;

-- Query 19: User-Defined Function - Check active cart
DELIMITER //
CREATE FUNCTION IsActiveCart(added_date DATE)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), added_date) < 30 THEN
        RETURN 'Active';
    ELSE
        RETURN 'Stale';
    END IF;
END //
DELIMITER ;
SELECT cart_id, added_date, IsActiveCart(added_date) AS cart_status
FROM Carts;

-- Query 20: User-Defined Function - Get category name
DELIMITER //
CREATE FUNCTION GetCartCategoryName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cat_name VARCHAR(100);
    SELECT c.category_name INTO cat_name FROM Categories c JOIN Products p ON c.category_id = p.category_id WHERE p.product_id = product_id;
    RETURN cat_name;
END //
DELIMITER ;
SELECT cart_id, GetCartCategoryName(product_id) AS category_name
FROM Carts;

-- Table 15: Addresses Table Queries
-- Query 1: JOIN - Addresses with Customers and Shipments
SELECT a.address_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, s.tracking_number
FROM Addresses a
LEFT JOIN Customers c ON a.customer_id = c.customer_id
LEFT JOIN Shipments s ON a.address_id = s.address_id;

-- Query 2: JOIN - Addresses with Orders and Customers
SELECT a.address_line1, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Addresses a
LEFT JOIN Orders o ON a.customer_id = o.customer_id
LEFT JOIN Customers c ON a.customer_id = c.customer_id;

-- Query 3: JOIN - Addresses with Subscriptions and Customers
SELECT a.address_id, s.subscription_plan, c.email
FROM Addresses a
LEFT JOIN Subscriptions s ON a.customer_id = s.customer_id
LEFT JOIN Customers c ON a.customer_id = c.customer_id;

-- Query 4: JOIN - Addresses with Payments and Orders
SELECT a.address_line1, p.payment_amount, o.order_id
FROM Addresses a
LEFT JOIN Orders o ON a.customer_id = o.customer_id
LEFT JOIN Payments p ON o.order_id = p.order_id;

-- Query 5: JOIN - Addresses with Returns and Orders
SELECT a.address_id, r.reason, o.order_id
FROM Addresses a
LEFT JOIN Orders o ON a.customer_id = o.customer_id
LEFT JOIN Returns r ON o.order_id = r.order_id;

-- Query 6: Subquery - Addresses for customers
SELECT address_line1
FROM Addresses
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 7: Subquery - Addresses used in shipments
SELECT address_id
FROM Addresses
WHERE EXISTS (SELECT 1 FROM Shipments s WHERE s.address_id = Addresses.address_id);

-- Query 8: Subquery - Addresses for active customers
SELECT address_line1
FROM Addresses
WHERE customer_id IN (SELECT customer_id FROM Orders);

-- Query 9: Subquery - Default addresses
SELECT address_id
FROM Addresses
WHERE is_default = TRUE;

-- Query 10: Subquery - Addresses in specific cities
SELECT address_line1
FROM Addresses
WHERE city IN (SELECT city FROM Warehouses);

-- Query 11: Built-in Function - Address length
SELECT address_id, LENGTH(address_line1) AS address_length
FROM Addresses
WHERE address_line1 IS NOT NULL;

-- Query 12: Built-in Function - Created date formatted
SELECT address_id, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Addresses
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase city
SELECT UPPER(city) AS city_name
FROM Addresses
WHERE city IS NOT NULL;

-- Query 14: Built-in Function - Zip code length
SELECT address_id, LENGTH(zip_code) AS zip_length
FROM Addresses
WHERE zip_code IS NOT NULL;

-- Query 15: Built-in Function - Address status
SELECT address_id, 
       CASE 
           WHEN is_default = TRUE THEN 'Default'
           ELSE 'Alternate'
       END AS address_status
FROM Addresses;

-- Query 16: User-Defined Function - Format address
DELIMITER //
CREATE FUNCTION FormatAddress(address VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(address, 1)), LOWER(SUBSTRING(address, 2)));
END //
DELIMITER ;
SELECT address_id, address_line1, FormatAddress(address_line1) AS formatted_address
FROM Addresses;

-- Query 17: User-Defined Function - Check default address
DELIMITER //
CREATE FUNCTION IsDefaultAddress(is_default BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_default THEN
        RETURN 'Default';
    ELSE
        RETURN 'Alternate';
    END IF;
END //
DELIMITER ;
SELECT address_id, is_default, IsDefaultAddress(is_default) AS address_status
FROM Addresses;

-- Query 18: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetAddressCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT address_id, GetAddressCustomerName(customer_id) AS customer_name
FROM Addresses;

-- Query 19: User-Defined Function - Calculate address age
DELIMITER //
CREATE FUNCTION GetAddressAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT address_id, created_date, GetAddressAge(created_date) AS address_age_in_days
FROM Addresses
WHERE created_date IS NOT NULL;

-- Query 20: User-Defined Function - Get shipment count
DELIMITER //
CREATE FUNCTION GetAddressShipmentCount(address_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ship_count INT;
    SELECT COUNT(*) INTO ship_count FROM Shipments WHERE address_id = address_id;
    RETURN ship_count;
END //
DELIMITER ;
SELECT address_id, GetAddressShipmentCount(address_id) AS shipment_count
FROM Addresses;

-- Table 16: Subscriptions Table Queries
-- Query 1: JOIN - Subscriptions with Customers and Payments
SELECT s.subscription_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.payment_amount
FROM Subscriptions s
LEFT JOIN Customers c ON s.customer_id = c.customer_id
LEFT JOIN Payments p ON s.subscription_id = p.subscription_id;

-- Query 2: JOIN - Subscriptions with Orders and Customers
SELECT s.subscription_plan, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Subscriptions s
LEFT JOIN Customers c ON s.customer_id = c.customer_id
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Query 3: JOIN - Subscriptions with Addresses and Customers
SELECT s.subscription_id, a.address_line1, c.email
FROM Subscriptions s
LEFT JOIN Customers c ON s.customer_id = c.customer_id
LEFT JOIN Addresses a ON c.customer_id = a.customer_id;

-- Query 4: JOIN - Subscriptions with Payments and Transactions
SELECT s.subscription_id, p.payment_amount, t.transaction_id
FROM Subscriptions s
LEFT JOIN Payments p ON s.subscription_id = p.subscription_id
LEFT JOIN Transactions t ON p.payment_id = t.payment_id;

-- Query 5: JOIN - Subscriptions with Discounts and Customers
SELECT s.subscription_plan, d.discount_percentage, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Subscriptions s
LEFT JOIN Discounts d ON s.subscription_id = d.subscription_id
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 6: Subquery - Subscriptions for active customers
SELECT subscription_id
FROM Subscriptions
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 7: Subquery - Active subscriptions
SELECT subscription_plan
FROM Subscriptions
WHERE status = 'Active';

-- Query 8: Subquery - Subscriptions with payments
SELECT subscription_id
FROM Subscriptions
WHERE EXISTS (SELECT 1 FROM Payments p WHERE p.subscription_id = Subscriptions.subscription_id);

-- Query 9: Subquery - Subscriptions with orders
SELECT subscription_id
FROM Subscriptions
WHERE customer_id IN (SELECT customer_id FROM Orders);

-- Query 10: Subquery - Subscriptions with discounts
SELECT subscription_id
FROM Subscriptions
WHERE EXISTS (SELECT 1 FROM Discounts d WHERE d.subscription_id = Subscriptions.subscription_id);

-- Query 11: Built-in Function - Subscription plan length
SELECT subscription_id, LENGTH(subscription_plan) AS plan_length
FROM Subscriptions
WHERE subscription_plan IS NOT NULL;

-- Query 12: Built-in Function - Start date formatted
SELECT subscription_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_date
FROM Subscriptions
WHERE start_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS subscription_status
FROM Subscriptions;

-- Query 14: Built-in Function - Subscription duration
SELECT subscription_id, DATEDIFF(end_date, start_date) AS duration_days
FROM Subscriptions
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Query 15: Built-in Function - Subscription status
SELECT subscription_id, 
       CASE 
           WHEN status = 'Active' THEN 'Ongoing'
           ELSE 'Expired'
       END AS subscription_status
FROM Subscriptions;

-- Query 16: User-Defined Function - Format subscription plan
DELIMITER //
CREATE FUNCTION FormatSubscriptionPlan(plan VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(plan, 1)), LOWER(SUBSTRING(plan, 2)));
END //
DELIMITER ;
SELECT subscription_id, subscription_plan, FormatSubscriptionPlan(subscription_plan) AS formatted_plan
FROM Subscriptions;

-- Query 17: User-Defined Function - Check active subscription
DELIMITER //
CREATE FUNCTION IsActiveSubscription(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Active' THEN
        RETURN 'Ongoing';
    ELSE
        RETURN 'Expired';
    END IF;
END //
DELIMITER ;
SELECT subscription_id, status, IsActiveSubscription(status) AS subscription_status
FROM Subscriptions;

-- Query 18: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetSubscriptionCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT subscription_id, GetSubscriptionCustomerName(customer_id) AS customer_name
FROM Subscriptions;

-- Query 19: User-Defined Function - Calculate subscription age
DELIMITER //
CREATE FUNCTION GetSubscriptionAge(start_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), start_date);
END //
DELIMITER ;
SELECT subscription_id, start_date, GetSubscriptionAge(start_date) AS subscription_age_in_days
FROM Subscriptions
WHERE start_date IS NOT NULL;

-- Query 20: User-Defined Function - Get payment count
DELIMITER //
CREATE FUNCTION GetSubscriptionPaymentCount(subscription_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pay_count INT;
    SELECT COUNT(*) INTO pay_count FROM Payments WHERE subscription_id = subscription_id;
    RETURN pay_count;
END //
DELIMITER ;
SELECT subscription_id, GetSubscriptionPaymentCount(subscription_id) AS payment_count
FROM Subscriptions;

-- Table 17: Discounts Table Queries
-- Query 1: JOIN - Discounts with Products and Categories
SELECT d.discount_id, p.product_name, c.category_name
FROM Discounts d
LEFT JOIN Products p ON d.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Discounts with Promotions and Products
SELECT d.discount_percentage, pr.promotion_name, p.product_name
FROM Discounts d
LEFT JOIN Promotions pr ON d.product_id = pr.product_id
LEFT JOIN Products p ON d.product_id = p.product_id;

-- Query 3: JOIN - Discounts with Orders and Products
SELECT d.discount_id, o.order_id, p.product_name
FROM Discounts d
LEFT JOIN Orders o ON d.product_id = o.product_id
LEFT JOIN Products p ON d.product_id = p.product_id;

-- Query 4: JOIN - Discounts with Subscriptions and Customers
SELECT d.discount_id, s.subscription_plan, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Discounts d
LEFT JOIN Subscriptions s ON d.subscription_id = s.subscription_id
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 5: JOIN - Discounts with Reviews and Products
SELECT d.discount_percentage, r.rating, p.product_name
FROM Discounts d
LEFT JOIN Reviews r ON d.product_id = r.product_id
LEFT JOIN Products p ON d.product_id = p.product_id;

-- Query 6: Subquery - Discounts for active products
SELECT discount_id
FROM Discounts
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Discounts with promotions
SELECT discount_id
FROM Discounts
WHERE EXISTS (SELECT 1 FROM Promotions pr WHERE pr.product_id = Discounts.product_id);

-- Query 8: Subquery - Active discounts
SELECT discount_percentage
FROM Discounts
WHERE is_active = TRUE;

-- Query 9: Subquery - Discounts for subscriptions
SELECT discount_id
FROM Discounts
WHERE subscription_id IN (SELECT subscription_id FROM Subscriptions WHERE status = 'Active');

-- Query 10: Subquery - Discounts for ordered products
SELECT discount_id
FROM Discounts
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Discounts.product_id);

-- Query 11: Built-in Function - Discount percentage rounded
SELECT discount_id, ROUND(discount_percentage) AS rounded_percentage
FROM Discounts
WHERE discount_percentage > 0;

-- Query 12: Built-in Function - Start date formatted
SELECT discount_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_date
FROM Discounts
WHERE start_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase discount code
SELECT UPPER(discount_code) AS discount_code
FROM Discounts;

-- Query 14: Built-in Function - Discount duration
SELECT discount_id, DATEDIFF(end_date, start_date) AS duration_days
FROM Discounts
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Query 15: Built-in Function - Discount status
SELECT discount_id, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Expired'
       END AS discount_status
FROM Discounts;

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
FROM Discounts;

-- Query 17: User-Defined Function - Check active discount
DELIMITER //
CREATE FUNCTION IsActiveDiscount(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Expired';
    END IF;
END //
DELIMITER ;
SELECT discount_id, is_active, IsActiveDiscount(is_active) AS discount_status
FROM Discounts;

-- Query 18: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetDiscountProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT discount_id, GetDiscountProductName(product_id) AS product_name
FROM Discounts;

-- Query 19: User-Defined Function - Calculate discount amount
DELIMITER //
CREATE FUNCTION CalculateDiscountAmount(price DECIMAL(10,2), percentage DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (percentage / 100);
END //
DELIMITER ;
SELECT discount_id, discount_percentage, CalculateDiscountAmount(100.00, discount_percentage) AS discount_amount
FROM Discounts;

-- Query 20: User-Defined Function - Calculate discount duration
DELIMITER //
CREATE FUNCTION GetDiscountDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END //
DELIMITER ;
SELECT discount_id, start_date, end_date, GetDiscountDuration(start_date, end_date) AS duration_in_days
FROM Discounts
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Table 18: Taxes Table Queries
-- Query 1: JOIN - Taxes with Orders and Customers
SELECT t.tax_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Taxes t
LEFT JOIN Orders o ON t.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 2: JOIN - Taxes with Payments and Orders
SELECT t.tax_id, p.payment_amount, o.order_id
FROM Taxes t
LEFT JOIN Payments p ON t.order_id = p.order_id
LEFT JOIN Orders o ON t.order_id = o.order_id;

-- Query 3: JOIN - Taxes with Shipments and Orders
SELECT t.tax_id, s.tracking_number, o.order_id
FROM Taxes t
LEFT JOIN Shipments s ON t.order_id = s.order_id
LEFT JOIN Orders o ON t.order_id = o.order_id;

-- Query 4: JOIN - Taxes with Products and Orders
SELECT t.tax_amount, p.product_name, o.order_id
FROM Taxes t
LEFT JOIN Orders o ON t.order_id = o.order_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 5: JOIN - Taxes with Addresses and Customers
SELECT t.tax_id, a.address_line1, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Taxes t
LEFT JOIN Orders o ON t.order_id = o.order_id
LEFT JOIN Addresses a ON o.customer_id = a.customer_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 6: Subquery - Taxes for orders
SELECT tax_id
FROM Taxes
WHERE order_id IN (SELECT order_id FROM Orders);

-- Query 7: Subquery - Taxes for shipped orders
SELECT tax_id
FROM Taxes
WHERE EXISTS (SELECT 1 FROM Shipments s WHERE s.order_id = Taxes.order_id);

-- Query 8: Subquery - Taxes for paid orders
SELECT tax_id
FROM Taxes
WHERE EXISTS (SELECT 1 FROM Payments p WHERE p.order_id = Taxes.order_id);

-- Query 9: Subquery - Taxes for specific customers
SELECT tax_id
FROM Taxes
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id);

-- Query 10: Subquery - Taxes for specific products
SELECT tax_id
FROM Taxes
WHERE order_id IN (SELECT order_id FROM Orders o JOIN Products p ON o.product_id = p.product_id);

-- Query 11: Built-in Function - Tax amount rounded
SELECT tax_id, ROUND(tax_amount) AS rounded_amount
FROM Taxes
WHERE tax_amount > 0;

-- Query 12: Built-in Function - Created date formatted
SELECT tax_id, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Taxes
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase tax type
SELECT UPPER(tax_type) AS tax_type
FROM Taxes;

-- Query 14: Built-in Function - Tax rate rounded
SELECT tax_id, ROUND(tax_rate) AS rounded_rate
FROM Taxes
WHERE tax_rate > 0;

-- Query 15: Built-in Function - Tax status
SELECT tax_id, 
       CASE 
           WHEN tax_amount > 0 THEN 'Applied'
           ELSE 'Not Applied'
       END AS tax_status
FROM Taxes;

-- Query 16: User-Defined Function - Format tax type
DELIMITER //
CREATE FUNCTION FormatTaxType(tax_type VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(tax_type);
END //
DELIMITER ;
SELECT tax_id, tax_type, FormatTaxType(tax_type) AS formatted_type
FROM Taxes;

-- Query 17: User-Defined Function - Calculate total with tax
DELIMITER //
CREATE FUNCTION CalculateTotalWithTax(amount DECIMAL(10,2), tax_rate DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount * (1 + tax_rate / 100);
END //
DELIMITER ;
SELECT tax_id, tax_amount, CalculateTotalWithTax(100.00, tax_rate) AS total_with_tax
FROM Taxes;

-- Query 18: User-Defined Function - Get order ID
DELIMITER //
CREATE FUNCTION GetTaxOrderId(tax_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_id INT;
    SELECT order_id INTO ord_id FROM Taxes WHERE tax_id = tax_id;
    RETURN ord_id;
END //
DELIMITER ;
SELECT tax_id, GetTaxOrderId(tax_id) AS order_id
FROM Taxes;

-- Query 19: User-Defined Function - Calculate tax age
DELIMITER //
CREATE FUNCTION GetTaxAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT tax_id, created_date, GetTaxAge(created_date) AS tax_age_in_days
FROM Taxes
WHERE created_date IS NOT NULL;

-- Query 20: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetTaxCustomerName(tax_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(c.first_name, ' ', c.last_name) INTO cust_name FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id JOIN Taxes t ON o.order_id = t.order_id WHERE t.tax_id = tax_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT tax_id, GetTaxCustomerName(tax_id) AS customer_name
FROM Taxes;

-- Table 19: GiftCards Table Queries
-- Query 1: JOIN - GiftCards with Customers and Payments
SELECT g.gift_card_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.payment_amount
FROM GiftCards g
LEFT JOIN Customers c ON g.customer_id = c.customer_id
LEFT JOIN Payments p ON g.gift_card_id = p.gift_card_id;

-- Query 2: JOIN - GiftCards with Orders and Customers
SELECT g.gift_card_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
LEFT JOIN Payments p ON g.gift_card_id = p.gift_card_id
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 3: JOIN - GiftCards with Transactions and Payments
SELECT g.gift_card_id, t.transaction_id, p.payment_amount
FROM GiftCards g
LEFT JOIN Payments p ON g.gift_card_id = p.gift_card_id
LEFT JOIN Transactions t ON p.payment_id = t.payment_id;

-- Query 4: JOIN - GiftCards with Subscriptions and Customers
SELECT g.gift_card_id, s.subscription_plan, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
LEFT JOIN Payments p ON g.gift_card_id = p.gift_card_id
LEFT JOIN Subscriptions s ON p.subscription_id = s.subscription_id
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 5: JOIN - GiftCards with Addresses and Customers
SELECT g.gift_card_id, a.address_line1, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM GiftCards g
LEFT JOIN Customers c ON g.customer_id = c.customer_id
LEFT JOIN Addresses a ON c.customer_id = a.customer_id;

-- Query 6: Subquery - GiftCards used in payments
SELECT gift_card_id
FROM GiftCards
WHERE EXISTS (SELECT 1 FROM Payments p WHERE p.gift_card_id = GiftCards.gift_card_id);

-- Query 7: Subquery - GiftCards for active customers
SELECT card_number
FROM GiftCards
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Active gift cards
SELECT gift_card_id
FROM GiftCards
WHERE is_active = TRUE;

-- Query 9: Subquery - GiftCards used in orders
SELECT gift_card_id
FROM GiftCards
WHERE EXISTS (SELECT 1 FROM Payments p JOIN Orders o ON p.order_id = o.order_id WHERE p.gift_card_id = GiftCards.gift_card_id);

-- Query 10: Subquery - GiftCards for subscriptions
SELECT gift_card_id
FROM GiftCards
WHERE EXISTS (SELECT 1 FROM Payments p JOIN Subscriptions s ON p.subscription_id = s.subscription_id WHERE p.gift_card_id = GiftCards.gift_card_id);

-- Query 11: Built-in Function - Card number length
SELECT gift_card_id, LENGTH(card_number) AS card_number_length
FROM GiftCards
WHERE card_number IS NOT NULL;

-- Query 12: Built-in Function - Issue date formatted
SELECT gift_card_id, DATE_FORMAT(issue_date, '%M %d, %Y') AS formatted_date
FROM GiftCards
WHERE issue_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase card number
SELECT UPPER(card_number) AS card_number
FROM GiftCards;

-- Query 14: Built-in Function - Balance rounded
SELECT gift_card_id, ROUND(balance) AS rounded_balance
FROM GiftCards
WHERE balance > 0;

-- Query 15: Built-in Function - Gift card status
SELECT gift_card_id, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS card_status
FROM GiftCards;

-- Query 16: User-Defined Function - Format card number
DELIMITER //
CREATE FUNCTION FormatCardNumber(card_number VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(card_number);
END //
DELIMITER ;
SELECT gift_card_id, card_number, FormatCardNumber(card_number) AS formatted_number
FROM GiftCards;

-- Query 17: User-Defined Function - Check active gift card
DELIMITER //
CREATE FUNCTION IsActiveGiftCard(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT gift_card_id, is_active, IsActiveGiftCard(is_active) AS card_status
FROM GiftCards;

-- Query 18: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetGiftCardCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT gift_card_id, GetGiftCardCustomerName(customer_id) AS customer_name
FROM GiftCards;

-- Query 19: User-Defined Function - Calculate gift card age
DELIMITER //
CREATE FUNCTION GetGiftCardAge(issue_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), issue_date);
END //
DELIMITER ;
SELECT gift_card_id, issue_date, GetGiftCardAge(issue_date) AS card_age_in_days
FROM GiftCards
WHERE issue_date IS NOT NULL;

-- Query 20: User-Defined Function - Get payment count
DELIMITER //
CREATE FUNCTION GetGiftCardPaymentCount(gift_card_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pay_count INT;
    SELECT COUNT(*) INTO pay_count FROM Payments WHERE gift_card_id = gift_card_id;
    RETURN pay_count;
END //
DELIMITER ;
SELECT gift_card_id, GetGiftCardPaymentCount(gift_card_id) AS payment_count
FROM GiftCards;

-- Table 20: Transactions Table Queries
-- Query 1: JOIN - Transactions with Payments and Orders
SELECT t.transaction_id, p.payment_amount, o.order_id
FROM Transactions t
LEFT JOIN Payments p ON t.payment_id = p.payment_id
LEFT JOIN Orders o ON p.order_id = o.order_id;

-- Query 2: JOIN - Transactions with Customers and Orders
SELECT t.transaction_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, o.order_id
FROM Transactions t
LEFT JOIN Payments p ON t.payment_id = p.payment_id
LEFT JOIN Orders o ON p.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 3: JOIN - Transactions with GiftCards and Payments
SELECT t.transaction_id, g.card_number, p.payment_amount
FROM Transactions t
LEFT JOIN Payments p ON t.payment_id = p.payment_id
LEFT JOIN GiftCards g ON p.gift_card_id = g.gift_card_id;

-- Query 4: JOIN - Transactions with Subscriptions and Payments
SELECT t.transaction_id, s.subscription_plan, p.payment_amount
FROM Transactions t
LEFT JOIN Payments p ON t.payment_id = p.payment_id
LEFT JOIN Subscriptions s ON p.subscription_id = s.subscription_id;

-- Query 5: JOIN - Transactions with Products and Orders
SELECT t.transaction_id, p.product_name, o.order_id
FROM Transactions t
LEFT JOIN Payments pay ON t.payment_id = pay.payment_id
LEFT JOIN Orders o ON pay.order_id = o.order_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 6: Subquery - Transactions for payments
SELECT transaction_id
FROM Transactions
WHERE payment_id IN (SELECT payment_id FROM Payments);

-- Query 7: Subquery - Transactions for orders
SELECT transaction_id
FROM Transactions
WHERE payment_id IN (SELECT payment_id FROM Payments p JOIN Orders o ON p.order_id = o.order_id);

-- Query 8: Subquery - Transactions for subscriptions
SELECT transaction_id
FROM Transactions
WHERE payment_id IN (SELECT payment_id FROM Payments p JOIN Subscriptions s ON p.subscription_id = s.subscription_id);

-- Query 9: Subquery - Transactions with gift cards
SELECT transaction_id
FROM Transactions
WHERE payment_id IN (SELECT payment_id FROM Payments p JOIN GiftCards g ON p.gift_card_id = g.gift_card_id);

-- Query 10: Subquery - Successful transactions
SELECT transaction_id
FROM Transactions
WHERE status = 'Success';

-- Query 11: Built-in Function - Transaction amount rounded
SELECT transaction_id, ROUND(amount) AS rounded_amount
FROM Transactions
WHERE amount > 0;

-- Query 12: Built-in Function - Transaction date formatted
SELECT transaction_id, DATE_FORMAT(transaction_date, '%M %d, %Y') AS formatted_date
FROM Transactions
WHERE transaction_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS transaction_status
FROM Transactions;

-- Query 14: Built-in Function - Transaction ID length
SELECT transaction_id, LENGTH(transaction_id) AS trans_id_length
FROM Transactions;

-- Query 15: Built-in Function - Transaction status
SELECT transaction_id, 
       CASE 
           WHEN status = 'Success' THEN 'Completed'
           ELSE 'Pending'
       END AS transaction_status
FROM Transactions;

-- Query 16: User-Defined Function - Format transaction status
DELIMITER //
CREATE FUNCTION FormatTransactionStatus(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(status);
END //
DELIMITER ;
SELECT transaction_id, status, FormatTransactionStatus(status) AS formatted_status
FROM Transactions;

-- Query 17: User-Defined Function - Check successful transaction
DELIMITER //
CREATE FUNCTION IsSuccessfulTransaction(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Success' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT transaction_id, status, IsSuccessfulTransaction(status) AS transaction_status
FROM Transactions;

-- Query 18: User-Defined Function - Get payment amount
DELIMITER //
CREATE FUNCTION GetTransactionPaymentAmount(transaction_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE pay_amount DECIMAL(10,2);
    SELECT p.payment_amount INTO pay_amount FROM Payments p JOIN Transactions t ON p.payment_id = t.payment_id WHERE t.transaction_id = transaction_id;
    RETURN pay_amount;
END //
DELIMITER ;
SELECT transaction_id, GetTransactionPaymentAmount(transaction_id) AS payment_amount
FROM Transactions;

-- Query 19: User-Defined Function - Calculate transaction age
DELIMITER //
CREATE FUNCTION GetTransactionAge(transaction_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), transaction_date);
END //
DELIMITER ;
SELECT transaction_id, transaction_date, GetTransactionAge(transaction_date) AS transaction_age_in_days
FROM Transactions
WHERE transaction_date IS NOT NULL;

-- Query 20: User-Defined Function - Get order ID
DELIMITER //
CREATE FUNCTION GetTransactionOrderId(transaction_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_id INT;
    SELECT o.order_id INTO ord_id FROM Orders o JOIN Payments p ON o.order_id = p.order_id JOIN Transactions t ON p.payment_id = t.payment_id WHERE t.transaction_id = transaction_id;
    RETURN ord_id;
END //
DELIMITER ;
SELECT transaction_id, GetTransactionOrderId(transaction_id) AS order_id
FROM Transactions;

-- Table 21: Employees Table Queries
-- Query 1: JOIN - Employees with Departments and Warehouses
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, d.department_name, w.warehouse_name
FROM Employees e
LEFT JOIN Departments d ON e.department_id = d.department_id
LEFT JOIN Warehouses w ON e.warehouse_id = w.warehouse_id;

-- Query 2: JOIN - Employees with CustomerSupportTickets and Customers
SELECT e.employee_id, t.ticket_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Employees e
LEFT JOIN CustomerSupportTickets t ON e.employee_id = t.employee_id
LEFT JOIN Customers c ON t.customer_id = c.customer_id;

-- Query 3: JOIN - Employees with Orders and Customers
SELECT e.employee_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Employees e
LEFT JOIN CustomerSupportTickets t ON e.employee_id = t.employee_id
LEFT JOIN Orders o ON t.order_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 4: JOIN - Employees with SellerAccounts and Products
SELECT e.employee_id, s.seller_name, p.product_name
FROM Employees e
LEFT JOIN SellerAccounts s ON e.employee_id = s.employee_id
LEFT JOIN Products p ON s.seller_id = p.seller_id;

-- Query 5: JOIN - Employees with Warehouses and Inventory
SELECT e.employee_id, w.warehouse_name, i.quantity
FROM Employees e
LEFT JOIN Warehouses w ON e.warehouse_id = w.warehouse_id
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id;

-- Query 6: Subquery - Employees in active departments
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS employee_name
FROM Employees
WHERE department_id IN (SELECT department_id FROM Departments WHERE is_active = TRUE);

-- Query 7: Subquery - Employees handling support tickets
SELECT employee_id
FROM Employees
WHERE EXISTS (SELECT 1 FROM CustomerSupportTickets t WHERE t.employee_id = Employees.employee_id);

-- Query 8: Subquery - Employees in active warehouses
SELECT employee_id
FROM Employees
WHERE warehouse_id IN (SELECT warehouse_id FROM Warehouses WHERE is_active = TRUE);

-- Query 9: Subquery - Employees managing seller accounts
SELECT employee_id
FROM Employees
WHERE EXISTS (SELECT 1 FROM SellerAccounts s WHERE s.employee_id = Employees.employee_id);

-- Query 10: Subquery - Employees with high salary
SELECT employee_id
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Query 11: Built-in Function - Employee name length
SELECT employee_id, LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length
FROM Employees;

-- Query 12: Built-in Function - Hire date formatted
SELECT employee_id, DATE_FORMAT(hire_date, '%M %d, %Y') AS formatted_date
FROM Employees
WHERE hire_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase job title
SELECT UPPER(job_title) AS job_title
FROM Employees;

-- Query 14: Built-in Function - Salary rounded
SELECT employee_id, ROUND(salary) AS rounded_salary
FROM Employees
WHERE salary > 0;

-- Query 15: Built-in Function - Employee status
SELECT employee_id, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS employee_status
FROM Employees;

-- Query 16: User-Defined Function - Format employee name
DELIMITER //
CREATE FUNCTION FormatEmployeeName(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(first_name, 2)), ' ', UPPER(LEFT(last_name, 1)), LOWER(SUBSTRING(last_name, 2)));
END //
DELIMITER ;
SELECT employee_id, first_name, last_name, FormatEmployeeName(first_name, last_name) AS formatted_name
FROM Employees;

-- Query 17: User-Defined Function - Check active employee
DELIMITER //
CREATE FUNCTION IsActiveEmployee(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT employee_id, is_active, IsActiveEmployee(is_active) AS employee_status
FROM Employees;

-- Query 18: User-Defined Function - Get department name
DELIMITER //
CREATE FUNCTION GetEmployeeDepartmentName(employee_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE dept_name VARCHAR(100);
    SELECT department_name INTO dept_name FROM Departments WHERE department_id = (SELECT department_id FROM Employees WHERE employee_id = employee_id);
    RETURN dept_name;
END //
DELIMITER ;
SELECT employee_id, GetEmployeeDepartmentName(employee_id) AS department_name
FROM Employees;

-- Query 19: User-Defined Function - Calculate employee tenure
DELIMITER //
CREATE FUNCTION GetEmployeeTenure(hire_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), hire_date);
END //
DELIMITER ;
SELECT employee_id, hire_date, GetEmployeeTenure(hire_date) AS tenure_in_days
FROM Employees
WHERE hire_date IS NOT NULL;

-- Query 20: User-Defined Function - Get ticket count
DELIMITER //
CREATE FUNCTION GetEmployeeTicketCount(employee_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ticket_count INT;
    SELECT COUNT(*) INTO ticket_count FROM CustomerSupportTickets WHERE employee_id = employee_id;
    RETURN ticket_count;
END //
DELIMITER ;
SELECT employee_id, GetEmployeeTicketCount(employee_id) AS ticket_count
FROM Employees;

-- Table 22: Departments Table Queries
-- Query 1: JOIN - Departments with Employees and Warehouses
SELECT d.department_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, w.warehouse_name
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
LEFT JOIN Warehouses w ON e.warehouse_id = w.warehouse_id;

-- Query 2: JOIN - Departments with CustomerSupportTickets and Employees
SELECT d.department_name, t.ticket_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
LEFT JOIN CustomerSupportTickets t ON e.employee_id = t.employee_id;

-- Query 3: JOIN - Departments with SellerAccounts and Employees
SELECT d.department_name, s.seller_name, CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
LEFT JOIN SellerAccounts s ON e.employee_id = s.employee_id;

-- Query 4: JOIN - Departments with Orders and CustomerSupportTickets
SELECT d.department_name, o.order_id, t.ticket_id
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
LEFT JOIN CustomerSupportTickets t ON e.employee_id = t.employee_id
LEFT JOIN Orders o ON t.order_id = o.order_id;

-- Query 5: JOIN - Departments with Products and SellerAccounts
SELECT d.department_name, p.product_name, s.seller_name
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
LEFT JOIN SellerAccounts s ON e.employee_id = s.employee_id
LEFT JOIN Products p ON s.seller_id = p.seller_id;

-- Query 6: Subquery - Departments with active employees
SELECT department_name
FROM Departments
WHERE EXISTS (SELECT 1 FROM Employees e WHERE e.department_id = Departments.department_id AND e.is_active = TRUE);

-- Query 7: Subquery - Departments with support tickets
SELECT department_name
FROM Departments
WHERE EXISTS (SELECT 1 FROM CustomerSupportTickets t JOIN Employees e ON t.employee_id = e.employee_id WHERE e.department_id = Departments.department_id);

-- Query 8: Subquery - Departments with seller accounts
SELECT department_name
FROM Departments
WHERE EXISTS (SELECT 1 FROM SellerAccounts s JOIN Employees e ON s.employee_id = e.employee_id WHERE e.department_id = Departments.department_id);

-- Query 9: Subquery - Departments in active warehouses
SELECT department_name
FROM Departments
WHERE EXISTS (SELECT 1 FROM Employees e JOIN Warehouses w ON e.warehouse_id = w.warehouse_id WHERE e.department_id = Departments.department_id AND w.is_active = TRUE);

-- Query 10: Subquery - Departments with high employee count
SELECT department_name
FROM Departments
WHERE department_id IN (SELECT department_id FROM Employees GROUP BY department_id HAVING COUNT(*) > 5);

-- Query 11: Built-in Function - Department name length
SELECT department_name, LENGTH(department_name) AS name_length
FROM Departments
WHERE department_name IS NOT NULL;

-- Query 12: Built-in Function - Created date formatted
SELECT department_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Departments
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase department name
SELECT UPPER(department_name) AS department_name
FROM Departments;

-- Query 14: Built-in Function - Description length
SELECT department_name, LENGTH(description) AS desc_length
FROM Departments
WHERE description IS NOT NULL;

-- Query 15: Built-in Function - Department status
SELECT department_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS department_status
FROM Departments;

-- Query 16: User-Defined Function - Format department name
DELIMITER //
CREATE FUNCTION FormatDepartmentName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2)));
END //
DELIMITER ;
SELECT department_name, FormatDepartmentName(department_name) AS formatted_name
FROM Departments;

-- Query 17: User-Defined Function - Check active department
DELIMITER //
CREATE FUNCTION IsActiveDepartment(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT department_name, is_active, IsActiveDepartment(is_active) AS department_status
FROM Departments;

-- Query 18: User-Defined Function - Get employee count
DELIMITER //
CREATE FUNCTION GetDepartmentEmployeeCount(department_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count FROM Employees WHERE department_id = department_id;
    RETURN emp_count;
END //
DELIMITER ;
SELECT department_name, GetDepartmentEmployeeCount(department_id) AS employee_count
FROM Departments;

-- Query 19: User-Defined Function - Calculate department age
DELIMITER //
CREATE FUNCTION GetDepartmentAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT department_name, created_date, GetDepartmentAge(created_date) AS department_age_in_days
FROM Departments
WHERE created_date IS NOT NULL;

-- Query 20: User-Defined Function - Get ticket count
DELIMITER //
CREATE FUNCTION GetDepartmentTicketCount(department_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ticket_count INT;
    SELECT COUNT(*) INTO ticket_count FROM CustomerSupportTickets t JOIN Employees e ON t.employee_id = e.employee_id WHERE e.department_id = department_id;
    RETURN ticket_count;
END //
DELIMITER ;
SELECT department_name, GetDepartmentTicketCount(department_id) AS ticket_count
FROM Departments;

-- Table 23: Coupons Table Queries
-- Query 1: JOIN - Coupons with Orders and Customers
SELECT co.coupon_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Coupons co
LEFT JOIN Orders o ON co.coupon_id = o.coupon_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 2: JOIN - Coupons with Products and Orders
SELECT co.coupon_code, p.product_name, o.order_id
FROM Coupons co
LEFT JOIN Orders o ON co.coupon_id = o.coupon_id
LEFT JOIN Products p ON o.product_id = p.product_id;

-- Query 3: JOIN - Coupons with Payments and Orders
SELECT co.coupon_id, p.payment_amount, o.order_id
FROM Coupons co
LEFT JOIN Orders o ON co.coupon_id = o.coupon_id
LEFT JOIN Payments p ON o.order_id = p.order_id;

-- Query 4: JOIN - Coupons with Subscriptions and Customers
SELECT co.coupon_id, s.subscription_plan, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Coupons co
LEFT JOIN Subscriptions s ON co.coupon_id = s.coupon_id
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 5: JOIN - Coupons with Discounts and Orders
SELECT co.coupon_code, d.discount_percentage, o.order_id
FROM Coupons co
LEFT JOIN Orders o ON co.coupon_id = o.coupon_id
LEFT JOIN Discounts d ON o.product_id = d.product_id;

-- Query 6: Subquery - Coupons used in orders
SELECT coupon_id
FROM Coupons
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.coupon_id = Coupons.coupon_id);

-- Query 7: Subquery - Active coupons
SELECT coupon_code
FROM Coupons
WHERE is_active = TRUE;

-- Query 8: Subquery - Coupons for subscriptions
SELECT coupon_id
FROM Coupons
WHERE EXISTS (SELECT 1 FROM Subscriptions s WHERE s.coupon_id = Coupons.coupon_id);

-- Query 9: Subquery - Coupons for specific customers
SELECT coupon_id
FROM Coupons
WHERE EXISTS (SELECT 1 FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id WHERE o.coupon_id = Coupons.coupon_id);

-- Query 10: Subquery - Coupons for specific products
SELECT coupon_id
FROM Coupons
WHERE EXISTS (SELECT 1 FROM Orders o JOIN Products p ON o.product_id = p.product_id WHERE o.coupon_id = Coupons.coupon_id);

-- Query 11: Built-in Function - Coupon code length
SELECT coupon_id, LENGTH(coupon_code) AS code_length
FROM Coupons
WHERE coupon_code IS NOT NULL;

-- Query 12: Built-in Function - Start date formatted
SELECT coupon_id, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_date
FROM Coupons
WHERE start_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase coupon code
SELECT UPPER(coupon_code) AS coupon_code
FROM Coupons;

-- Query 14: Built-in Function - Discount amount rounded
SELECT coupon_id, ROUND(discount_amount) AS rounded_amount
FROM Coupons
WHERE discount_amount > 0;

-- Query 15: Built-in Function - Coupon status
SELECT coupon_id, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Expired'
       END AS coupon_status
FROM Coupons;

-- Query 16: User-Defined Function - Format coupon code
DELIMITER //
CREATE FUNCTION FormatCouponCode(code VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(code);
END //
DELIMITER ;
SELECT coupon_id, coupon_code, FormatCouponCode(coupon_code) AS formatted_code
FROM Coupons;

-- Query 17: User-Defined Function - Check active coupon
DELIMITER //
CREATE FUNCTION IsActiveCoupon(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Expired';
    END IF;
END //
DELIMITER ;
SELECT coupon_id, is_active, IsActiveCoupon(is_active) AS coupon_status
FROM Coupons;

-- Query 18: User-Defined Function - Get order count
DELIMITER //
CREATE FUNCTION GetCouponOrderCount(coupon_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ord_count INT;
    SELECT COUNT(*) INTO ord_count FROM Orders WHERE coupon_id = coupon_id;
    RETURN ord_count;
END //
DELIMITER ;
SELECT coupon_id, GetCouponOrderCount(coupon_id) AS order_count
FROM Coupons;

-- Query 19: User-Defined Function - Calculate coupon duration
DELIMITER //
CREATE FUNCTION GetCouponDuration(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END //
DELIMITER ;
SELECT coupon_id, start_date, end_date, GetCouponDuration(start_date, end_date) AS duration_in_days
FROM Coupons
WHERE end_date IS NOT NULL AND start_date IS NOT NULL;

-- Query 20: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetCouponCustomerName(coupon_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(c.first_name, ' ', c.last_name) INTO cust_name FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id WHERE o.coupon_id = coupon_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT coupon_id, GetCouponCustomerName(coupon_id) AS customer_name
FROM Coupons;

-- Table 24: Feedback Table Queries
-- Query 1: JOIN - Feedback with Customers and Products
SELECT f.feedback_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, p.product_name
FROM Feedback f
LEFT JOIN Customers c ON f.customer_id = c.customer_id
LEFT JOIN Products p ON f.product_id = p.product_id;

-- Query 2: JOIN - Feedback with Orders and Customers
SELECT f.feedback_id, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Feedback f
LEFT JOIN Orders o ON f.product_id = o.product_id
LEFT JOIN Customers c ON f.customer_id = c.customer_id;

-- Query 3: JOIN - Feedback with Reviews and Products
SELECT f.feedback_id, r.rating AS review_rating, p.product_name
FROM Feedback f
LEFT JOIN Reviews r ON f.product_id = r.product_id
LEFT JOIN Products p ON f.product_id = p.product_id;

-- Query 4: JOIN - Feedback with Categories and Products
SELECT f.feedback_id, c.category_name, p.product_name
FROM Feedback f
LEFT JOIN Products p ON f.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 5: JOIN - Feedback with Promotions and Products
SELECT f.feedback_id, pr.promotion_name, p.product_name
FROM Feedback f
LEFT JOIN Promotions pr ON f.product_id = pr.product_id
LEFT JOIN Products p ON f.product_id = p.product_id;

-- Query 6: Subquery - Feedback for active products
SELECT feedback_id
FROM Feedback
WHERE product_id IN (SELECT product_id FROM Products WHERE is_active = TRUE);

-- Query 7: Subquery - Feedback from specific customers
SELECT feedback_id
FROM Feedback
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 8: Subquery - Approved feedback
SELECT feedback_id
FROM Feedback
WHERE status = 'Approved';

-- Query 9: Subquery - Feedback for ordered products
SELECT feedback_id
FROM Feedback
WHERE EXISTS (SELECT 1 FROM Orders o WHERE o.product_id = Feedback.product_id);

-- Query 10: Subquery - Anonymous feedback
SELECT feedback_id
FROM Feedback
WHERE is_anonymous = TRUE;

-- Query 11: Built-in Function - Comment length
SELECT feedback_id, LENGTH(comment) AS comment_length
FROM Feedback
WHERE comment IS NOT NULL;

-- Query 12: Built-in Function - Feedback date formatted
SELECT feedback_id, DATE_FORMAT(feedback_date, '%M %d, %Y') AS formatted_date
FROM Feedback
WHERE feedback_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase status
SELECT feedback_id, UPPER(status) AS feedback_status
FROM Feedback;

-- Query 14: Built-in Function - Rating rounded
SELECT feedback_id, ROUND(rating) AS rounded_rating
FROM Feedback
WHERE rating BETWEEN 1 AND 5;

-- Query 15: Built-in Function - Feedback anonymity status
SELECT feedback_id, 
       CASE 
           WHEN is_anonymous = TRUE THEN 'Anonymous'
           ELSE 'Named'
       END AS anonymity_status
FROM Feedback;

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
WHERE comment IS NOT NULL;

-- Query 17: User-Defined Function - Check feedback status
DELIMITER //
CREATE FUNCTION IsApprovedFeedback(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Approved' THEN
        RETURN 'Published';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT feedback_id, status, IsApprovedFeedback(status) AS feedback_status
FROM Feedback;

-- Query 18: User-Defined Function - Get customer name
DELIMITER //
CREATE FUNCTION GetFeedbackCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN IFNULL(cust_name, 'Unknown');
END //
DELIMITER ;
SELECT feedback_id, GetFeedbackCustomerName(customer_id) AS customer_name
FROM Feedback;

-- Query 19: User-Defined Function - Calculate feedback age
DELIMITER //
CREATE FUNCTION GetFeedbackAge(feedback_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), feedback_date);
END //
DELIMITER ;
SELECT feedback_id, feedback_date, GetFeedbackAge(feedback_date) AS feedback_age_in_days
FROM Feedback
WHERE feedback_date IS NOT NULL;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetFeedbackProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN IFNULL(prod_name, 'Unknown');
END //
DELIMITER ;
SELECT feedback_id, GetFeedbackProductName(product_id) AS product_name
FROM Feedback;

-- Table 25: Logs Table Queries
-- Query 1: JOIN - Logs with Employees and Departments
SELECT l.log_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, d.department_name
FROM Logs l
LEFT JOIN Employees e ON l.user_id = e.employee_id
LEFT JOIN Departments d ON e.department_id = d.department_id;

-- Query 2: JOIN - Logs with Orders and Customers
SELECT l.log_id, l.action, o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Logs l
LEFT JOIN Orders o ON l.table_name = 'Orders' AND l.record_id = o.order_id
LEFT JOIN Customers c ON o.customer_id = c.customer_id;

-- Query 3: JOIN - Logs with Products and Categories
SELECT l.log_id, l.action, p.product_name, c.category_name
FROM Logs l
LEFT JOIN Products p ON l.table_name = 'Products' AND l.record_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 4: JOIN - Logs with Payments and Orders
SELECT l.log_id, l.action, p.payment_amount, o.order_id
FROM Logs l
LEFT JOIN Payments p ON l.table_name = 'Payments' AND l.record_id = p.payment_id
LEFT JOIN Orders o ON p.order_id = o.order_id;

-- Query 5: JOIN - Logs with Feedback and Customers
SELECT l.log_id, l.action, f.comment, CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM Logs l
LEFT JOIN Feedback f ON l.table_name = 'Feedback' AND l.record_id = f.feedback_id
LEFT JOIN Customers c ON f.customer_id = c.customer_id;

-- Query 6: Subquery - Logs for active employees
SELECT log_id
FROM Logs
WHERE user_id IN (SELECT employee_id FROM Employees WHERE is_active = TRUE);

-- Query 7: Subquery - Successful logs
SELECT log_id
FROM Logs
WHERE status = 'Success';

-- Query 8: Subquery - Logs for order actions
SELECT log_id
FROM Logs
WHERE table_name = 'Orders' AND EXISTS (SELECT 1 FROM Orders o WHERE o.order_id = Logs.record_id);

-- Query 9: Subquery - Logs for product updates
SELECT log_id
FROM Logs
WHERE table_name = 'Products' AND EXISTS (SELECT 1 FROM Products p WHERE p.product_id = Logs.record_id);

-- Query 10: Subquery - Logs for feedback actions
SELECT log_id
FROM Logs
WHERE table_name = 'Feedback' AND EXISTS (SELECT 1 FROM Feedback f WHERE f.feedback_id = Logs.record_id);

-- Query 11: Built-in Function - Action length
SELECT log_id, LENGTH(action) AS action_length
FROM Logs
WHERE action IS NOT NULL;

-- Query 12: Built-in Function - Log date formatted
SELECT log_id, DATE_FORMAT(log_date, '%M %d, %Y %H:%i:%s') AS formatted_date
FROM Logs
WHERE log_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase table name
SELECT log_id, UPPER(table_name) AS table_name
FROM Logs;

-- Query 14: Built-in Function - IP address length
SELECT log_id, LENGTH(ip_address) AS ip_length
FROM Logs
WHERE ip_address IS NOT NULL;

-- Query 15: Built-in Function - Log status
SELECT log_id, 
       CASE 
           WHEN status = 'Success' THEN 'Completed'
           ELSE 'Failed'
       END AS log_status
FROM Logs;

-- Query 16: User-Defined Function - Format log action
DELIMITER //
CREATE FUNCTION FormatLogAction(action VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(action, 1)), LOWER(SUBSTRING(action, 2)));
END //
DELIMITER ;
SELECT log_id, action, FormatLogAction(action) AS formatted_action
FROM Logs
WHERE action IS NOT NULL;

-- Query 17: User-Defined Function - Check log status
DELIMITER //
CREATE FUNCTION IsSuccessfulLog(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Success' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Failed';
    END IF;
END //
DELIMITER ;
SELECT log_id, status, IsSuccessfulLog(status) AS log_status
FROM Logs;

-- Query 18: User-Defined Function - Get employee name
DELIMITER //
CREATE FUNCTION GetLogEmployeeName(user_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT CONCAT(first_name, ' ', last_name) INTO emp_name FROM Employees WHERE employee_id = user_id;
    RETURN IFNULL(emp_name, 'Unknown');
END //
DELIMITER ;
SELECT log_id, GetLogEmployeeName(user_id) AS employee_name
FROM Logs;

-- Query 19: User-Defined Function - Calculate log age
DELIMITER //
CREATE FUNCTION GetLogAge(log_date DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), log_date);
END //
DELIMITER ;
SELECT log_id, log_date, GetLogAge(log_date) AS log_age_in_days
FROM Logs
WHERE log_date IS NOT NULL;

-- Query 20: User-Defined Function - Get table record count
DELIMITER //
CREATE FUNCTION GetLogTableRecordCount(table_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE rec_count INT;
    SET @sql = CONCAT('SELECT COUNT(*) INTO @count FROM ', table_name);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    SET rec_count = @count;
    DEALLOCATE PREPARE stmt;
    RETURN rec_count;
END //
DELIMITER ;
SELECT log_id, table_name, GetLogTableRecordCount(table_name) AS record_count
FROM Logs;
