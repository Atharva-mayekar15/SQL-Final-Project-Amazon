-- Project Phase-4(V&C<SP<WF<D&TCL<Tri)
-- Table 1: Products
-- 1. View: Active products with price > $100
CREATE VIEW ActiveHighPricedProducts AS
SELECT product_id, product_name, price, category_id, stock_quantity
FROM Products
WHERE is_active = TRUE AND price > 100;

-- 2. View: Products with supplier details
CREATE VIEW ProductsWithSuppliers AS
SELECT p.product_id, p.product_name, p.price, s.supplier_name, s.contact_email
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- 3. View: Top rated products
CREATE VIEW TopRatedProducts AS
SELECT product_id, product_name, rating
FROM Products
WHERE rating >= 4.5
ORDER BY rating DESC;

-- 4. CTE: Average price by category
WITH CategoryAvgPrice AS (
    SELECT category_id, AVG(price) AS avg_price
    FROM Products
    GROUP BY category_id
)
SELECT p.product_id, p.product_name, p.price, c.avg_price
FROM Products p
JOIN CategoryAvgPrice c ON p.category_id = c.category_id
WHERE p.price > c.avg_price;

-- 5. CTE: Low stock products
WITH LowStockProducts AS (
    SELECT product_id, product_name, stock_quantity
    FROM Products
    WHERE stock_quantity < 50
)
SELECT p.product_name, p.stock_quantity, s.supplier_name
FROM LowStockProducts p
JOIN Products pr ON p.product_id = pr.product_id
JOIN Suppliers s ON pr.supplier_id = s.supplier_id;

-- 6. CTE: Ranked products by rating
WITH RankedProducts AS (
    SELECT product_id, product_name, rating,
           RANK() OVER (ORDER BY rating DESC) AS rating_rank
    FROM Products
    WHERE rating IS NOT NULL
)
SELECT product_name, rating, rating_rank
FROM RankedProducts
WHERE rating_rank <= 5;

-- 7. Stored Procedure: Update product price
DELIMITER //
CREATE PROCEDURE UpdateProductPrice(IN prod_id INT, IN new_price DECIMAL(10,2))
BEGIN
    UPDATE Products SET price = new_price WHERE product_id = prod_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate low stock products
DELIMITER //
CREATE PROCEDURE DeactivateLowStockProducts()
BEGIN
    UPDATE Products SET is_active = FALSE WHERE stock_quantity = 0;
END //
DELIMITER ;

-- 9. Stored Procedure: Get products by category
DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN cat_id INT)
BEGIN
    SELECT product_id, product_name, price
    FROM Products
    WHERE category_id = cat_id AND is_active = TRUE;
END //
DELIMITER ;

-- 10. TCL: Update stock with rollback
START TRANSACTION;
UPDATE Products SET stock_quantity = stock_quantity - 10 WHERE product_id = 1;
UPDATE Products SET stock_quantity = stock_quantity - 5 WHERE product_id = 2;
-- Simulate error
INSERT INTO Products (product_id) VALUES (1); -- Duplicate key error
COMMIT;
ROLLBACK;

-- 11. TCL: Commit price update
START TRANSACTION;
UPDATE Products SET price = price * 1.1 WHERE category_id = 1;
SAVEPOINT price_updated;
UPDATE Products SET price = price * 1.05 WHERE category_id = 2;
COMMIT;

-- 12. TCL: Rollback stock update
START TRANSACTION;
UPDATE Products SET stock_quantity = stock_quantity + 20 WHERE product_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Products TO 'user1'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Products TO 'inventory_manager';

-- 15. Trigger: Log price changes
DELIMITER //
CREATE TRIGGER LogPriceChange
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price != NEW.price THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Price Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Product ID: ', NEW.product_id, ' Price changed from ', OLD.price, ' to ', NEW.price),
                'Products', 'Price adjustment');
    END IF;
END;
// DELIMITER ;


-- 16. Trigger: Prevent negative stock
DELIMITER //
CREATE TRIGGER PreventNegativeStock
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Deactivate on stock depletion
DELIMITER //
CREATE TRIGGER DeactivateOnStockDepletion
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity = 0 THEN
        UPDATE Products SET is_active = FALSE WHERE product_id = NEW.product_id;
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank products by price
SELECT product_id, product_name, price, category_id,
       RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
FROM Products;

-- 19. Window Function: Running total stock
SELECT product_id, product_name, stock_quantity, category_id,
       SUM(stock_quantity) OVER (PARTITION BY category_id ORDER BY product_id) AS running_stock
FROM Products;

-- 20. Window Function: Price percentage by category
SELECT product_id, product_name, price, category_id,
       price / SUM(price) OVER (PARTITION BY category_id) * 100 AS price_percentage
FROM Products;

-- Table 2: Customers
-- 1. View: Recently registered customers
CREATE VIEW RecentCustomers AS
SELECT customer_id, first_name, last_name, registration_date
FROM Customers
WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 2. View: Customers with orders
CREATE VIEW CustomersWithOrders AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 3. View: Customer contact details
CREATE VIEW CustomerContacts AS
SELECT customer_id, first_name, last_name, email, phone
FROM Customers
WHERE email IS NOT NULL;

-- 4. CTE: High-value customers
WITH HighValueCustomers AS (
    SELECT customer_id, SUM(total_price) AS total_spent
    FROM Orders
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, h.total_spent
FROM HighValueCustomers h
JOIN Customers c ON h.customer_id = c.customer_id
WHERE h.total_spent > 1000;

-- 5. CTE: Customer order frequency
WITH OrderFrequency AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, o.order_count
FROM OrderFrequency o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_count > 2;

-- 6. CTE: Latest registrations
WITH LatestRegistrations AS (
    SELECT customer_id, first_name, last_name, registration_date,
           RANK() OVER (ORDER BY registration_date DESC) AS reg_rank
    FROM Customers
)
SELECT first_name, last_name, registration_date, reg_rank
FROM LatestRegistrations
WHERE reg_rank <= 5;

-- 7. Stored Procedure: Update customer email
DELIMITER //
CREATE PROCEDURE UpdateCustomerEmail(IN cust_id INT, IN new_email VARCHAR(100))
BEGIN
    UPDATE Customers SET email = new_email WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete inactive customers
DELIMITER //
CREATE PROCEDURE DeleteInactiveCustomers()
BEGIN
    DELETE FROM Customers WHERE registration_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get customer details
DELIMITER //
CREATE PROCEDURE GetCustomerDetails(IN cust_id INT)
BEGIN
    SELECT customer_id, first_name, last_name, email, registration_date
    FROM Customers
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 10. TCL: Update customer details with rollback
START TRANSACTION;
UPDATE Customers SET email = 'new.email@email.com' WHERE customer_id = 1;
UPDATE Customers SET phone = '555-9999' WHERE customer_id = 2;
-- Simulate error
INSERT INTO Customers (customer_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Customers SET address = '123 New St' WHERE customer_id = 3;
SAVEPOINT address_updated;
UPDATE Customers SET city = 'New City' WHERE customer_id = 3;
COMMIT;

-- 12. TCL: Rollback email update
START TRANSACTION;
UPDATE Customers SET email = 'test@email.com' WHERE customer_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Customers TO 'user2'@'localhost';

-- 14. DCL: Grant insert permission
GRANT INSERT ON Customers TO 'crm_manager';

-- 15. Trigger: Log customer updates
DELIMITER //
CREATE TRIGGER LogCustomerUpdate
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'Customer Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Customer ID: ', NEW.customer_id, ' Email changed to ', NEW.email),
            'Customers', 'Profile update');
END;
// DELIMITER ;

-- 16. Trigger: Validate email
DELIMITER //
CREATE TRIGGER ValidateCustomerEmail
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log customer deletion
DELIMITER //
CREATE TRIGGER LogCustomerDeletion
AFTER DELETE ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (OLD.customer_id, 'Customer Deletion', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Customer ID: ', OLD.customer_id, ' deleted'),
            'Customers', 'Account removal');
END;
// DELIMITER ;

-- 18. Window Function: Rank customers by registration date
SELECT customer_id, first_name, last_name, registration_date,
       RANK() OVER (ORDER BY registration_date DESC) AS reg_rank
FROM Customers;

-- 19. Window Function: Running total of customers by state
SELECT customer_id, first_name, state,
       COUNT(*) OVER (PARTITION BY state ORDER BY customer_id) AS state_customer_count
FROM Customers;

-- 20. Window Function: Percentage of customers by city
SELECT customer_id, first_name, city,
       COUNT(*) OVER (PARTITION BY city) / COUNT(*) OVER () * 100 AS city_percentage
FROM Customers;

-- Table 3: Orders
-- 1. View: Delivered orders
CREATE VIEW DeliveredOrders AS
SELECT order_id, customer_id, total_price, order_date
FROM Orders
WHERE status = 'Delivered';

-- 2. View: Orders with products
CREATE VIEW OrdersWithProducts AS
SELECT o.order_id, o.customer_id, p.product_name, o.quantity
FROM Orders o
JOIN Products p ON o.product_id = p.product_id;

-- 3. View: High-value orders
CREATE VIEW HighValueOrders AS
SELECT order_id, customer_id, total_price
FROM Orders
WHERE total_price > 500;

-- 4. CTE: Total revenue by customer
WITH CustomerRevenue AS (
    SELECT customer_id, SUM(total_price) AS total_revenue
    FROM Orders
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, r.total_revenue
FROM CustomerRevenue r
JOIN Customers c ON r.customer_id = c.customer_id;

-- 5. CTE: Recent orders
WITH RecentOrders AS (
    SELECT order_id, customer_id, order_date
    FROM Orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT o.order_id, c.first_name, o.order_date
FROM RecentOrders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- 6. CTE: Ranked orders by price
WITH RankedOrders AS (
    SELECT order_id, customer_id, total_price,
           DENSE_RANK() OVER (ORDER BY total_price DESC) AS price_rank
    FROM Orders
)
SELECT order_id, customer_id, total_price, price_rank
FROM RankedOrders
WHERE price_rank <= 5;

-- 7. Stored Procedure: Cancel order
DELIMITER //
CREATE PROCEDURE CancelOrder(IN ord_id INT)
BEGIN
    UPDATE Orders SET status = 'Cancelled' WHERE order_id = ord_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get customer orders
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN cust_id INT)
BEGIN
    SELECT order_id, product_id, total_price, order_date
    FROM Orders
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Update order status
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus(IN ord_id INT, IN new_status VARCHAR(50))
BEGIN
    UPDATE Orders SET status = new_status WHERE order_id = ord_id;
END //
DELIMITER ;

-- 10. TCL: Update order with rollback
START TRANSACTION;
UPDATE Orders SET quantity = quantity + 1 WHERE order_id = 1;
UPDATE Orders SET total_price = total_price * 1.1 WHERE order_id = 1;
-- Simulate error
INSERT INTO Orders (order_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Orders SET status = 'Shipped' WHERE order_id = 2;
SAVEPOINT status_updated;
UPDATE Orders SET tracking_number = 'TRK999999' WHERE order_id = 2;
COMMIT;

-- 12. TCL: Rollback order update
START TRANSACTION;
UPDATE Orders SET quantity = 5 WHERE order_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Orders TO 'user3'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Orders TO 'order_manager';

-- 15. Trigger: Log order status changes
DELIMITER //
CREATE TRIGGER LogOrderStatusChange
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Order Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Order ID: ', NEW.order_id, ' Status changed to ', NEW.status),
                'Orders', 'Status update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate quantity
DELIMITER //
CREATE TRIGGER ValidateOrderQuantity
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Update stock on order
DELIMITER //
CREATE TRIGGER UpdateStockOnOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    UPDATE Products SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END;
// DELIMITER ;

-- 18. Window Function: Rank orders by total price
SELECT order_id, customer_id, total_price,
       RANK() OVER (PARTITION BY customer_id ORDER BY total_price DESC) AS price_rank
FROM Orders;

-- 19. Window Function: Running total by customer
SELECT order_id, customer_id, total_price,
       SUM(total_price) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM Orders;

-- 20. Window Function: Order percentage by customer
SELECT order_id, customer_id, total_price,
       total_price / SUM(total_price) OVER (PARTITION BY customer_id) * 100 AS order_percentage
FROM Orders;

-- Table 4: Suppliers
-- 1. View: Active suppliers
CREATE VIEW ActiveSuppliers AS
SELECT supplier_id, supplier_name, contact_email
FROM Suppliers
WHERE contract_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 2. View: Suppliers with products
CREATE VIEW SuppliersWithProducts AS
SELECT s.supplier_id, s.supplier_name, COUNT(p.product_id) AS product_count
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id;

-- 3. View: Supplier contact details
CREATE VIEW SupplierContacts AS
SELECT supplier_id, supplier_name, contact_name, contact_phone
FROM Suppliers;

-- 4. CTE: Suppliers by product count
WITH SupplierProductCount AS (
    SELECT supplier_id, COUNT(*) AS product_count
    FROM Products
    GROUP BY supplier_id
)
SELECT s.supplier_name, sp.product_count
FROM SupplierProductCount sp
JOIN Suppliers s ON sp.supplier_id = s.supplier_id;

-- 5. CTE: Recent suppliers
WITH RecentSuppliers AS (
    SELECT supplier_id, supplier_name, contract_date
    FROM Suppliers
    WHERE contract_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
)
SELECT supplier_name, contract_date
FROM RecentSuppliers
ORDER BY contract_date DESC;

-- 6. CTE: Ranked suppliers by products
WITH RankedSuppliers AS (
    SELECT supplier_id, supplier_name,
           COUNT(*) OVER (PARTITION BY supplier_id) AS product_count,
           RANK() OVER (ORDER BY COUNT(*) DESC) AS supplier_rank
    FROM Products
    GROUP BY supplier_id, supplier_name
)
SELECT supplier_name, product_count, supplier_rank
FROM RankedSuppliers
WHERE supplier_rank <= 5;

-- 7. Stored Procedure: Update supplier contact
DELIMITER //
CREATE PROCEDURE UpdateSupplierContact(IN supp_id INT, IN new_email VARCHAR(100))
BEGIN
    UPDATE Suppliers SET contact_email = new_email WHERE supplier_id = supp_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get supplier products
DELIMITER //
CREATE PROCEDURE GetSupplierProducts(IN supp_id INT)
BEGIN
    SELECT p.product_id, p.product_name
    FROM Products p
    WHERE p.supplier_id = supp_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add new supplier
DELIMITER //
CREATE PROCEDURE AddSupplier(IN name VARCHAR(100), IN email VARCHAR(100))
BEGIN
    INSERT INTO Suppliers (supplier_id, supplier_name, contact_email)
    VALUES ((SELECT MAX(supplier_id) + 1 FROM Suppliers), name, email);
END //
DELIMITER ;

-- 10. TCL: Update supplier with rollback
START TRANSACTION;
UPDATE Suppliers SET contact_phone = '555-8888' WHERE supplier_id = 101;
UPDATE Suppliers SET address = '456 New St' WHERE supplier_id = 101;
-- Simulate error
INSERT INTO Suppliers (supplier_id) VALUES (101);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit supplier update
START TRANSACTION;
UPDATE Suppliers SET contact_name = 'New Contact' WHERE supplier_id = 102;
SAVEPOINT contact_updated;
UPDATE Suppliers SET city = 'New City' WHERE supplier_id = 102;
COMMIT;

-- 12. TCL: Rollback supplier update
START TRANSACTION;
UPDATE Suppliers SET contact_email = 'new@email.com' WHERE supplier_id = 103;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Suppliers TO 'user4'@'localhost';

-- 14. DCL: Grant insert permission
GRANT INSERT ON Suppliers TO 'procurement_manager';

-- 15. Trigger: Log supplier updates
DELIMITER //
CREATE TRIGGER LogSupplierUpdate
AFTER UPDATE ON Suppliers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Supplier Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Supplier ID: ', NEW.supplier_id, ' Email changed to ', NEW.contact_email),
            'Suppliers', 'Contact update');
END;
// DELIMITER ;

-- 16. Trigger: Validate supplier email
DELIMITER //
CREATE TRIGGER ValidateSupplierEmail
BEFORE INSERT ON Suppliers
FOR EACH ROW
BEGIN
    IF NEW.contact_email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log supplier deletion
DELIMITER //
CREATE TRIGGER LogSupplierDeletion
AFTER DELETE ON Suppliers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Supplier Deletion', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Supplier ID: ', OLD.supplier_id, ' deleted'),
            'Suppliers', 'Supplier removal');
