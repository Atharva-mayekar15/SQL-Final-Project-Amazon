-- Project Phase-4(V&C<SP<WF<D&TCL<Tri)

-- **Table 1: Products**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active products with price greater than $100
CREATE VIEW ActiveHighPricedProducts AS
SELECT product_id, product_name, price, category_id, stock_quantity
FROM Products
WHERE is_active = TRUE AND price > 100;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of products with supplier and category details
CREATE VIEW ProductDetails AS
SELECT p.product_id, p.product_name, p.price, c.category_name, s.supplier_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of top-rated products with rating >= 4.5
CREATE VIEW TopRatedProducts AS
SELECT product_id, product_name, rating, category_id
FROM Products
WHERE rating >= 4.5 AND is_active = TRUE;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of products with low stock (< 50 units)
CREATE VIEW LowStockProducts AS
SELECT product_id, product_name, stock_quantity, supplier_id
FROM Products
WHERE stock_quantity < 50 AND is_active = TRUE;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to compare product prices with the average price in their category
WITH CategoryAvgPrice AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM Products
    GROUP BY category_id
)
SELECT p.product_id, p.product_name, p.price, c.avg_price
FROM Products p
JOIN CategoryAvgPrice c ON p.category_id = c.category_id
WHERE p.is_active = TRUE;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list products with supplier contact details
WITH SupplierContacts AS (
    SELECT supplier_id, supplier_name, contact_email
    FROM Suppliers
)
SELECT p.product_id, p.product_name, s.supplier_name, s.contact_email
FROM Products p
JOIN SupplierContacts s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find products included in orders since 2024
WITH RecentOrders AS (
    SELECT product_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT p.product_id, p.product_name, p.price
FROM Products p
JOIN RecentOrders ro ON p.product_id = ro.product_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list products with average review ratings >= 4
WITH HighRatedReviews AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
    HAVING avg_rating >= 4
)
SELECT p.product_id, p.product_name, h.avg_rating
FROM Products p
JOIN HighRatedReviews h ON p.product_id = h.product_id
WHERE p.is_active = TRUE;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new product
DELIMITER //
CREATE PROCEDURE AddProduct(
    IN p_product_id INT,
    IN p_product_name VARCHAR(100),
    IN p_category_id INT,
    IN p_price DECIMAL(10,2),
    IN p_stock_quantity INT,
    IN p_supplier_id INT,
    IN p_rating FLOAT,
    IN p_release_date DATE,
    IN p_is_active BOOLEAN,
    IN p_description TEXT
)
BEGIN
    INSERT INTO Products (product_id, product_name, category_id, price, stock_quantity, supplier_id, rating, release_date, is_active, description)
    VALUES (p_product_id, p_product_name, p_category_id, p_price, p_stock_quantity, p_supplier_id, p_rating, p_release_date, p_is_active, p_description);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a product's price