END;
// DELIMITER ;

-- 18. Window Function: Rank suppliers by contract date
SELECT supplier_id, supplier_name, contract_date,
       RANK() OVER (ORDER BY contract_date DESC) AS contract_rank
FROM Suppliers;

-- 19. Window Function: Running total of suppliers by state
SELECT supplier_id, supplier_name, state,
       COUNT(*) OVER (PARTITION BY state ORDER BY supplier_id) AS state_supplier_count
FROM Suppliers;

-- 20. Window Function: Supplier percentage by city
SELECT supplier_id, supplier_name, city,
       COUNT(*) OVER (PARTITION BY city) / COUNT(*) OVER () * 100 AS city_percentage
FROM Suppliers;

-- Table 5: Categories
-- 1. View: Active categories
CREATE VIEW ActiveCategories AS
SELECT category_id, category_name, description
FROM Categories
WHERE is_active = TRUE;

-- 2. View: Categories with products
CREATE VIEW CategoriesWithProducts AS
SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_id;

-- 3. View: Parent categories
CREATE VIEW ParentCategories AS
SELECT category_id, category_name
FROM Categories
WHERE parent_category_id IS NULL;

-- 4. CTE: Category product count
WITH CategoryProductCount AS (
    SELECT category_id, COUNT(*) AS product_count
    FROM Products
    GROUP BY category_id
)
SELECT c.category_name, cp.product_count
FROM CategoryProductCount cp
JOIN Categories c ON cp.category_id = c.category_id;

-- 5. CTE: Recent categories
WITH RecentCategories AS (
    SELECT category_id, category_name, created_date
    FROM Categories
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
)
SELECT category_name, created_date
FROM RecentCategories
ORDER BY created_date DESC;

-- 6. CTE: Ranked categories by products
WITH RankedCategories AS (
    SELECT c.category_id, c.category_name,
           COUNT(p.product_id) AS product_count,
           RANK() OVER (ORDER BY COUNT(p.product_id) DESC) AS cat_rank
    FROM Categories c
    LEFT JOIN Products p ON c.category_id = p.category_id
    GROUP BY c.category_id
)
SELECT category_name, product_count, cat_rank
FROM RankedCategories
WHERE cat_rank <= 5;

-- 7. Stored Procedure: Update category description
DELIMITER //
CREATE PROCEDURE UpdateCategoryDescription(IN cat_id INT, IN new_desc TEXT)
BEGIN
    UPDATE Categories SET description = new_desc WHERE category_id = cat_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate category
DELIMITER //
CREATE PROCEDURE DeactivateCategory(IN cat_id INT)
BEGIN
    UPDATE Categories SET is_active = FALSE WHERE category_id = cat_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get subcategories
DELIMITER //
CREATE PROCEDURE GetSubcategories(IN parent_id INT)
BEGIN
    SELECT category_id, category_name
    FROM Categories
    WHERE parent_category_id = parent_id;
END //
DELIMITER ;

-- 10. TCL: Update category with rollback
START TRANSACTION;
UPDATE Categories SET category_name = 'New Electronics' WHERE category_id = 1;
UPDATE Categories SET display_order = 10 WHERE category_id = 1;
-- Simulate error
INSERT INTO Categories (category_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit category update
START TRANSACTION;
UPDATE Categories SET is_active = TRUE WHERE category_id = 2;
SAVEPOINT status_updated;
UPDATE Categories SET meta_title = 'Updated Title' WHERE category_id = 2;
COMMIT;

-- 12. TCL: Rollback category update
START TRANSACTION;
UPDATE Categories SET description = 'Updated description' WHERE category_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Categories TO 'user5'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Categories TO 'catalog_manager';

-- 15. Trigger: Log category updates
DELIMITER //
CREATE TRIGGER LogCategoryUpdate
AFTER UPDATE ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Category Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Category ID: ', NEW.category_id, ' Name changed to ', NEW.category_name),
            'Categories', 'Category update');
END;
// DELIMITER ;

-- 16. Trigger: Validate display order
DELIMITER //
CREATE TRIGGER ValidateDisplayOrder
BEFORE INSERT ON Categories
FOR EACH ROW
BEGIN
    IF NEW.display_order < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Display order cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log category deletion
DELIMITER //
CREATE TRIGGER LogCategoryDeletion
AFTER DELETE ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Category Deletion', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Category ID: ', OLD.category_id, ' deleted'),
            'Categories', 'Category removal');
END;
// DELIMITER ;

-- 18. Window Function: Rank categories by creation date
SELECT category_id, category_name, created_date,
       RANK() OVER (ORDER BY created_date DESC) AS create_rank
FROM Categories;

-- 19. Window Function: Running total of categories by parent
SELECT category_id, category_name, parent_category_id,
       COUNT(*) OVER (PARTITION BY parent_category_id ORDER BY category_id) AS subcat_count
FROM Categories;

-- 20. Window Function: Category percentage
SELECT category_id, category_name,
       COUNT(*) OVER (PARTITION BY parent_category_id) / COUNT(*) OVER () * 100 AS cat_percentage
FROM Categories;

-- Table 6: Reviews
-- 1. View: Verified reviews
CREATE VIEW VerifiedReviews AS
SELECT review_id, product_id, rating, comment
FROM Reviews
WHERE is_verified = TRUE;

-- 2. View: Reviews with products
CREATE VIEW ReviewsWithProducts AS
SELECT r.review_id, r.rating, p.product_name
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id;

-- 3. View: High-rated reviews
CREATE VIEW HighRatedReviews AS
SELECT review_id, product_id, rating
FROM Reviews
WHERE rating >= 4;

-- 4. CTE: Average rating by product
WITH ProductAvgRating AS (
    SELECT product_id, AVG(rating) AS avg_rating
    FROM Reviews
    GROUP BY product_id
)
SELECT p.product_name, pa.avg_rating
FROM ProductAvgRating pa
JOIN Products p ON pa.product_id = p.product_id;

-- 5. CTE: Recent reviews
WITH RecentReviews AS (
    SELECT review_id, product_id, review_date
    FROM Reviews
    WHERE review_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT r.review_id, p.product_name, r.review_date
FROM RecentReviews r
JOIN Products p ON r.product_id = p.product_id;

-- 6. CTE: Ranked reviews by helpfulness
WITH RankedReviews AS (
    SELECT review_id, product_id, helpful_votes,
           RANK() OVER (PARTITION BY product_id ORDER BY helpful_votes DESC) AS help_rank
    FROM Reviews
)
SELECT review_id, product_id, helpful_votes, help_rank
FROM RankedReviews
WHERE help_rank <= 5;

-- 7. Stored Procedure: Approve review
DELIMITER //
CREATE PROCEDURE ApproveReview(IN rev_id INT)
BEGIN
    UPDATE Reviews SET status = 'Approved' WHERE review_id = rev_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get product reviews
DELIMITER //
CREATE PROCEDURE GetProductReviews(IN prod_id INT)
BEGIN
    SELECT review_id, rating, comment
    FROM Reviews
    WHERE product_id = prod_id AND status = 'Approved';
END //
DELIMITER ;

-- 9. Stored Procedure: Update review rating
DELIMITER //
CREATE PROCEDURE UpdateReviewRating(IN rev_id INT, IN new_rating INT)
BEGIN
    UPDATE Reviews SET rating = new_rating WHERE review_id = rev_id;
END //
DELIMITER ;

-- 10. TCL: Update review with rollback
START TRANSACTION;
UPDATE Reviews SET rating = 5 WHERE review_id = 1;
UPDATE Reviews SET comment = 'Updated comment' WHERE review_id = 1;
-- Simulate error
INSERT INTO Reviews (review_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit review status
START TRANSACTION;
UPDATE Reviews SET status = 'Approved' WHERE review_id = 2;
SAVEPOINT status_updated;
UPDATE Reviews SET helpful_votes = helpful_votes + 1 WHERE review_id = 2;
COMMIT;

-- 12. TCL: Rollback review update
START TRANSACTION;
UPDATE Reviews SET comment = 'New comment' WHERE review_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Reviews TO 'user6'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Reviews TO 'review_moderator';

-- 15. Trigger: Log review updates
DELIMITER //
CREATE TRIGGER LogReviewUpdate
AFTER UPDATE ON Reviews
FOR EACH ROW
BEGIN
    IF OLD.rating != NEW.rating THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Review Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Review ID: ', NEW.review_id, ' Rating changed to ', NEW.rating),
                'Reviews', 'Rating update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate rating
DELIMITER //
CREATE TRIGGER ValidateReviewRating
BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Update product rating
DELIMITER //
CREATE TRIGGER UpdateProductRating
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    UPDATE Products SET rating = (
        SELECT AVG(rating) FROM Reviews WHERE product_id = NEW.product_id
    ) WHERE product_id = NEW.product_id;
END;
// DELIMITER ;

-- 18. Window Function: Rank reviews by rating
SELECT review_id, product_id, rating,
       RANK() OVER (PARTITION BY product_id ORDER BY rating DESC) AS rating_rank
FROM Reviews;

-- 19. Window Function: Running total of helpful votes
SELECT review_id, product_id, helpful_votes,
       SUM(helpful_votes) OVER (PARTITION BY product_id ORDER BY review_id) AS running_votes
FROM Reviews;

-- 20. Window Function: Review percentage by product
SELECT review_id, product_id, rating,
       COUNT(*) OVER (PARTITION BY product_id) / COUNT(*) OVER () * 100 AS review_percentage
FROM Reviews;

-- Table 7: Payments
-- 1. View: Completed payments
CREATE VIEW CompletedPayments AS
SELECT payment_id, order_id, amount, payment_date
FROM Payments
WHERE status = 'Completed';

-- 2. View: Payments with orders
CREATE VIEW PaymentsWithOrders AS
SELECT p.payment_id, p.amount, o.order_id, o.customer_id
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id;

-- 3. View: High-amount payments
CREATE VIEW HighAmountPayments AS
SELECT payment_id, order_id, amount
FROM Payments
WHERE amount > 500;

-- 4. CTE: Total payments by customer
WITH CustomerPayments AS (
    SELECT customer_id, SUM(amount) AS total_paid
    FROM Payments
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cp.total_paid
FROM CustomerPayments cp
JOIN Customers c ON cp.customer_id = c.customer_id;

-- 5. CTE: Recent payments
WITH RecentPayments AS (
    SELECT payment_id, order_id, payment_date
    FROM Payments
    WHERE payment_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT p.payment_id, o.order_id, p.payment_date
FROM RecentPayments p
JOIN Orders o ON p.order_id = o.order_id;

-- 6. CTE: Ranked payments by amount
WITH RankedPayments AS (
    SELECT payment_id, customer_id, amount,
           RANK() OVER (ORDER BY amount DESC) AS amount_rank
    FROM Payments
)
SELECT payment_id, customer_id, amount, amount_rank
FROM RankedPayments
WHERE amount_rank <= 5;

-- 7. Stored Procedure: Refund payment
DELIMITER //
CREATE PROCEDURE RefundPayment(IN pay_id INT)
BEGIN
    UPDATE Payments SET status = 'Refunded' WHERE payment_id = pay_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get customer payments
DELIMITER //
CREATE PROCEDURE GetCustomerPayments(IN cust_id INT)
BEGIN
    SELECT payment_id, order_id, amount, payment_date
    FROM Payments
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Update payment status
DELIMITER //
CREATE PROCEDURE UpdatePaymentStatus(IN pay_id INT, IN new_status VARCHAR(50))
BEGIN
    UPDATE Payments SET status = new_status WHERE payment_id = pay_id;
END //
DELIMITER ;

-- 10. TCL: Update payment with rollback
START TRANSACTION;
UPDATE Payments SET amount = 1000 WHERE payment_id = 1;
UPDATE Payments SET status = 'Completed' WHERE payment_id = 1;
-- Simulate error
INSERT INTO Payments (payment_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit payment update
START TRANSACTION;
UPDATE Payments SET payment_method = 'Credit Card' WHERE payment_id = 2;
SAVEPOINT method_updated;
UPDATE Payments SET transaction_id = 'TXN999999' WHERE payment_id = 2;
COMMIT;

-- 12. TCL: Rollback payment update
START TRANSACTION;
UPDATE Payments SET amount = 500 WHERE payment_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Payments TO 'user7'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Payments TO 'finance_manager';

-- 15. Trigger: Log payment updates
DELIMITER //
CREATE TRIGGER LogPaymentUpdate
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Payment Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Payment ID: ', NEW.payment_id, ' Status changed to ', NEW.status),
                'Payments', 'Status update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate payment amount
DELIMITER //
CREATE TRIGGER ValidatePaymentAmount
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log payment insertion
DELIMITER //
CREATE TRIGGER LogPaymentInsertion
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'Payment Insert', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Payment ID: ', NEW.payment_id, ' Amount: ', NEW.amount),
            'Payments', 'New payment');
END;
// DELIMITER ;

-- 18. Window Function: Rank payments by amount
SELECT payment_id, customer_id, amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS amount_rank
FROM Payments;

-- 19. Window Function: Running total of payments
SELECT payment_id, customer_id, amount,
       SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS running_total
FROM Payments;

-- 20. Window Function: Payment percentage by customer
SELECT payment_id, customer_id, amount,
       amount / SUM(amount) OVER (PARTITION BY customer_id) * 100 AS payment_percentage
FROM Payments;

-- Table 8: Shipments
-- 1. View: In-transit shipments
CREATE VIEW InTransitShipments AS
SELECT shipment_id, order_id, shipping_date, carrier
FROM Shipments
WHERE status = 'In Transit';

-- 2. View: Shipments with orders
CREATE VIEW ShipmentsWithOrders AS
SELECT s.shipment_id, s.order_id, o.customer_id
FROM Shipments s
JOIN Orders o ON s.order_id = o.order_id;

-- 3. View: Expensive shipments
CREATE VIEW ExpensiveShipments AS
SELECT shipment_id, order_id, shipping_cost
FROM Shipments
WHERE shipping_cost > 12;

-- 4. CTE: Total shipping cost by carrier
WITH CarrierCosts AS (
    SELECT carrier, SUM(shipping_cost) AS total_cost
    FROM Shipments
    GROUP BY carrier
)
SELECT carrier, total_cost
FROM CarrierCosts
ORDER BY total_cost DESC;

-- 5. CTE: Recent shipments
WITH RecentShipments AS (
    SELECT shipment_id, order_id, shipping_date
    FROM Shipments sh
    WHERE shipping_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT s.shipment_id, o.order_id, s.shipping_date
FROM RecentShipments s
JOIN Orders o ON s.order_id = o.order_id;

-- 6. CTE: Ranked shipments by cost
WITH RankedShipments AS (
    SELECT shipment_idähän, order_id, shipping_cost,
           RANK() OVER (ORDER BY shipping_cost DESC) AS cost_rank
    FROM Shipments
)
SELECT shipment_id, order_id, shipping_cost, cost_rank
FROM RankedShipments
WHERE cost_rank <= 5;

-- 7. Stored Procedure: Update shipment status
DELIMITER //
CREATE PROCEDURE UpdateShipmentStatus(IN ship_id INT, IN new_status VARCHAR(50))
BEGIN
    UPDATE Shipments SET status = new_status WHERE shipment_id = ship_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get order shipments
DELIMITER //
CREATE PROCEDURE GetOrderShipments(IN ord_id INT)
BEGIN
    SELECT shipment_id, carrier, shipping_date
    FROM Shipments
    WHERE order_id = ord_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add shipment
DELIMITER //
CREATE PROCEDURE AddShipment(IN ord_id INT, IN carrier VARCHAR(50), IN cost DECIMAL(10,2))
BEGIN
    INSERT INTO Shipments (shipment_id, order_id, carrier, shipping_cost, shipping_date)
    VALUES ((SELECT MAX(shipment_id) + 1 FROM Shipments), ord_id, carrier, cost, CURDATE());
END //
DELIMITER ;

-- 10. TCL: Update shipment with rollback
START TRANSACTION;
UPDATE Shipments SET status = 'Delivered' WHERE shipment_id = 1;
UPDATE Shipments sh SET tracking_number = 'TRK999999' WHERE shipment_id = 1;
-- Simulate error
INSERT INTO Shipments (shipment_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit shipment update
START TRANSACTION;
UPDATE Shipments SET carrier = 'FedEx' WHERE shipment_id = 2;
SAVEPOINT carrier_updated;
UPDATE Shipments SET estimated_delivery_date = DATE_ADD(CURDATE(), INTERVAL 5 DAY) WHERE shipment_id = 2;
COMMIT;

-- 12. TCL: Rollback shipment update
START TRANSACTION;
UPDATE Shipments SET shipping_cost = 15.99 WHERE shipment_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Shipments TO 'user8'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Shipments TO 'logistics_manager';

-- 15. Trigger: Log shipment updates
DELIMITER //
CREATE TRIGGER LogShipmentUpdate
AFTER UPDATE ON Shipments
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Shipment Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Shipment ID: ', NEW.shipment_id, ' Status changed to ', NEW.status),
                'Shipments', 'Status update');
                  END IF ;
                  END ;
// DELIMITER ;

-- 16. Trigger: Validate shipping cost
DELIMITER //
CREATE TRIGGER ValidateShippingCost
BEFORE INSERT ON Shipments
FOR EACH ROW
BEGIN
    IF NEW.shipping_cost < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shipping cost cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log shipment insertion
DELIMITER //
CREATE TRIGGER LogShipmentInsertion
AFTER INSERT ON Shipments
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Shipment Insert', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Shipment ID: ', NEW.shipment_id, ' for Order ID: ', NEW.order_id),
            'Shipments', 'New shipment');
END;
// DELIMITER ;

-- 18. Window Function: Rank shipments by cost
SELECT shipment_id, order_id, shipping_cost,
       RANK() OVER (PARTITION BY carrier ORDER BY shipping_cost DESC) AS cost_rank
FROM Shipments;

-- 19. Window Function: Running total of shipping costs
SELECT shipment_id, order_id, shipping_cost,
       SUM(shipping_cost) OVER (PARTITION BY carrier ORDER BY shipping_date) AS running_cost
FROM Shipments;

-- 20. Window Function: Shipment percentage by carrier
SELECT shipment_id, carrier, shipping_cost,
       shipping_cost / SUM(shipping_cost) OVER (PARTITION BY carrier) * 100 AS cost_percentage
FROM Shipments;

-- Table 9: Warehouses
-- 1. View: Active warehouses
CREATE VIEW ActiveWarehouses AS
SELECT warehouse_id, warehouse_name, city
FROM Warehouses
WHERE operational_since <= CURDATE();

-- 2. View: Warehouses with inventory
CREATE VIEW WarehousesWithInventory AS
SELECT w.warehouse_id, w.warehouse_name, COUNT(i.inventory_id) AS item_count
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id;

-- 3. View: Warehouse managers
CREATE VIEW WarehouseManagers AS
SELECT warehouse_id, warehouse_name, manager_name, contact_phone
FROM Warehouses;

-- 4. CTE: Warehouse inventory count
WITH WarehouseInventory AS (
    SELECT warehouse_id, COUNT(*) AS inventory_count
    FROM Inventory
    GROUP BY warehouse_id
)
SELECT w.warehouse_name, wi.inventory_count
FROM WarehouseInventory wi
JOIN Warehouses w ON wi.warehouse_id = w.warehouse_id;

-- 5. CTE: Large warehouses
WITH LargeWarehouses AS (
    SELECT warehouse_id, warehouse_name, capacity
    FROM Warehouses
    WHERE capacity > 8000
)
SELECT warehouse_name, capacity
FROM LargeWarehouses
ORDER BY capacity DESC;

-- 6. CTE: Ranked warehouses by capacity
WITH RankedWarehouses AS (
    SELECT warehouse_id, warehouse_name, capacity,
           RANK() OVER (ORDER BY capacity DESC) AS capacity_rank
    FROM Warehouses
)
SELECT warehouse_name, capacity, capacity_rank
FROM RankedWarehouses
WHERE capacity_rank <= 5;

-- 7. Stored Procedure: Update warehouse manager
DELIMITER //
CREATE PROCEDURE UpdateWarehouseManager(IN w_id INT, IN new_manager VARCHAR(50))
BEGIN
    UPDATE Warehouses SET manager_name = new_manager WHERE warehouse_id = w_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get warehouse inventory
DELIMITER //
CREATE PROCEDURE GetWarehouseInventory(IN w_id INT)
BEGIN
    SELECT i.inventory_id, p.product_name, i.quantity
    FROM Inventory i
    JOIN Products p ON i.product_id = p.product_id
    WHERE i.warehouse_id = w_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add warehouse
DELIMITER //
CREATE PROCEDURE AddWarehouse(IN name VARCHAR(100), IN cap INT)
BEGIN
    INSERT INTO Warehouses (warehouse_id, warehouse_name, capacity, operational_date)
    VALUES ((SELECT MAX(warehouse_id) + 1 FROM Warehouses), name, cap, CURRENT_DATE);
END //
DELIMITER ;

-- 10. TCL: Update warehouse with rollback
START TRANSACTION;
UPDATE Warehouses SET contact_phone = '555-7777' WHERE warehouse_id = 1;
UPDATE Warehouses SET address = '123 New Ware St' WHERE warehouse_id = 1;
-- Simulate error
INSERT INTO Warehouses (warehouse_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit warehouse update
START TRANSACTION;
UPDATE Warehouses SET manager_name = 'New Manager' WHERE warehouse_id = 2;
SAVEPOINT manager_updated;
UPDATE Warehouses SET city = 'New City' WHERE warehouse_id = 2;
COMMIT;

-- 12. TCL: Rollback warehouse update
START TRANSACTION;
UPDATE Warehouses SET capacity = 9000 WHERE warehouse_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Warehouses TO 'user9'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Warehouses TO 'warehouse_admin';

-- 15. Trigger: Log warehouse updates
DELIMITER //
CREATE TRIGGER LogWarehouseUpdate
AFTER UPDATE ON Warehouses
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Warehouse Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Warehouse ID: ', NEW.warehouse_id, ' Manager changed to ', NEW.manager_name),
            'Warehouses', 'Manager update');
END;
// DELIMITER ;

-- 16. Trigger: Validate warehouse capacity
DELIMITER //
CREATE TRIGGER ValidateWarehouseCapacity
BEFORE INSERT ON Warehouses
FOR EACH ROW
BEGIN
    IF NEW.capacity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Capacity must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log warehouse deletion
DELIMITER //
CREATE TRIGGER LogWarehouseDeletion
AFTER DELETE ON Warehouses
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Warehouse Deletion', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Warehouse ID: ', OLD.warehouse_id, ' deleted'),
            'Warehouses', 'Warehouse removal');
END;
// DELIMITER ;

-- 18. Window Function: Rank warehouses by capacity
SELECT warehouse_id, warehouse_name, capacity,
       RANK() OVER (ORDER BY capacity DESC) AS capacity_rank
FROM Warehouses;

-- 19. Window Function: Running total of warehouses by state
SELECT warehouse_id, warehouse_name, state,
       COUNT(*) OVER (PARTITION BY state ORDER BY warehouse_id) AS state_warehouse_count
FROM Warehouses;

-- 20. Window Function: Warehouse percentage by city
SELECT warehouse_id, warehouse_name, city,
       COUNT(*) OVER (PARTITION BY city) / COUNT(*) OVER () * 100 AS city_percentage
FROM Warehouses;

-- Table 10: Inventory
-- 1. View: Low stock inventory
CREATE VIEW LowStockInventory AS
SELECT inventory_id, product_id, warehouse_id, quantity
FROM Inventory
WHERE quantity < min_stock_level;

-- 2. View: Inventory with products
CREATE VIEW InventoryWithProducts AS
SELECT i.inventory_id, p.product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;

-- 3. View: Active inventory
CREATE VIEW ActiveInventory AS
SELECT inventory_id, product_id, warehouse_id, quantity
FROM Inventory
WHERE status = 'In Stock';

-- 4. CTE: Total inventory by warehouse
WITH WarehouseInventory AS (
    SELECT warehouse_id, SUM(quantity) AS total_quantity
    FROM Inventory
    GROUP BY warehouse_id
)
SELECT w.warehouse_name, wi.total_quantity
FROM WarehouseInventory wi
JOIN Warehouses w ON wi.warehouse_id = w.warehouse_id;

-- 5. CTE: Low stock items
WITH LowStockItems AS (
    SELECT inventory_id, product_id, quantity, min_stock_level
    FROM Inventory
    WHERE quantity < min_stock_level
)
SELECT i.inventory_id, p.product_name, i.quantity
FROM LowStockItems i
JOIN Products p ON i.product_id = p.product_id;

-- 6. CTE: Ranked inventory by quantity
WITH RankedInventory AS (
    SELECT inventory_id, product_id, quantity,
           RANK() OVER (PARTITION BY warehouse_id ORDER BY quantity DESC) AS qty_rank
    FROM Inventory
)
SELECT inventory_id, product_id, quantity, qty_rank
FROM RankedInventory
WHERE qty_rank <= 5;

-- 7. Stored Procedure: Update inventory quantity
DELIMITER //
CREATE PROCEDURE UpdateInventoryQuantity(IN inv_id INT, IN new_qty INT)
BEGIN
    UPDATE Inventory SET quantity = new_qty WHERE inventory_id = inv_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Reorder inventory
DELIMITER //
CREATE PROCEDURE ReorderInventory(IN inv_id INT)
BEGIN
    UPDATE Inventory SET quantity = quantity + reorder_quantity
    WHERE inventory_id = inv_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get inventory by product
DELIMITER //
CREATE PROCEDURE GetInventoryByProduct(IN prod_id INT)
BEGIN
    SELECT inventory_id, warehouse_id, quantity
    FROM Inventory
    WHERE product_id = prod_id;
END //
DELIMITER ;

-- 10. TCL: Update inventory with rollback
START TRANSACTION;
UPDATE Inventory SET quantity = quantity - 10 WHERE inventory_id = 1;
UPDATE Inventory SET status = 'Low Stock' WHERE inventory_id = 1;
-- Simulate error
INSERT INTO Inventory (inventory_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit inventory update
START TRANSACTION;
UPDATE Inventory SET quantity = quantity + 50 WHERE inventory_id = 2;
SAVEPOINT qty_updated;
UPDATE Inventory SET last_updated = CURRENT_DATE WHERE inventory_id = 2;
COMMIT;

-- 12. TCL: Rollback inventory update
START TRANSACTION;
UPDATE Inventory SET quantity = 100 WHERE inventory_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Inventory TO 'user10'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Inventory TO 'inventory_manager';

-- 15. Trigger: Log inventory updates
DELIMITER //
CREATE TRIGGER LogInventoryUpdate
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Inventory Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Inventory ID: ', NEW.inventory_id, ' Quantity changed to ', NEW.quantity),
                'Inventory', 'Stock update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate inventory quantity
DELIMITER //
CREATE TRIGGER ValidateInventoryQuantity
BEFORE INSERT ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Update inventory status
DELIMITER //
CREATE TRIGGER UpdateInventoryStatus
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity < NEW.min_stock_level THEN
        UPDATE Inventory SET new_status = 'Low Stock' WHERE inventory_id = NEW.inventory_id;
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank inventory by quantity
SELECT inventory_id, product_id, quantity,
       RANK() OVER (PARTITION BY warehouse_id ORDER BY quantity DESC) AS qty_rank
FROM Inventory;

-- 19. Window Function: Running total of inventory
SELECT inventory_id, product_id, quantity,
       SUM(quantity) OVER (PARTITION BY warehouse_id ORDER BY inventory_id) AS running_qty
FROM Inventory;

-- 20. Window Function: Inventory percentage by warehouse
SELECT inventory_id, product_id, quantity,
       quantity / SUM(quantity) OVER (PARTITION BY warehouse_id) * 100 AS qty_percentage
FROM Inventory;

-- Table 11: Promotions
-- 1. View: Active promotions
CREATE VIEW ActivePromotions AS
SELECT promotion_id, promotion_name, discount_percentage
FROM Promotions
WHERE is_active = TRUE;

-- 2. View: Promotions with products
CREATE VIEW PromotionsWithProducts AS
SELECT pr.promotion_id, pr.promotion_name, p.product_name
FROM Promotions pr
JOIN Products p ON pr.product_id = p.product_id;

-- 3. View: High discount promotions
CREATE VIEW HighDiscountPromotions AS
SELECT promotion_id, promotion_name, discount_percentage
FROM Promotions
WHERE discount_percentage >= 20;

-- 4. CTE: Total promotions by product
WITH ProductPromotions AS (
    SELECT product_id, COUNT(*) AS prom_count
    FROM Promotions
    GROUP BY product_id
)
SELECT p.product_name, pp.prom_count
FROM ProductPromotions pp
JOIN Products p ON pp.product_id = p.product_id;

-- 5. CTE: Recent promotions
WITH RecentPromotions AS (
    SELECT promotion_id, promotion_name, start_date
    FROM Promotions
    WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT promotion_name, start_date
FROM RecentPromotions;

-- 6. CTE: Ranked promotions by discount
WITH RankedPromotions AS (
    SELECT promotion_id, product_id, discount_percentage,
           RANK() OVER (PARTITION BY product_id ORDER BY discount_percentage DESC) AS disc_rank
    FROM Promotions
)
SELECT promotion_id, product_id, discount_percentage, disc_rank
FROM RankedPromotions
WHERE disc_rank <= 5;

-- 7. Stored Procedure: Activate promotion
DELIMITER //
CREATE PROCEDURE ActivatePromotion(IN prom_id INT)
BEGIN
    UPDATE Promotions SET is_active = TRUE WHERE promotion_id = prom_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get product promotions
DELIMITER //
CREATE PROCEDURE GetProductPromotions(IN prod_id INT)
BEGIN
    SELECT promotion_id, promotion_name, discount_percentage
    FROM Promotions
    WHERE product_id = prod_id AND is_active = TRUE;
END //
DELIMITER ;

-- 9. Stored Procedure: End promotion
DELIMITER //
CREATE PROCEDURE EndPromotion(IN prom_id INT)
BEGIN
    UPDATE Promotions SET is_active = FALSE, end_date = CURDATE()
    WHERE promotion_id = prom_id;
END //
DELIMITER ;

-- 10. TCL: Update promotion with rollback
START TRANSACTION;
UPDATE Promotions SET discount_percentage = 25.00 WHERE promotion_id = 1;
UPDATE Promotions SET is_active = TRUE WHERE promotion_id = 1;
-- Simulate error
INSERT INTO Promotions (promotion_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit promotion update
START TRANSACTION;
UPDATE Promotions SET start_date = CURDATE() WHERE promotion_id = 2;
SAVEPOINT date_updated;
UPDATE Promotions SET max_uses = 200 WHERE promotion_id = 2;
COMMIT;

-- 12. TCL: Rollback promotion update
START TRANSACTION;
UPDATE Promotions SET discount_percentage = 30.00 WHERE promotion_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Promotions TO 'user11'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Promotions TO 'marketing_manager';

-- 15. Trigger: Log promotion updates
DELIMITER //
CREATE TRIGGER LogPromotionUpdate
AFTER UPDATE ON Promotions
FOR EACH ROW
BEGIN
    IF OLD.discount_percentage != NEW.discount_percentage THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Promotion Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Promotion ID: ', NEW.promotion_id, ' Discount changed to %', NEW.discount_percentage),
                'Promotions', 'Discount update');
                END IF ;
END;
// DELIMITER ;

-- 16. Trigger: Validate discount percentage
DELIMITER //
CREATE TRIGGER ValidateDiscountPercentage
BEFORE INSERT ON Promotions
FOR EACH ROW
BEGIN
    IF NEW.discount_percentage < 0 OR NEW.discount_percentage > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Discount percentage must be between 0 and 100';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log promotion end
DELIMITER //
CREATE TRIGGER LogPromotionEnd
AFTER UPDATE ON Promotions
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Promotion Ended', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Promotion ID: ', NEW.promotion_id, ' ended'),
                'Promotions', 'Promotion deactivation');
END IF ;
END;

// DELIMITER ;

-- 18. Window Function: Rank promotions by discount
SELECT promotion_id, product_id, discount_percentage,
       RANK() OVER (PARTITION BY product_id ORDER BY discount_percentage DESC) AS disc_rank
FROM Promotions;

-- 19. Window Function: Running total of promotions
SELECT promotion_id, product_id, discount_percentage,
       COUNT(*) OVER (PARTITION BY product_id ORDER BY start_date) AS running_prom_count
FROM Promotions;

-- 20. Window Function: Promotion percentage by product
SELECT promotion_id, product_id, discount_percentage,
       COUNT(*) OVER (PARTITION BY product_id) / COUNT(*) OVER () * 100 AS prom_percentage
FROM Promotions;

-- Table 12: Returns
-- 1. View: Approved returns
CREATE VIEW ApprovedReturns AS
SELECT return_id, order_id, refund_amount
FROM Returns
WHERE status = 'Approved';

-- 2. View: Returns with products
CREATE VIEW ReturnsWithProducts AS
SELECT r.return_id, p.product_name, r.refunded_amount
FROM Returns r
JOIN Products p ON r.product_id = p.product_id;

-- 3. View: Recent returns
CREATE VIEW RecentReturns AS
SELECT return_id, order_id, return_date
FROM Returns
WHERE return_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 4. CTE: Total refunds by customer
WITH CustomerRefunds AS (
    SELECT customer_id, SUM(refunded_amount) AS total_refunded
    FROM Returns
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cr.total_refunded
FROM CustomerRefunds cr
JOIN Customers c ON cr.customer_id = c.customer_id;

-- 5. CTE: Defective returns
WITH DefectiveReturns AS (
    SELECT return_id, product_id, reason
    FROM Returns
    WHERE reason = 'Defective'
)
SELECT r.return_id, p.product_name, r.reason
FROM DefectiveReturns r
JOIN Products p ON r.product_id = p.product_id;

-- 6. CTE: Ranked returns by refund
WITH RankedReturns AS (
    SELECT return_id, customer_id, refunded_amount,
           RANK() OVER (PARTITION BY customer_id ORDER BY refunded_amount DESC) AS refund_rank
    FROM Returns
)
SELECT return_id, customer_id, refunded_amount, refund_rank
FROM RankedReturns
WHERE refund_rank <= 5;

-- 7. Stored Procedure: Approve return
DELIMITER //
CREATE PROCEDURE ApproveReturn(IN ret_id INT)
BEGIN
    UPDATE Returns SET status = 'Approved' WHERE return_id = ret_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get customer returns
DELIMITER //
CREATE PROCEDURE GetCustomerReturns(IN cust_id INT)
BEGIN
    SELECT return_id, product_id, refunded_amount, return_date
    FROM Returns
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Update refund amount
DELIMITER //
CREATE PROCEDURE UpdateRefundAmount(IN ret_id INT, IN new_amount DECIMAL(10,2))
BEGIN
    UPDATE Returns SET refunded_amount = new_amount WHERE return_id = ret_id;
END //
DELIMITER ;

-- 10. TCL: Update return with rollback
START TRANSACTION;
UPDATE Returns SET status = 'Approved' WHERE return_id = 1;
UPDATE Returns SET refunded_amount = 1000 WHERE return_id = 1;
-- Simulate error
INSERT INTO Returns (return_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit return update
START TRANSACTION;
UPDATE Returns SET return_method = 'Mail' WHERE return_id = 2;
SAVEPOINT method_updated;
UPDATE Returns SET notes = 'Processed' WHERE return_id = 2;
COMMIT;

-- 12. TCL: Rollback return update
START TRANSACTION;
UPDATE Returns SET refunded_amount = 500 WHERE return_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Returns TO 'user12'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Returns TO 'returns_manager';

-- 15. Trigger: Log return updates
DELIMITER //
CREATE TRIGGER LogReturnUpdate
AFTER UPDATE ON Returns
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Return Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Return ID: ', NEW.return_id, ' Status changed to ', NEW.status),
                'Returns', 'Status update');
END IF;
END ;
// DELIMITER ;

-- 16. Trigger: Validate refund amount
DELIMITER //
CREATE TRIGGER ValidateRefundAmount
BEFORE INSERT ON Returns
FOR EACH ROW
BEGIN
    IF NEW.refunded_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Refund amount cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Update inventory on return
DELIMITER //
CREATE TRIGGER UpdateInventoryOnReturn
AFTER INSERT ON Returns
FOR EACH ROW
BEGIN
    UPDATE Inventory SET quantity = quantity + (
        SELECT quantity FROM Orders WHERE order_id = NEW.order_id
    ) WHERE product_id = NEW.product_id;
END;
// DELIMITER ;

-- 18. Window Function: Rank returns by refund amount
SELECT return_id, customer_id, refunded_amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY refunded_amount DESC) AS refund_rank
FROM Returns;

-- 19. Window Function: Running total of refunds
SELECT return_id, customer_id, refunded_amount,
       SUM(refunded_amount) OVER (PARTITION BY customer_id ORDER BY return_date) AS running_refunded
FROM Returns;

-- 20. Window Function: Refund percentage by customer
SELECT return_id, customer_id, refunded_amount,
       refunded_amount / SUM(refunded_amount) OVER (PARTITION BY customer_id) * 100 AS refund_percentage
FROM Returns;

-- Table 13: Wishlists
-- 1. View: Active wishlists
CREATE VIEW ActiveWishlists AS
SELECT wishlist_id, customer_id, product_id
FROM Wishlists
WHERE is_active = TRUE;

-- 2. View: Wishlists with products
CREATE VIEW WishlistsWithProducts AS
SELECT w.wishlist_id, p.product_name, w.customer_id
FROM Wishlists w
JOIN Products p ON w.product_id = p.product_id;

-- 3. View: Customer wishlists
CREATE VIEW CustomerWishlists AS
SELECT w.wishlist_id, c.first_name, c.last_name
FROM Wishlists w
JOIN Customers c ON w.customer_id = c.customer_id;

-- 4. CTE: Wishlist item count
WITH WishlistItems AS (
    SELECT customer_id, COUNT(*) AS item_count
    FROM Wishlists
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, wi.item_count
FROM WishlistItems wi
JOIN Customers c ON wi.customer_id = c.customer_id;

-- 5. CTE: Recent wishlist items
WITH RecentWishlistItems AS (
    SELECT wishlist_id, product_id, created_date
    FROM Wishlists
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT w.wishlist_id, p.product_name, w.created_date
FROM RecentWishlistItems w
JOIN Products p ON w.product_id = p.product_id;

-- 6. CTE: Ranked wishlists by customer
WITH RankedWishlists AS (
    SELECT wishlist_id, customer_id,
           COUNT(*) OVER (PARTITION BY customer_id) AS item_count,
           RANK() OVER (PARTITION BY customer_id ORDER BY created_date DESC) AS wish_rank
    FROM Wishlists
    GROUP BY wishlist_id
)
SELECT wishlist_id, customer_id, item_count, wish_rank
FROM RankedWishlists
WHERE wish_rank <= 5;

-- 7. Stored Procedure: Add wishlist item
DELIMITER //
CREATE PROCEDURE AddWishlistItem(IN cust_id INT, IN prod_id INT)
BEGIN
    INSERT INTO Wishlists (wishlist_id, customer_id, product_id, created_date, is_active)
    VALUES ((SELECT MAX(wishlist_id) + 1 FROM Wishlists), cust_id, prod_id, CURDATE(), TRUE);
END //
DELIMITER ;

-- 8. Stored Procedure: Remove wishlist item
DELIMITER //
CREATE PROCEDURE RemoveWishlistItem(IN wish_id INT)
BEGIN
    UPDATE Wishlists SET is_active = FALSE WHERE wishlist_id = wish_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get customer wishlist
DELIMITER //
CREATE PROCEDURE GetCustomerWishlist(IN cust_id INT)
BEGIN
    SELECT w.wishlist_id, p.product_name
    FROM Wishlists w
    JOIN Products p ON w.product_id = p.product_id
    WHERE w.customer_id = cust_id AND w.is_active = TRUE;
END //
DELIMITER ;

-- 10. TCL: Update wishlist with rollback
START TRANSACTION;
UPDATE Wishlists SET is_active = FALSE WHERE wishlist_id = 1;
UPDATE Wishlists SET notes = 'Removed' WHERE wishlist_id = 1;
-- Simulate error
INSERT INTO Wishlists (wishlist_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit wishlist update
START TRANSACTION;
UPDATE Wishlists SET product_id = 2 WHERE wishlist_id = 2;
SAVEPOINT product_updated;
UPDATE Wishlists SET created_date = CURDATE() WHERE wishlist_id = 2;
COMMIT;

-- 12. TCL: Rollback wishlist update
START TRANSACTION;
UPDATE Wishlists SET is_active = TRUE WHERE wishlist_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Wishlists TO 'user13'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Wishlists TO 'customer_service';

-- 15. Trigger: Log wishlist updates
DELIMITER //
CREATE TRIGGER LogWishlistUpdate
AFTER UPDATE ON Wishlists
FOR EACH ROW
BEGIN
    IF OLD.is_active != NEW.is_active THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Wishlist Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Wishlist ID: ', NEW.wishlist_id, ' Active status changed to ', NEW.is_active),
                'Wishlists', 'Status update');
END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate wishlist product
DELIMITER //
CREATE TRIGGER ValidateWishlistProduct
BEFORE INSERT ON Wishlists
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Products WHERE product_id = NEW.product_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid product ID';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log wishlist insertion
DELIMITER //
CREATE TRIGGER LogWishlistInsertion
AFTER INSERT ON Wishlists
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'Wishlist Insert', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Wishlist ID: ', NEW.wishlist_id, ' for Product ID: ', NEW.product_id),
            'Wishlists', 'New wishlist item');
END;
// DELIMITER ;

-- 18. Window Function: Rank wishlists by creation date
SELECT wishlist_id, customer_id, created_date,
       RANK() OVER (PARTITION BY customer_id ORDER BY created_date DESC) AS create_rank
FROM Wishlists;

-- 19. Window Function: Running total of wishlist items
SELECT wishlist_id, customer_id, product_id,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY created_date) AS running_items
FROM Wishlists;

-- 20. Window Function: Wishlist percentage by customer
SELECT wishlist_id, customer_id, product_id,
       COUNT(*) OVER (PARTITION BY customer_id) / COUNT(*) OVER () * 100 AS wish_percentage
FROM Wishlists;

-- Table 14: Carts
-- 1. View: Active carts
CREATE VIEW ActiveCarts AS
SELECT cart_id, customer_id, product_id, quantity, total_price
FROM Carts
WHERE is_active = TRUE;

-- 2. View: Carts with products
CREATE VIEW CartsWithProducts AS
SELECT c.cart_id, p.product_name, c.quantity, c.total_price
FROM Carts c
JOIN Products p ON c.product_id = p.product_id
WHERE c.is_active = TRUE;

-- 3. View: Customer carts summary
CREATE VIEW CustomerCartsSummary AS
SELECT c.customer_id, cu.first_name, cu.last_name, COUNT(c.cart_id) AS item_count, SUM(c.total_price) AS total_value
FROM Carts c
JOIN Customers cu ON c.customer_id = cu.customer_id
WHERE c.is_active = TRUE
GROUP BY c.customer_id, cu.first_name, cu.last_name;

-- 4. CTE: Cart total by customer
WITH CartTotals AS (
    SELECT customer_id, SUM(total_price) AS cart_total
    FROM Carts
    WHERE is_active = TRUE
    GROUP BY customer_id
)
SELECT cu.first_name, cu.last_name, ct.cart_total
FROM CartTotals ct
JOIN Customers cu ON ct.customer_id = cu.customer_id
WHERE ct.cart_total > 100;

-- 5. CTE: Recent cart items
WITH RecentCartItems AS (
    SELECT cart_id, product_id, created_date
    FROM Carts
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND is_active = TRUE
)
SELECT c.cart_id, p.product_name, c.created_date
FROM RecentCartItems c
JOIN Products p ON c.product_id = p.product_id;

-- 6. CTE: Ranked carts by total price
WITH RankedCarts AS (
    SELECT cart_id, customer_id, total_price,
           RANK() OVER (PARTITION BY customer_id ORDER BY total_price DESC) AS price_rank
    FROM Carts
    WHERE is_active = TRUE
)
SELECT r.cart_id, cu.first_name, r.total_price, r.price_rank
FROM RankedCarts r
JOIN Customers cu ON r.customer_id = cu.customer_id
WHERE r.price_rank <= 3;

-- 7. Stored Procedure: Add cart item
DELIMITER //
CREATE PROCEDURE AddCartItem(IN cust_id INT, IN prod_id INT, IN qty INT)
BEGIN
    DECLARE prod_price DECIMAL(10,2);
    SELECT price INTO prod_price FROM Products WHERE product_id = prod_id;
    INSERT INTO Carts (cart_id, customer_id, product_id, quantity, created_date, is_active, total_price)
    VALUES ((SELECT COALESCE(MAX(cart_id), 0) + 1 FROM Carts), cust_id, prod_id, qty, CURDATE(), TRUE, prod_price * qty);
END //
DELIMITER ;

-- 8. Stored Procedure: Remove cart item
DELIMITER //
CREATE PROCEDURE RemoveCartItem(IN cart_id INT)
BEGIN
    UPDATE Carts SET is_active = FALSE, last_updated_date = CURDATE()
    WHERE cart_id = cart_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get customer cart
DELIMITER //
CREATE PROCEDURE GetCustomerCart(IN cust_id INT)
BEGIN
    SELECT c.cart_id, p.product_name, c.quantity, c.total_price
    FROM Carts c
    JOIN Products p ON c.product_id = p.product_id
    WHERE c.customer_id = cust_id AND c.is_active = TRUE;
END //
DELIMITER ;

-- 10. TCL: Update cart with rollback
START TRANSACTION;
UPDATE Carts SET quantity = quantity + 1 WHERE cart_id = 1;
UPDATE Carts c SET total_price = (SELECT price * c.quantity FROM Products WHERE product_id = c.product_id) WHERE cart_id = 1;
-- Simulate error
INSERT INTO Carts (cart_id) VALUES (1); -- Duplicate key error
COMMIT;
ROLLBACK;

-- 11. TCL: Commit cart update
START TRANSACTION;
UPDATE Carts SET quantity = 3 WHERE cart_id = 2;
SAVEPOINT quantity_updated;
UPDATE Carts c SET total_price = (SELECT price * c.quantity FROM Products WHERE product_id = c.product_id), last_updated_date = CURDATE() WHERE cart_id = 2;
COMMIT;

-- 12. TCL: Rollback cart update
START TRANSACTION;
UPDATE Carts SET total_price = 50.00 WHERE cart_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Carts TO 'user14'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Carts TO 'cart_manager';

-- 15. Trigger: Log cart updates
DELIMITER //
CREATE TRIGGER LogCartUpdate
AFTER UPDATE ON Carts
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity OR OLD.total_price != NEW.total_price THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Cart Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Cart ID: ', NEW.cart_id, ' Quantity: ', NEW.quantity, ' Total: ', NEW.total_price),
                'Carts', 'Cart item updated');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate cart quantity