DELIMITER //
CREATE PROCEDURE UpdateProductPrice(
    IN p_product_id INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    UPDATE Products
    SET price = p_new_price
    WHERE product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a product
DELIMITER //
CREATE PROCEDURE DeleteProduct(
    IN p_product_id INT
)
BEGIN
    DELETE FROM Products
    WHERE product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve product details with category and supplier info
DELIMITER //
CREATE PROCEDURE GetProductDetails(
    IN p_product_id INT
)
BEGIN
    SELECT p.product_id, p.product_name, p.price, c.category_name, s.supplier_name
    FROM Products p
    JOIN Categories c ON p.category_id = c.category_id
    JOIN Suppliers s ON p.supplier_id = s.supplier_id
    WHERE p.product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new gaming console product
INSERT INTO Products (product_id, product_name, category_id, price, stock_quantity, supplier_id, rating, release_date, is_active, description)
VALUES (21, 'Gaming Console', 1, 399.99, 100, 101, 4.7, '2025-01-01', TRUE, 'Next-gen gaming console');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates stock quantity for product ID 1 by adding 50 units
UPDATE Products
SET stock_quantity = stock_quantity + 50
WHERE product_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a discontinued product with product ID 1
DELETE FROM Products
WHERE product_id = 1 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates product rating based on average review rating within a transaction
START TRANSACTION;
UPDATE Products p
SET rating = (
    SELECT AVG(rating)
    FROM Reviews r
    WHERE r.product_id = p.product_id
)
WHERE p.product_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record product insertions
CREATE TABLE ProductLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    action VARCHAR(50),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogProductInsert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductLog (product_id, action, log_date, user_id)
    VALUES (NEW.product_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log product price updates
DELIMITER //
CREATE TRIGGER LogProductPriceUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO ProductLog (product_id, action, log_date, user_id)
        VALUES (NEW.product_id, CONCAT('PRICE_UPDATE: ', OLD.price, ' to ', NEW.price), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative stock quantities
DELIMITER //
CREATE TRIGGER PreventNegativeStock
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a table and trigger to update category product count
CREATE TABLE CategoryProductCount (
    category_id INT PRIMARY KEY,
    product_count INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
DELIMITER //
CREATE TRIGGER UpdateCategoryProductCount
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO CategoryProductCount (category_id, product_count)
    VALUES (NEW.category_id, (SELECT COUNT(*) FROM Products WHERE category_id = NEW.category_id))
    ON DUPLICATE KEY UPDATE product_count = (SELECT COUNT(*) FROM Products WHERE category_id = NEW.category_id);
END //
DELIMITER ;

-- **Table 2: Customers**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of customers registered after January 1, 2024
CREATE VIEW RecentCustomers AS
SELECT customer_id, first_name, last_name, email, registration_date
FROM Customers
WHERE registration_date >= '2024-01-01';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of customers with their default addresses
CREATE VIEW CustomerAddresses AS
SELECT c.customer_id, c.first_name, c.last_name, a.street, a.city
FROM Customers c
JOIN Addresses a ON c.customer_id = a.customer_id
WHERE a.is_default = TRUE;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of customers with active subscriptions
CREATE VIEW SubscribedCustomers AS
SELECT c.customer_id, c.first_name, s.plan_name
FROM Customers c
JOIN Subscriptions s ON c.customer_id = s.customer_id
WHERE s.is_active = TRUE;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of customers with more than one order
CREATE VIEW FrequentCustomers AS
SELECT c.customer_id, c.first_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name
HAVING order_count > 1;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count customers by state
WITH CustomerByState AS (
    SELECT state, COUNT(*) AS customer_count
    FROM Customers
    GROUP BY state
)
SELECT state, customer_count
FROM CustomerByState
WHERE customer_count > 1;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list customers with their payment methods
WITH CustomerPayments AS (
    SELECT customer_id, payment_type
    FROM Payment_Methods
)
SELECT c.customer_id, c.first_name, cp.payment_type
FROM Customers c
JOIN CustomerPayments cp ON c.customer_id = cp.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find customers with recent orders
WITH RecentOrders AS (
    SELECT customer_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN RecentOrders ro ON c.customer_id = ro.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list customers with active addresses
WITH ActiveAddresses AS (
    SELECT customer_id
    FROM Addresses
    WHERE is_default = TRUE
)
SELECT c.customer_id, c.first_name, c.email
FROM Customers c
JOIN ActiveAddresses aa ON c.customer_id = aa.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new customer
DELIMITER //
CREATE PROCEDURE AddCustomer(
    IN p_customer_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone_number VARCHAR(15),
    IN p_state VARCHAR(50),
    IN p_registration_date DATE
)
BEGIN
    INSERT INTO Customers (customer_id, first_name, last_name, email, phone_number, state, registration_date)
    VALUES (p_customer_id, p_first_name, p_last_name, p_email, p_phone_number, p_state, p_registration_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a customer's email
DELIMITER //
CREATE PROCEDURE UpdateCustomerEmail(
    IN p_customer_id INT,
    IN p_new_email VARCHAR(100)
)
BEGIN
    UPDATE Customers
    SET email = p_new_email
    WHERE customer_id = p_customer_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a customer
DELIMITER //
CREATE PROCEDURE DeleteCustomer(
    IN p_customer_id INT
)
BEGIN
    DELETE FROM Customers
    WHERE customer_id = p_customer_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve customer details
DELIMITER //
CREATE PROCEDURE GetCustomerDetails(
    IN p_customer_id INT
)
BEGIN
    SELECT c.customer_id, c.first_name, c.last_name, a.street, a.city
    FROM Customers c
    LEFT JOIN Addresses a ON c.customer_id = a.customer_id
    WHERE c.customer_id = p_customer_id AND (a.is_default = TRUE OR a.is_default IS NULL);
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new customer
INSERT INTO Customers (customer_id, first_name, last_name, email, phone_number, state, registration_date)
VALUES (201, 'John', 'Smith', 'john.smith@email.com', '123-456-7890', 'CA', '2025-06-07');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a customer's phone number
UPDATE Customers
SET phone_number = '987-654-3210'
WHERE customer_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a customer with no orders
DELETE FROM Customers
WHERE customer_id = 1
AND NOT EXISTS (
    SELECT 1 FROM Orders WHERE customer_id = 1
);

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates customer state within a transaction
START TRANSACTION;
UPDATE Customers
SET state = 'NY'
WHERE customer_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record customer insertions
CREATE TABLE CustomerLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogCustomerInsert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
    VALUES (NEW.customer_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log customer email updates
DELIMITER //
CREATE TRIGGER LogCustomerEmailUpdate
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
        VALUES (NEW.customer_id, CONCAT('EMAIL_UPDATE: ', OLD.email, ' to ', NEW.email), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent duplicate emails
DELIMITER //
CREATE TRIGGER BeforeCustomerInsert
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Customers WHERE email = NEW.email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Triggers
-- Description: Creates a trigger to log customer deletions
DELIMITER //
CREATE TRIGGER LogCustomerDelete
AFTER DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
    VALUES (OLD.customer_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 3: Categories**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active categories
CREATE VIEW ActiveCategories AS
SELECT category_id, category_name, parent_category_id
FROM Categories
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of categories with product counts
CREATE VIEW CategoryProductCounts AS
SELECT c.category_id, c.category_name,্র

System: Apologies for the interruption. Here is the complete corrected SQL file with `DELIMITER` statements added to all triggers and the typo in the `LogCustomerInsert` trigger fixed (changing `customerLog` to `CustomerLog`). All non-trigger queries remain unchanged, and the structure, comments, and query numbering are preserved as in the original file.

<xaiArtifact artifact_id="39887b4d-992a-46b5-b68a-90ed0247ea83" artifact_version_id="3ca6d3a4-611a-438c-82d2-29dcc82c1e71" title="corrected_phase4.sql" contentType="text/sql">
-- **Table 1: Products**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active products with price greater than $100
CREATE VIEW ActiveHighPricedProducts AS
SELECT product_id, product_name, price, category_id, stock_quantity
FROM Products
WHERE is_active = TRUE AND price > 100;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of products with supplier and category details
CREATE VIEW ProductDetails AS
SELECT p.product_id, p.product_name, p.price, c.category_name, s.supplier_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of top-rated products with rating >= 4.5
CREATE VIEW TopRatedProducts AS
SELECT product_id, product_name, rating, category_id
FROM Products
WHERE rating >= 4.5 AND is_active = TRUE;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of products with low stock (< 50 units)
CREATE VIEW LowStockProducts AS
SELECT product_id, product_name, stock_quantity, supplier_id
FROM Products
WHERE stock_quantity < 50 AND is_active = TRUE;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to compare product prices with the average price in their category
WITH CategoryAvgPrice AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM Products
    GROUP BY category_id
)
SELECT p.product_id, p.product_name, p.price, c.avg_price
FROM Products p
JOIN CategoryAvgPrice c ON p.category_id = c.category_id
WHERE p.is_active = TRUE;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list products with supplier contact details
WITH SupplierContacts AS (
    SELECT supplier_id, supplier_name, contact_email
    FROM Suppliers
)
SELECT p.product_id, p.product_name, s.supplier_name, s.contact_email
FROM Products p
JOIN SupplierContacts s ON p.supplier_id = s.supplier_id
WHERE p.is_active = TRUE;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find products included in orders since 2024
WITH RecentOrders AS (
    SELECT product_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT p.product_id, p.product_name, p.price
FROM Products p
JOIN RecentOrders ro ON p.product_id = ro.product_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list products with average review ratings >= 4
WITH HighRatedReviews AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
    HAVING avg_rating >= 4
)
SELECT p.product_id, p.product_name, h.avg_rating
FROM Products p
JOIN HighRatedReviews h ONས

System: I apologize for the previous response being cut off. Below is the continuation of the corrected SQL file, starting from the point where it was interrupted, with all triggers properly wrapped with `DELIMITER //` and `DELIMITER ;`, and the typo in the `LogCustomerInsert` trigger fixed (`customerLog` to `CustomerLog`). The rest of the file remains unchanged except for the trigger sections (Queries 17–20 for each table) and the typo correction.

<xaiArtifact artifact_id="39887b4d-992a-46b5-b68a-90ed0247ea83" artifact_version_id="7f85fbcd-64d6-4310-976f-ee6e092ee40a" title="corrected_phase4.sql" contentType="text/sql">
-- **Table 1: Products** (continued)

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record product insertions
CREATE TABLE ProductLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    action VARCHAR(50),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogProductInsert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductLog (product_id, action, log_date, user_id)
    VALUES (NEW.product_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log product price updates
DELIMITER //
CREATE TRIGGER LogProductPriceUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO ProductLog (product_id, action, log_date, user_id)
        VALUES (NEW.product_id, CONCAT('PRICE_UPDATE: ', OLD.price, ' to ', NEW.price), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative stock quantities
DELIMITER //
CREATE TRIGGER PreventNegativeStock
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a table and trigger to update category product count
CREATE TABLE CategoryProductCount (
    category_id INT PRIMARY KEY,
    product_count INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
DELIMITER //
CREATE TRIGGER UpdateCategoryProductCount
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO CategoryProductCount (category_id, product_count)
    VALUES (NEW.category_id, (SELECT COUNT(*) FROM Products WHERE category_id = NEW.category_id))
    ON DUPLICATE KEY UPDATE product_count = (SELECT COUNT(*) FROM Products WHERE category_id = NEW.category_id);
END //
DELIMITER ;

-- **Table 2: Customers**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of customers registered after January 1, 2024
CREATE VIEW RecentCustomers AS
SELECT customer_id, first_name, last_name, email, registration_date
FROM Customers
WHERE registration_date >= '2024-01-01';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of customers with their default addresses
CREATE VIEW CustomerAddresses AS
SELECT c.customer_id, c.first_name, c.last_name, a.street, a.city
FROM Customers c
JOIN Addresses a ON c.customer_id = a.customer_id
WHERE a.is_default = TRUE;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of customers with active subscriptions
CREATE VIEW SubscribedCustomers AS
SELECT c.customer_id, c.first_name, s.plan_name
FROM Customers c
JOIN Subscriptions s ON c.customer_id = s.customer_id
WHERE s.is_active = TRUE;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of customers with more than one order
CREATE VIEW FrequentCustomers AS
SELECT c.customer_id, c.first_name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name
HAVING order_count > 1;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count customers by state
WITH CustomerByState AS (
    SELECT state, COUNT(*) AS customer_count
    FROM Customers
    GROUP BY state
)
SELECT state, customer_count
FROM CustomerByState
WHERE customer_count > 1;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list customers with their payment methods
WITH CustomerPayments AS (
    SELECT customer_id, payment_type
    FROM Payment_Methods
)
SELECT c.customer_id, c.first_name, cp.payment_type
FROM Customers c
JOIN CustomerPayments cp ON c.customer_id = cp.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find customers with recent orders
WITH RecentOrders AS (
    SELECT customer_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT c.customer_id, c.first_name, c.last_name
FROM Customers c
JOIN RecentOrders ro ON c.customer_id = ro.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list customers with active addresses
WITH ActiveAddresses AS (
    SELECT customer_id
    FROM Addresses
    WHERE is_default = TRUE
)
SELECT c.customer_id, c.first_name, c.email
FROM Customers c
JOIN ActiveAddresses aa ON c.customer_id = aa.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new customer
DELIMITER //
CREATE PROCEDURE AddCustomer(
    IN p_customer_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone_number VARCHAR(15),
    IN p_state VARCHAR(50),
    IN p_registration_date DATE
)
BEGIN
    INSERT INTO Customers (customer_id, first_name, last_name, email, phone_number, state, registration_date)
    VALUES (p_customer_id, p_first_name, p_last_name, p_email, p_phone_number, p_state, p_registration_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a customer's email
DELIMITER //
CREATE PROCEDURE UpdateCustomerEmail(
    IN p_customer_id INT,
    IN p_new_email VARCHAR(100)
)
BEGIN
    UPDATE Customers
    SET email = p_new_email
    WHERE customer_id = p_customer_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a customer
DELIMITER //
CREATE PROCEDURE DeleteCustomer(
    IN p_customer_id INT
)
BEGIN
    DELETE FROM Customers
    WHERE customer_id = p_customer_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve customer details
DELIMITER //
CREATE PROCEDURE GetCustomerDetails(
    IN p_customer_id INT
)
BEGIN
    SELECT c.customer_id, c.first_name, c.last_name, a.street, a.city
    FROM Customers c
    LEFT JOIN Addresses a ON c.customer_id = a.customer_id
    WHERE c.customer_id = p_customer_id AND (a.is_default = TRUE OR a.is_default IS NULL);
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new customer
INSERT INTO Customers (customer_id, first_name, last_name, email, phone_number, state, registration_date)
VALUES (201, 'John', 'Smith', 'john.smith@email.com', '123-456-7890', 'CA', '2025-06-07');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a customer's phone number
UPDATE Customers
SET phone_number = '987-654-3210'
WHERE customer_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a customer with no orders
DELETE FROM Customers
WHERE customer_id = 1
AND NOT EXISTS (
    SELECT 1 FROM Orders WHERE customer_id = 1
);

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates customer state within a transaction
START TRANSACTION;
UPDATE Customers
SET state = 'NY'
WHERE customer_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record customer insertions
CREATE TABLE CustomerLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogCustomerInsert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
    VALUES (NEW.customer_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log customer email updates
DELIMITER //
CREATE TRIGGER LogCustomerEmailUpdate
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
        VALUES (NEW.customer_id, CONCAT('EMAIL_UPDATE: ', OLD.email, ' to ', NEW.email), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent duplicate emails
DELIMITER //
CREATE TRIGGER BeforeCustomerInsert
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Customers WHERE email = NEW.email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log customer deletions
DELIMITER //
CREATE TRIGGER LogCustomerDelete
AFTER DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO CustomerLog (customer_id, action, log_date, user_id)
    VALUES (OLD.customer_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 3: Categories**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active categories
CREATE VIEW ActiveCategories AS
SELECT category_id, category_name, parent_category_id
FROM Categories
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of categories with product counts
CREATE VIEW CategoryProductCounts AS
SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of top-level categories
CREATE VIEW TopLevelCategories AS
SELECT category_id, category_name
FROM Categories
WHERE parent_category_id IS NULL AND is_active = TRUE;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of categories with subcategories
CREATE VIEW CategoryHierarchy AS
SELECT c1.category_id, c1.category_name, c2.category_name AS subcategory_name
FROM Categories c1
LEFT JOIN Categories c2 ON c2.parent_category_id = c1.category_id
WHERE c1.is_active = TRUE;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to list categories with their parent categories
WITH ParentCategories AS (
    SELECT category_id, category_name
    FROM Categories
    WHERE parent_category_id IS NULL
)
SELECT c.category_id, c.category_name, pc.category_name AS parent_name
FROM Categories c
LEFT JOIN ParentCategories pc ON c.parent_category_id = pc.category_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to count products per category
WITH CategoryCounts AS (
    SELECT category_id, COUNT(*) AS product_count
    FROM Products
    GROUP BY category_id
)
SELECT c.category_id, c.category_name, COALESCE(cc.product_count, 0) AS product_count
FROM Categories c
LEFT JOIN CategoryCounts cc ON c.category_id = cc.category_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to list active categories with products
WITH ActiveProducts AS (
    SELECT category_id
    FROM Products
    WHERE is_active = TRUE
)
SELECT c.category_id, c.category_name
FROM Categories c
JOIN ActiveProducts ap ON c.category_id = ap.category_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to find categories with high-priced products
WITH HighPricedProducts AS (
    SELECT category_id
    FROM Products
    WHERE price > 100
)
SELECT c.category_id, c.category_name
FROM Categories c
JOIN HighPricedProducts hpp ON c.category_id = hpp.category_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new category
DELIMITER //
CREATE PROCEDURE AddCategory(
    IN p_category_id INT,
    IN p_category_name VARCHAR(100),
    IN p_parent_category_id INT,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Categories (category_id, category_name, parent_category_id, is_active)
    VALUES (p_category_id, p_category_name, p_parent_category_id, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a category's name
DELIMITER //
CREATE PROCEDURE UpdateCategoryName(
    IN p_category_id INT,
    IN p_new_name VARCHAR(100)
)
BEGIN
    UPDATE Categories
    SET category_name = p_new_name
    WHERE category_id = p_category_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a category
DELIMITER //
CREATE PROCEDURE DeleteCategory(
    IN p_category_id INT
)
BEGIN
    DELETE FROM Categories
    WHERE category_id = p_category_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve category details
DELIMITER //
CREATE PROCEDURE GetCategoryDetails(
    IN p_category_id INT
)
BEGIN
    SELECT c.category_id, c.category_name, c2.category_name AS parent_name
    FROM Categories c
    LEFT JOIN Categories c2 ON c.parent_category_id = c2.category_id
    WHERE c.category_id = p_category_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new category
INSERT INTO Categories (category_id, category_name, parent_category_id, is_active)
VALUES (101, 'Electronics', NULL, TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a category's active status
UPDATE Categories
SET is_active = FALSE
WHERE category_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive category
DELETE FROM Categories
WHERE category_id = 1 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates category name within a transaction
START TRANSACTION;
UPDATE Categories
SET category_name = 'New Electronics'
WHERE category_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record category insertions
CREATE TABLE CategoryLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogCategoryInsert
AFTER INSERT ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO CategoryLog (category_id, action, log_date, user_id)
    VALUES (NEW.category_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log category name updates
DELIMITER //
CREATE TRIGGER LogCategoryNameUpdate
AFTER UPDATE ON Categories
FOR EACH ROW
BEGIN
    IF OLD.category_name != NEW.category_name THEN
        INSERT INTO CategoryLog (category_id, action, log_date, user_id)
        VALUES (NEW.category_id, CONCAT('NAME_UPDATE: ', OLD.category_name, ' to ', NEW.category_name), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent deleting active categories
DELIMITER //
CREATE TRIGGER PreventActiveCategoryDelete
BEFORE DELETE ON Categories
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete active category';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log category deletions
DELIMITER //
CREATE TRIGGER LogCategoryDelete
AFTER DELETE ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO CategoryLog (category_id, action, log_date, user_id)
    VALUES (OLD.category_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 4: Orders**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of orders placed in 2025
CREATE VIEW RecentOrders AS
SELECT order_id, customer_id, order_date, total_amount
FROM Orders
WHERE YEAR(order_date) = 2025;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of orders with customer details
CREATE VIEW OrderCustomerDetails AS
SELECT o.order_id, o.order_date, c.first_name, c.last_name
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of orders with high total amounts
CREATE VIEW HighValueOrders AS
SELECT order_id, customer_id, total_amount
FROM Orders
WHERE total_amount > 500;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of orders with payment status
CREATE VIEW OrderPaymentStatus AS
SELECT o.order_id, o.order_date, p.payment_status
FROM Orders o
JOIN Payments p ON o.order_id = p.order_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count orders by customer
WITH OrderCounts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, oc.order_count
FROM Customers c
JOIN OrderCounts oc ON c.customer_id = oc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list orders with product details
WITH OrderProducts AS (
    SELECT order_id, product_id
    FROM Order_Items
)
SELECT o.order_id, o.order_date, p.product_name
FROM Orders o
JOIN OrderProducts op ON o.order_id = op.order_id
JOIN Products p ON op.product_id = p.product_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find orders with pending payments
WITH PendingPayments AS (
    SELECT order_id
    FROM Payments
    WHERE payment_status = 'Pending'
)
SELECT o.order_id, o.order_date, o.total_amount
FROM Orders o
JOIN PendingPayments pp ON o.order_id = pp.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list orders by month
WITH OrdersByMonth AS (
    SELECT MONTH(order_date) AS order_month, COUNT(*) AS order_count
    FROM Orders
    GROUP BY MONTH(order_date)
)
SELECT order_month, order_count
FROM OrdersByMonth;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new order
DELIMITER //
CREATE PROCEDURE AddOrder(
    IN p_order_id INT,
    IN p_customer_id INT,
    IN p_order_date DATE,
    IN p_total_amount DECIMAL(10,2),
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status)
    VALUES (p_order_id, p_customer_id, p_order_date, p_total_amount, p_status);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update an order's status
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus(
    IN p_order_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Orders
    SET status = p_new_status
    WHERE order_id = p_order_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete an order
DELIMITER //
CREATE PROCEDURE DeleteOrder(
    IN p_order_id INT
)
BEGIN
    DELETE FROM Orders
    WHERE order_id = p_order_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve order details
DELIMITER //
CREATE PROCEDURE GetOrderDetails(
    IN p_order_id INT
)
BEGIN
    SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    WHERE o.order_id = p_order_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new order
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status)
VALUES (301, 1, '2025-06-07', 299.99, 'Pending');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates an order's total amount
UPDATE Orders
SET total_amount = 350.00
WHERE order_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a cancelled order
DELETE FROM Orders
WHERE order_id = 1 AND status = 'Cancelled';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates order status within a transaction
START TRANSACTION;
UPDATE Orders
SET status = 'Shipped'
WHERE order_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record order insertions
CREATE TABLE OrderLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogOrderInsert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderLog (order_id, action, log_date, user_id)
    VALUES (NEW.order_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log order status updates
DELIMITER //
CREATE TRIGGER LogOrderStatusUpdate
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO OrderLog (order_id, action, log_date, user_id)
        VALUES (NEW.order_id, CONCAT('STATUS_UPDATE: ', OLD.status, ' to ', NEW.status), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative total amounts
DELIMITER //
CREATE TRIGGER PreventNegativeTotal
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.total_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log order deletions
DELIMITER //
CREATE TRIGGER LogOrderDelete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderLog (order_id, action, log_date, user_id)
    VALUES (OLD.order_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 5: Order_Items**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of order items with product details
CREATE VIEW OrderItemDetails AS
SELECT oi.order_id, oi.product_id, p.product_name, oi.quantity
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of order items with high quantities
CREATE VIEW HighQuantityOrderItems AS
SELECT order_id, product_id, quantity
FROM Order_Items
WHERE quantity > 5;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of order items for specific orders
CREATE VIEW RecentOrderItems AS
SELECT oi.order_id, oi.product_id, oi.quantity
FROM Order_Items oi
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_date >= '2025-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of order items with total cost
CREATE VIEW OrderItemCosts AS
SELECT oi.order_id, oi.product_id, oi.quantity, (oi.quantity * p.price) AS total_cost
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to list order items with product prices
WITH ProductPrices AS (
    SELECT product_id, price
    FROM Products
)
SELECT oi.order_id, oi.product_id, oi.quantity, pp.price
FROM Order_Items oi
JOIN ProductPrices pp ON oi.product_id = pp.product_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to count order items by order
WITH ItemCounts AS (
    SELECT order_id, COUNT(*) AS item_count
    FROM Order_Items
    GROUP BY order_id
)
SELECT o.order_id, o.order_date, ic.item_count
FROM Orders o
JOIN ItemCounts ic ON o.order_id = ic.order_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find order items for high-value orders
WITH HighValueOrders AS (
    SELECT order_id
    FROM Orders
    WHERE total_amount > 500
)
SELECT oi.order_id, oi.product_id, oi.quantity
FROM Order_Items oi
JOIN HighValueOrders hvo ON oi.order_id = hvo.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list order items with product categories
WITH ProductCategories AS (
    SELECT product_id, category_id
    FROM Products
)
SELECT oi.order_id, oi.product_id, pc.category_id
FROM Order_Items oi
JOIN ProductCategories pc ON oi.product_id = pc.product_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new order item
DELIMITER //
CREATE PROCEDURE AddOrderItem(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    INSERT INTO Order_Items (order_id, product_id, quantity)
    VALUES (p_order_id, p_product_id, p_quantity);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update an order item's quantity
DELIMITER //
CREATE PROCEDURE UpdateOrderItemQuantity(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_new_quantity INT
)
BEGIN
    UPDATE Order_Items
    SET quantity = p_new_quantity
    WHERE order_id = p_order_id AND product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete an order item
DELIMITER //
CREATE PROCEDURE DeleteOrderItem(
    IN p_order_id INT,
    IN p_product_id INT
)
BEGIN
    DELETE FROM Order_Items
    WHERE order_id = p_order_id AND product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve order item details
DELIMITER //
CREATE PROCEDURE GetOrderItemDetails(
    IN p_order_id INT,
    IN p_product_id INT
)
BEGIN
    SELECT oi.order_id, oi.product_id, p.product_name, oi.quantity
    FROM Order_Items oi
    JOIN Products p ON oi.product_id = p.product_id
    WHERE oi.order_id = p_order_id AND oi.product_id = p_product_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new order item
INSERT INTO Order_Items (order_id, product_id, quantity)
VALUES (301, 1, 2);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates an order item's quantity
UPDATE Order_Items
SET quantity = 3
WHERE order_id = 1 AND product_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an order item
DELETE FROM Order_Items
WHERE order_id = 1 AND product_id = 1;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates order item quantity within a transaction
START TRANSACTION;
UPDATE Order_Items
SET quantity = quantity + 1
WHERE order_id = 1 AND product_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record order item insertions
CREATE TABLE OrderItemLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogOrderItemInsert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    INSERT INTO OrderItemLog (order_id, product_id, action, log_date, user_id)
    VALUES (NEW.order_id, NEW.product_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log order item quantity updates
DELIMITER //
CREATE TRIGGER LogOrderItemQuantityUpdate
AFTER UPDATE ON Order_Items
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO OrderItemLog (order_id, product_id, action, log_date, user_id)
        VALUES (NEW.order_id, NEW.product_id, CONCAT('QUANTITY_UPDATE: ', OLD.quantity, ' to ', NEW.quantity), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative quantities
DELIMITER //
CREATE TRIGGER PreventNegativeQuantity
BEFORE UPDATE ON Order_Items
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to update product stock on order item insertion
DELIMITER //
CREATE TRIGGER UpdateStockOnOrderItemInsert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END //
DELIMITER ;

-- **Table 6: Suppliers**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active suppliers
CREATE VIEW ActiveSuppliers AS
SELECT supplier_id, supplier_name, contact_email
FROM Suppliers
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of suppliers with product counts
CREATE VIEW SupplierProductCounts AS
SELECT s.supplier_id, s.supplier_name, COUNT(p.product_id) AS product_count
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of suppliers with contact details
CREATE VIEW SupplierContacts AS
SELECT supplier_id, supplier_name, contact_phone, contact_email
FROM Suppliers;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of suppliers with high-rated products
CREATE VIEW HighRatedSuppliers AS
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
JOIN Products p ON s.supplier_id = p.supplier_id
WHERE p.rating >= 4.5;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count products by supplier
WITH SupplierCounts AS (
    SELECT supplier_id, COUNT(*) AS product_count
    FROM Products
    GROUP BY supplier_id
)
SELECT s.supplier_id, s.supplier_name, COALESCE(sc.product_count, 0) AS product_count
FROM Suppliers s
LEFT JOIN SupplierCounts sc ON s.supplier_id = sc.supplier_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list suppliers with active products
WITH ActiveProducts AS (
    SELECT supplier_id
    FROM Products
    WHERE is_active = TRUE
)
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
JOIN ActiveProducts ap ON s.supplier_id = ap.supplier_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find suppliers with low stock products
WITH LowStockProducts AS (
    SELECT supplier_id
    FROM Products
    WHERE stock_quantity < 50
)
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
JOIN LowStockProducts lsp ON s.supplier_id = lsp.supplier_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list suppliers with high-priced products
WITH HighPricedProducts AS (
    SELECT supplier_id
    FROM Products
    WHERE price > 100
)
SELECT s.supplier_id, s.supplier_name
FROM Suppliers s
JOIN HighPricedProducts hpp ON s.supplier_id = hpp.supplier_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new supplier
DELIMITER //
CREATE PROCEDURE AddSupplier(
    IN p_supplier_id INT,
    IN p_supplier_name VARCHAR(100),
    IN p_contact_email VARCHAR(100),
    IN p_contact_phone VARCHAR(15),
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, contact_phone, is_active)
    VALUES (p_supplier_id, p_supplier_name, p_contact_email, p_contact_phone, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a supplier's contact email
DELIMITER //
CREATE PROCEDURE UpdateSupplierEmail(
    IN p_supplier_id INT,
    IN p_new_email VARCHAR(100)
)
BEGIN
    UPDATE Suppliers
    SET contact_email = p_new_email
    WHERE supplier_id = p_supplier_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a supplier
DELIMITER //
CREATE PROCEDURE DeleteSupplier(
    IN p_supplier_id INT
)
BEGIN
    DELETE FROM Suppliers
    WHERE supplier_id = p_supplier_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve supplier details
DELIMITER //
CREATE PROCEDURE GetSupplierDetails(
    IN p_supplier_id INT
)
BEGIN
    SELECT supplier_id, supplier_name, contact_email, contact_phone
    FROM Suppliers
    WHERE supplier_id = p_supplier_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new supplier
INSERT INTO Suppliers (supplier_id, supplier_name, contact_email, contact_phone, is_active)
VALUES (401, 'Tech Supplies', 'tech@supplies.com', '123-456-7890', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a supplier's contact phone
UPDATE Suppliers
SET contact_phone = '987-654-3210'
WHERE supplier_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive supplier
DELETE FROM Suppliers
WHERE supplier_id = 1 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates supplier active status within a transaction
START TRANSACTION;
UPDATE Suppliers
SET is_active = FALSE
WHERE supplier_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record supplier insertions
CREATE TABLE SupplierLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogSupplierInsert
AFTER INSERT ON Suppliers
FOR EACH ROW
BEGIN
    INSERT INTO SupplierLog (supplier_id, action, log_date, user_id)
    VALUES (NEW.supplier_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log supplier email updates
DELIMITER //
CREATE TRIGGER LogSupplierEmailUpdate
AFTER UPDATE ON Suppliers
FOR EACH ROW
BEGIN
    IF OLD.contact_email != NEW.contact_email THEN
        INSERT INTO SupplierLog (supplier_id, action, log_date, user_id)
        VALUES (NEW.supplier_id, CONCAT('EMAIL_UPDATE: ', OLD.contact_email, ' to ', NEW.contact_email), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent deleting active suppliers
DELIMITER //
CREATE TRIGGER PreventActiveSupplierDelete
BEFORE DELETE ON Suppliers
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete active supplier';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log supplier deletions
DELIMITER //
CREATE TRIGGER LogSupplierDelete
AFTER DELETE ON Suppliers
FOR EACH ROW
BEGIN
    INSERT INTO SupplierLog (supplier_id, action, log_date, user_id)
    VALUES (OLD.supplier_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 7: Addresses**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of default addresses
CREATE VIEW DefaultAddresses AS
SELECT address_id, customer_id, street, city
FROM Addresses
WHERE is_default = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of addresses with customer details
CREATE VIEW AddressCustomerDetails AS
SELECT a.address_id, a.street, c.first_name, c.last_name
FROM Addresses a
JOIN Customers c ON a.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of addresses by state
CREATE VIEW AddressesByState AS
SELECT address_id, customer_id, state
FROM Addresses
GROUP BY state;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of addresses for recent customers
CREATE VIEW RecentCustomerAddresses AS
SELECT a.address_id, a.street, a.city
FROM Addresses a
JOIN Customers c ON a.customer_id = c.customer_id
WHERE c.registration_date >= '2024-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count addresses by customer
WITH AddressCounts AS (
    SELECT customer_id, COUNT(*) AS address_count
    FROM Addresses
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, ac.address_count
FROM Customers c
JOIN AddressCounts ac ON c.customer_id = ac.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list default addresses
WITH DefaultAddresses AS (
    SELECT address_id, customer_id
    FROM Addresses
    WHERE is_default = TRUE
)
SELECT da.address_id, c.first_name, c.last_name
FROM DefaultAddresses da
JOIN Customers c ON da.customer_id = c.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find addresses in specific states
WITH StateAddresses AS (
    SELECT address_id, customer_id
    FROM Addresses
    WHERE state = 'CA'
)
SELECT sa.address_id, c.first_name
FROM StateAddresses sa
JOIN Customers c ON sa.customer_id = c.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list addresses with recent orders
WITH RecentOrders AS (
    SELECT customer_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT a.address_id, a.street
FROM Addresses a
JOIN RecentOrders ro ON a.customer_id = ro.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new address
DELIMITER //
CREATE PROCEDURE AddAddress(
    IN p_address_id INT,
    IN p_customer_id INT,
    IN p_street VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(50),
    IN p_zip_code VARCHAR(10),
    IN p_is_default BOOLEAN
)
BEGIN
    INSERT INTO Addresses (address_id, customer_id, street, city, state, zip_code, is_default)
    VALUES (p_address_id, p_customer_id, p_street, p_city, p_state, p_zip_code, p_is_default);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update an address's city
DELIMITER //
CREATE PROCEDURE UpdateAddressCity(
    IN p_address_id INT,
    IN p_new_city VARCHAR(50)
)
BEGIN
    UPDATE Addresses
    SET city = p_new_city
    WHERE address_id = p_address_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete an address
DELIMITER //
CREATE PROCEDURE DeleteAddress(
    IN p_address_id INT
)
BEGIN
    DELETE FROM Addresses
    WHERE address_id = p_address_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve address details
DELIMITER //
CREATE PROCEDURE GetAddressDetails(
    IN p_address_id INT
)
BEGIN
    SELECT a.address_id, a.street, a.city, c.first_name
    FROM Addresses a
    JOIN Customers c ON a.customer_id = c.customer_id
    WHERE a.address_id = p_address_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new address
INSERT INTO Addresses (address_id, customer_id, street, city, state, zip_code, is_default)
VALUES (501, 1, '123 Main St', 'Los Angeles', 'CA', '90001', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates an address's zip code
UPDATE Addresses
SET zip_code = '90002'
WHERE address_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a non-default address
DELETE FROM Addresses
WHERE address_id = 1 AND is_default = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates address state within a transaction
START TRANSACTION;
UPDATE Addresses
SET state = 'NY'
WHERE address_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record address insertions
CREATE TABLE AddressLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    address_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogAddressInsert
AFTER INSERT ON Addresses
FOR EACH ROW
BEGIN
    INSERT INTO AddressLog (address_id, action, log_date, user_id)
    VALUES (NEW.address_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log address city updates
DELIMITER //
CREATE TRIGGER LogAddressCityUpdate
AFTER UPDATE ON Addresses
FOR EACH ROW
BEGIN
    IF OLD.city != NEW.city THEN
        INSERT INTO AddressLog (address_id, action, log_date, user_id)
        VALUES (NEW.address_id, CONCAT('CITY_UPDATE: ', OLD.city, ' to ', NEW.city), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent multiple default addresses
DELIMITER //
CREATE TRIGGER PreventMultipleDefaults
BEFORE INSERT ON Addresses
FOR EACH ROW
BEGIN
    IF NEW.is_default = TRUE THEN
        UPDATE Addresses
        SET is_default = FALSE
        WHERE customer_id = NEW.customer_id AND address_id != NEW.address_id;
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log address deletions
DELIMITER //
CREATE TRIGGER LogAddressDelete
AFTER DELETE ON Addresses
FOR EACH ROW
BEGIN
    INSERT INTO AddressLog (address_id, action, log_date, user_id)
    VALUES (OLD.address_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 8: Payments**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of completed payments
CREATE VIEW CompletedPayments AS
SELECT payment_id, order_id, payment_date, amount
FROM Payments
WHERE payment_status = 'Completed';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of payments with order details
CREATE VIEW PaymentOrderDetails AS
SELECT p.payment_id, p.order_id, o.order_date, p.amount
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of payments by payment method
CREATE VIEW PaymentsByMethod AS
SELECT p.payment_id, p.order_id, pm.payment_type
FROM Payments p
JOIN Payment_Methods pm ON p.payment_method_id = pm.payment_method_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of pending payments
CREATE VIEW PendingPayments AS
SELECT payment_id, order_id, amount
FROM Payments
WHERE payment_status = 'Pending';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count payments by order
WITH PaymentCounts AS (
    SELECT order_id, COUNT(*) AS payment_count
    FROM Payments
    GROUP BY order_id
)
SELECT o.order_id, o.order_date, pc.payment_count
FROM Orders o
JOIN PaymentCounts pc ON o.order_id = pc.order_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list payments with customer details
WITH CustomerOrders AS (
    SELECT order_id, customer_id
    FROM Orders
)
SELECT p.payment_id, p.order_id, c.first_name
FROM Payments p
JOIN CustomerOrders co ON p.order_id = co.order_id
JOIN Customers c ON co.customer_id = c.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find payments for recent orders
WITH RecentOrders AS (
    SELECT order_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT p.payment_id, p.order_id, p.amount
FROM Payments p
JOIN RecentOrders ro ON p.order_id = ro.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list payments by status
WITH PaymentStatus AS (
    SELECT payment_status, COUNT(*) AS payment_count
    FROM Payments
    GROUP BY payment_status
)
SELECT payment_status, payment_count
FROM PaymentStatus;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new payment
DELIMITER //
CREATE PROCEDURE AddPayment(
    IN p_payment_id INT,
    IN p_order_id INT,
    IN p_payment_method_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_date DATE,
    IN p_payment_status VARCHAR(50)
)
BEGIN
    INSERT INTO Payments (payment_id, order_id, payment_method_id, amount, payment_date, payment_status)
    VALUES (p_payment_id, p_order_id, p_payment_method_id, p_amount, p_payment_date, p_payment_status);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a payment's status
DELIMITER //
CREATE PROCEDURE UpdatePaymentStatus(
    IN p_payment_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Payments
    SET payment_status = p_new_status
    WHERE payment_id = p_payment_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a payment
DELIMITER //
CREATE PROCEDURE DeletePayment(
    IN p_payment_id INT
)
BEGIN
    DELETE FROM Payments
    WHERE payment_id = p_payment_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve payment details
DELIMITER //
CREATE PROCEDURE GetPaymentDetails(
    IN p_payment_id INT
)
BEGIN
    SELECT p.payment_id, p.order_id, pm.payment_type, p.amount
    FROM Payments p
    JOIN Payment_Methods pm ON p.payment_method_id = pm.payment_method_id
    WHERE p.payment_id = p_payment_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new payment
INSERT INTO Payments (payment_id, order_id, payment_method_id, amount, payment_date, payment_status)
VALUES (601, 301, 1, 299.99, '2025-06-07', 'Pending');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a payment's amount
UPDATE Payments
SET amount = 350.00
WHERE payment_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a failed payment
DELETE FROM Payments
WHERE payment_id = 1 AND payment_status = 'Failed';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates payment status within a transaction
START TRANSACTION;
UPDATE Payments
SET payment_status = 'Completed'
WHERE payment_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record payment insertions
CREATE TABLE PaymentLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogPaymentInsert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    INSERT INTO PaymentLog (payment_id, action, log_date, user_id)
    VALUES (NEW.payment_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log payment amount updates
DELIMITER //
CREATE TRIGGER LogPaymentAmountUpdate
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF OLD.amount != NEW.amount THEN
        INSERT INTO PaymentLog (payment_id, action, log_date, user_id)
        VALUES (NEW.payment_id, CONCAT('AMOUNT_UPDATE: ', OLD.amount, ' to ', NEW.amount), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative payment amounts
DELIMITER //
CREATE TRIGGER PreventNegativePayment
BEFORE UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log payment deletions
DELIMITER //
CREATE TRIGGER LogPaymentDelete
AFTER DELETE ON Payments
FOR EACH ROW
BEGIN
    INSERT INTO PaymentLog (payment_id, action, log_date, user_id)
    VALUES (OLD.payment_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 9: Payment_Methods** (continued)

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of payment methods with customer details
CREATE VIEW PaymentMethodCustomerDetails AS
SELECT pm.payment_method_id, pm.payment_type, c.first_name, c.last_name
FROM Payment_Methods pm
JOIN Customers c ON pm.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of payment methods used in payments
CREATE VIEW UsedPaymentMethods AS
SELECT pm.payment_method_id, pm.payment_type
FROM Payment_Methods pm
JOIN Payments p ON pm.payment_method_id = p.payment_method_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of payment methods by type
CREATE VIEW PaymentMethodsByType AS
SELECT payment_type, COUNT(*) AS method_count
FROM Payment_Methods
GROUP BY payment_type;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count payment methods by customer
WITH PaymentMethodCounts AS (
    SELECT customer_id, COUNT(*) AS method_count
    FROM Payment_Methods
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, pmc.method_count
FROM Customers c
JOIN PaymentMethodCounts pmc ON c.customer_id = pmc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list payment methods for recent customers
WITH RecentCustomers AS (
    SELECT customer_id
    FROM Customers
    WHERE registration_date >= '2024-01-01'
)
SELECT pm.payment_method_id, pm.payment_type
FROM Payment_Methods pm
JOIN RecentCustomers rc ON pm.customer_id = rc.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find payment methods used in high-value orders
WITH HighValueOrders AS (
    SELECT order_id
    FROM Orders
    WHERE total_amount > 500
)
SELECT pm.payment_method_id, pm.payment_type
FROM Payment_Methods pm
JOIN Payments p ON pm.payment_method_id = p.payment_method_id
JOIN HighValueOrders hvo ON p.order_id = hvo.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list active payment methods with customer details
WITH ActiveMethods AS (
    SELECT payment_method_id, customer_id
    FROM Payment_Methods
    WHERE is_active = TRUE
)
SELECT am.payment_method_id, c.first_name
FROM ActiveMethods am
JOIN Customers c ON am.customer_id = c.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new payment method
DELIMITER //
CREATE PROCEDURE AddPaymentMethod(
    IN p_payment_method_id INT,
    IN p_customer_id INT,
    IN p_payment_type VARCHAR(50),
    IN p_card_number VARCHAR(20),
    IN p_expiry_date DATE,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Payment_Methods (payment_method_id, customer_id, payment_type, card_number, expiry_date, is_active)
    VALUES (p_payment_method_id, p_customer_id, p_payment_type, p_card_number, p_expiry_date, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a payment method's type
DELIMITER //
CREATE PROCEDURE UpdatePaymentMethodType(
    IN p_payment_method_id INT,
    IN p_new_type VARCHAR(50)
)
BEGIN
    UPDATE Payment_Methods
    SET payment_type = p_new_type
    WHERE payment_method_id = p_payment_method_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a payment method
DELIMITER //
CREATE PROCEDURE DeletePaymentMethod(
    IN p_payment_method_id INT
)
BEGIN
    DELETE FROM Payment_Methods
    WHERE payment_method_id = p_payment_method_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve payment method details
DELIMITER //
CREATE PROCEDURE GetPaymentMethodDetails(
    IN p_payment_method_id INT
)
BEGIN
    SELECT pm.payment_method_id, pm.payment_type, c.first_name
    FROM Payment_Methods pm
    JOIN Customers c ON pm.customer_id = c.customer_id
    WHERE pm.payment_method_id = p_payment_method_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new payment method
INSERT INTO Payment_Methods (payment_method_id, customer_id, payment_type, card_number, expiry_date, is_active)
VALUES (701, 1, 'Credit Card', '1234-5678-9012-3456', '2026-12-31', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a payment method's expiry date
UPDATE Payment_Methods
SET expiry_date = '2027-12-31'
WHERE payment_method_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive payment method
DELETE FROM Payment_Methods
WHERE payment_method_id = 1 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates payment method active status within a transaction
START TRANSACTION;
UPDATE Payment_Methods
SET is_active = FALSE
WHERE payment_method_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record payment method insertions
CREATE TABLE PaymentMethodLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_method_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogPaymentMethodInsert
AFTER INSERT ON Payment_Methods
FOR EACH ROW
BEGIN
    INSERT INTO PaymentMethodLog (payment_method_id, action, log_date, user_id)
    VALUES (NEW.payment_method_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log payment method type updates
DELIMITER //
CREATE TRIGGER LogPaymentMethodTypeUpdate
AFTER UPDATE ON Payment_Methods
FOR EACH ROW
BEGIN
    IF OLD.payment_type != NEW.payment_type THEN
        INSERT INTO PaymentMethodLog (payment_method_id, action, log_date,_parameter_id
        VALUES (NEW.payment_method_id, CONCAT('TYPE_UPDATE: ', OLD.payment_type, ' to ', NEW.payment_type), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent expired payment methods
DELIMITER //
CREATE TRIGGER PreventExpiredPaymentMethod
BEFORE INSERT ON Payment_Methods
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add expired payment method';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log payment method deletions
DELIMITER //
CREATE TRIGGER LogPaymentMethodDelete
AFTER DELETE ON Payment_Methods
FOR EACH ROW
BEGIN
    INSERT INTO PaymentMethodLog (payment_method_id, action, log_date, user_id)
    VALUES (OLD.payment_method_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 10: Reviews**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of reviews with high ratings
CREATE VIEW HighRatedReviews AS
SELECT review_id, product_id, customer_id, rating
FROM Reviews
WHERE rating >= 4;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of reviews with customer and product details
CREATE VIEW ReviewDetails AS
SELECT r.review_id, p.product_name, c.first_name
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id
JOIN Customers c ON r.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of recent reviews
CREATE VIEW RecentReviews AS
SELECT review_id, product_id, review_date
FROM Reviews
WHERE review_date >= '2024-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of reviews by product
CREATE VIEW ReviewsByProduct AS
SELECT p.product_id, p.product_name, COUNT(r.review_id) AS review_count
FROM Products p
LEFT JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to average ratings by product
WITH AverageRatings AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, ar.avg_rating
FROM Products p
JOIN AverageRatings ar ON p.product_id = ar.product_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list reviews by customer
WITH CustomerReviews AS (
    SELECT customer_id, COUNT(*) AS review_count
    FROM Reviews
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, cr.review_count
FROM Customers c
JOIN CustomerReviews cr ON c.customer_id = cr.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find reviews for high-priced products
WITH HighPricedProducts AS (
    SELECT product_id
    FROM Products
    WHERE price > 100
)
SELECT r.review_id, r.product_id, r.rating
FROM Reviews r
JOIN HighPricedProducts hpp ON r.product_id = hpp.product_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list recent reviews with customer details
WITH RecentReviews AS (
    SELECT review_id, customer_id
    FROM Reviews
    WHERE review_date >= '2024-01-01'
)
SELECT rr.review_id, c.first_name
FROM RecentReviews rr
JOIN Customers c ON rr.customer_id = c.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new review
DELIMITER //
CREATE PROCEDURE AddReview(
    IN p_review_id INT,
    IN p_product_id INT,
    IN p_customer_id INT,
    IN p_rating INT,
    IN p_comment TEXT,
    IN p_review_date DATE
)
BEGIN
    INSERT INTO Reviews (review_id, product_id, customer_id, rating, comment, review_date)
    VALUES (p_review_id, p_product_id, p_customer_id, p_rating, p_comment, p_review_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a review's rating
DELIMITER //
CREATE PROCEDURE UpdateReviewRating(
    IN p_review_id INT,
    IN p_new_rating INT
)
BEGIN
    UPDATE Reviews
    SET rating = p_new_rating
    WHERE review_id = p_review_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a review
DELIMITER //
CREATE PROCEDURE DeleteReview(
    IN p_review_id INT
)
BEGIN
    DELETE FROM Reviews
    WHERE review_id = p_review_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve review details
DELIMITER //
CREATE PROCEDURE GetReviewDetails(
    IN p_review_id INT
)
BEGIN
    SELECT r.review_id, p.product_name, c.first_name, r.rating
    FROM Reviews r
    JOIN Products p ON r.product_id = p.product_id
    JOIN Customers c ON r.customer_id = c.customer_id
    WHERE r.review_id = p_review_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new review
INSERT INTO Reviews (review_id, product_id, customer_id, rating, comment, review_date)
VALUES (801, 1, 1, 5, 'Great product!', '2025-06-07');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a review's comment
UPDATE Reviews
SET comment = 'Updated: Excellent product!'
WHERE review_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a review
DELETE FROM Reviews
WHERE review_id = 1;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates review rating within a transaction
START TRANSACTION;
UPDATE Reviews
SET rating = 4
WHERE review_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record review insertions
CREATE TABLE ReviewLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    review_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogReviewInsert
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    INSERT INTO ReviewLog (review_id, action, log_date, user_id)
    VALUES (NEW.review_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log review rating updates
DELIMITER //
CREATE TRIGGER LogReviewRatingUpdate
AFTER UPDATE ON Reviews
FOR EACH ROW
BEGIN
    IF OLD.rating != NEW.rating THEN
        INSERT INTO ReviewLog (review_id, action, log_date, user_id)
        VALUES (NEW.review_id, CONCAT('RATING_UPDATE: ', OLD.rating, ' to ', NEW.rating), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to validate review ratings
DELIMITER //
CREATE TRIGGER ValidateReviewRating
BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log review deletions
DELIMITER //
CREATE TRIGGER LogReviewDelete
AFTER DELETE ON Reviews
FOR EACH ROW
BEGIN
    INSERT INTO ReviewLog (review_id, action, log_date, user_id)
    VALUES (OLD.review_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 11: Subscriptions**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active subscriptions
CREATE VIEW ActiveSubscriptions AS
SELECT subscription_id, customer_id, plan_name
FROM Subscriptions
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of subscriptions with customer details
CREATE VIEW SubscriptionCustomerDetails AS
SELECT s.subscription_id, s.plan_name, c.first_name
FROM Subscriptions s
JOIN Customers c ON s.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of subscriptions by plan
CREATE VIEW SubscriptionsByPlan AS
SELECT plan_name, COUNT(*) AS subscription_count
FROM Subscriptions
GROUP BY plan_name;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent subscriptions
CREATE VIEW RecentSubscriptions AS
SELECT subscription_id, customer_id, start_date
FROM Subscriptions
WHERE start_date >= '2024-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count subscriptions by customer
WITH SubscriptionCounts AS (
    SELECT customer_id, COUNT(*) AS subscription_count
    FROM Subscriptions
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, sc.subscription_count
FROM Customers c
JOIN SubscriptionCounts sc ON c.customer_id = sc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list subscriptions with recent orders
WITH RecentOrders AS (
    SELECT customer_id
    FROM Orders
    WHERE order_date >= '2024-01-01'
)
SELECT s.subscription_id, s.plan_name
FROM Subscriptions s
JOIN RecentOrders ro ON s.customer_id = ro.customer_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find subscriptions nearing end date
WITH ExpiringSubscriptions AS (
    SELECT subscription_id, customer_id
    FROM Subscriptions
    WHERE end_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
)
SELECT es.subscription_id, c.first_name
FROM ExpiringSubscriptions es
JOIN Customers c ON es.customer_id = c.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list active subscriptions with customer details
WITH ActiveSubscriptions AS (
    SELECT subscription_id, customer_id
    FROM Subscriptions
    WHERE is_active = TRUE
)
SELECT asub.subscription_id, c.first_name
FROM ActiveSubscriptions asub
JOIN Customers c ON asub.customer_id = c.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new subscription
DELIMITER //
CREATE PROCEDURE AddSubscription(
    IN p_subscription_id INT,
    IN p_customer_id INT,
    IN p_plan_name VARCHAR(100),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Subscriptions (subscription_id, customer_id, plan_name, start_date, end_date, is_active)
    VALUES (p_subscription_id, p_customer_id, p_plan_name, p_start_date, p_end_date, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a subscription's end date
DELIMITER //
CREATE PROCEDURE UpdateSubscriptionEndDate(
    IN p_subscription_id INT,
    IN p_new_end_date DATE
)
BEGIN
    UPDATE Subscriptions
    SET end_date = p_new_end_date
    WHERE subscription_id = p_subscription_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a subscription
DELIMITER //
CREATE PROCEDURE DeleteSubscription(
    IN p_subscription_id INT
)
BEGIN
    DELETE FROM Subscriptions
    WHERE subscription_id = p_subscription_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve subscription details
DELIMITER //
CREATE PROCEDURE GetSubscriptionDetails(
    IN p_subscription_id INT
)
BEGIN
    SELECT s.subscription_id, s.plan_name, c.first_name
    FROM Subscriptions s
    JOIN Customers c ON s.customer_id = c.customer_id
    WHERE s.subscription_id = p_subscription_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new subscription
INSERT INTO Subscriptions (subscription_id, customer_id, plan_name, start_date, end_date, is_active)
VALUES (901, 1, 'Premium', '2025-06-07', '2026-06-07', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a subscription's plan name
UPDATE Subscriptions
SET plan_name = 'Ultra'
WHERE subscription_id = 1;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive subscription
DELETE FROM Subscriptions
WHERE subscription_id = 1 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates subscription active status within a transaction
START TRANSACTION;
UPDATE Subscriptions
SET is_active = FALSE
WHERE subscription_id = 1;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record subscription insertions
CREATE TABLE SubscriptionLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    subscription_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogSubscriptionInsert
AFTER INSERT ON Subscriptions
FOR EACH ROW
BEGIN
    INSERT INTO SubscriptionLog (subscription_id, action, log_date, user_id)
    VALUES (NEW.subscription_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log subscription plan updates
DELIMITER //
CREATE TRIGGER LogSubscriptionPlanUpdate
AFTER UPDATE ON Subscriptions
FOR EACH ROW
BEGIN
    IF OLD.plan_name != NEW.plan_name THEN
        INSERT INTO SubscriptionLog (subscription_id, action, log_date, user_id)
        VALUES (NEW.subscription_id, CONCAT('PLAN_UPDATE: ', OLD.plan_name, ' to ', NEW.plan_name), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid end dates
DELIMITER //
CREATE TRIGGER PreventInvalidEndDate
BEFORE INSERT ON Subscriptions
FOR EACH ROW
BEGIN
    IF NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End date cannot be before start date';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log subscription deletions
DELIMITER //
CREATE TRIGGER LogSubscriptionDelete
AFTER DELETE ON Subscriptions
FOR EACH ROW
BEGIN
    INSERT INTO SubscriptionLog (subscription_id, action, log_date, user_id)
    VALUES (OLD.subscription_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 12: Wishlists**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active wishlists
CREATE VIEW ActiveWishlists AS
SELECT wishlist_id, customer_id, product_id, added_date
FROM Wishlists
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of wishlists with customer and product details
CREATE VIEW WishlistDetails AS
SELECT w.wishlist_id, c.first_name, p.product_name
FROM Wishlists w
JOIN Customers c ON w.customer_id = c.customer_id
JOIN Products p ON w.product_id = p.product_id
WHERE w.is_active = TRUE;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of wishlists added in 2025
CREATE VIEW RecentWishlists AS
SELECT wishlist_id, customer_id, product_id
FROM Wishlists
WHERE YEAR(added_date) = 2025;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of wishlists with product categories
CREATE VIEW WishlistCategories AS
SELECT w.wishlist_id, w.product_id, c.category_name
FROM Wishlists w
JOIN Products p ON w.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count wishlist items by customer
WITH WishlistCounts AS (
    SELECT customer_id, COUNT(*) AS wishlist_count
    FROM Wishlists
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, wc.wishlist_count
FROM Customers c
JOIN WishlistCounts wc ON c.customer_id = wc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list wishlists with high-priced products
WITH HighPricedProducts AS (
    SELECT product_id
    FROM Products
    WHERE price > 100
)
SELECT w.wishlist_id, w.customer_id, w.product_id
FROM Wishlists w
JOIN HighPricedProducts hpp ON w.product_id = hpp.product_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find wishlists for recent customers
WITH RecentCustomers AS (
    SELECT customer_id
    FROM Customers
    WHERE registration_date >= '2024-01-01'
)
SELECT w.wishlist_id, w.product_id
FROM Wishlists w
JOIN RecentCustomers rc ON w.customer_id = rc.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list wishlists with active products
WITH ActiveProducts AS (
    SELECT product_id
    FROM Products
    WHERE is_active = TRUE
)
SELECT w.wishlist_id, w.customer_id
FROM Wishlists w
JOIN ActiveProducts ap ON w.product_id = ap.product_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new wishlist item
DELIMITER //
CREATE PROCEDURE AddWishlistItem(
    IN p_wishlist_id INT,
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_added_date DATETIME,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date, is_active)
    VALUES (p_wishlist_id, p_customer_id, p_product_id, p_added_date, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a wishlist item's active status
DELIMITER //
CREATE PROCEDURE UpdateWishlistStatus(
    IN p_wishlist_id INT,
    IN p_is_active BOOLEAN
)
BEGIN
    UPDATE Wishlists
    SET is_active = p_is_active
    WHERE wishlist_id = p_wishlist_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a wishlist item
DELIMITER //
CREATE PROCEDURE DeleteWishlistItem(
    IN p_wishlist_id INT
)
BEGIN
    DELETE FROM Wishlists
    WHERE wishlist_id = p_wishlist_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve wishlist details
DELIMITER //
CREATE PROCEDURE GetWishlistDetails(
    IN p_wishlist_id INT
)
BEGIN
    SELECT w.wishlist_id, c.first_name, p.product_name
    FROM Wishlists w
    JOIN Customers c ON w.customer_id = c.customer_id
    JOIN Products p ON w.product_id = p.product_id
    WHERE w.wishlist_id = p_wishlist_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new wishlist item
INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date, is_active)
VALUES (1001, 201, 21, '2025-06-07 10:00:00', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a wishlist item's active status
UPDATE Wishlists
SET is_active = FALSE
WHERE wishlist_id = 1001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive wishlist item
DELETE FROM Wishlists
WHERE wishlist_id = 1001 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates wishlist active status within a transaction
START TRANSACTION;
UPDATE Wishlists
SET is_active = TRUE
WHERE wishlist_id = 1001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record wishlist insertions
CREATE TABLE WishlistLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    wishlist_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogWishlistInsert
AFTER INSERT ON Wishlists
FOR EACH ROW
BEGIN
    INSERT INTO WishlistLog (wishlist_id, action, log_date, user_id)
    VALUES (NEW.wishlist_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log wishlist active status updates
DELIMITER //
CREATE TRIGGER LogWishlistStatusUpdate
AFTER UPDATE ON Wishlists
FOR EACH ROW
BEGIN
    IF OLD.is_active != NEW.is_active THEN
        INSERT INTO WishlistLog (wishlist_id, action, log_date, user_id)
        VALUES (NEW.wishlist_id, CONCAT('STATUS_UPDATE: ', OLD.is_active, ' to ', NEW.is_active), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent duplicate wishlist entries
DELIMITER //
CREATE TRIGGER PreventDuplicateWishlist
BEFORE INSERT ON Wishlists
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Wishlists
        WHERE customer_id = NEW.customer_id AND product_id = NEW.product_id AND is_active = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product already exists in customer\'s active wishlist';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log wishlist deletions
DELIMITER //
CREATE TRIGGER LogWishlistDelete
AFTER DELETE ON Wishlists
FOR EACH ROW
BEGIN
    INSERT INTO WishlistLog (wishlist_id, action, log_date, user_id)
    VALUES (OLD.wishlist_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 13: Cart_Items**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active cart items
CREATE VIEW ActiveCartItems AS
SELECT cart_item_id, customer_id, product_id, quantity
FROM Cart_Items
WHERE quantity > 0;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of cart items with product details
CREATE VIEW CartItemDetails AS
SELECT ci.cart_item_id, c.first_name, p.product_name, ci.quantity
FROM Cart_Items ci
JOIN Customers c ON ci.customer_id = c.customer_id
JOIN Products p ON ci.product_id = p.product_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of cart items added recently
CREATE VIEW RecentCartItems AS
SELECT cart_item_id, customer_id, product_id
FROM Cart_Items
WHERE added_date >= '2025-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of cart items with total cost
CREATE VIEW CartItemCosts AS
SELECT ci.cart_item_id, ci.product_id, ci.quantity, (ci.quantity * p.price) AS total_cost
FROM Cart_Items ci
JOIN Products p ON ci.product_id = p.product_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count cart items by customer
WITH CartItemCounts AS (
    SELECT customer_id, COUNT(*) AS item_count
    FROM Cart_Items
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, cic.item_count
FROM Customers c
JOIN CartItemCounts cic ON c.customer_id = cic.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list cart items for high-priced products
WITH HighPricedProducts AS (
    SELECT product_id, price
    FROM Products
    WHERE price > 100
)
SELECT ci.cart_item_id, ci.customer_id, ci.product_id, hpp.price
FROM Cart_Items ci
JOIN HighPricedProducts hpp ON ci.product_id = hpp.product_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find cart items for recent customers
WITH RecentCustomers AS (
    SELECT customer_id
    FROM Customers
    WHERE registration_date >= '2024-01-01'
)
SELECT ci.cart_item_id, ci.product_id, ci.quantity
FROM Cart_Items ci
JOIN RecentCustomers rc ON ci.customer_id = rc.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list cart items with low stock products
WITH LowStockProducts AS (
    SELECT product_id
    FROM Products
    WHERE stock_quantity < 50
)
SELECT ci.cart_item_id, ci.customer_id
FROM Cart_Items ci
JOIN LowStockProducts lsp ON ci.product_id = lsp.product_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new cart item
DELIMITER //
CREATE PROCEDURE AddCartItem(
    IN p_cart_item_id INT,
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_added_date DATETIME
)
BEGIN
    INSERT INTO Cart_Items (cart_item_id, customer_id, product_id, quantity, added_date)
    VALUES (p_cart_item_id, p_customer_id, p_product_id, p_quantity, p_added_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a cart item's quantity
DELIMITER //
CREATE PROCEDURE UpdateCartItemQuantity(
    IN p_cart_item_id INT,
    IN p_new_quantity INT
)
BEGIN
    UPDATE Cart_Items
    SET quantity = p_new_quantity
    WHERE cart_item_id = p_cart_item_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a cart item
DELIMITER //
CREATE PROCEDURE DeleteCartItem(
    IN p_cart_item_id INT
)
BEGIN
    DELETE FROM Cart_Items
    WHERE cart_item_id = p_cart_item_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve cart item details
DELIMITER //
CREATE PROCEDURE GetCartItemDetails(
    IN p_cart_item_id INT
)
BEGIN
    SELECT ci.cart_item_id, c.first_name, p.product_name, ci.quantity
    FROM Cart_Items ci
    JOIN Customers c ON ci.customer_id = c.customer_id
    JOIN Products p ON ci.product_id = p.product_id
    WHERE ci.cart_item_id = p_cart_item_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new cart item
INSERT INTO Cart_Items (cart_item_id, customer_id, product_id, quantity, added_date)
VALUES (2001, 201, 21, 2, '2025-06-07 12:00:00');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a cart item's quantity
UPDATE Cart_Items
SET quantity = 3
WHERE cart_item_id = 2001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a cart item
DELETE FROM Cart_Items
WHERE cart_item_id = 2001;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates cart item quantity within a transaction
START TRANSACTION;
UPDATE Cart_Items
SET quantity = quantity + 1
WHERE cart_item_id = 2001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record cart item insertions
CREATE TABLE CartItemLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_item_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogCartItemInsert
AFTER INSERT ON Cart_Items
FOR EACH ROW
BEGIN
    INSERT INTO CartItemLog (cart_item_id, action, log_date, user_id)
    VALUES (NEW.cart_item_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log cart item quantity updates
DELIMITER //
CREATE TRIGGER LogCartItemQuantityUpdate
AFTER UPDATE ON Cart_Items
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO CartItemLog (cart_item_id, action, log_date, user_id)
        VALUES (NEW.cart_item_id, CONCAT('QUANTITY_UPDATE: ', OLD.quantity, ' to ', NEW.quantity), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative quantities
DELIMITER //
CREATE TRIGGER PreventNegativeCartQuantity
BEFORE UPDATE ON Cart_Items
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cart item quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log cart item deletions
DELIMITER //
CREATE TRIGGER LogCartItemDelete
AFTER DELETE ON Cart_Items
FOR EACH ROW
BEGIN
    INSERT INTO CartItemLog (cart_item_id, action, log_date, user_id)
    VALUES (OLD.cart_item_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 14: Promotions**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active promotions
CREATE VIEW ActivePromotions AS
SELECT promotion_id, promotion_name, discount_percentage
FROM Promotions
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of promotions with product details
CREATE VIEW PromotionProductDetails AS
SELECT pr.promotion_id, pr.promotion_name, p.product_name
FROM Promotions pr
JOIN Products p ON pr.promotion_id = p.promotion_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of promotions with high discounts
CREATE VIEW HighDiscountPromotions AS
SELECT promotion_id, promotion_name, discount_percentage
FROM Promotions
WHERE discount_percentage > 20;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent promotions
CREATE VIEW RecentPromotions AS
SELECT promotion_id, promotion_name, start_date
FROM Promotions
WHERE start_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count promotions by month
WITH PromotionsByMonth AS (
    SELECT MONTH(start_date) AS promo_month, COUNT(*) AS promo_count
    FROM Promotions
    GROUP BY MONTH(start_date)
)
SELECT promo_month, promo_count
FROM PromotionsByMonth;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list promotions with high discounts
WITH HighDiscounts AS (
    SELECT promotion_id
    FROM Promotions
    WHERE discount_percentage > 20
)
SELECT pr.promotion_id, pr.promotion_name
FROM Promotions pr
JOIN HighDiscounts hd ON pr.promotion_id = hd.promotion_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find active promotions
WITH ActivePromos AS (
    SELECT promotion_id
    FROM Promotions
    WHERE is_active = TRUE
)
SELECT pr.promotion_id, pr.promotion_name
FROM Promotions pr
JOIN ActivePromos ap ON pr.promotion_id = ap.promotion_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list promotions nearing end
WITH ExpiringPromotions AS (
    SELECT promotion_id
    FROM Promotions
    WHERE end_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
)
SELECT pr.promotion_id, pr.promotion_name
FROM Promotions pr
JOIN ExpiringPromotions ep ON pr.promotion_id = ep.promotion_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new promotion
DELIMITER //
CREATE PROCEDURE AddPromotion(
    IN p_promotion_id INT,
    IN p_promotion_name VARCHAR(100),
    IN p_discount_percentage DECIMAL(5,2),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Promotions (promotion_id, promotion_name, discount_percentage, start_date, end_date, is_active)
    VALUES (p_promotion_id, p_promotion_name, p_discount_percentage, p_start_date, p_end_date, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a promotion's discount
DELIMITER //
CREATE PROCEDURE UpdatePromotionDiscount(
    IN p_promotion_id INT,
    IN p_new_discount DECIMAL(5,2)
)
BEGIN
    UPDATE Promotions
    SET discount_percentage = p_new_discount
    WHERE promotion_id = p_promotion_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a promotion
DELIMITER //
CREATE PROCEDURE DeletePromotion(
    IN p_promotion_id INT
)
BEGIN
    DELETE FROM Promotions
    WHERE promotion_id = p_promotion_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve promotion details
DELIMITER //
CREATE PROCEDURE GetPromotionDetails(
    IN p_promotion_id INT
)
BEGIN
    SELECT promotion_id, promotion_name, discount_percentage, start_date, end_date
    FROM Promotions
    WHERE promotion_id = p_promotion_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new promotion
INSERT INTO Promotions (promotion_id, promotion_name, discount_percentage, start_date, end_date, is_active)
VALUES (3001, 'Summer Sale', 25.00, '2025-06-01', '2025-06-30', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a promotion's end date
UPDATE Promotions
SET end_date = '2025-07-15'
WHERE promotion_id = 3001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive promotion
DELETE FROM Promotions
WHERE promotion_id = 3001 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates promotion active status within a transaction
START TRANSACTION;
UPDATE Promotions
SET is_active = FALSE
WHERE promotion_id = 3001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record promotion insertions
CREATE TABLE PromotionLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    promotion_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogPromotionInsert
AFTER INSERT ON Promotions
FOR EACH ROW
BEGIN
    INSERT INTO PromotionLog (promotion_id, action, log_date, user_id)
    VALUES (NEW.promotion_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log promotion discount updates
DELIMITER //
CREATE TRIGGER LogPromotionDiscountUpdate
AFTER UPDATE ON Promotions
FOR EACH ROW
BEGIN
    IF OLD.discount_percentage != NEW.discount_percentage THEN
        INSERT INTO PromotionLog (promotion_id, action, log_date, user_id)
        VALUES (NEW.promotion_id, CONCAT('DISCOUNT_UPDATE: ', OLD.discount_percentage, ' to ', NEW.discount_percentage), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid promotion dates
DELIMITER //
CREATE TRIGGER PreventInvalidPromotionDates
BEFORE INSERT ON Promotions
FOR EACH ROW
BEGIN
    IF NEW.end_date < NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End date cannot be before start date';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log promotion deletions
DELIMITER //
CREATE TRIGGER LogPromotionDelete
AFTER DELETE ON Promotions
FOR EACH ROW
BEGIN
    INSERT INTO PromotionLog (promotion_id, action, log_date, user_id)
    VALUES (OLD.promotion_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 15: Coupons**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active coupons
CREATE VIEW ActiveCoupons AS
SELECT coupon_id, coupon_code, discount_amount
FROM Coupons
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of coupons with customer details
CREATE VIEW CouponCustomerDetails AS
SELECT cp.coupon_id, cp.coupon_code, c.first_name
FROM Coupons cp
JOIN Customers c ON cp.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of coupons with high discounts
CREATE VIEW HighDiscountCoupons AS
SELECT coupon_id, coupon_code, discount_amount
FROM Coupons
WHERE discount_amount > 50;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent coupons
CREATE VIEW RecentCoupons AS
SELECT coupon_id, coupon_code, expiry_date
FROM Coupons
WHERE expiry_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count coupons by customer
WITH CouponCounts AS (
    SELECT customer_id, COUNT(*) AS coupon_count
    FROM Coupons
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, cc.coupon_count
FROM Customers c
JOIN CouponCounts cc ON c.customer_id = cc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list coupons nearing expiry
WITH ExpiringCoupons AS (
    SELECT coupon_id
    FROM Coupons
    WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
)
SELECT cp.coupon_id, cp.coupon_code
FROM Coupons cp
JOIN ExpiringCoupons ec ON cp.coupon_id = ec.coupon_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find active coupons
WITH ActiveCoupons AS (
    SELECT coupon_id
    FROM Coupons
    WHERE is_active = TRUE
)
SELECT cp.coupon_id, cp.coupon_code
FROM Coupons cp
JOIN ActiveCoupons ac ON cp.coupon_id = ac.coupon_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list coupons used in orders
WITH CouponOrders AS (
    SELECT coupon_id
    FROM Orders
    WHERE coupon_id IS NOT NULL
)
SELECT cp.coupon_id, cp.coupon_code
FROM Coupons cp
JOIN CouponOrders co ON cp.coupon_id = co.coupon_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new coupon
DELIMITER //
CREATE PROCEDURE AddCoupon(
    IN p_coupon_id INT,
    IN p_coupon_code VARCHAR(20),
    IN p_discount_amount DECIMAL(10,2),
    IN p_expiry_date DATE,
    IN p_is_active BOOLEAN,
    IN p_customer_id INT
)
BEGIN
    INSERT INTO Coupons (coupon_id, coupon_code, discount_amount, expiry_date, is_active, customer_id)
    VALUES (p_coupon_id, p_coupon_code, p_discount_amount, p_expiry_date, p_is_active, p_customer_id);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a coupon's discount
DELIMITER //
CREATE PROCEDURE UpdateCouponDiscount(
    IN p_coupon_id INT,
    IN p_new_discount DECIMAL(10,2)
)
BEGIN
    UPDATE Coupons
    SET discount_amount = p_new_discount
    WHERE coupon_id = p_coupon_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a coupon
DELIMITER //
CREATE PROCEDURE DeleteCoupon(
    IN p_coupon_id INT
)
BEGIN
    DELETE FROM Coupons
    WHERE coupon_id = p_coupon_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve coupon details
DELIMITER //
CREATE PROCEDURE GetCouponDetails(
    IN p_coupon_id INT
)
BEGIN
    SELECT cp.coupon_id, cp.coupon_code, c.first_name, cp.discount_amount
    FROM Coupons cp
    JOIN Customers c ON cp.customer_id = c.customer_id
    WHERE cp.coupon_id = p_coupon_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new coupon
INSERT INTO Coupons (coupon_id, coupon_code, discount_amount, expiry_date, is_active, customer_id)
VALUES (4001, 'SAVE50', 50.00, '2025-12-31', TRUE, 201);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a coupon's expiry date
UPDATE Coupons
SET expiry_date = '2026-01-31'
WHERE coupon_id = 4001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive coupon
DELETE FROM Coupons
WHERE coupon_id = 4001 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates coupon active status within a transaction
START TRANSACTION;
UPDATE Coupons
SET is_active = FALSE
WHERE coupon_id = 4001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record coupon insertions
CREATE TABLE CouponLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogCouponInsert
AFTER INSERT ON Coupons
FOR EACH ROW
BEGIN
    INSERT INTO CouponLog (coupon_id, action, log_date, user_id)
    VALUES (NEW.coupon_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log coupon discount updates
DELIMITER //
CREATE TRIGGER LogCouponDiscountUpdate
AFTER UPDATE ON Coupons
FOR EACH ROW
BEGIN
    IF OLD.discount_amount != NEW.discount_amount THEN
        INSERT INTO CouponLog (coupon_id, action, log_date, user_id)
        VALUES (NEW.coupon_id, CONCAT('DISCOUNT_UPDATE: ', OLD.discount_amount, ' to ', NEW.discount_amount), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent expired coupons
DELIMITER //
CREATE TRIGGER PreventExpiredCoupon
BEFORE INSERT ON Coupons
FOR EACH ROW
BEGIN
    IF NEW.expiry_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot add expired coupon';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log coupon deletions
DELIMITER //
CREATE TRIGGER LogCouponDelete
AFTER DELETE ON Coupons
FOR EACH ROW
BEGIN
    INSERT INTO CouponLog (coupon_id, action, log_date, user_id)
    VALUES (OLD.coupon_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 16: Shipping_Methods**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active shipping methods
CREATE VIEW ActiveShippingMethods AS
SELECT shipping_method_id, method_name, cost
FROM Shipping_Methods
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of shipping methods with high costs
CREATE VIEW HighCostShippingMethods AS
SELECT shipping_method_id, method_name, cost
FROM Shipping_Methods
WHERE cost > 20;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of shipping methods used in shipments
CREATE VIEW UsedShippingMethods AS
SELECT sm.shipping_method_id, sm.method_name
FROM Shipping_Methods sm
JOIN Shipments s ON sm.shipping_method_id = s.shipping_method_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of fast shipping methods
CREATE VIEW FastShippingMethods AS
SELECT shipping_method_id, method_name, estimated_days
FROM Shipping_Methods
WHERE estimated_days <= 3;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count shipments by shipping method
WITH ShipmentCounts AS (
    SELECT shipping_method_id, COUNT(*) AS shipment_count
    FROM Shipments
    GROUP BY shipping_method_id
)
SELECT sm.shipping_method_id, sm.method_name, sc.shipment_count
FROM Shipping_Methods sm
JOIN ShipmentCounts sc ON sm.shipping_method_id = sc.shipping_method_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list high-cost shipping methods
WITH HighCostMethods AS (
    SELECT shipping_method_id
    FROM Shipping_Methods
    WHERE cost > 20
)
SELECT sm.shipping_method_id, sm.method_name
FROM Shipping_Methods sm
JOIN HighCostMethods hcm ON sm.shipping_method_id = hcm.shipping_method_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find active shipping methods
WITH ActiveMethods AS (
    SELECT shipping_method_id
    FROM Shipping_Methods
    WHERE is_active = TRUE
)
SELECT sm.shipping_method_id, sm.method_name
FROM Shipping_Methods sm
JOIN ActiveMethods am ON sm.shipping_method_id = am.shipping_method_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list recently used shipping methods
WITH RecentShipments AS (
    SELECT shipping_method_id
    FROM Shipments
    WHERE shipment_date >= '2025-01-01'
)
SELECT sm.shipping_method_id, sm.method_name
FROM Shipping_Methods sm
JOIN RecentShipments rs ON sm.shipping_method_id = rs.shipping_method_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new shipping method
DELIMITER //
CREATE PROCEDURE AddShippingMethod(
    IN p_shipping_method_id INT,
    IN p_method_name VARCHAR(100),
    IN p_cost DECIMAL(10,2),
    IN p_estimated_days INT,
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Shipping_Methods (shipping_method_id, method_name, cost, estimated_days, is_active)
    VALUES (p_shipping_method_id, p_method_name, p_cost, p_estimated_days, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a shipping method's cost
DELIMITER //
CREATE PROCEDURE UpdateShippingMethodCost(
    IN p_shipping_method_id INT,
    IN p_new_cost DECIMAL(10,2)
)
BEGIN
    UPDATE Shipping_Methods
    SET cost = p_new_cost
    WHERE shipping_method_id = p_shipping_method_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a shipping method
DELIMITER //
CREATE PROCEDURE DeleteShippingMethod(
    IN p_shipping_method_id INT
)
BEGIN
    DELETE FROM Shipping_Methods
    WHERE shipping_method_id = p_shipping_method_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve shipping method details
DELIMITER //
CREATE PROCEDURE GetShippingMethodDetails(
    IN p_shipping_method_id INT
)
BEGIN
    SELECT shipping_method_id, method_name, cost, estimated_days
    FROM Shipping_Methods
    WHERE shipping_method_id = p_shipping_method_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new shipping method
INSERT INTO Shipping_Methods (shipping_method_id, method_name, cost, estimated_days, is_active)
VALUES (5001, 'Express Shipping', 25.00, 2, TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a shipping method's estimated days
UPDATE Shipping_Methods
SET estimated_days = 3
WHERE shipping_method_id = 5001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive shipping method
DELETE FROM Shipping_Methods
WHERE shipping_method_id = 5001 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates shipping method cost within a transaction
START TRANSACTION;
UPDATE Shipping_Methods
SET cost = 30.00
WHERE shipping_method_id = 5001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record shipping method insertions
CREATE TABLE ShippingMethodLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    shipping_method_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogShippingMethodInsert
AFTER INSERT ON Shipping_Methods
FOR EACH ROW
BEGIN
    INSERT INTO ShippingMethodLog (shipping_method_id, action, log_date, user_id)
    VALUES (NEW.shipping_method_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log shipping method cost updates
DELIMITER //
CREATE TRIGGER LogShippingMethodCostUpdate
AFTER UPDATE ON Shipping_Methods
FOR EACH ROW
BEGIN
    IF OLD.cost != NEW.cost THEN
        INSERT INTO ShippingMethodLog (shipping_method_id, action, log_date, user_id)
        VALUES (NEW.shipping_method_id, CONCAT('COST_UPDATE: ', OLD.cost, ' to ', NEW.cost), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative costs
DELIMITER //
CREATE TRIGGER PreventNegativeShippingCost
BEFORE UPDATE ON Shipping_Methods
FOR EACH ROW
BEGIN
    IF NEW.cost < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shipping cost cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log shipping method deletions
DELIMITER //
CREATE TRIGGER LogShippingMethodDelete
AFTER DELETE ON Shipping_Methods
FOR EACH ROW
BEGIN
    INSERT INTO ShippingMethodLog (shipping_method_id, action, log_date, user_id)
    VALUES (OLD.shipping_method_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 17: Shipments**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active shipments
CREATE VIEW ActiveShipments AS
SELECT shipment_id, order_id, shipment_date, status
FROM Shipments
WHERE status IN ('Shipped', 'In Transit');

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of shipments with order details
CREATE VIEW ShipmentOrderDetails AS
SELECT s.shipment_id, o.order_date, c.first_name
FROM Shipments s
JOIN Orders o ON s.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of shipments by shipping method
CREATE VIEW ShipmentsByMethod AS
SELECT s.shipment_id, sm.method_name
FROM Shipments s
JOIN Shipping_Methods sm ON s.shipping_method_id = sm.shipping_method_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent shipments
CREATE VIEW RecentShipments AS
SELECT shipment_id, order_id, shipment_date
FROM Shipments
WHERE shipment_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count shipments by order
WITH ShipmentCounts AS (
    SELECT order_id, COUNT(*) AS shipment_count
    FROM Shipments
    GROUP BY order_id
)
SELECT o.order_id, o.order_date, sc.shipment_count
FROM Orders o
JOIN ShipmentCounts sc ON o.order_id = sc.order_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list shipments with delayed status
WITH DelayedShipments AS (
    SELECT shipment_id
    FROM Shipments
    WHERE status = 'Delayed'
)
SELECT s.shipment_id, s.order_id
FROM Shipments s
JOIN DelayedShipments ds ON s.shipment_id = ds.shipment_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find shipments for recent orders
WITH RecentOrders AS (
    SELECT order_id
    FROM Orders
    WHERE order_date >= '2025-01-01'
)
SELECT s.shipment_id, s.order_id
FROM Shipments s
JOIN RecentOrders ro ON s.order_id = ro.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list shipments by customer
WITH CustomerOrders AS (
    SELECT order_id, customer_id
    FROM Orders
)
SELECT s.shipment_id, co.customer_id, c.first_name
FROM Shipments s
JOIN CustomerOrders co ON s.order_id = co.order_id
JOIN Customers c ON co.customer_id = c.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new shipment
DELIMITER //
CREATE PROCEDURE AddShipment(
    IN p_shipment_id INT,
    IN p_order_id INT,
    IN p_shipping_method_id INT,
    IN p_shipment_date DATE,
    IN p_status VARCHAR(50),
    IN p_tracking_number VARCHAR(50)
)
BEGIN
    INSERT INTO Shipments (shipment_id, order_id, shipping_method_id, shipment_date, status, tracking_number)
    VALUES (p_shipment_id, p_order_id, p_shipping_method_id, p_shipment_date, p_status, p_tracking_number);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a shipment's status
DELIMITER //
CREATE PROCEDURE UpdateShipmentStatus(
    IN p_shipment_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Shipments
    SET status = p_new_status
    WHERE shipment_id = p_shipment_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a shipment
DELIMITER //
CREATE PROCEDURE DeleteShipment(
    IN p_shipment_id INT
)
BEGIN
    DELETE FROM Shipments
    WHERE shipment_id = p_shipment_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve shipment details
DELIMITER //
CREATE PROCEDURE GetShipmentDetails(
    IN p_shipment_id INT
)
BEGIN
    SELECT s.shipment_id, o.order_date, sm.method_name, s.status
    FROM Shipments s
    JOIN Orders o ON s.order_id = o.order_id
    JOIN Shipping_Methods sm ON s.shipping_method_id = sm.shipping_method_id
    WHERE s.shipment_id = p_shipment_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new shipment
INSERT INTO Shipments (shipment_id, order_id, shipping_method_id, shipment_date, status, tracking_number)
VALUES (6001, 301, 5001, '2025-06-08', 'Shipped', 'TRK123456');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a shipment's tracking number
UPDATE Shipments
SET tracking_number = 'TRK654321'
WHERE shipment_id = 6001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a cancelled shipment
DELETE FROM Shipments
WHERE shipment_id = 6001 AND status = 'Cancelled';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates shipment status within a transaction
START TRANSACTION;
UPDATE Shipments
SET status = 'Delivered'
WHERE shipment_id = 6001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record shipment insertions
CREATE TABLE ShipmentLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogShipmentInsert
AFTER INSERT ON Shipments
FOR EACH ROW
BEGIN
    INSERT INTO ShipmentLog (shipment_id, action, log_date, user_id)
    VALUES (NEW.shipment_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log shipment status updates
DELIMITER //
CREATE TRIGGER LogShipmentStatusUpdate
AFTER UPDATE ON Shipments
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO ShipmentLog (shipment_id, action, log_date, user_id)
        VALUES (NEW.shipment_id, CONCAT('STATUS_UPDATE: ', OLD.status, ' to ', NEW.status), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid shipment dates
DELIMITER //
CREATE TRIGGER PreventInvalidShipmentDate
BEFORE INSERT ON Shipments
FOR EACH ROW
BEGIN
    IF NEW.shipment_date < (SELECT order_date FROM Orders WHERE order_id = NEW.order_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shipment date cannot be before order date';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log shipment deletions
DELIMITER //
CREATE TRIGGER LogShipmentDelete
AFTER DELETE ON Shipments
FOR EACH ROW
BEGIN
    INSERT INTO ShipmentLog (shipment_id, action, log_date, user_id)
    VALUES (OLD.shipment_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 18: Warehouses**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of active warehouses
CREATE VIEW ActiveWarehouses AS
SELECT warehouse_id, warehouse_name, location
FROM Warehouses
WHERE is_active = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of warehouses with product counts
CREATE VIEW WarehouseProductCounts AS
SELECT w.warehouse_id, w.warehouse_name, COUNT(it.product_id) AS product_count
FROM Warehouses w
LEFT JOIN Inventory_Transactions it ON w.warehouse_id = it.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of warehouses by location
CREATE VIEW WarehousesByLocation AS
SELECT warehouse_id, warehouse_name, location
FROM Warehouses
ORDER BY location;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of warehouses with recent transactions
CREATE VIEW RecentWarehouseTransactions AS
SELECT w.warehouse_id, w.warehouse_name
FROM Warehouses w
JOIN Inventory_Transactions it ON w.warehouse_id = it.warehouse_id
WHERE it.transaction_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count products by warehouse
WITH ProductCounts AS (
    SELECT warehouse_id, COUNT(DISTINCT product_id) AS product_count
    FROM Inventory_Transactions
    GROUP BY warehouse_id
)
SELECT w.warehouse_id, w.warehouse_name, pc.product_count
FROM Warehouses w
JOIN ProductCounts pc ON w.warehouse_id = pc.warehouse_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list active warehouses
WITH ActiveWarehouses AS (
    SELECT warehouse_id
    FROM Warehouses
    WHERE is_active = TRUE
)
SELECT w.warehouse_id, w.warehouse_name
FROM Warehouses w
JOIN ActiveWarehouses aw ON w.warehouse_id = aw.warehouse_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find warehouses with low stock
WITH LowStockTransactions AS (
    SELECT warehouse_id
    FROM Inventory_Transactions
    WHERE quantity < 50
)
SELECT w.warehouse_id, w.warehouse_name
FROM Warehouses w
JOIN LowStockTransactions lst ON w.warehouse_id = lst.warehouse_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list warehouses with recent shipments
WITH RecentShipments AS (
    SELECT warehouse_id
    FROM Inventory_Transactions
    WHERE transaction_date >= '2025-01-01'
)
SELECT w.warehouse_id, w.warehouse_name
FROM Warehouses w
JOIN RecentShipments rs ON w.warehouse_id = rs.warehouse_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new warehouse
DELIMITER //
CREATE PROCEDURE AddWarehouse(
    IN p_warehouse_id INT,
    IN p_warehouse_name VARCHAR(100),
    IN p_location VARCHAR(100),
    IN p_is_active BOOLEAN
)
BEGIN
    INSERT INTO Warehouses (warehouse_id, warehouse_name, location, is_active)
    VALUES (p_warehouse_id, p_warehouse_name, p_location, p_is_active);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a warehouse's location
DELIMITER //
CREATE PROCEDURE UpdateWarehouseLocation(
    IN p_warehouse_id INT,
    IN p_new_location VARCHAR(100)
)
BEGIN
    UPDATE Warehouses
    SET location = p_new_location
    WHERE warehouse_id = p_warehouse_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a warehouse
DELIMITER //
CREATE PROCEDURE DeleteWarehouse(
    IN p_warehouse_id INT
)
BEGIN
    DELETE FROM Warehouses
    WHERE warehouse_id = p_warehouse_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve warehouse details
DELIMITER //
CREATE PROCEDURE GetWarehouseDetails(
    IN p_warehouse_id INT
)
BEGIN
    SELECT warehouse_id, warehouse_name, location
    FROM Warehouses
    WHERE warehouse_id = p_warehouse_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new warehouse
INSERT INTO Warehouses (warehouse_id, warehouse_name, location, is_active)
VALUES (7001, 'Main Warehouse', 'Los Angeles, CA', TRUE);

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a warehouse's name
UPDATE Warehouses
SET warehouse_name = 'Central Warehouse'
WHERE warehouse_id = 7001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inactive warehouse
DELETE FROM Warehouses
WHERE warehouse_id = 7001 AND is_active = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates warehouse active status within a transaction
START TRANSACTION;
UPDATE Warehouses
SET is_active = FALSE
WHERE warehouse_id = 7001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record warehouse insertions
CREATE TABLE WarehouseLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogWarehouseInsert
AFTER INSERT ON Warehouses
FOR EACH ROW
BEGIN
    INSERT INTO WarehouseLog (warehouse_id, action, log_date, user_id)
    VALUES (NEW.warehouse_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log warehouse name updates
DELIMITER //
CREATE TRIGGER LogWarehouseNameUpdate
AFTER UPDATE ON Warehouses
FOR EACH ROW
BEGIN
    IF OLD.warehouse_name != NEW.warehouse_name THEN
        INSERT INTO WarehouseLog (warehouse_id, action, log_date, user_id)
        VALUES (NEW.warehouse_id, CONCAT('NAME_UPDATE: ', OLD.warehouse_name, ' to ', NEW.warehouse_name), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent deletion of active warehouses
DELIMITER //
CREATE TRIGGER PreventActiveWarehouseDelete
BEFORE DELETE ON Warehouses
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete active warehouse';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log warehouse deletions
DELIMITER //
CREATE TRIGGER LogWarehouseDelete
AFTER DELETE ON Warehouses
FOR EACH ROW
BEGIN
    INSERT INTO WarehouseLog (warehouse_id, action, log_date, user_id)
    VALUES (OLD.warehouse_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 19: Inventory_Transactions**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of recent inventory transactions
CREATE VIEW RecentInventoryTransactions AS
SELECT transaction_id, product_id, warehouse_id, transaction_date
FROM Inventory_Transactions
WHERE transaction_date >= '2025-01-01';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of inventory transactions by product
CREATE VIEW InventoryTransactionsByProduct AS
SELECT it.transaction_id, p.product_name, it.quantity
FROM Inventory_Transactions it
JOIN Products p ON it.product_id = p.product_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of inventory transactions by warehouse
CREATE VIEW InventoryTransactionsByWarehouse AS
SELECT it.transaction_id, w.warehouse_name, it.quantity
FROM Inventory_Transactions it
JOIN Warehouses w ON it.warehouse_id = w.warehouse_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of large inventory transactions
CREATE VIEW LargeInventoryTransactions AS
SELECT transaction_id, product_id, quantity
FROM Inventory_Transactions
WHERE quantity > 100;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count transactions by product
WITH TransactionCounts AS (
    SELECT product_id, COUNT(*) AS transaction_count
    FROM Inventory_Transactions
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, tc.transaction_count
FROM Products p
JOIN TransactionCounts tc ON p.product_id = tc.product_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list transactions by type
WITH TransactionTypes AS (
    SELECT transaction_type, COUNT(*) AS type_count
    FROM Inventory_Transactions
    GROUP BY transaction_type
)
SELECT transaction_type, type_count
FROM TransactionTypes;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find recent transactions
WITH RecentTransactions AS (
    SELECT transaction_id
    FROM Inventory_Transactions
    WHERE transaction_date >= '2025-01-01'
)
SELECT it.transaction_id, it.product_id
FROM Inventory_Transactions it
JOIN RecentTransactions rt ON it.transaction_id = rt.transaction_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list transactions for low stock products
WITH LowStockProducts AS (
    SELECT product_id
    FROM Products
    WHERE stock_quantity < 50
)
SELECT it.transaction_id, it.product_id
FROM Inventory_Transactions it
JOIN LowStockProducts lsp ON it.product_id = lsp.product_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new inventory transaction
DELIMITER //
CREATE PROCEDURE AddInventoryTransaction(
    IN p_transaction_id INT,
    IN p_product_id INT,
    IN p_warehouse_id INT,
    IN p_quantity INT,
    IN p_transaction_date DATETIME,
    IN p_transaction_type VARCHAR(50)
)
BEGIN
    INSERT INTO Inventory_Transactions (transaction_id, product_id, warehouse_id, quantity, transaction_date, transaction_type)
    VALUES (p_transaction_id, p_product_id, p_warehouse_id, p_quantity, p_transaction_date, p_transaction_type);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update an inventory transaction's quantity
DELIMITER //
CREATE PROCEDURE UpdateInventoryTransactionQuantity(
    IN p_transaction_id INT,
    IN p_new_quantity INT
)
BEGIN
    UPDATE Inventory_Transactions
    SET quantity = p_new_quantity
    WHERE transaction_id = p_transaction_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete an inventory transaction
DELIMITER //
CREATE PROCEDURE DeleteInventoryTransaction(
    IN p_transaction_id INT
)
BEGIN
    DELETE FROM Inventory_Transactions
    WHERE transaction_id = p_transaction_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve inventory transaction details
DELIMITER //
CREATE PROCEDURE GetInventoryTransactionDetails(
    IN p_transaction_id INT
)
BEGIN
    SELECT it.transaction_id, p.product_name, w.warehouse_name, it.quantity
    FROM Inventory_Transactions it
    JOIN Products p ON it.product_id = p.product_id
    JOIN Warehouses w ON it.warehouse_id = w.warehouse_id
    WHERE it.transaction_id = p_transaction_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new inventory transaction
INSERT INTO Inventory_Transactions (transaction_id, product_id, warehouse_id, quantity, transaction_date, transaction_type)
VALUES (8001, 21, 7001, 100, '2025-06-07 14:00:00', 'Restock');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates an inventory transaction's quantity
UPDATE Inventory_Transactions
SET quantity = 150
WHERE transaction_id = 8001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an inventory transaction
DELETE FROM Inventory_Transactions
WHERE transaction_id = 8001;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates inventory transaction quantity within a transaction
START TRANSACTION;
UPDATE Inventory_Transactions
SET quantity = quantity + 50
WHERE transaction_id = 8001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record inventory transaction insertions
CREATE TABLE InventoryTransactionLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogInventoryTransactionInsert
AFTER INSERT ON Inventory_Transactions
FOR EACH ROW
BEGIN
    INSERT INTO InventoryTransactionLog (transaction_id, action, log_date, user_id)
    VALUES (NEW.transaction_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log inventory transaction quantity updates
DELIMITER //
CREATE TRIGGER LogInventoryTransactionQuantityUpdate
AFTER UPDATE ON Inventory_Transactions
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO InventoryTransactionLog (transaction_id, action, log_date, user_id)
        VALUES (NEW.transaction_id, CONCAT('QUANTITY_UPDATE: ', OLD.quantity, ' to ', NEW.quantity), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative quantities
DELIMITER //
CREATE TRIGGER PreventNegativeInventoryQuantity
BEFORE UPDATE ON Inventory_Transactions
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inventory transaction quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log inventory transaction deletions
DELIMITER //
CREATE TRIGGER LogInventoryTransactionDelete
AFTER DELETE ON Inventory_Transactions
FOR EACH ROW
BEGIN
    INSERT INTO InventoryTransactionLog (transaction_id, action, log_date, user_id)
    VALUES (OLD.transaction_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 20: Customer_Support_Tickets**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of open customer support tickets
CREATE VIEW OpenSupportTickets AS
SELECT ticket_id, customer_id, status
FROM Customer_Support_Tickets
WHERE status = 'Open';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of tickets with customer details
CREATE VIEW SupportTicketCustomerDetails AS
SELECT cst.ticket_id, c.first_name, cst.issue_description
FROM Customer_Support_Tickets cst
JOIN Customers c ON cst.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of tickets by order
CREATE VIEW SupportTicketsByOrder AS
SELECT cst.ticket_id, o.order_date
FROM Customer_Support_Tickets cst
JOIN Orders o ON cst.order_id = o.order_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent support tickets
CREATE VIEW RecentSupportTickets AS
SELECT ticket_id, customer_id, created_date
FROM Customer_Support_Tickets
WHERE created_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count tickets by customer
WITH TicketCounts AS (
    SELECT customer_id, COUNT(*) AS ticket_count
    FROM Customer_Support_Tickets
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, tc.ticket_count
FROM Customers c
JOIN TicketCounts tc ON c.customer_id = tc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list open tickets
WITH OpenTickets AS (
    SELECT ticket_id
    FROM Customer_Support_Tickets
    WHERE status = 'Open'
)
SELECT cst.ticket_id, cst.customer_id
FROM Customer_Support_Tickets cst
JOIN OpenTickets ot ON cst.ticket_id = ot.ticket_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find tickets for recent orders
WITH RecentOrders AS (
    SELECT order_id
    FROM Orders
    WHERE order_date >= '2025-01-01'
)
SELECT cst.ticket_id, cst.order_id
FROM Customer_Support_Tickets cst
JOIN RecentOrders ro ON cst.order_id = ro.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list tickets by status
WITH TicketStatus AS (
    SELECT status, COUNT(*) AS ticket_count
    FROM Customer_Support_Tickets
    GROUP BY status
)
SELECT status, ticket_count
FROM TicketStatus;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new support ticket
DELIMITER //
CREATE PROCEDURE AddSupportTicket(
    IN p_ticket_id INT,
    IN p_customer_id INT,
    IN p_order_id INT,
    IN p_issue_description TEXT,
    IN p_status VARCHAR(50),
    IN p_created_date DATETIME
)
BEGIN
    INSERT INTO Customer_Support_Tickets (ticket_id, customer_id, order_id, issue_description, status, created_date)
    VALUES (p_ticket_id, p_customer_id, p_order_id, p_issue_description, p_status, p_created_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a ticket's status
DELIMITER //
CREATE PROCEDURE UpdateSupportTicketStatus(
    IN p_ticket_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Customer_Support_Tickets
    SET status = p_new_status
    WHERE ticket_id = p_ticket_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a support ticket
DELIMITER //
CREATE PROCEDURE DeleteSupportTicket(
    IN p_ticket_id INT
)
BEGIN
    DELETE FROM Customer_Support_Tickets
    WHERE ticket_id = p_ticket_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve support ticket details
DELIMITER //
CREATE PROCEDURE GetSupportTicketDetails(
    IN p_ticket_id INT
)
BEGIN
    SELECT cst.ticket_id, c.first_name, o.order_date, cst.status
    FROM Customer_Support_Tickets cst
    JOIN Customers c ON cst.customer_id = c.customer_id
    JOIN Orders o ON cst.order_id = o.order_id
    WHERE cst.ticket_id = p_ticket_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new support ticket
INSERT INTO Customer_Support_Tickets (ticket_id, customer_id, order_id, issue_description, status, created_date)
VALUES (9001, 201, 301, 'Order not delivered', 'Open', '2025-06-07 15:00:00');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a support ticket's status
UPDATE Customer_Support_Tickets
SET status = 'Resolved'
WHERE ticket_id = 9001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a closed support ticket
DELETE FROM Customer_Support_Tickets
WHERE ticket_id = 9001 AND status = 'Closed';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates support ticket status within a transaction
START TRANSACTION;
UPDATE Customer_Support_Tickets
SET status = 'In Progress'
WHERE ticket_id = 9001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record support ticket insertions
CREATE TABLE SupportTicketLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogSupportTicketInsert
AFTER INSERT ON Customer_Support_Tickets
FOR EACH ROW
BEGIN
    INSERT INTO SupportTicketLog (ticket_id, action, log_date, user_id)
    VALUES (NEW.ticket_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log support ticket status updates
DELIMITER //
CREATE TRIGGER LogSupportTicketStatusUpdate
AFTER UPDATE ON Customer_Support_Tickets
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO SupportTicketLog (ticket_id, action, log_date, user_id)
        VALUES (NEW.ticket_id, CONCAT('STATUS_UPDATE: ', OLD.status, ' to ', NEW.status), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid ticket statuses
DELIMITER //
CREATE TRIGGER PreventInvalidTicketStatus
BEFORE UPDATE ON Customer_Support_Tickets
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Open', 'In Progress', 'Resolved', 'Closed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid ticket status';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log support ticket deletions
DELIMITER //
CREATE TRIGGER LogSupportTicketDelete
AFTER DELETE ON Customer_Support_Tickets
FOR EACH ROW
BEGIN
    INSERT INTO SupportTicketLog (ticket_id, action, log_date, user_id)
    VALUES (OLD.ticket_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 21: Refunds**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of approved refunds
CREATE VIEW ApprovedRefunds AS
SELECT refund_id, order_id, amount
FROM Refunds
WHERE status = 'Approved';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of refunds with order details
CREATE VIEW RefundOrderDetails AS
SELECT r.refund_id, o.order_date, c.first_name
FROM Refunds r
JOIN Orders o ON r.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of refunds by amount
CREATE VIEW HighAmountRefunds AS
SELECT refund_id, order_id, amount
FROM Refunds
WHERE amount > 100;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of recent refunds
CREATE VIEW RecentRefunds AS
SELECT refund_id, order_id, refund_date
FROM Refunds
WHERE refund_date >= '2025-01-01';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count refunds by order
WITH RefundCounts AS (
    SELECT order_id, COUNT(*) AS refund_count
    FROM Refunds
    GROUP BY order_id
)
SELECT o.order_id, o.order_date, rc.refund_count
FROM Orders o
JOIN RefundCounts rc ON o.order_id = rc.order_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list pending refunds
WITH PendingRefunds AS (
    SELECT refund_id
    FROM Refunds
    WHERE status = 'Pending'
)
SELECT r.refund_id, r.order_id
FROM Refunds r
JOIN PendingRefunds pr ON r.refund_id = pr.refund_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find refunds for recent orders
WITH RecentOrders AS (
    SELECT order_id
    FROM Orders
    WHERE order_date >= '2025-01-01'
)
SELECT r.refund_id, r.order_id
FROM Refunds r
JOIN RecentOrders ro ON r.order_id = ro.order_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list refunds by customer
WITH CustomerRefunds AS (
    SELECT r.refund_id, o.customer_id
    FROM Refunds r
    JOIN Orders o ON r.order_id = o.order_id
)
SELECT cr.refund_id, c.first_name
FROM CustomerRefunds cr
JOIN Customers c ON cr.customer_id = c.customer_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new refund
DELIMITER //
CREATE PROCEDURE AddRefund(
    IN p_refund_id INT,
    IN p_order_id INT,
    IN p_payment_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_refund_date DATE,
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO Refunds (refund_id, order_id, payment_id, amount, refund_date, status)
    VALUES (p_refund_id, p_order_id, p_payment_id, p_amount, p_refund_date, p_status);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a refund's status
DELIMITER //
CREATE PROCEDURE UpdateRefundStatus(
    IN p_refund_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Refunds
    SET status = p_new_status
    WHERE refund_id = p_refund_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a refund
DELIMITER //
CREATE PROCEDURE DeleteRefund(
    IN p_refund_id INT
)
BEGIN
    DELETE FROM Refunds
    WHERE refund_id = p_refund_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve refund details
DELIMITER //
CREATE PROCEDURE GetRefundDetails(
    IN p_refund_id INT
)
BEGIN
    SELECT r.refund_id, o.order_date, p.payment_date, r.amount, r.status
    FROM Refunds r
    JOIN Orders o ON r.order_id = o.order_id
    JOIN Payments p ON r.payment_id = p.payment_id
    WHERE r.refund_id = p_refund_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new refund
INSERT INTO Refunds (refund_id, order_id, payment_id, amount, refund_date, status)
VALUES (10001, 301, 601, 150.00, '2025-06-08', 'Pending');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a refund's amount
UPDATE Refunds
SET amount = 200.00
WHERE refund_id = 10001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a denied refund
DELETE FROM Refunds
WHERE refund_id = 10001 AND status = 'Denied';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates refund status within a transaction
START TRANSACTION;
UPDATE Refunds
SET status = 'Approved'
WHERE refund_id = 10001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record refund insertions
CREATE TABLE RefundLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    refund_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogRefundInsert
AFTER INSERT ON Refunds
FOR EACH ROW
BEGIN
    INSERT INTO RefundLog (refund_id, action, log_date, user_id)
    VALUES (NEW.refund_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log refund status updates
DELIMITER //
CREATE TRIGGER LogRefundStatusUpdate
AFTER UPDATE ON Refunds
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO RefundLog (refund_id, action, log_date, user_id)
        VALUES (NEW.refund_id, CONCAT('STATUS_UPDATE: ', OLD.status, ' to ', NEW.status), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent negative refund amounts
DELIMITER //
CREATE TRIGGER PreventNegativeRefundAmount
BEFORE INSERT ON Refunds
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Refund amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log refund deletions
DELIMITER //
CREATE TRIGGER LogRefundDelete
AFTER DELETE ON Refunds
FOR EACH ROW
BEGIN
    INSERT INTO RefundLog (refund_id, action, log_date, user_id)
    VALUES (OLD.refund_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 22: Product_Images**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of primary product images
CREATE VIEW PrimaryProductImages AS
SELECT image_id, product_id, image_url
FROM Product_Images
WHERE is_primary = TRUE;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of product images with product details
CREATE VIEW ProductImageDetails AS
SELECT pi.image_id, p.product_name, pi.image_url
FROM Product_Images pi
JOIN Products p ON pi.product_id = p.product_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of recent product images
CREATE VIEW RecentProductImages AS
SELECT image_id, product_id, uploaded_date
FROM Product_Images
WHERE uploaded_date >= '2025-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of product images with categories
CREATE VIEW ProductImageCategories AS
SELECT pi.image_id, p.product_id, c.category_name
FROM Product_Images pi
JOIN Products p ON pi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count images by product
WITH ImageCounts AS (
    SELECT product_id, COUNT(*) AS image_count
    FROM Product_Images
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, ic.image_count
FROM Products p
JOIN ImageCounts ic ON p.product_id = ic.product_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list primary images
WITH PrimaryImages AS (
    SELECT image_id
    FROM Product_Images
    WHERE is_primary = TRUE
)
SELECT pi.image_id, pi.product_id
FROM Product_Images pi
JOIN PrimaryImages pri ON pi.image_id = pri.image_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find images for recent products
WITH RecentProducts AS (
    SELECT product_id
    FROM Products
    WHERE created_date >= '2025-01-01'
)
SELECT pi.image_id, pi.product_id
FROM Product_Images pi
JOIN RecentProducts rp ON pi.product_id = rp.product_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list images for active products
WITH ActiveProducts AS (
    SELECT product_id
    FROM Products
    WHERE is_active = TRUE
)
SELECT pi.image_id, pi.product_id
FROM Product_Images pi
JOIN ActiveProducts ap ON pi.product_id = ap.product_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new product image
DELIMITER //
CREATE PROCEDURE AddProductImage(
    IN p_image_id INT,
    IN p_product_id INT,
    IN p_image_url VARCHAR(255),
    IN p_is_primary BOOLEAN,
    IN p_uploaded_date DATETIME
)
BEGIN
    INSERT INTO Product_Images (image_id, product_id, image_url, is_primary, uploaded_date)
    VALUES (p_image_id, p_product_id, p_image_url, p_is_primary, p_uploaded_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a product image's primary status
DELIMITER //
CREATE PROCEDURE UpdateProductImagePrimary(
    IN p_image_id INT,
    IN p_is_primary BOOLEAN
)
BEGIN
    UPDATE Product_Images
    SET is_primary = p_is_primary
    WHERE image_id = p_image_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a product image
DELIMITER //
CREATE PROCEDURE DeleteProductImage(
    IN p_image_id INT
)
BEGIN
    DELETE FROM Product_Images
    WHERE image_id = p_image_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve product image details
DELIMITER //
CREATE PROCEDURE GetProductImageDetails(
    IN p_image_id INT
)
BEGIN
    SELECT pi.image_id, p.product_name, pi.image_url, pi.is_primary
    FROM Product_Images pi
    JOIN Products p ON pi.product_id = p.product_id
    WHERE pi.image_id = p_image_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new product image
INSERT INTO Product_Images (image_id, product_id, image_url, is_primary, uploaded_date)
VALUES (11001, 21, 'https://example.com/product21.jpg', TRUE, '2025-06-07 16:00:00');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a product image's primary status
UPDATE Product_Images
SET is_primary = FALSE
WHERE image_id = 11001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a non-primary product image
DELETE FROM Product_Images
WHERE image_id = 11001 AND is_primary = FALSE;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates product image primary status within a transaction
START TRANSACTION;
UPDATE Product_Images
SET is_primary = TRUE
WHERE image_id = 11001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record product image insertions
CREATE TABLE ProductImageLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    image_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogProductImageInsert
AFTER INSERT ON Product_Images
FOR EACH ROW
BEGIN
    INSERT INTO ProductImageLog (image_id, action, log_date, user_id)
    VALUES (NEW.image_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log product image primary status updates
DELIMITER //
CREATE TRIGGER LogProductImagePrimaryUpdate
AFTER UPDATE ON Product_Images
FOR EACH ROW
BEGIN
    IF OLD.is_primary != NEW.is_primary THEN
        INSERT INTO ProductImageLog (image_id, action, log_date, user_id)
        VALUES (NEW.image_id, CONCAT('PRIMARY_UPDATE: ', OLD.is_primary, ' to ', NEW.is_primary), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent multiple primary images per product
DELIMITER //
CREATE TRIGGER PreventMultiplePrimaryImages
BEFORE INSERT ON Product_Images
FOR EACH ROW
BEGIN
    IF NEW.is_primary = TRUE AND EXISTS (
        SELECT 1 FROM Product_Images
        WHERE product_id = NEW.product_id AND is_primary = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product already has a primary image';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log product image deletions
DELIMITER //
CREATE TRIGGER LogProductImageDelete
AFTER DELETE ON Product_Images
FOR EACH ROW
BEGIN
    INSERT INTO ProductImageLog (image_id, action, log_date, user_id)
    VALUES (OLD.image_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 23: Product_Tags**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of product tags by product
CREATE VIEW ProductTagsByProduct AS
SELECT tag_id, product_id, tag_name
FROM Product_Tags
ORDER BY product_id;

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of popular tags
CREATE VIEW PopularProductTags AS
SELECT tag_name, COUNT(*) AS tag_count
FROM Product_Tags
GROUP BY tag_name
HAVING tag_count > 5;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of recent product tags
CREATE VIEW RecentProductTags AS
SELECT tag_id, product_id, created_date
FROM Product_Tags
WHERE created_date >= '2025-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of product tags with categories
CREATE VIEW ProductTagCategories AS
SELECT pt.tag_id, p.product_id, c.category_name
FROM Product_Tags pt
JOIN Products p ON pt.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id;

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count tags by product
WITH TagCounts AS (
    SELECT product_id, COUNT(*) AS tag_count
    FROM Product_Tags
    GROUP BY product_id
)
SELECT p.product_id, p.product_name, tc.tag_count
FROM Products p
JOIN TagCounts tc ON p.product_id = tc.product_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list tags for active products
WITH ActiveProducts AS (
    SELECT product_id
    FROM Products
    WHERE is_active = TRUE
)
SELECT pt.tag_id, pt.tag_name
FROM Product_Tags pt
JOIN ActiveProducts ap ON pt.product_id = ap.product_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find tags for high-rated products
WITH HighRatedProducts AS (
    SELECT product_id
    FROM Reviews
    GROUP BY product_id
    HAVING AVG(rating) >= 4
)
SELECT pt.tag_id, pt.tag_name
FROM Product_Tags pt
JOIN HighRatedProducts hrp ON pt.product_id = hrp.product_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list recent tags
WITH RecentTags AS (
    SELECT tag_id
    FROM Product_Tags
    WHERE created_date >= '2025-01-01'
)
SELECT pt.tag_id, pt.tag_name
FROM Product_Tags pt
JOIN RecentTags rt ON pt.tag_id = rt.tag_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new product tag
DELIMITER //
CREATE PROCEDURE AddProductTag(
    IN p_tag_id INT,
    IN p_product_id INT,
    IN p_tag_name VARCHAR(50),
    IN p_created_date DATETIME
)
BEGIN
    INSERT INTO Product_Tags (tag_id, product_id, tag_name, created_date)
    VALUES (p_tag_id, p_product_id, p_tag_name, p_created_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a product tag's name
DELIMITER //
CREATE PROCEDURE UpdateProductTagName(
    IN p_tag_id INT,
    IN p_new_tag_name VARCHAR(50)
)
BEGIN
    UPDATE Product_Tags
    SET tag_name = p_new_tag_name
    WHERE tag_id = p_tag_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a product tag
DELIMITER //
CREATE PROCEDURE DeleteProductTag(
    IN p_tag_id INT
)
BEGIN
    DELETE FROM Product_Tags
    WHERE tag_id = p_tag_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve product tag details
DELIMITER //
CREATE PROCEDURE GetProductTagDetails(
    IN p_tag_id INT
)
BEGIN
    SELECT pt.tag_id, p.product_name, pt.tag_name
    FROM Product_Tags pt
    JOIN Products p ON pt.product_id = p.product_id
    WHERE pt.tag_id = p_tag_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new product tag
INSERT INTO Product_Tags (tag_id, product_id, tag_name, created_date)
VALUES (12001, 21, 'Electronics', '2025-06-07 17:00:00');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a product tag's name
UPDATE Product_Tags
SET tag_name = 'Gadgets'
WHERE tag_id = 12001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a product tag
DELETE FROM Product_Tags
WHERE tag_id = 12001;

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates product tag name within a transaction
START TRANSACTION;
UPDATE Product_Tags
SET tag_name = 'Tech'
WHERE tag_id = 12001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record product tag insertions
CREATE TABLE ProductTagLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogProductTagInsert
AFTER INSERT ON Product_Tags
FOR EACH ROW
BEGIN
    INSERT INTO ProductTagLog (tag_id, action, log_date, user_id)
    VALUES (NEW.tag_id, 'INSERT', NOW(), USER());
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log product tag name updates
DELIMITER //
CREATE TRIGGER LogProductTagNameUpdate
AFTER UPDATE ON Product_Tags
FOR EACH ROW
BEGIN
    IF OLD.tag_name != NEW.tag_name THEN
        INSERT INTO ProductTagLog (tag_id, action, log_date, user_id)
        VALUES (NEW.tag_id, CONCAT('NAME_UPDATE: ', OLD.tag_name, ' to ', NEW.tag_name), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent duplicate tags per product
DELIMITER //
CREATE TRIGGER PreventDuplicateProductTag
BEFORE INSERT ON Product_Tags
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Product_Tags
        WHERE product_id = NEW.product_id AND tag_name = NEW.tag_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tag already exists for this product';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log product tag deletions
DELIMITER //
CREATE TRIGGER LogProductTagDelete
AFTER DELETE ON Product_Tags
FOR EACH ROW
BEGIN
    INSERT INTO ProductTagLog (tag_id, action, log_date, user_id)
    VALUES (OLD.tag_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 24: Notifications**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of sent notifications
CREATE VIEW SentNotifications AS
SELECT notification_id, customer_id, sent_date
FROM Notifications
WHERE status = 'Sent';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of notifications with customer details
CREATE VIEW NotificationCustomerDetails AS
SELECT n.notification_id, c.first_name, n.message
FROM Notifications n
JOIN Customers c ON n.customer_id = c.customer_id;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of recent notifications
CREATE VIEW RecentNotifications AS
SELECT notification_id, customer_id, sent_date
FROM Notifications
WHERE sent_date >= '2025-01-01';

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of unread notifications
CREATE VIEW UnreadNotifications AS
SELECT notification_id, customer_id, message
FROM Notifications
WHERE status = 'Unread';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count notifications by customer
WITH NotificationCounts AS (
    SELECT customer_id, COUNT(*) AS notification_count
    FROM Notifications
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, nc.notification_count
FROM Customers c
JOIN NotificationCounts nc ON c.customer_id = nc.customer_id;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list unread notifications
WITH UnreadNotifications AS (
    SELECT notification_id
    FROM Notifications
    WHERE status = 'Unread'
)
SELECT n.notification_id, n.customer_id
FROM Notifications n
JOIN UnreadNotifications un ON n.notification_id = un.notification_id;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find notifications for recent orders
WITH RecentOrders AS (
    SELECT customer_id
    FROM Orders
    WHERE order_date >= '2025-01-01'
)
SELECT n.notification_id, n.message
FROM Notifications n
JOIN RecentOrders ro ON n.customer_id = ro.customer_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list notifications by status
WITH NotificationStatus AS (
    SELECT status, COUNT(*) AS notification_count
    FROM Notifications
    GROUP BY status
)
SELECT status, notification_count
FROM NotificationStatus;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new notification
DELIMITER //
CREATE PROCEDURE AddNotification(
    IN p_notification_id INT,
    IN p_customer_id INT,
    IN p_message TEXT,
    IN p_sent_date DATETIME,
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO Notifications (notification_id, customer_id, message, sent_date, status)
    VALUES (p_notification_id, p_customer_id, p_message, p_sent_date, p_status);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update a notification's status
DELIMITER //
CREATE PROCEDURE UpdateNotificationStatus(
    IN p_notification_id INT,
    IN p_new_status VARCHAR(50)
)
BEGIN
    UPDATE Notifications
    SET status = p_new_status
    WHERE notification_id = p_notification_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete a notification
DELIMITER //
CREATE PROCEDURE DeleteNotification(
    IN p_notification_id INT
)
BEGIN
    DELETE FROM Notifications
    WHERE notification_id = p_notification_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve notification details
DELIMITER //
CREATE PROCEDURE GetNotificationDetails(
    IN p_notification_id INT
)
BEGIN
    SELECT n.notification_id, c.first_name, n.message, n.status
    FROM Notifications n
    JOIN Customers c ON n.customer_id = c.customer_id
    WHERE n.notification_id = p_notification_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new notification
INSERT INTO Notifications (notification_id, customer_id, message, sent_date, status)
VALUES (13001, 201, 'Your order has shipped!', '2025-06-07 18:00:00', 'Sent');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates a notification's status
UPDATE Notifications
SET status = 'Read'
WHERE notification_id = 13001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes a read notification
DELETE FROM Notifications
WHERE notification_id = 13001 AND status = 'Read';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates notification status within a transaction
START TRANSACTION;
UPDATE Notifications
SET status = 'Unread'
WHERE notification_id = 13001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record notification insertions
CREATE TABLE NotificationLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    notification_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //;
CREATE TRIGGER LogNotificationInsert
AFTER INSERT ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO NotificationLog (notification_id, action, log_date, user_id)
    VALUES (NEW.notification_id, 'INSERT', NOW(), USER());
END //;
DELIMITER ; ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log notification status updates
DELIMITER //
CREATE TRIGGER LogNotificationStatusUpdate
AFTER UPDATE ON Notifications
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO NotificationLog (notification_id, action, log_date, user_id)
        VALUES (NEW.notification_id, CONCAT('STATUS_UPDATE: ', OLD.status, ' to ', NEW.status), NOW(), USER());
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid notification statuses
DELIMITER //;
CREATE TRIGGER PreventInvalidNotificationStatus
BEFORE UPDATE ON Notifications
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('New', 'Unread', 'Sent', 'Read') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid notification status';
    END IF;
END //;
DELIMITER ; ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log notification deletions
DELIMITER //
CREATE TRIGGER LogNotificationDelete
AFTER DELETE ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO NotificationLog (notification_id, action, log_date, user_id)
    VALUES (OLD.notification_id, 'DELETE', NOW(), USER());
END //
DELIMITER ;

-- **Table 25: Audit_Logs**

-- Query Number: 1
-- Query Type: View
-- Description: Creates a view of recent audit logs
CREATE VIEW RecentAuditLogs AS
SELECT audit_id, user_id, action_date
FROM Audit_Logs
WHERE action_date >= '2025-01-01';

-- Query Number: 2
-- Query Type: View
-- Description: Creates a view of audit logs by table
CREATE VIEW AuditLogsByTable AS
SELECT audit_id, table_name, COUNT(*) AS log_count
FROM Audit_Logs
GROUP BY table_name;

-- Query Number: 3
-- Query Type: View
-- Description: Creates a view of audit logs by user
CREATE VIEW AuditLogsByUser AS
SELECT audit_id, user_id, action
FROM Audit_Logs
ORDER BY user_id;

-- Query Number: 4
-- Query Type: View
-- Description: Creates a view of audit logs
CREATE VIEW DeletionAuditLogs AS
SELECT audit_id, table_name, record_id
FROM Audit_Logs
WHERE action LIKE '%DELETE%';

-- Query Number: 5
-- Query Type: CTE
-- Description: Uses a CTE to count logs by table
WITH TableLogCounts AS (
    SELECT table_name, COUNT(*) AS log_count
    FROM Audit_Logs
    GROUP BY table_name
)
SELECT table_name, log_count
FROM TableLogCounts;

-- Query Number: 6
-- Query Type: CTE
-- Description: Uses a CTE to list logs by user
WITH UserLogs AS (
    SELECT user_id, COUNT(*) AS log_count
    FROM Audit_Logs
    GROUP BY user_id
)
SELECT user_id, log_count
FROM UserLogs;

-- Query Number: 7
-- Query Type: CTE
-- Description: Uses a CTE to find recent logs
WITH RecentLogs AS (
    SELECT audit_id
    FROM Audit_Logs
    WHERE action_date >= '2025-01-01'
)
SELECT al.audit_id, al.table_name
FROM Audit_Logs al
JOIN RecentLogs rl ON al.audit_id = rl.audit_id;

-- Query Number: 8
-- Query Type: CTE
-- Description: Uses a CTE to list logs for deletion actions
WITH DeletionLogs AS (
    SELECT audit_id
    FROM Audit_Logs
    WHERE action LIKE '%DELETE%'
)
SELECT al.audit_id, al.table_name
FROM Audit_Logs al
JOIN DeletionLogs dl ON al.audit_id = dl.audit_id;

-- Query Number: 9
-- Query Type: Stored Procedure
-- Description: Creates a procedure to insert a new audit log
DELIMITER //
CREATE PROCEDURE AddAuditLog(
    IN p_audit_id INT,
    IN p_user_id VARCHAR(50),
    IN p_action VARCHAR(100),
    IN p_table_name VARCHAR(50),
    IN p_record_id INT,
    IN p_action_date DATETIME
)
BEGIN
    INSERT INTO Audit_Logs (audit_id, user_id, action, table_name, record_id, action_date)
    VALUES (p_audit_id, p_user_id, p_action, p_table_name, p_record_id, p_action_date);
END //
DELIMITER ;

-- Query Number: 10
-- Query Type: Stored Procedure
-- Description: Creates a procedure to update an audit log's action
DELIMITER //
CREATE PROCEDURE UpdateAuditLogAction(
    IN p_audit_id INT,
    IN p_new_action VARCHAR(100)
)
BEGIN
    UPDATE Audit_Logs
    SET action = p_new_action
    WHERE audit_id = p_audit_id;
END //
DELIMITER ;

-- Query Number: 11
-- Query Type: Stored Procedure
-- Description: Creates a procedure to delete an audit log
DELIMITER //
CREATE PROCEDURE DeleteAuditLog(
    IN p_audit_id INT
)
BEGIN
    DELETE FROM Audit_Logs
    WHERE audit_id = p_audit_id;
END //
DELIMITER ;

-- Query Number: 12
-- Query Type: Stored Procedure
-- Description: Creates a procedure to retrieve audit log details
DELIMITER //
CREATE PROCEDURE GetAuditLogDetails(
    IN p_audit_id INT
)
BEGIN
    SELECT audit_id, user_id, action, table_name, record_id
    FROM Audit_Logs
    WHERE audit_id = p_audit_id;
END //
DELIMITER ;

-- Query Number: 13
-- Query Type: DML
-- Description: Inserts a new audit log
INSERT INTO Audit_Logs (audit_id, user_id, action, table_name, record_id, action_date)
VALUES (14001, 'admin', 'INSERT', 'Orders', 301, '2025-06-07 11:00:00');

-- Query Number: 14
-- Query Type: DML
-- Description: Updates an audit log's action
UPDATE Audit_Logs
SET action = 'UPDATE'
WHERE audit_id = 14001;

-- Query Number: 15
-- Query Type: DML
-- Description: Deletes an old audit log
DELETE FROM Audit_Logs
WHERE audit_id = 14001 AND action_date < '2025-01-01';

-- Query Number: 16
-- Query Type: TCL
-- Description: Updates audit log action within a transaction
START TRANSACTION;
UPDATE Audit_Logs
SET action = 'DELETE'
WHERE audit_id = 14001;
COMMIT;

-- Query Number: 17
-- Query Type: Trigger
-- Description: Creates a log table and trigger to record audit log insertions
CREATE TABLE AuditLogLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    audit_id INT,
    action VARCHAR(20),
    log_date DATETIME,
    user_id VARCHAR(50)
);
DELIMITER //
CREATE TRIGGER LogAuditLogInsert
AFTER INSERT ON Audit_Logs
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogLog (audit_id, action, log_date, user_id)
    VALUES (NEW.audit_id, 'INSERT', NOW(), NEW.user_id);
END //
DELIMITER ;

-- Query Number: 18
-- Query Type: Trigger
-- Description: Creates a trigger to log audit log action updates
DELIMITER //
CREATE TRIGGER LogAuditLogActionUpdate
AFTER UPDATE ON Audit_Logs
FOR EACH ROW
BEGIN
    IF OLD.action != NEW.action THEN
        INSERT INTO AuditLogLog (audit_id, action, log_date, user_id)
        VALUES (NEW.audit_id, CONCAT('ACTION_UPDATE: ', OLD.action, ' to ', NEW.action), NOW(), NEW.user_id);
    END IF;
END //
DELIMITER ;

-- Query Number: 19
-- Query Type: Trigger
-- Description: Creates a trigger to prevent invalid table names
DELIMITER //
CREATE TRIGGER PreventInvalidTableName
BEFORE INSERT ON Audit_Logs
FOR EACH ROW
BEGIN
    IF NEW.table_name NOT IN (
        'Products', 'Customers', 'Categories', 'Orders', 'Order_Items', 'Suppliers', 'Addresses',
        'Payments', 'Payment_Methods', 'Reviews', 'Subscriptions', 'Wishlists', 'Cart_Items',
        'Promotions', 'Coupons', 'Shipping_Methods', 'Shipments', 'Warehouses', 'Inventory_Transactions',
        'Customer_Support_Tickets', 'Refunds', 'Product_Images', 'Product_Tags', 'Notifications', 'Audit_Logs'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid table name';
    END IF;
END //
DELIMITER ;

-- Query Number: 20
-- Query Type: Trigger
-- Description: Creates a trigger to log audit log deletions
DELIMITER //
CREATE TRIGGER LogAuditLogDelete
AFTER DELETE ON Audit_Logs
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogLog (audit_id, action, log_date, user_id)
    VALUES (OLD.audit_id, 'DELETE', NOW(), OLD.user_id);
END //
DELIMITER ;