DELIMITER //
CREATE TRIGGER ValidateCartQuantity
BEFORE INSERT ON Carts
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log cart insertion
DELIMITER //
CREATE TRIGGER LogCartInsertion
AFTER INSERT ON Carts
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'Cart Insert', NOW(), '127.0.0.1', 'Unknown', 'Success',
            CONCAT('Cart ID: ', NEW.cart_id, ' Product ID: ', NEW.product_id, ' Quantity: ', NEW.quantity),
            'Carts', 'New cart item added');
END;
// DELIMITER ;

-- 18. Window Function: Rank carts by total price
SELECT cart_id, customer_id, total_price,
       RANK() OVER (PARTITION BY customer_id ORDER BY total_price DESC) AS price_rank
FROM Carts
WHERE is_active = TRUE;

-- 19. Window Function: Running total of cart items
SELECT cart_id, customer_id, quantity,
       SUM(quantity) OVER (PARTITION BY customer_id ORDER BY created_date) AS running_quantity
FROM Carts
WHERE is_active = TRUE;

-- 20. Window Function: Cart total price percentage by customer
SELECT cart_id, customer_id, total_price,
       total_price / SUM(total_price) OVER (PARTITION BY customer_id) * 100 AS price_percentage
FROM Carts
WHERE is_active = TRUE;

-- Table 15: Employees
-- 1. View: Active employees
CREATE VIEW ActiveEmployees AS
SELECT employee_id, first_name, last_name, department_id
FROM Employees
WHERE employment_status = 'Active';

-- 2. View: Employees with departments
CREATE VIEW EmployeesWithDepartments AS
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id;

-- 3. View: High-salary employees
CREATE VIEW HighSalaryEmployees AS
SELECT employee_id, first_name, last_name, salary
FROM Employees
WHERE salary > 80000;

-- 4. CTE: Average salary by department
WITH DepartmentAvgSalary AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department_id
)
SELECT e.first_name, e.last_name, e.salary, d.avg_salary
FROM Employees e
JOIN DepartmentAvgSalary d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;

-- 5. CTE: Recent hires
WITH RecentHires AS (
    SELECT employee_id, first_name, last_name, hire_date
    FROM Employees
    WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
)
SELECT r.first_name, r.last_name, r.hire_date, d.department_name
FROM RecentHires r
JOIN Employees e ON r.employee_id = e.employee_id
JOIN Departments d ON e.department_id = d.department_id;

-- 6. CTE: Ranked employees by salary
WITH RankedEmployees AS (
    SELECT employee_id, first_name, last_name, salary,
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM Employees
)
SELECT first_name, last_name, salary, salary_rank
FROM RankedEmployees
WHERE salary_rank <= 3;

-- 7. Stored Procedure: Update employee salary
DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalary(IN emp_id INT, IN new_salary DECIMAL(10,2))
BEGIN
    UPDATE Employees SET salary = new_salary WHERE employee_id = emp_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Terminate employee
DELIMITER //
CREATE PROCEDURE TerminateEmployee(IN emp_id INT)
BEGIN
    UPDATE Employees SET employment_status = 'Terminated', termination_date = CURDATE()
    WHERE employee_id = emp_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get department employees
DELIMITER //
CREATE PROCEDURE GetDepartmentEmployees(IN dept_id INT)
BEGIN
    SELECT employee_id, first_name, last_name, salary
    FROM Employees
    WHERE department_id = dept_id AND employment_status = 'Active';
END //
DELIMITER ;

-- 10. TCL: Update employee with rollback
START TRANSACTION;
UPDATE Employees SET salary = salary * 1.1 WHERE employee_id = 1;
UPDATE Employees SET job_title = 'Senior Manager' WHERE employee_id = 1;
-- Simulate error
INSERT INTO Employees (employee_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit employee update
START TRANSACTION;
UPDATE Employees SET department_id = 2 WHERE employee_id = 2;
SAVEPOINT dept_updated;
UPDATE Employees SET email = 'new.email@company.com' WHERE employee_id = 2;
COMMIT;

-- 12. TCL: Rollback employee update
START TRANSACTION;
UPDATE Employees SET salary = 90000 WHERE employee_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Employees TO 'user15'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Employees TO 'hr_manager';

-- 15. Trigger: Log employee updates
DELIMITER //
CREATE TRIGGER LogEmployeeUpdate
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.employee_id, 'Employee Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Employee ID: ', NEW.employee_id, ' Salary changed to ', NEW.salary),
                'Employees', 'Salary update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate email
DELIMITER //
CREATE TRIGGER ValidateEmployeeEmail
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log employee termination
DELIMITER //
CREATE TRIGGER LogEmployeeTermination
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.employment_status != NEW.employment_status AND NEW.employment_status = 'Terminated' THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.employee_id, 'Employee Termination', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Employee ID: ', NEW.employee_id, ' terminated'),
                'Employees', 'Termination');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank employees by salary
SELECT employee_id, first_name, last_name, salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM Employees;

-- 19. Window Function: Running total of salaries
SELECT employee_id, first_name, last_name, salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS running_salary
FROM Employees;

-- 20. Window Function: Salary percentage by department
SELECT employee_id, first_name, last_name, salary,
       salary / SUM(salary) OVER (PARTITION BY department_id) * 100 AS salary_percentage
FROM Employees;

-- Table 16: Departments
-- 1. View: Active departments
CREATE VIEW ActiveDepartments AS
SELECT department_id, department_name, budget
FROM Departments
WHERE is_active = TRUE;

-- 2. View: Departments with employees
CREATE VIEW DepartmentsWithEmployees AS
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- 3. View: High-budget departments
CREATE VIEW HighBudgetDepartments AS
SELECT department_id, department_name, budget
FROM Departments
WHERE budget > 500000;

-- 4. CTE: Average budget by location
WITH LocationAvgBudget AS (
    SELECT location, AVG(budget) AS avg_budget
    FROM Departments
    GROUP BY location
)
SELECT d.department_name, d.budget, l.avg_budget
FROM Departments d
JOIN LocationAvgBudget l ON d.location = l.location
WHERE d.budget > l.avg_budget;

-- 5. CTE: Recent departments
WITH RecentDepartments AS (
    SELECT department_id, department_name, created_date
    FROM Departments
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
)
SELECT department_name, created_date
FROM RecentDepartments
ORDER BY created_date DESC;

-- 6. CTE: Ranked departments by budget
WITH RankedDepartments AS (
    SELECT department_id, department_name, budget,
           RANK() OVER (ORDER BY budget DESC) AS budget_rank
    FROM Departments
)
SELECT department_name, budget, budget_rank
FROM RankedDepartments
WHERE budget_rank <= 3;

-- 7. Stored Procedure: Update department budget
DELIMITER //
CREATE PROCEDURE UpdateDepartmentBudget(IN dept_id INT, IN new_budget DECIMAL(12,2))
BEGIN
    UPDATE Departments SET budget = new_budget WHERE department_id = dept_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate department
DELIMITER //
CREATE PROCEDURE DeactivateDepartment(IN dept_id INT)
BEGIN
    UPDATE Departments SET is_active = FALSE WHERE department_id = dept_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get department details
DELIMITER //
CREATE PROCEDURE GetDepartmentDetails(IN dept_id INT)
BEGIN
    SELECT department_id, department_name, budget, location
    FROM Departments
    WHERE department_id = dept_id;
END //
DELIMITER ;

-- 10. TCL: Update department with rollback
START TRANSACTION;
UPDATE Departments SET budget = budget * 1.05 WHERE department_id = 1;
UPDATE Departments SET manager_id = 2 WHERE department_id = 1;
-- Simulate error
INSERT INTO Departments (department_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit department update
START TRANSACTION;
UPDATE Departments SET location = 'New York' WHERE department_id = 2;
SAVEPOINT location_updated;
UPDATE Departments SET department_name = 'Updated R&D' WHERE department_id = 2;
COMMIT;

-- 12. TCL: Rollback department update
START TRANSACTION;
UPDATE Departments SET budget = 600000 WHERE department_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Departments TO 'user16'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Departments TO 'admin_manager';

-- 15. Trigger: Log department updates
DELIMITER //
CREATE TRIGGER LogDepartmentUpdate
AFTER UPDATE ON Departments
FOR EACH ROW
BEGIN
    IF OLD.budget != NEW.budget THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Department Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Department ID: ', NEW.department_id, ' Budget changed to ', NEW.budget),
                'Departments', 'Budget update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate budget
DELIMITER //
CREATE TRIGGER ValidateDepartmentBudget
BEFORE INSERT ON Departments
FOR EACH ROW
BEGIN
    IF NEW.budget < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Budget cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log department deactivation
DELIMITER //
CREATE TRIGGER LogDepartmentDeactivation
AFTER UPDATE ON Departments
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Department Deactivation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Department ID: ', NEW.department_id, ' deactivated'),
                'Departments', 'Deactivation');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank departments by budget
SELECT department_id, department_name, budget,
       RANK() OVER (ORDER BY budget DESC) AS budget_rank
FROM Departments;

-- 19. Window Function: Running total of budgets
SELECT department_id, department_name, budget,
       SUM(budget) OVER (PARTITION BY location ORDER BY department_id) AS running_budget
FROM Departments;

-- 20. Window Function: Budget percentage by location
SELECT department_id, department_name, budget,
       budget / SUM(budget) OVER (PARTITION BY location) * 100 AS budget_percentage
FROM Departments;

-- Table 17: Transactions
-- 1. View: Completed transactions
CREATE VIEW CompletedTransactions AS
SELECT transaction_id, payment_id, amount, transaction_date
FROM Transactions
WHERE status = 'Completed';

-- 2. View: Transactions with payments
CREATE VIEW TransactionsWithPayments AS
SELECT t.transaction_id, t.amount, p.order_id, p.customer_id
FROM Transactions t
JOIN Payments p ON t.payment_id = p.payment_id;

-- 3. View: High-amount transactions
CREATE VIEW HighAmountTransactions AS
SELECT transaction_id, payment_id, amount
FROM Transactions
WHERE amount > 1000;

-- 4. CTE: Total transactions by customer
WITH CustomerTransactions AS (
    SELECT p.customer_id, SUM(t.amount) AS total_amount
    FROM Transactions t
    JOIN Payments p ON t.payment_id = p.payment_id
    GROUP BY p.customer_id
)
SELECT c.first_name, c.last_name, ct.total_amount
FROM CustomerTransactions ct
JOIN Customers c ON ct.customer_id = c.customer_id;

-- 5. CTE: Recent transactions
WITH RecentTransactions AS (
    SELECT transaction_id, payment_id, transaction_date
    FROM Transactions
    WHERE transaction_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT t.transaction_id, p.order_id, t.transaction_date
FROM RecentTransactions t
JOIN Payments p ON t.payment_id = p.payment_id;

-- 6. CTE: Ranked transactions by amount
WITH RankedTransactions AS (
    SELECT transaction_id, payment_id, amount,
           RANK() OVER (PARTITION BY payment_id ORDER BY amount DESC) AS amount_rank
    FROM Transactions
)
SELECT transaction_id, payment_id, amount, amount_rank
FROM RankedTransactions
WHERE amount_rank <= 3;

-- 7. Stored Procedure: Update transaction status
DELIMITER //
CREATE PROCEDURE UpdateTransactionStatus(IN trans_id INT, IN new_status VARCHAR(50))
BEGIN
    UPDATE Transactions SET status = new_status WHERE transaction_id = trans_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get payment transactions
DELIMITER //
CREATE PROCEDURE GetPaymentTransactions(IN pay_id INT)
BEGIN
    SELECT transaction_id, amount, transaction_date
    FROM Transactions
    WHERE payment_id = pay_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add transaction
DELIMITER //
CREATE PROCEDURE AddTransaction(IN pay_id INT, IN amt DECIMAL(10,2))
BEGIN
    INSERT INTO Transactions (transaction_id, payment_id, amount, transaction_date, status)
    VALUES ((SELECT COALESCE(MAX(transaction_id), 0) + 1 FROM Transactions), pay_id, amt, NOW(), 'Pending');
END //
DELIMITER ;

-- 10. TCL: Update transaction with rollback
START TRANSACTION;
UPDATE Transactions SET amount = 1500 WHERE transaction_id = 1;
UPDATE Transactions SET status = 'Completed' WHERE transaction_id = 1;
-- Simulate error
INSERT INTO Transactions (transaction_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit transaction update
START TRANSACTION;
UPDATE Transactions SET transaction_date = NOW() WHERE transaction_id = 2;
SAVEPOINT date_updated;
UPDATE Transactions SET gateway = 'Stripe' WHERE transaction_id = 2;
COMMIT;

-- 12. TCL: Rollback transaction update
START TRANSACTION;
UPDATE Transactions SET amount = 2000 WHERE transaction_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Transactions TO 'user17'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Transactions TO 'finance_manager';

-- 15. Trigger: Log transaction updates
DELIMITER //
CREATE TRIGGER LogTransactionUpdate
AFTER UPDATE ON Transactions
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Transaction Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Transaction ID: ', NEW.transaction_id, ' Status changed to ', NEW.status),
                'Transactions', 'Status update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate transaction amount
DELIMITER //
CREATE TRIGGER ValidateTransactionAmount
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction amount must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log transaction insertion
DELIMITER //
CREATE TRIGGER LogTransactionInsertion
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'Transaction Insert', NOW(), '127.0.0.1', 'Unknown', 'Success',
            CONCAT('Transaction ID: ', NEW.transaction_id, ' Amount: ', NEW.amount),
            'Transactions', 'New transaction');
END;
// DELIMITER ;

-- 18. Window Function: Rank transactions by amount
SELECT transaction_id, payment_id, amount,
       RANK() OVER (PARTITION BY payment_id ORDER BY amount DESC) AS amount_rank
FROM Transactions;

-- 19. Window Function: Running total of transactions
SELECT transaction_id, payment_id, amount,
       SUM(amount) OVER (PARTITION BY payment_id ORDER BY transaction_date) AS running_amount
FROM Transactions;

-- 20. Window Function: Transaction percentage by payment
SELECT transaction_id, payment_id, amount,
       amount / SUM(amount) OVER (PARTITION BY payment_id) * 100 AS amount_percentage
FROM Transactions;

-- Table 18: Discounts
-- 1. View: Active discounts
CREATE VIEW ActiveDiscounts AS
SELECT discount_id, discount_code, discount_value
FROM Discounts
WHERE is_active = TRUE AND expiry_date >= CURDATE();

-- 2. View: Discounts with orders
CREATE VIEW DiscountsWithOrders AS
SELECT d.discount_id, d.discount_code, COUNT(o.order_id) AS order_count
FROM Discounts d
LEFT JOIN Orders o ON d.discount_id = o.discount_id
GROUP BY d.discount_id, d.discount_code;

-- 3. View: High-value discounts
CREATE VIEW HighValueDiscounts AS
SELECT discount_id, discount_code, discount_value
FROM Discounts
WHERE discount_value > 50;

-- 4. CTE: Total discount usage
WITH DiscountUsage AS (
    SELECT discount_id, COUNT(*) AS usage_count
    FROM Orders
    WHERE discount_id IS NOT NULL
    GROUP BY discount_id
)
SELECT d.discount_code, du.usage_count
FROM DiscountUsage du
JOIN Discounts d ON du.discount_id = d.discount_id;

-- 5. CTE: Recent discounts
WITH RecentDiscounts AS (
    SELECT discount_id, discount_code, created_date
    FROM Discounts
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT discount_code, created_date
FROM RecentDiscounts
ORDER BY created_date DESC;

-- 6. CTE: Ranked discounts by value
WITH RankedDiscounts AS (
    SELECT discount_id, discount_code, discount_value,
           RANK() OVER (ORDER BY discount_value DESC) AS value_rank
    FROM Discounts
)
SELECT discount_code, discount_value, value_rank
FROM RankedDiscounts
WHERE value_rank <= 3;

-- 7. Stored Procedure: Activate discount
DELIMITER //
CREATE PROCEDURE ActivateDiscount(IN disc_id INT)
BEGIN
    UPDATE Discounts SET is_active = TRUE WHERE discount_id = disc_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get discount details
DELIMITER //
CREATE PROCEDURE GetDiscountDetails(IN disc_id INT)
BEGIN
    SELECT discount_id, discount_code, discount_value, expiry_date
    FROM Discounts
    WHERE discount_id = disc_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add discount
DELIMITER //
CREATE PROCEDURE AddDiscount(IN code VARCHAR(50), IN value DECIMAL(10,2))
BEGIN
    INSERT INTO Discounts (discount_id, discount_code, discount_value, created_date, is_active, expiry_date)
    VALUES ((SELECT COALESCE(MAX(discount_id), 0) + 1 FROM Discounts), code, value, CURDATE(), TRUE, DATE_ADD(CURDATE(), INTERVAL 1 YEAR));
END //
DELIMITER ;

-- 10. TCL: Update discount with rollback
START TRANSACTION;
UPDATE Discounts SET discount_value = 75 WHERE discount_id = 1;
UPDATE Discounts SET is_active = TRUE WHERE discount_id = 1;
-- Simulate error
INSERT INTO Discounts (discount_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit discount update
START TRANSACTION;
UPDATE Discounts SET expiry_date = DATE_ADD(CURDATE(), INTERVAL 6 MONTH) WHERE discount_id = 2;
SAVEPOINT expiry_updated;
UPDATE Discounts SET discount_code = 'SALE2025' WHERE discount_id = 2;
COMMIT;

-- 12. TCL: Rollback discount update
START TRANSACTION;
UPDATE Discounts SET discount_value = 100 WHERE discount_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Discounts TO 'user18'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Discounts TO 'marketing_manager';

-- 15. Trigger: Log discount updates
DELIMITER //
CREATE TRIGGER LogDiscountUpdate
AFTER UPDATE ON Discounts
FOR EACH ROW
BEGIN
    IF OLD.discount_value != NEW.discount_value THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Discount Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Discount ID: ', NEW.discount_id, ' Value changed to ', NEW.discount_value),
                'Discounts', 'Value update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate discount value
DELIMITER //
CREATE TRIGGER ValidateDiscountValue
BEFORE INSERT ON Discounts
FOR EACH ROW
BEGIN
    IF NEW.discount_value <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Discount value must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log discount deactivation
DELIMITER //
CREATE TRIGGER LogDiscountDeactivation
AFTER UPDATE ON Discounts
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Discount Deactivation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Discount ID: ', NEW.discount_id, ' deactivated'),
                'Discounts', 'Deactivation');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank discounts by value
SELECT discount_id, discount_code, discount_value,
       RANK() OVER (ORDER BY discount_value DESC) AS value_rank
FROM Discounts;

-- 19. Window Function: Running total of discounts
SELECT discount_id, discount_code, discount_value,
       COUNT(*) OVER (ORDER BY created_date) AS running_discount_count
FROM Discounts;

-- 20. Window Function: Discount percentage
SELECT discount_id, discount_code, discount_value,
       discount_value / SUM(discount_value) OVER () * 100 AS value_percentage
FROM Discounts;

-- Table 19: Taxes
-- 1. View: Active taxes
CREATE VIEW ActiveTaxes AS
SELECT tax_id, tax_name, tax_rate
FROM Taxes
WHERE is_active = TRUE;

-- 2. View: Taxes with orders
CREATE VIEW TaxesWithOrders AS
SELECT t.tax_id, t.tax_name, COUNT(o.order_id) AS order_count
FROM Taxes t
LEFT JOIN Orders o ON t.tax_id = o.tax_id
GROUP BY t.tax_id, t.tax_name;

-- 3. View: High-rate taxes
CREATE VIEW HighRateTaxes AS
SELECT tax_id, tax_name, tax_rate
FROM Taxes
WHERE tax_rate > 5;

-- 4. CTE: Total tax revenue
WITH TaxRevenue AS (
    SELECT tax_id, SUM(total_price * tax_rate / 100) AS total_tax
    FROM Orders o
    JOIN Taxes t ON o.tax_id = t.tax_id
    GROUP BY tax_id
)
SELECT t.tax_name, tr.total_tax
FROM TaxRevenue tr
JOIN Taxes t ON tr.tax_id = t.tax_id;

-- 5. CTE: Recent taxes
WITH RecentTaxes AS (
    SELECT tax_id, tax_name, created_date
    FROM Taxes
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
)
SELECT tax_name, created_date
FROM RecentTaxes
ORDER BY created_date DESC;

-- 6. CTE: Ranked taxes by rate
WITH RankedTaxes AS (
    SELECT tax_id, tax_name, tax_rate,
           RANK() OVER (ORDER BY tax_rate DESC) AS rate_rank
    FROM Taxes
)
SELECT tax_name, tax_rate, rate_rank
FROM RankedTaxes
WHERE rate_rank <= 3;

-- 7. Stored Procedure: Update tax rate
DELIMITER //
CREATE PROCEDURE UpdateTaxRate(IN tax_id INT, IN new_rate DECIMAL(5,2))
BEGIN
    UPDATE Taxes SET tax_rate = new_rate WHERE tax_id = tax_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate tax
DELIMITER //
CREATE PROCEDURE DeactivateTax(IN tax_id INT)
BEGIN
    UPDATE Taxes SET is_active = FALSE WHERE tax_id = tax_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add tax
DELIMITER //
CREATE PROCEDURE AddTax(IN name VARCHAR(100), IN rate DECIMAL(5,2))
BEGIN
    INSERT INTO Taxes (tax_id, tax_name, tax_rate, created_date, is_active)
    VALUES ((SELECT COALESCE(MAX(tax_id), 0) + 1 FROM Taxes), name, rate, CURDATE(), TRUE);
END //
DELIMITER ;

-- 10. TCL: Update tax with rollback
START TRANSACTION;
UPDATE Taxes SET tax_rate = 7.5 WHERE tax_id = 1;
UPDATE Taxes SET is_active = TRUE WHERE tax_id = 1;
-- Simulate error
INSERT INTO Taxes (tax_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit tax update
START TRANSACTION;
UPDATE Taxes SET tax_name = 'Updated Sales Tax' WHERE tax_id = 2;
SAVEPOINT name_updated;
UPDATE Taxes SET jurisdiction = 'New York' WHERE tax_id = 2;
COMMIT;

-- 12. TCL: Rollback tax update
START TRANSACTION;
UPDATE Taxes SET tax_rate = 8.0 WHERE tax_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Taxes TO 'user19'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Taxes TO 'finance_manager';

-- 15. Trigger: Log tax updates
DELIMITER //
CREATE TRIGGER LogTaxUpdate
AFTER UPDATE ON Taxes
FOR EACH ROW
BEGIN
    IF OLD.tax_rate != NEW.tax_rate THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Tax Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Tax ID: ', NEW.tax_id, ' Rate changed to ', NEW.tax_rate),
                'Taxes', 'Rate update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate tax rate
DELIMITER //
CREATE TRIGGER ValidateTaxRate
BEFORE INSERT ON Taxes
FOR EACH ROW
BEGIN
    IF NEW.tax_rate < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tax rate cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log tax deactivation
DELIMITER //
CREATE TRIGGER LogTaxDeactivation
AFTER UPDATE ON Taxes
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Tax Deactivation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Tax ID: ', NEW.tax_id, ' deactivated'),
                'Taxes', 'Deactivation');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank taxes by rate
SELECT tax_id, tax_name, tax_rate,
       RANK() OVER (ORDER BY tax_rate DESC) AS rate_rank
FROM Taxes;

-- 19. Window Function: Running total of taxes
SELECT tax_id, tax_name, tax_rate,
       COUNT(*) OVER (PARTITION BY jurisdiction ORDER BY tax_id) AS tax_count
FROM Taxes;

-- 20. Window Function: Tax rate percentage
SELECT tax_id, tax_name, tax_rate,
       tax_rate / SUM(tax_rate) OVER () * 100 AS rate_percentage
FROM Taxes;

-- Table 20: Addresses
-- 1. View: Primary addresses
CREATE VIEW PrimaryAddresses AS
SELECT address_id, customer_id, address_line1, city
FROM Addresses
WHERE is_default = TRUE;

-- 2. View: Addresses with customers
CREATE VIEW AddressesWithCustomers AS
SELECT a.address_id, c.first_name, c.last_name, a.address_line1
FROM Addresses a
JOIN Customers c ON a.customer_id = c.customer_id;

-- 3. View: Recent addresses
CREATE VIEW RecentAddresses AS
SELECT address_id, customer_id, created_date
FROM Addresses
WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 4. CTE: Address count by customer
WITH AddressCount AS (
    SELECT customer_id, COUNT(*) AS address_count
    FROM Addresses
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, ac.address_count
FROM AddressCount ac
JOIN Customers c ON ac.customer_id = c.customer_id
WHERE ac.address_count > 1;

-- 5. CTE: Recent address updates
WITH RecentAddressUpdates AS (
    SELECT address_id, customer_id, last_updated
    FROM Addresses
    WHERE last_updated >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT a.address_id, c.first_name, a.last_updated
FROM RecentAddressUpdates a
JOIN Customers c ON a.customer_id = c.customer_id;

-- 6. CTE: Ranked addresses by customer
WITH RankedAddresses AS (
    SELECT address_id, customer_id, created_date,
           RANK() OVER (PARTITION BY customer_id ORDER BY created_date DESC) AS address_rank
    FROM Addresses
)
SELECT address_id, customer_id, created_date, address_rank
FROM RankedAddresses
WHERE address_rank <= 2;

-- 7. Stored Procedure: Update address
DELIMITER //
CREATE PROCEDURE UpdateAddress(IN addr_id INT, IN new_line1 VARCHAR(255))
BEGIN
    UPDATE Addresses SET address_line1 = new_line1, last_updated = CURDATE()
    WHERE address_id = addr_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Set default address
DELIMITER //
CREATE PROCEDURE SetDefaultAddress(IN addr_id INT, IN cust_id INT)
BEGIN
    UPDATE Addresses SET is_default = FALSE WHERE customer_id = cust_id;
    UPDATE Addresses SET is_default = TRUE WHERE address_id = addr_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Get customer addresses
DELIMITER //
CREATE PROCEDURE GetCustomerAddresses(IN cust_id INT)
BEGIN
    SELECT address_id, address_line1, city, is_default
    FROM Addresses
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 10. TCL: Update address with rollback
START TRANSACTION;
UPDATE Addresses SET city = 'New York' WHERE address_id = 1;
UPDATE Addresses SET postal_code = '10001' WHERE address_id = 1;
-- Simulate error
INSERT INTO Addresses (address_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Addresses SET address_line1 = '123 New St' WHERE address_id = 2;
SAVEPOINT line_updated;
UPDATE Addresses SET last_updated = CURDATE() WHERE address_id = 2;
COMMIT;

-- 12. TCL: Rollback address update
START TRANSACTION;
UPDATE Addresses SET state = 'CA' WHERE address_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Addresses TO 'user20'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Addresses TO 'customer_service';

-- 15. Trigger: Log address updates
DELIMITER //
CREATE TRIGGER LogAddressUpdate
AFTER UPDATE ON Addresses
FOR EACH ROW
BEGIN
    IF OLD.address_line1 != NEW.address_line1 THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Address Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Address ID: ', NEW.address_id, ' Line1 changed to ', NEW.address_line1),
                'Addresses', 'Address update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate postal code
DELIMITER //
CREATE TRIGGER ValidatePostalCode
BEFORE INSERT ON Addresses
FOR EACH ROW
BEGIN
    IF NEW.postal_code NOT REGEXP '^[0-9]{5}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid postal code format';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log address insertion
DELIMITER //
CREATE TRIGGER LogAddressInsertion
AFTER INSERT ON Addresses
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'Address Insert', NOW(), '127.0.0.1', 'Unknown', 'Success',
            CONCAT('Address ID: ', NEW.address_id, ' for Customer ID: ', NEW.customer_id),
            'Addresses', 'New address');
END;
// DELIMITER ;

-- 18. Window Function: Rank addresses by creation date
SELECT address_id, customer_id, created_date,
       RANK() OVER (PARTITION BY customer_id ORDER BY created_date DESC) AS create_rank
FROM Addresses;

-- 19. Window Function: Running total of addresses
SELECT address_id, customer_id, created_date,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY created_date) AS address_count
FROM Addresses;

-- 20. Window Function: Address percentage by customer
SELECT address_id, customer_id, created_date,
       COUNT(*) OVER (PARTITION BY customer_id) / COUNT(*) OVER () * 100 AS address_percentage
FROM Addresses;

-- Table 21: Subscriptions
-- 1. View: Active subscriptions
CREATE VIEW ActiveSubscriptions AS
SELECT subscription_id, customer_id, plan_name
FROM Subscriptions
WHERE status = 'Active';

-- 2. View: Subscriptions with customers
CREATE VIEW SubscriptionsWithCustomers AS
SELECT s.subscription_id, c.first_name, c.last_name, s.plan_name
FROM Subscriptions s
JOIN Customers c ON s.customer_id = c.customer_id;

-- 3. View: Premium subscriptions
CREATE VIEW PremiumSubscriptions AS
SELECT subscription_id, customer_id, plan_name, monthly_fee
FROM Subscriptions
WHERE monthly_fee > 20;

-- 4. CTE: Total revenue by plan
WITH PlanRevenue AS (
    SELECT plan_name, SUM(monthly_fee) AS total_revenue
    FROM Subscriptions
    WHERE status = 'Active'
    GROUP BY plan_name
)
SELECT plan_name, total_revenue
FROM PlanRevenue
ORDER BY total_revenue DESC;

-- 5. CTE: Recent subscriptions
WITH RecentSubscriptions AS (
    SELECT subscription_id, customer_id, start_date
    FROM Subscriptions
    WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT s.subscription_id, c.first_name, s.start_date
FROM RecentSubscriptions s
JOIN Customers c ON s.customer_id = c.customer_id;

-- 6. CTE: Ranked subscriptions by fee
WITH RankedSubscriptions AS (
    SELECT subscription_id, customer_id, monthly_fee,
           RANK() OVER (PARTITION BY customer_id ORDER BY monthly_fee DESC) AS fee_rank
    FROM Subscriptions
)
SELECT subscription_id, customer_id, monthly_fee, fee_rank
FROM RankedSubscriptions
WHERE fee_rank <= 2;

-- 7. Stored Procedure: Cancel subscription
DELIMITER //
CREATE PROCEDURE CancelSubscription(IN sub_id INT)
BEGIN
    UPDATE Subscriptions SET status = 'Cancelled', end_date = CURDATE()
    WHERE subscription_id = sub_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get customer subscriptions
DELIMITER //
CREATE PROCEDURE GetCustomerSubscriptions(IN cust_id INT)
BEGIN
    SELECT subscription_id, plan_name, monthly_fee, status
    FROM Subscriptions
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add subscription
DELIMITER //
CREATE PROCEDURE AddSubscription(IN cust_id INT, IN plan VARCHAR(100), IN fee DECIMAL(10,2))
BEGIN
    INSERT INTO Subscriptions (subscription_id, customer_id, plan_name, monthly_fee, start_date, status)
    VALUES ((SELECT COALESCE(MAX(subscription_id), 0) + 1 FROM Subscriptions), cust_id, plan, fee, CURDATE(), 'Active');
END //
DELIMITER ;

-- 10. TCL: Update subscription with rollback
START TRANSACTION;
UPDATE Subscriptions SET monthly_fee = 25 WHERE subscription_id = 1;
UPDATE Subscriptions SET status = 'Active' WHERE subscription_id = 1;
-- Simulate error
INSERT INTO Subscriptions (subscription_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit subscription update
START TRANSACTION;
UPDATE Subscriptions SET plan_name = 'Premium Plus' WHERE subscription_id = 2;
SAVEPOINT plan_updated;
UPDATE Subscriptions SET next_billing_date = DATE_ADD(CURDATE(), INTERVAL 1 MONTH) WHERE subscription_id = 2;
COMMIT;

-- 12. TCL: Rollback subscription update
START TRANSACTION;
UPDATE Subscriptions SET monthly_fee = 30 WHERE subscription_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Subscriptions TO 'user21'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Subscriptions TO 'subscription_manager';

-- 15. Trigger: Log subscription updates
DELIMITER //
CREATE TRIGGER LogSubscriptionUpdate
AFTER UPDATE ON Subscriptions
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Subscription Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Subscription ID: ', NEW.subscription_id, ' Status changed to ', NEW.status),
                'Subscriptions', 'Status update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate monthly fee
DELIMITER //
CREATE TRIGGER ValidateSubscriptionFee
BEFORE INSERT ON Subscriptions
FOR EACH ROW
BEGIN
    IF NEW.monthly_fee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Monthly fee cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log subscription cancellation
DELIMITER //
CREATE TRIGGER LogSubscriptionCancellation
AFTER UPDATE ON Subscriptions
FOR EACH ROW
BEGIN
    IF OLD.status = 'Active' AND NEW.status = 'Cancelled' THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Subscription Cancellation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Subscription ID: ', NEW.subscription_id, ' cancelled'),
                'Subscriptions', 'Cancellation');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank subscriptions by fee
SELECT subscription_id, customer_id, monthly_fee,
       RANK() OVER (PARTITION BY customer_id ORDER BY monthly_fee DESC) AS fee_rank
FROM Subscriptions;

-- 19. Window Function: Running total of subscriptions
SELECT subscription_id, customer_id, monthly_fee,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY start_date) AS subscription_count
FROM Subscriptions;

-- 20. Window Function: Fee percentage by customer
SELECT subscription_id, customer_id, monthly_fee,
       monthly_fee / SUM(monthly_fee) OVER (PARTITION BY customer_id) * 100 AS fee_percentage
FROM Subscriptions;

-- Table 22: GiftCards
-- 1. View: Active gift cards
CREATE VIEW ActiveGiftCards AS
SELECT gift_card_id, customer_id, balance
FROM GiftCards
WHERE is_active = TRUE AND expiry_date >= CURDATE();

-- 2. View: Gift cards with customers
CREATE VIEW GiftCardsWithCustomers AS
SELECT g.gift_card_id, c.first_name, c.last_name, g.balance
FROM GiftCards g
JOIN Customers c ON g.customer_id = c.customer_id;

-- 3. View: High-balance gift cards
CREATE VIEW HighBalanceGiftCards AS
SELECT gift_card_id, customer_id, balance
FROM GiftCards
WHERE balance > 100;

-- 4. CTE: Total gift card balance by customer
WITH CustomerGiftCardBalance AS (
    SELECT customer_id, SUM(balance) AS total_balance
    FROM GiftCards
    WHERE is_active = TRUE
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cg.total_balance
FROM CustomerGiftCardBalance cg
JOIN Customers c ON cg.customer_id = c.customer_id;

-- 5. CTE: Recent gift cards
WITH RecentGiftCards AS (
    SELECT gift_card_id, customer_id, issue_date
    FROM GiftCards
    WHERE issue_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT g.gift_card_id, c.first_name, g.issue_date
FROM RecentGiftCards g
JOIN Customers c ON g.customer_id = c.customer_id;

-- 6. CTE: Ranked gift cards by balance
WITH RankedGiftCards AS (
    SELECT gift_card_id, customer_id, balance,
           RANK() OVER (PARTITION BY customer_id ORDER BY balance DESC) AS balance_rank
    FROM GiftCards
)
SELECT gift_card_id, customer_id, balance, balance_rank
FROM RankedGiftCards
WHERE balance_rank <= 2;

-- 7. Stored Procedure: Update gift card balance
DELIMITER //
CREATE PROCEDURE UpdateGiftCardBalance(IN gc_id INT, IN new_balance DECIMAL(10,2))
BEGIN
    UPDATE GiftCards SET balance = new_balance WHERE gift_card_id = gc_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate gift card
DELIMITER //
CREATE PROCEDURE DeactivateGiftCard(IN gc_id INT)
BEGIN
    UPDATE GiftCards SET is_active = FALSE WHERE gift_card_id = gc_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add gift card
DELIMITER //
CREATE PROCEDURE AddGiftCard(IN cust_id INT, IN bal DECIMAL(10,2))
BEGIN
    INSERT INTO GiftCards (gift_card_id, customer_id, balance, issue_date, is_active, expiry_date)
    VALUES ((SELECT COALESCE(MAX(gift_card_id), 0) + 1 FROM GiftCards), cust_id, bal, CURDATE(), TRUE, DATE_ADD(CURDATE(), INTERVAL 1 YEAR));
END //
DELIMITER ;

-- 10. TCL: Update gift card with rollback
START TRANSACTION;
UPDATE GiftCards SET balance = balance - 50 WHERE gift_card_id = 1;
UPDATE GiftCards SET last_used = NOW() WHERE gift_card_id = 1;
-- Simulate error
INSERT INTO GiftCards (gift_card_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit gift card update
START TRANSACTION;
UPDATE GiftCards SET is_active = TRUE WHERE gift_card_id = 2;
SAVEPOINT status_updated;
UPDATE GiftCards SET expiry_date = DATE_ADD(CURDATE(), INTERVAL 6 MONTH) WHERE gift_card_id = 2;
COMMIT;

-- 12. TCL: Rollback gift card update
START TRANSACTION;
UPDATE GiftCards SET balance = 200 WHERE gift_card_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON GiftCards TO 'user22'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON GiftCards TO 'giftcard_manager';

-- 15. Trigger: Log gift card updates
DELIMITER //
CREATE TRIGGER LogGiftCardUpdate
AFTER UPDATE ON GiftCards
FOR EACH ROW
BEGIN
    IF OLD.balance != NEW.balance THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'GiftCard Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('GiftCard ID: ', NEW.gift_card_id, ' Balance changed to ', NEW.balance),
                'GiftCards', 'Balance update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate gift card balance
DELIMITER //
CREATE TRIGGER ValidateGiftCardBalance
BEFORE INSERT ON GiftCards
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Balance cannot be negative';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log gift card deactivation
DELIMITER //
CREATE TRIGGER LogGiftCardDeactivation
AFTER UPDATE ON GiftCards
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'GiftCard Deactivation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('GiftCard ID: ', NEW.gift_card_id, ' deactivated'),
                'GiftCards', 'Deactivation');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank gift cards by balance
SELECT gift_card_id, customer_id, balance,
       RANK() OVER (PARTITION BY customer_id ORDER BY balance DESC) AS balance_rank
FROM GiftCards;

-- 19. Window Function: Running total of gift cards
SELECT gift_card_id, customer_id, balance,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY issue_date) AS gift_card_count
FROM GiftCards;

-- 20. Window Function: Balance percentage by customer
SELECT gift_card_id, customer_id, balance,
       balance / SUM(balance) OVER (PARTITION BY customer_id) * 100 AS balance_percentage
FROM GiftCards;

-- Table 23: Coupons
-- 1. View: Active coupons
CREATE VIEW ActiveCoupons AS
SELECT coupon_id, coupon_code, discount_amount
FROM Coupons
WHERE is_active = TRUE AND expiry_date >= CURDATE();

-- 2. View: Coupons with customers
CREATE VIEW CouponsWithCustomers AS
SELECT cp.coupon_id, c.first_name, c.last_name, cp.discount_amount
FROM Coupons cp
JOIN Customers c ON cp.customer_id = c.customer_id;

-- 3. View: High-discount coupons
CREATE VIEW HighDiscountCoupons AS
SELECT coupon_id, coupon_code, discount_amount
FROM Coupons
WHERE discount_amount > 25;

-- 4. CTE: Coupon usage by customer
WITH CouponUsage AS (
    SELECT customer_id, COUNT(*) AS coupon_count
    FROM Coupons
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cu.coupon_count
FROM CouponUsage cu
JOIN Customers c ON cu.customer_id = c.customer_id;

-- 5. CTE: Recent coupons
WITH RecentCoupons AS (
    SELECT coupon_id, coupon_code, issue_date
    FROM Coupons
    WHERE issue_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT cp.coupon_id, c.first_name, cp.issue_date
FROM RecentCoupons cp
JOIN Customers c ON cp.customer_id = c.customer_id;

-- 6. CTE: Ranked coupons by discount
WITH RankedCoupons AS (
    SELECT coupon_id, customer_id, discount_amount,
           RANK() OVER (PARTITION BY customer_id ORDER BY discount_amount DESC) AS discount_rank
    FROM Coupons
)
SELECT coupon_id, customer_id, discount_amount, discount_rank
FROM RankedCoupons
WHERE discount_rank <= 2;

-- 7. Stored Procedure: Update coupon amount
DELIMITER //
CREATE PROCEDURE UpdateCouponAmount(IN cp_id INT, IN new_amount DECIMAL(10,2))
BEGIN
    UPDATE Coupons SET discount_amount = new_amount WHERE coupon_id = cp_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate coupon
DELIMITER //
CREATE PROCEDURE DeactivateCoupon(IN cp_id INT)
BEGIN
    UPDATE Coupons SET is_active = FALSE WHERE coupon_id = cp_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add coupon
DELIMITER //
CREATE PROCEDURE AddCoupon(IN cust_id INT, IN code VARCHAR(50), IN amt DECIMAL(10,2))
BEGIN
    INSERT INTO Coupons (coupon_id, customer_id, coupon_code, discount_amount, issue_date, is_active, expiry_date)
    VALUES ((SELECT COALESCE(MAX(coupon_id), 0) + 1 FROM Coupons), cust_id, code, amt, CURDATE(), TRUE, DATE_ADD(CURDATE(), INTERVAL 6 MONTH));
END //
DELIMITER ;

-- 10. TCL: Update coupon with rollback
START TRANSACTION;
UPDATE Coupons SET discount_amount = 30 WHERE coupon_id = 1;
UPDATE Coupons SET is_active = TRUE WHERE coupon_id = 1;
-- Simulate error
INSERT INTO Coupons (coupon_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit coupon update
START TRANSACTION;
UPDATE Coupons SET expiry_date = DATE_ADD(CURDATE(), INTERVAL 3 MONTH) WHERE coupon_id = 2;
SAVEPOINT expiry_updated;
UPDATE Coupons SET coupon_code = 'COUPON2025' WHERE coupon_id = 2;
COMMIT;

-- 12. TCL: Rollback coupon update
START TRANSACTION;
UPDATE Coupons SET discount_amount = 40 WHERE coupon_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Coupons TO 'user23'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Coupons TO 'marketing_manager';

-- 15. Trigger: Log coupon updates
DELIMITER //
CREATE TRIGGER LogCouponUpdate
AFTER UPDATE ON Coupons
FOR EACH ROW
BEGIN
    IF OLD.discount_amount != NEW.discount_amount THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Coupon Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Coupon ID: ', NEW.coupon_id, ' Amount changed to ', NEW.discount_amount),
                'Coupons', 'Amount update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate coupon amount
DELIMITER //
CREATE TRIGGER ValidateCouponAmount
BEFORE INSERT ON Coupons
FOR EACH ROW
BEGIN
    IF NEW.discount_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Discount amount must be positive';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log coupon deactivation
DELIMITER //
CREATE TRIGGER LogCouponDeactivation
AFTER UPDATE ON Coupons
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Coupon Deactivation', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Coupon ID: ', NEW.coupon_id, ' deactivated'),
                'Coupons', 'Deactivation');
    END IF;
END;
// DELIITER ;

-- 18. Window Function: Rank coupons by discount
SELECT coupon_id, customer_id, discount_amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY discount_amount DESC) AS discount_rank
FROM Coupons;

-- 19. Window Function: Running total of coupons
SELECT coupon_id, customer_id, discount_amount,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY issue_date) AS coupon_count
FROM Coupons;

-- 20. Window Function: Discount percentage by customer
SELECT coupon_id, customer_id, discount_amount,
       discount_amount / SUM(discount_amount) OVER (PARTITION BY customer_id) * 100 AS discount_percentage
FROM Coupons;

-- Table 24: Feedback
-- 1. View: Approved feedback
CREATE VIEW ApprovedFeedback AS
SELECT feedback_id, customer_id, rating, comment
FROM Feedback
WHERE status = 'Approved';

-- 2. View: Feedback with customers
CREATE VIEW FeedbackWithCustomers AS
SELECT f.feedback_id, c.first_name, c.last_name, f.rating
FROM Feedback f
JOIN Customers c ON f.customer_id = c.customer_id;

-- 3. View: High-rated feedback
CREATE VIEW HighRatedFeedback AS
SELECT feedback_id, customer_id, rating
FROM Feedback
WHERE rating >= 4;

-- 4. CTE: Average rating by feedback type
WITH FeedbackAvgRating AS (
    SELECT feedback_type, AVG(rating) AS avg_rating
    FROM Feedback
    GROUP BY feedback_type
)
SELECT f.feedback_type, f.avg_rating
FROM FeedbackAvgRating f
WHERE f.avg_rating > 3;

-- 5. CTE: Recent feedback
WITH RecentFeedback AS (
    SELECT feedback_id, customer_id, submission_date
    FROM Feedback
    WHERE submission_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT f.feedback_id, c.first_name, f.submission_date
FROM RecentFeedback f
JOIN Customers c ON f.customer_id = c.customer_id;

-- 6. CTE: Ranked feedback by rating
WITH RankedFeedback AS (
    SELECT feedback_id, customer_id, rating,
           RANK() OVER (PARTITION BY customer_id ORDER BY rating DESC) AS rating_rank
    FROM Feedback
)
SELECT feedback_id, customer_id, rating, rating_rank
FROM RankedFeedback
WHERE rating_rank <= 2;

-- 7. Stored Procedure: Approve feedback
DELIMITER //
CREATE PROCEDURE ApproveFeedback(IN fb_id INT)
BEGIN
    UPDATE Feedback SET status = 'Approved' WHERE feedback_id = fb_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Get customer feedback
DELIMITER //
CREATE PROCEDURE GetCustomerFeedback(IN cust_id INT)
BEGIN
    SELECT feedback_id, rating, comment, submission_date
    FROM Feedback
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Add feedback
DELIMITER //
CREATE PROCEDURE AddFeedback(IN cust_id INT, IN rate INT, IN comm TEXT)
BEGIN
    INSERT INTO Feedback (feedback_id, customer_id, rating, comment, submission_date, status)
    VALUES ((SELECT COALESCE(MAX(feedback_id), 0) + 1 FROM Feedback), cust_id, rate, comm, CURDATE(), 'Pending');
END //
DELIMITER ;

-- 10. TCL: Update feedback with rollback
START TRANSACTION;
UPDATE Feedback SET rating = 5 WHERE feedback_id = 1;
UPDATE Feedback SET status = 'Approved' WHERE feedback_id = 1;
-- Simulate error
INSERT INTO Feedback (feedback_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit feedback update
START TRANSACTION;
UPDATE Feedback SET comment = 'Updated comment' WHERE feedback_id = 2;
SAVEPOINT comment_updated;
UPDATE Feedback SET submission_date = CURDATE() WHERE feedback_id = 2;
COMMIT;

-- 12. TCL: Rollback feedback update
START TRANSACTION;
UPDATE Feedback SET rating = 3 WHERE feedback_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Feedback TO 'user24'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Feedback TO 'feedback_manager';

-- 15. Trigger: Log feedback updates
DELIMITER //
CREATE TRIGGER LogFeedbackUpdate
AFTER UPDATE ON Feedback
FOR EACH ROW
BEGIN
    IF OLD.rating != NEW.rating THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Feedback Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Feedback ID: ', NEW.feedback_id, ' Rating changed to ', NEW.rating),
                'Feedback', 'Rating update');
    END IF;
END;
// DELIMITER ;

-- 16. Trigger: Validate feedback rating
DELIMITER //
CREATE TRIGGER ValidateFeedbackRating
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rating must be between 1 and 5';
    END IF;
END;
// DELIMITER ;

-- 17. Trigger: Log feedback approval
DELIMITER //
CREATE TRIGGER LogFeedbackApproval
AFTER UPDATE ON Feedback
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status AND NEW.status = 'Approved' THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Feedback Approval', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Feedback ID: ', NEW.feedback_id, ' approved'),
                'Feedback', 'Approval');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank feedback by rating
SELECT feedback_id, customer_id, rating,
       RANK() OVER (PARTITION BY customer_id ORDER BY rating DESC) AS rating_rank
FROM Feedback;

-- 19. Window Function: Running total of feedback
SELECT feedback_id, customer_id, rating,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY submission_date) AS feedback_count
FROM Feedback;

-- 20. Window Function: Rating percentage by customer
SELECT feedback_id, customer_id, rating,
       rating / SUM(rating) OVER (PARTITION BY customer_id) * 100 AS rating_percentage
FROM Feedback;

-- Table 25: Logs
-- 1. View: Recent logs
CREATE VIEW RecentLogs AS
SELECT log_id, user_id, action, log_date
FROM Logs
WHERE log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 2. View: Failed logs
CREATE VIEW FailedLogs AS
SELECT log_id, user_id, action, details
FROM Logs
WHERE status = 'Failed';

-- 3. View: Logs by module
CREATE VIEW LogsByModule AS
SELECT log_id, module, action, log_date
FROM Logs
WHERE module IS NOT NULL;

-- 4. CTE: Log count by user
WITH UserLogCount AS (
    SELECT user_id, COUNT(*) AS log_count
    FROM Logs
    GROUP BY user_id
)
SELECT u.first_name, u.last_name, ul.log_count
FROM UserLogCount ul
JOIN Customers u ON ul.user_id = u.customer_id;

-- 5. CTE: Recent actions
WITH RecentActions AS (
    SELECT log_id, user_id, action, log_date
    FROM Logs
    WHERE log_date >= DATE_SUB(CURDATE(), INTERVAL 24 HOUR)
)
SELECT l.log_id, c.first_name, l.action, l.log_date
FROM RecentActions l
JOIN Customers c ON l.user_id = c.customer_id;

-- 6. CTE: Ranked logs by module
WITH RankedLogs AS (
    SELECT log_id, module, log_date,
           RANK() OVER (PARTITION BY module ORDER BY log_date DESC) AS log_rank
    FROM Logs
)
SELECT log_id, module, log_date, log_rank
FROM RankedLogs
WHERE log_rank <= 5;

-- 7. Stored Procedure: Add log entry
DELIMITER //
CREATE PROCEDURE AddLogEntry(IN u_id INT, IN act VARCHAR(100), IN det TEXT)
BEGIN
    INSERT INTO Logs (log_id, user_id, action, log_date, ip_address, device_info, status, details, module)
    VALUES ((SELECT COALESCE(MAX(log_id), 0) + 1 FROM Logs), u_id, act, NOW(), '127.0.0.1', 'Unknown', 'Success', det, 'General');
END //
DELIMITER ;

-- 8. Stored Procedure: Get logs by user
DELIMITER //
CREATE PROCEDURE GetLogsByUser(IN u_id INT)
BEGIN
    SELECT log_id, action, log_date, details
    FROM Logs
    WHERE user_id = u_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Clear old logs
DELIMITER //
CREATE PROCEDURE ClearOldLogs()
BEGIN
    DELETE FROM Logs WHERE log_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 10. TCL: Update log with rollback
START TRANSACTION;
UPDATE Logs SET status = 'Failed' WHERE log_id = 1;
UPDATE Logs SET details = 'Updated error details' WHERE log_id = 1;
-- Simulate error
INSERT INTO Logs (log_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit log update
START TRANSACTION;
UPDATE Logs SET module = 'System' WHERE log_id = 2;
SAVEPOINT module_updated;
UPDATE Logs SET ip_address = '192.168.1.1' WHERE log_id = 2;
COMMIT;

-- 12. TCL: Rollback log update
START TRANSACTION;
UPDATE Logs SET action = 'System Check' WHERE log_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Logs TO 'user25'@'localhost';

-- 14. DCL: Grant insert permission
GRANT INSERT ON Logs TO 'system_admin';

-- 15. Trigger: Log log insertion
DELIMITER //
CREATE TRIGGER LogLogInsertion
AFTER INSERT ON Logs
FOR EACH ROW
BEGIN
    INSERT INTO Logs (log_id, user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES ((SELECT COALESCE(MAX(log_id), 0) + 1 FROM Logs), NEW.user_id, 'Log Insert', NOW(), '127.0.0.1', 'Unknown', 'Success',
            CONCAT('Log ID: ', NEW.log_id, ' created'), 'Logs', 'Meta log');
END;
// DELIMITER ;

-- 16. Trigger: Validate log status
DELIMITER //
CREATE TRIGGER ValidateLogStatus
BEFORE INSERT ON Logs
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Success', 'Failed', 'Pending') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid log status'
    END;
END;
// DELIMITER ;

-- 17. Trigger: Log log updates
DELIMITER //
CREATE TRIGGER LogLogUpdate
AFTER UPDATE ON Logs
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (log_id, user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES ((SELECT COALESCE(MAX(log_id), 0) + 1 FROM Logs), NEW.user_id, 'Log Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Log ID: ', NEW.log_id, ' Status changed to ', NEW.status), 'Logs', 'Meta log');
    END IF;
END;
// DELIMITER ;

-- 18. Window Function: Rank logs by date
SELECT log_id, user_id, log_date,
       RANK() OVER (PARTITION BY user_id ORDER BY log_date DESC) AS log_rank
FROM Logs;

-- 19. Window Function: Running total of logs
SELECT log_id, user_id, log_date,
       COUNT(*) OVER (PARTITION BY user_id ORDER BY log_date) AS log_count
FROM Logs;

-- 20. Window Function: Log percentage by module
SELECT log_id, module, log_date,
       COUNT(*) OVER (PARTITION BY module) / COUNT(*) OVER () * 100 AS log_percentage
FROM Logs;
