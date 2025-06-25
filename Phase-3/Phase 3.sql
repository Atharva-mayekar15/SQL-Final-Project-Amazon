-- Project Phase-3 (A<Joins<SQ<Fun<B&UD)

-- Products Table Queries
-- 1. Inner Join: Product details with category names
SELECT p.product_id, p.product_name, c.category_name, p.price
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE;

-- 2. Left Join: Products with supplier details
SELECT p.product_name, p.price, COALESCE(s.supplier_name, 'No Supplier') AS supplier
FROM Products p
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- 3. Right Join: Suppliers and their products
SELECT s.supplier_name, p.product_name
FROM Products p
RIGHT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- 4. Full Join (Emulated): Products and promotions
SELECT p.product_name, pr.promotion_name, pr.discount_percentage
FROM Products p
LEFT JOIN Promotions pr ON p.product_id = pr.product_id
UNION
SELECT p.product_name, pr.promotion_name, pr.discount_percentage
FROM Products p
RIGHT JOIN Promotions pr ON p.product_id = pr.product_id
WHERE p.product_id IS NULL;

-- 5. Subquery (Simple): Products with above-average stock quantity
SELECT product_name, stock_quantity
FROM Products
WHERE stock_quantity > (SELECT AVG(stock_quantity) FROM Products);

-- 6. Subquery (Complex): Products in customer carts
SELECT product_name, price
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Carts c
    WHERE c.product_id = p.product_id AND c.is_active = TRUE
);

-- 7. Function (Aggregation): Total stock value by category
SELECT c.category_name, SUM(p.price * p.stock_quantity) AS total_value
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- 8. Function (String): Uppercase product names and abbreviated description
SELECT UPPER(product_name) AS product_name, SUBSTRING(description, 1, 20) AS short_desc
FROM Products
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new product
INSERT INTO Products (product_id, product_name, category_id, price, stock_quantity, supplier_id, rating, release_date, is_active, description)
VALUES (21, 'Wireless Keyboard', 2, 79.99, 100, 108, 4.2, '2025-05-25', TRUE, 'Ergonomic wireless keyboard');

-- 10. Update/Delete: Increase stock for low-stock products
UPDATE Products
SET stock_quantity = stock_quantity + 50
WHERE stock_quantity < 50 AND is_active = TRUE;

-- Customers Table Queries
-- 1. Inner Join: Customers with their orders
SELECT c.customer_id, c.first_name, c.last_name, o.order_id
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- 2. Left Join: Customers with addresses
SELECT c.first_name, c.last_name, a.street
FROM Customers c
LEFT JOIN Addresses a ON c.customer_id = a.customer_id;

-- 3. Right Join: Addresses with customer details
SELECT a.street, a.city, c.first_name
FROM Customers c
RIGHT JOIN Addresses a ON c.customer_id = a.customer_id;

-- 4. Full Join (Emulated): Customers and subscriptions
SELECT c.first_name, c.last_name, s.plan_name
FROM Customers c
LEFT JOIN Subscriptions s ON c.customer_id = s.customer_id
UNION
SELECT c.first_name, c.last_name, s.plan_name
FROM Customers c
RIGHT JOIN Subscriptions s ON c.customer_id = s.customer_id
WHERE c.customer_id IS NULL;

-- 5. Subquery (Simple): Customers with above-average loyalty points
SELECT first_name, last_name, loyalty_points
FROM Customers
WHERE loyalty_points > (SELECT AVG(loyalty_points) FROM Customers);

-- 6. Subquery (Complex): Customers with multiple orders
SELECT first_name, last_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id AND o.quantity > 1
);

-- 7. Function (Aggregation): Count customers per city
SELECT city, COUNT(*) AS customer_count
FROM Customers
GROUP BY city;

-- 8. Function (String): Concatenate full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name, email
FROM Customers
WHERE state = 'CA';

-- 9. Basic Operation (SELECT): Select active customers
SELECT customer_id, first_name, last_name
FROM Customers
WHERE email IS NOT NULL;

-- 10. Update/Delete: Update customer email domain
UPDATE Customers
SET email = REPLACE(email, 'email.com', 'newemail.com')
WHERE city = 'New York';

-- Orders Table Queries
-- 1. Inner Join: Orders with product details
SELECT o.order_id, p.product_name, o.quantity
FROM Orders o
INNER JOIN Products p ON o.product_id = p.product_id;

-- 2. Left Join: Orders with shipment details
SELECT o.order_id, o.total_price, s.carrier
FROM Orders o
LEFT JOIN Shipments s ON o.order_id = s.order_id;

-- 3. Right Join: Shipments with order details
SELECT s.tracking_number, o.order_id
FROM Orders o
RIGHT JOIN Shipments s ON o.order_id = s.order_id;

-- 4. Full Join (Emulated): Orders and payments
SELECT o.order_id, p.amount
FROM Orders o
LEFT JOIN Payments p ON o.order_id = p.order_id
UNION
SELECT o.order_id, p.amount
FROM Orders o
RIGHT JOIN Payments p ON o.order_id = p.order_id
WHERE o.order_id IS NULL;

-- 5. Subquery (Simple): Orders with above-average total price
SELECT order_id, total_price
FROM Orders
WHERE total_price > (SELECT AVG(total_price) FROM Orders);

-- 6. Subquery (Complex): Orders from customers in New York
SELECT order_id, total_price
FROM Orders o
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE city = 'New York'
);

-- 7. Function (Aggregation): Total orders by status
SELECT status, COUNT(*) AS order_count
FROM Orders
GROUP BY status;

-- 8. Function (Date): Format order dates
SELECT order_id, DATE_FORMAT(order_date, '%Y-%m-%d') AS formatted_date
FROM Orders
WHERE status = 'Processing';

-- 9. Basic Operation (INSERT): Add a new order
INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity, total_price, shipping_address, status, payment_method, tracking_number)
VALUES (21, 1, 1, '2025-05-25', 1, 999.99, '123 Main St, New York, NY 10001', 'Processing', 'Credit Card', 'TRK123476');

-- 10. Update/Delete: Cancel old pending orders
UPDATE Orders
SET status = 'Canceled'
WHERE status = 'Processing' AND order_date < DATEADD(MONTH, -1, '2025-05-25');

-- Suppliers Table Queries
-- 1. Inner Join: Suppliers with their products
SELECT s.supplier_id, s.supplier_name, p.product_name
FROM Suppliers s
INNER JOIN Products p ON s.supplier_id = p.supplier_id;

-- 2. Left Join: Suppliers with product counts
SELECT s.supplier_name, COUNT(p.product_id) AS product_count
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name;

-- 3. Right Join: Products with supplier details
SELECT p.product_name, s.supplier_name
FROM Suppliers s
RIGHT JOIN Products p ON s.supplier_id = p.supplier_id;

-- 4. Full Join (Emulated): Suppliers and inventory
SELECT s.supplier_name, i.quantity
FROM Suppliers s
LEFT JOIN Inventory i ON s.supplier_id = (SELECT supplier_id FROM Products WHERE product_id = i.product_id)
UNION
SELECT s.supplier_name, i.quantity
FROM Suppliers s
RIGHT JOIN Inventory i ON s.supplier_id = (SELECT supplier_id FROM Products WHERE product_id = i.product_id)
WHERE s.supplier_id IS NULL;

-- 5. Subquery (Simple): Suppliers with above-average product count
SELECT supplier_name
FROM Suppliers s
WHERE (SELECT COUNT(*) FROM Products p WHERE p.supplier_id = s.supplier_id) > (SELECT AVG(COUNT(*)) FROM Products GROUP BY supplier_id);

-- 6. Subquery (Complex): Suppliers providing high-rated products
SELECT supplier_name
FROM Suppliers s
WHERE EXISTS (
    SELECT 1
    FROM Products p
    WHERE p.supplier_id = s.supplier_id AND p.rating >= 4.5
);

-- 7. Function (Aggregation): Count suppliers per city
SELECT city, COUNT(*) AS supplier_count
FROM Suppliers
GROUP BY city;

-- 8. Function (String): Lowercase supplier emails
SELECT supplier_name, LOWER(contact_email) AS email
FROM Suppliers
WHERE state = 'CA';

-- 9. Basic Operation (SELECT): Select active suppliers
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE contact_email IS NOT NULL;

-- 10. Update/Delete: Update supplier phone numbers
UPDATE Suppliers
SET contact_phone = '555-9999'
WHERE city = 'San Francisco';

-- Categories Table Queries
-- 1. Inner Join: Categories with their products
SELECT c.category_id, c.category_name, p.product_name
FROM Categories c
INNER JOIN Products p ON c.category_id = p.category_id;

-- 2. Left Join: Categories with product counts
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- 3. Right Join: Products with category details
SELECT p.product_name, c.category_name
FROM Categories c
RIGHT JOIN Products p ON c.category_id = p.category_id;

-- 4. Full Join (Emulated): Categories and parent categories
SELECT c.category_name, pc.category_name AS parent_category
FROM Categories c
LEFT JOIN Categories pc ON c.parent_category_id = pc.category_id
UNION
SELECT c.category_name, pc.category_name AS parent_category
FROM Categories c
RIGHT JOIN Categories pc ON c.parent_category_id = pc.category_id
WHERE c.category_id IS NULL;

-- 5. Subquery (Simple): Categories with above-average product count
SELECT category_name
FROM Categories c
WHERE (SELECT COUNT(*) FROM Products p WHERE p.category_id = c.category_id) > (SELECT AVG(COUNT(*)) FROM Products GROUP BY category_id);

-- 6. Subquery (Complex): Categories with high-priced products
SELECT category_name
FROM Categories c
WHERE EXISTS (
    SELECT 1
    FROM Products p
    WHERE p.category_id = c.category_id AND p.price > 500
);

-- 7. Function (Aggregation): Count products per category
SELECT category_name, COUNT(*) AS product_count
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY category_name;

-- 8. Function (String): Abbreviate category descriptions
SELECT category_name, SUBSTRING(description, 1, 15) AS short_desc
FROM Categories
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new category
INSERT INTO Categories (category_id, category_name, parent_category_id, description, created_date, is_active, display_order, image_url, meta_title, meta_description)
VALUES (21, 'Gadgets', 1, 'Innovative gadgets', '2025-05-25', TRUE, 21, 'gadgets.jpg', 'Gadgets', 'Shop innovative gadgets');

-- 10. Update/Delete: Deactivate old categories
UPDATE Categories
SET is_active = FALSE
WHERE created_date < DATEADD(YEAR, -3, '2025-05-25');

-- Reviews Table Queries
-- 1. Inner Join: Reviews with product names
SELECT r.review_id, p.product_name, r.rating
FROM Reviews r
INNER JOIN Products p ON r.product_id = p.product_id;

-- 2. Left Join: Reviews with customer names
SELECT r.review_id, r.rating, c.first_name
FROM Reviews r
LEFT JOIN Customers c ON r.customer_id = c.customer_id;

-- 3. Right Join: Customers with their reviews
SELECT c.first_name, r.rating
FROM Reviews r
RIGHT JOIN Customers c ON r.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Reviews and orders
SELECT r.review_id, o.order_id
FROM Reviews r
LEFT JOIN Orders o ON r.product_id = o.product_id AND r.customer_id = o.customer_id
UNION
SELECT r.review_id, o.order_id
FROM Reviews r
RIGHT JOIN Orders o ON r.product_id = o.product_id AND r.customer_id = o.customer_id
WHERE r.review_id IS NULL;

-- 5. Subquery (Simple): High-rated reviews
SELECT review_id, comment
FROM Reviews
WHERE rating > (SELECT AVG(rating) FROM Reviews);

-- 6. Subquery (Complex): Verified reviews for popular products
SELECT comment, rating
FROM Reviews r
WHERE is_verified = TRUE AND product_id IN (
    SELECT product_id
    FROM Orders
    GROUP BY product_id
    HAVING COUNT(*) > 1
);

-- 7. Function (Aggregation): Average rating per product
SELECT p.product_name, AVG(r.rating) AS avg_rating
FROM Reviews r
JOIN Products p ON r.product_id = p.product_id
GROUP BY p.product_name;

-- 8. Function (Numeric): Round review ratings
SELECT review_id, ROUND(rating, 1) AS rounded_rating
FROM Reviews
WHERE is_verified = TRUE;

-- 9. Basic Operation (SELECT): Select approved reviews
SELECT review_id, comment
FROM Reviews
WHERE status = 'Approved';

-- 10. Update/Delete: Mark low-rated reviews as pending
UPDATE Reviews
SET status = 'Pending'
WHERE rating < 3 AND status = 'Approved';

-- Payments Table Queries
-- 1. Inner Join: Payments with order details
SELECT p.payment_id, o.order_id, p.amount
FROM Payments p
INNER JOIN Orders o ON p.order_id = o.order_id;

-- 2. Left Join: Payments with customer details
SELECT p.payment_id, c.first_name, p.amount
FROM Payments p
LEFT JOIN Customers c ON p.customer_id = c.customer_id;

-- 3. Right Join: Customers with payment details
SELECT c.first_name, p.amount
FROM Payments p
RIGHT JOIN Customers c ON p.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Payments and transactions
SELECT p.payment_id, t.transaction_id
FROM Payments p
LEFT JOIN Transactions t ON p.payment_id = t.payment_id
UNION
SELECT p.payment_id, t.transaction_id
FROM Payments p
RIGHT JOIN Transactions t ON p.payment_id = t.payment_id
WHERE p.payment_id IS NULL;

-- 5. Subquery (Simple): Payments above average amount
SELECT payment_id, amount
FROM Payments
WHERE amount > (SELECT AVG(amount) FROM Payments);

-- 6. Subquery (Complex): Payments for orders with high quantity
SELECT payment_id, amount
FROM Payments p
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE quantity > 2
);

-- 7. Function (Aggregation): Total payments by method
SELECT payment_method, SUM(amount) AS total_amount
FROM Payments
GROUP BY payment_method;

-- 8. Function (Numeric): Ceiling payment amounts
SELECT payment_id, CEIL(amount) AS ceiling_amount
FROM Payments
WHERE status = 'Completed';

-- 9. Basic Operation (INSERT): Add a new payment
INSERT INTO Payments (payment_id, order_id, customer_id, amount, payment_date, payment_method, transaction_id, status, currency, notes)
VALUES (21, 21, 1, 999.99, '2025-05-25', 'Credit Card', 'TXN123476', 'Pending', 'USD', 'Payment for new order');

-- 10. Update/Delete: Cancel pending payments
UPDATE Payments
SET status = 'Canceled'
WHERE status = 'Pending' AND payment_date < DATEADD(MONTH, -1, '2025-05-25');

-- Shipments Table Queries
-- 1. Inner Join: Shipments with order details
SELECT s.shipment_id, o.order_id, s.carrier
FROM Shipments s
INNER JOIN Orders o ON s.order_id = s.order_id;

-- 2. Left Join: Shipments with warehouse details
SELECT s.shipment_id, w.warehouse_name
FROM Shipments s
LEFT JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;

-- 3. Right Join: Warehouses with shipment details
SELECT w.warehouse_name, s.shipment_id
FROM Shipments s
RIGHT JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;

-- 4. Full Join (Emulated): Shipments and orders
SELECT s.shipment_id, o.order_id
FROM Shipments s
LEFT JOIN Orders o ON s.order_id = o.order_id
UNION
SELECT s.shipment_id, o.order_id
FROM Shipments s
RIGHT JOIN Orders o ON s.order_id = o.order_id
WHERE s.shipment_id IS NULL;

-- 5. Subquery (Simple): High-cost shipments
SELECT shipment_id, shipping_cost
FROM Shipments
WHERE shipping_cost > (SELECT AVG(shipping_cost) FROM Shipments);

-- 6. Subquery (Complex): Shipments for high-value orders
SELECT shipment_id, carrier
FROM Shipments s
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE total_price > 500
);

-- 7. Function (Aggregation): Total shipping cost by carrier
SELECT carrier, SUM(shipping_cost) AS total_cost
FROM Shipments
GROUP BY carrier;

-- 8. Function (Date): Days until delivery
SELECT shipment_id, DATEDIFF(estimated_delivery, '2025-05-25') AS days_to_delivery
FROM Shipments
WHERE status = 'In Transit';

-- 9. Basic Operation (SELECT): Select in-transit shipments
SELECT shipment_id, tracking_number
FROM Shipments
WHERE status = 'In Transit';

-- 10. Update/Delete: Update shipment status
UPDATE Shipments
SET status = 'Delivered'
WHERE estimated_delivery <= '2025-05-25' AND status = 'In Transit';

-- Warehouses Table Queries
-- 1. Inner Join: Warehouses with inventory details
SELECT w.warehouse_id, w.warehouse_name, i.quantity
FROM Warehouses w
INNER JOIN Inventory i ON w.warehouse_id = i.warehouse_id;

-- 2. Left Join: Warehouses with shipment counts
SELECT w.warehouse_name, COUNT(s.shipment_id) AS shipment_count
FROM Warehouses w
LEFT JOIN Shipments s ON w.warehouse_id = s.warehouse_id
GROUP BY w.warehouse_name;

-- 3. Right Join: Shipments with warehouse details
SELECT s.shipment_id, w.warehouse_name
FROM Warehouses w
RIGHT JOIN Shipments s ON w.warehouse_id = s.warehouse_id;

-- 4. Full Join (Emulated): Warehouses and products
SELECT w.warehouse_name, p.product_name
FROM Warehouses w
LEFT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
JOIN Products p ON i.product_id = p.product_id
UNION
SELECT w.warehouse_name, p.product_name
FROM Warehouses w
RIGHT JOIN Inventory i ON w.warehouse_id = i.warehouse_id
JOIN Products p ON i.product_id = p.product_id
WHERE w.warehouse_id IS NULL;

-- 5. Subquery (Simple): Warehouses with above-average capacity
SELECT warehouse_name, capacity
FROM Warehouses
WHERE capacity > (SELECT AVG(capacity) FROM Warehouses);

-- 6. Subquery (Complex): Warehouses storing low-stock products
SELECT warehouse_name
FROM Warehouses w
WHERE EXISTS (
    SELECT 1
    FROM Inventory i
    WHERE i.warehouse_id = w.warehouse_id AND i.quantity < i.min_stock_level
);

-- 7. Function (Aggregation): Total capacity by state
SELECT state, SUM(capacity) AS total_capacity
FROM Warehouses
GROUP BY state;

-- 8. Function (String): Format manager names
SELECT CONCAT(manager_name, ' (', city, ')') AS manager_location
FROM Warehouses
WHERE capacity > 5000;

-- 9. Basic Operation (INSERT): Add a new warehouse
INSERT INTO Warehouses (warehouse_id, warehouse_name, address, city, state, zip_code, manager_name, contact_phone, capacity, operational_since)
VALUES (21, 'Miami Hub', '1818 Depot St', 'Miami', 'FL', '33102', 'John Doe', '555-0321', 7500, '2025-05-25');

-- 10. Update/Delete: Update warehouse capacity
UPDATE Warehouses
SET capacity = capacity + 1000
WHERE city = 'New York';

-- Inventory Table Queries
-- 1. Inner Join: Inventory with product details
SELECT i.inventory_id, p.product_name, i.quantity
FROM Inventory i
INNER JOIN Products p ON i.product_id = p.product_id;

-- 2. Left Join: Inventory with warehouse details
SELECT i.inventory_id, w.warehouse_name, i.quantity
FROM Inventory i
LEFT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- 3. Right Join: Warehouses with inventory details
SELECT w.warehouse_name, i.quantity
FROM Inventory i
RIGHT JOIN Warehouses w ON i.warehouse_id = w.warehouse_id;

-- 4. Full Join (Emulated): Inventory and products
SELECT i.inventory_id, p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
UNION
SELECT i.inventory_id, p.product_name
FROM Inventory i
RIGHT JOIN Products p ON i.product_id = p.product_id
WHERE i.inventory_id IS NULL;

-- 5. Subquery (Simple): Low-stock inventory
SELECT product_id, quantity
FROM Inventory
WHERE quantity < (SELECT AVG(min_stock_level) FROM Inventory);

-- 6. Subquery (Complex): Inventory for frequently ordered products
SELECT i.product_id, i.quantity
FROM Inventory i
WHERE product_id IN (
    SELECT product_id
    FROM Orders
    GROUP BY product_id
    HAVING COUNT(*) > 2
);

-- 7. Function (Aggregation): Total quantity by warehouse
SELECT w.warehouse_name, SUM(i.quantity) AS total_quantity
FROM Inventory i
JOIN Warehouses w ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name;

-- 8. Function (Numeric): Calculate reorder urgency
SELECT product_id, FLOOR((max_stock_level - quantity) / reorder_quantity) AS reorder_urgency
FROM Inventory
WHERE status = 'In Stock';

-- 9. Basic Operation (SELECT): Select low-stock items
SELECT product_id, quantity
FROM Inventory
WHERE quantity < min_stock_level;

-- 10. Update/Delete: Update inventory status
UPDATE Inventory
SET status = 'Low Stock'
WHERE quantity < min_stock_level;

-- Promotions Table Queries
-- 1. Inner Join: Promotions with product details
SELECT pr.promotion_id, p.product_name, pr.discount_percentage
FROM Promotions pr
INNER JOIN Products p ON pr.product_id = p.product_id;

-- 2. Left Join: Promotions with order counts
SELECT pr.promotion_name, COUNT(o.order_id) AS order_count
FROM Promotions pr
LEFT JOIN Orders o ON pr.product_id = o.product_id
GROUP BY pr.promotion_name;

-- 3. Right Join: Products with promotion details
SELECT p.product_name, pr.promotion_name
FROM Promotions pr
RIGHT JOIN Products p ON pr.product_id = p.product_id;

-- 4. Full Join (Emulated): Promotions and discounts
SELECT pr.promotion_name, d.discount_code
FROM Promotions pr
LEFT JOIN Discounts d ON pr.product_id = d.product_id
UNION
SELECT pr.promotion_name, d.discount_code
FROM Promotions pr
RIGHT JOIN Discounts d ON pr.product_id = d.product_id
WHERE pr.promotion_id IS NULL;

-- 5. Subquery (Simple): High-discount promotions
SELECT promotion_name, discount_percentage
FROM Promotions
WHERE discount_percentage > (SELECT AVG(discount_percentage) FROM Promotions);

-- 6. Subquery (Complex): Promotions for high-rated products
SELECT promotion_name
FROM Promotions pr
WHERE product_id IN (
    SELECT product_id
    FROM Reviews
    WHERE rating >= 4
);

-- 7. Function (Aggregation): Average discount by product
SELECT p.product_name, AVG(pr.discount_percentage) AS avg_discount
FROM Promotions pr
JOIN Products p ON pr.product_id = p.product_id
GROUP BY p.product_name;

-- 8. Function (Date): Days until promotion ends
SELECT promotion_name, DATEDIFF(end_date, '2025-05-25') AS days_remaining
FROM Promotions
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new promotion
INSERT INTO Promotions (promotion_id, promotion_name, product_id, discount_percentage, start_date, end_date, is_active, created_by, max_uses, description)
VALUES (21, 'Gadget Sale', 21, 15.00, '2025-05-25', DATEADD(MONTH, 1, '2025-05-25'), TRUE, 'Admin21', 100, 'Gadget discount');

-- 10. Update/Delete: Deactivate expired promotions
UPDATE Promotions
SET is_active = FALSE
WHERE end_date < '2025-05-25';

-- Returns Table Queries
-- 1. Inner Join: Returns with order details
SELECT r.return_id, o.order_id, r.refund_amount
FROM Returns r
INNER JOIN Orders o ON r.order_id = o.order_id;

-- 2. Left Join: Returns with product details
SELECT r.return_id, p.product_name, r.reason
FROM Returns r
LEFT JOIN Products p ON r.product_id = p.product_id;

-- 3. Right Join: Products with return details
SELECT p.product_name, r.return_id
FROM Returns r
RIGHT JOIN Products p ON r.product_id = p.product_id;

-- 4. Full Join (Emulated): Returns and customers
SELECT r.return_id, c.first_name
FROM Returns r
LEFT JOIN Customers c ON r.customer_id = c.customer_id
UNION
SELECT r.return_id, c.first_name
FROM Returns r
RIGHT JOIN Customers c ON r.customer_id = c.customer_id
WHERE r.return_id IS NULL;

-- 5. Subquery (Simple): High-refunded returns
SELECT return_id, refund_amount
FROM Returns
WHERE refund_amount > (SELECT AVG(refund_amount) FROM Returns);

-- 6. Subquery (Complex): Returns for high-quantity orders
SELECT return_id, reason
FROM Returns r
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE quantity > 2
);

-- 7. Function (Aggregation): Total refunds by reason
SELECT reason, SUM(refund_amount) AS total_refunded
FROM Returns
GROUP BY reason;

-- 8. Function (String): Replace return reasons
SELECT return_id, REPLACE(reason, 'Defective', 'Faulty') AS reason
FROM Returns
WHERE status = 'Approved';

-- 9. Basic Operation (SELECT): Select pending returns
SELECT return_id, reason
FROM Returns
WHERE status = 'Pending';

-- 10. Update/Delete: Approve pending returns
UPDATE Returns
SET status = 'Approved'
WHERE return_date < DATEADD(DAY, -7, '2025-05-25') AND status = 'Pending';

-- Wishlists Table Queries
-- 1. Inner Join: Wishlists with product details
SELECT w.wishlist_id, p.product_name, w.quantity
FROM Wishlists w
INNER JOIN Products p ON w.product_id = p.product_id;

-- 2. Left Join: Wishlists with customer details
SELECT w.wishlist_id, c.first_name, w.quantity
FROM Wishlists w
LEFT JOIN Customers c ON w.customer_id = c.customer_id;

-- 3. Right Join: Customers with wishlist details
SELECT c.first_name, w.wishlist_id
FROM Wishlists w
RIGHT JOIN Customers c ON w.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Wishlists and carts
SELECT w.wishlist_id, c.cart_id
FROM Wishlists w
LEFT JOIN Carts c ON w.customer_id = c.customer_id AND w.product_id = c.product_id
UNION
SELECT w.wishlist_id, c.cart_id
FROM Wishlists w
RIGHT JOIN Carts c ON w.customer_id = c.customer_id AND w.product_id = c.product_id
WHERE w.wishlist_id IS NULL;

-- 5. Subquery (Simple): Wishlists with high quantity
SELECT wishlist_id, quantity
FROM Wishlists
WHERE quantity > (SELECT AVG(quantity) FROM Wishlists);

-- 6. Subquery (Complex): Wishlists for high-priced products
SELECT wishlist_id, product_id
FROM Wishlists w
WHERE product_id IN (
    SELECT product_id
    FROM Products
    WHERE price > 500
);

-- 7. Function (Aggregation): Count wishlist items per customer
SELECT c.first_name, COUNT(w.wishlist_id) AS item_count
FROM Wishlists w
JOIN Customers c ON w.customer_id = c.customer_id
GROUP BY c.first_name;

-- 8. Function (Numeric): Format wishlist quantities
SELECT wishlist_id, FORMAT(quantity, 'N0') AS formatted_quantity
FROM Wishlists
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new wishlist item
INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date, quantity, notes, is_active, last_updated, category_id, status)
VALUES (21, 1, 21, '2025-05-25', 1, 'New gadget', TRUE, '2025-05-25', 1, 'Active');

-- 10. Update/Delete: Remove inactive wishlist items
DELETE FROM Wishlists
WHERE is_active = FALSE;

-- Carts Table Queries
-- 1. Inner Join: Carts with product details
SELECT c.cart_id, p.product_name, c.quantity
FROM Carts c
INNER JOIN Products p ON c.product_id = p.product_id;

-- 2. Left Join: Carts with customer details
SELECT c.cart_id, c.first_name, c.total_price
FROM Carts c
LEFT JOIN Customers c ON c.customer_id = c.customer_id;

-- 3. Right Join: Customers with cart details
SELECT c.first_name, c.cart_id
FROM Carts c
RIGHT JOIN Customers c ON c.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Carts and orders
SELECT c.cart_id, o.order_id
FROM Carts c
LEFT JOIN Orders o ON c.customer_id = o.customer_id AND c.product_id = o.product_id
UNION
SELECT c.cart_id, o.order_id
FROM Carts c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id AND c.product_id = o.product_id
WHERE c.cart_id IS NULL;

-- 5. Subquery (Simple): High-value carts
SELECT cart_id, total_price
FROM Carts
WHERE total_price > (SELECT AVG(total_price) FROM Carts);

-- 6. Subquery (Complex): Carts for customers with subscriptions
SELECT cart_id, product_id
FROM Carts c
WHERE customer_id IN (
    SELECT customer_id
    FROM Subscriptions
    WHERE is_active = TRUE
);

-- 7. Function (Aggregation): Total cart value by customer
SELECT c.first_name, SUM(c.total_price) AS total_cart_value
FROM Carts c
JOIN Customers c ON c.customer_id = c.customer_id
GROUP BY c.first_name;

-- 8. Function (Numeric): Price per item in carts
SELECT cart_id, CEIL(total_price / quantity) AS price_per_item
FROM Carts
WHERE is_active = TRUE;

-- 9. Basic Operation (SELECT): Select active carts
SELECT cart_id, product_id, quantity
FROM Carts
WHERE is_active = TRUE;

-- 10. Update/Delete: Clear old carts
DELETE FROM Carts
WHERE last_updated < DATEADD(MONTH, -6, '2025-05-25');

-- Employees Table Queries
-- 1. Inner Join: Employees with department details
SELECT e.employee_id, e.first_name, d.department_name
FROM Employees e
INNER JOIN Departments d ON e.department_id = d.department_id;

-- 2. Left Join: Employees with department details
SELECT e.first_name, e.last_name, d.department_name
FROM Employees e
LEFT JOIN Departments d ON e.department_id = d.department_id;

-- 3. Right Join: Departments with employee details
SELECT d.department_name, e.first_name
FROM Employees e
RIGHT JOIN Departments d ON e.department_id = d.department_id;

-- 4. Full Join (Emulated): Employees and logs
SELECT e.first_name, l.log_id
FROM Employees e
LEFT JOIN Logs l ON e.employee_id = l.user_id
UNION
SELECT e.first_name, l.log_id
FROM Employees e
RIGHT JOIN Logs l ON e.employee_id = l.user_id
WHERE e.employee_id IS NULL;

-- 5. Subquery (Simple): High-salary employees
SELECT first_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 6. Subquery (Complex): Employees in high-budget departments
SELECT first_name, last_name
FROM Employees e
WHERE department_id IN (
    SELECT department_id
    FROM Departments
    WHERE budget > 200000
);

-- 7. Function (Aggregation): Average salary by department
SELECT d.department_name, AVG(e.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 8. Function (String): Trim employee names
SELECT TRIM(first_name) AS first_name, email
FROM Employees
WHERE status = 'Active';

-- 9. Basic Operation (INSERT): Add a new employee
INSERT INTO Employees (employee_id, first_name, last_name, email, phone, hire_date, department_id, role, salary, status)
VALUES (21, 'Jane', 'Roe', 'jane.roe@company.com', '555-0421', '2025-05-25', 1, 'Manager', 82000.00, 'Active');

-- 10. Update/Delete: Update employee status
UPDATE Employees
SET status = 'Inactive'
WHERE hire_date < DATEADD(YEAR, -5, '2025-05-25');

-- Departments Table Queries
-- 1. Inner Join: Departments with manager details
SELECT d.department_id, d.department_name, e.first_name AS manager
FROM Departments d
INNER JOIN Employees e ON d.manager_id = e.employee_id;

-- 2. Left Join: Departments with employee counts
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;

-- 3. Right Join: Employees with department details
SELECT e.first_name, d.department_name
FROM Departments d
RIGHT JOIN Employees e ON d.department_id = e.department_id;

-- 4. Full Join (Emulated): Departments and logs
SELECT d.department_name, l.log_id
FROM Departments d
LEFT JOIN Logs l ON d.department_id = l.record_id
UNION
SELECT d.department_name, l.log_id
FROM Departments d
RIGHT JOIN Logs l ON d.department_id = l.record_id
WHERE d.department_id IS NULL;

-- 5. Subquery (Simple): High-budget departments
SELECT department_name, budget
FROM Departments
WHERE budget > (SELECT AVG(budget) FROM Departments);

-- 6. Subquery (Complex): Departments with multiple employees
SELECT department_name
FROM Departments d
WHERE EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.department_id = d.department_id AND e.salary > 50000
);

-- 7. Function (Aggregation): Total budget by location
SELECT location, SUM(budget) AS total_budget
FROM Departments
GROUP BY location;

-- 8. Function (String): Format department names
SELECT UPPER(department_name) AS department_name, contact_email
FROM Departments
WHERE is_active = TRUE;

-- 9. Basic Operation (SELECT): Select active departments
SELECT department_id, department_name
FROM Departments
WHERE is_active = TRUE;

-- 10. Update/Delete: Update department contact email
UPDATE Departments
SET contact_email = CONCAT(LOWER(department_name), '@company.com')
WHERE contact_email IS NULL;

-- Transactions Table Queries
-- 1. Inner Join: Transactions with payment details
SELECT t.transaction_id, p.amount, t.status
FROM Transactions t
INNER JOIN Payments p ON t.payment_id = p.payment_id;

-- 2. Left Join: Transactions with order details
SELECT t.transaction_id, o.order_id, t.amount
FROM Transactions t
LEFT JOIN Orders o ON t.order_id = o.order_id;

-- 3. Right Join: Orders with transaction details
SELECT o.order_id, t.transaction_id
FROM Transactions t
RIGHT JOIN Orders o ON t.order_id = o.order_id;

-- 4. Full Join (Emulated): Transactions and customers
SELECT t.transaction_id, c.first_name
FROM Transactions t
LEFT JOIN Customers c ON t.customer_id = c.customer_id
UNION
SELECT t.transaction_id, c.first_name
FROM Transactions t
RIGHT JOIN Customers c ON t.customer_id = c.customer_id
WHERE t.transaction_id IS NULL;

-- 5. Subquery (Simple): High-amount transactions
SELECT transaction_id, amount
FROM Transactions
WHERE amount > (SELECT AVG(amount) FROM Transactions);

-- 6. Subquery (Complex): Transactions for high-value orders
SELECT transaction_id, amount
FROM Transactions t
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE total_price > 500
);

-- 7. Function (Aggregation): Total transactions by gateway
SELECT gateway, COUNT(*) AS transaction_count
FROM Transactions
GROUP BY gateway;

-- 8. Function (Numeric): Absolute transaction amounts
SELECT transaction_id, ABS(amount) AS abs_amount
FROM Transactions
WHERE status = 'Success';

-- 9. Basic Operation (INSERT): Add a new transaction
INSERT INTO Transactions (transaction_id, payment_id, order_id, customer_id, amount, transaction_date, status, gateway, response_code, notes)
VALUES (21, 21, 21, 1, 999.99, '2025-05-25', 'Pending', 'Stripe', '100', 'New transaction');

-- 10. Update/Delete: Cancel pending transactions
UPDATE Transactions
SET status = 'Canceled'
WHERE status = 'Pending' AND transaction_date < DATEADD(MONTH, -1, '2025-05-25');

-- Discounts Table Queries
-- 1. Inner Join: Discounts with product details
SELECT d.discount_id, p.product_name, d.percentage
FROM Discounts d
INNER JOIN Products p ON d.product_id = p.product_id;

-- 2. Left Join: Discounts with order counts
SELECT d.discount_code, COUNT(o.order_id) AS order_count
FROM Discounts d
LEFT JOIN Orders o ON d.product_id = o.product_id
GROUP BY d.discount_code;

-- 3. Right Join: Products with discount details
SELECT p.product_name, d.discount_code
FROM Discounts d
RIGHT JOIN Products p ON d.product_id = p.product_id;

-- 4. Full Join (Emulated): Discounts and promotions
SELECT d.discount_code, pr.promotion_name
FROM Discounts d
LEFT JOIN Promotions pr ON d.product_id = pr.product_id
UNION
SELECT d.discount_code, pr.promotion_name
FROM Discounts d
RIGHT JOIN Promotions pr ON d.product_id = pr.product_id
WHERE d.discount_id IS NULL;

-- 5. Subquery (Simple): High-discount percentages
SELECT discount_code, percentage
FROM Discounts
WHERE percentage > (SELECT AVG(percentage) FROM Discounts);

-- 6. Subquery (Complex): Discounts for popular products
SELECT discount_code
FROM Discounts d
WHERE product_id IN (
    SELECT product_id
    FROM Orders
    GROUP BY product_id
    HAVING COUNT(*) > 1
);

-- 7. Function (Aggregation): Average discount by product
SELECT p.product_name, AVG(d.percentage) AS avg_discount
FROM Discounts d
JOIN Products p ON d.product_id = p.product_id
GROUP BY p.product_name;

-- 8. Function (String): Format discount codes
SELECT discount_id, CONCAT('DISC-', discount_code) AS formatted_code
FROM Discounts
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new discount
INSERT INTO Discounts (discount_id, discount_code, product_id, percentage, start_date, end_date, is_active, max_uses, created_by, description)
VALUES (21, 'GADGET15', 21, 15.00, '2025-05-25', DATEADD(MONTH, 1, '2025-05-25'), TRUE, 100, 'Admin21', 'Gadget discount');

-- 10. Update/Delete: Deactivate expired discounts
UPDATE Discounts
SET is_active = FALSE
WHERE end_date < '2025-05-25';

-- Taxes Table Queries
-- 1. Inner Join: Taxes with order details
SELECT t.tax_id, o.order_id, t.tax_amount
FROM Taxes t
INNER JOIN Orders o ON t.order_id = o.order_id;

-- 2. Left Join: Taxes with product details
SELECT t.tax_id, p.product_name, t.tax_rate
FROM Taxes t
LEFT JOIN Products p ON t.product_id = p.product_id;

-- 3. Right Join: Products with tax details
SELECT p.product_name, t.tax_id
FROM Taxes t
RIGHT JOIN Products p ON t.product_id = p.product_id;

-- 4. Full Join (Emulated): Taxes and orders
SELECT t.tax_id, o.order_id
FROM Taxes t
LEFT JOIN Orders o ON t.order_id = o.order_id
UNION
SELECT t.tax_id, o.order_id
FROM Taxes t
RIGHT JOIN Orders o ON t.order_id = o.order_id
WHERE t.tax_id IS NULL;

-- 5. Subquery (Simple): High-tax amounts
SELECT tax_id, tax_amount
FROM Taxes
WHERE tax_amount > (SELECT AVG(tax_amount) FROM Taxes);

-- 6. Subquery (Complex): Taxes for orders from New York
SELECT tax_id, tax_rate
FROM Taxes t
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE shipping_address LIKE '%New York%'
);

-- 7. Function (Aggregation): Total tax by region
SELECT region, SUM(tax_amount) AS total_tax
FROM Taxes
GROUP BY region;

-- 8. Function (Numeric): Round tax amounts
SELECT tax_id, ROUND(tax_amount, 2) AS rounded_tax
FROM Taxes
WHERE status = 'Applied';

-- 9. Basic Operation (SELECT): Select applied taxes
SELECT tax_id, tax_amount
FROM Taxes
WHERE status = 'Applied';

-- 10. Update/Delete: Update tax status
UPDATE Taxes
SET status = 'Applied'
WHERE tax_date < '2025-05-25' AND status = 'Pending';

-- Addresses Table Queries
-- 1. Inner Join: Addresses with customer details
SELECT a.address_id, c.first_name, a.street
FROM Addresses a
INNER JOIN Customers c ON a.customer_id = c.customer_id;

-- 2. Left Join: Addresses with order details
SELECT a.address_id, a.street, o.order_id
FROM Addresses a
LEFT JOIN Orders o ON a.street = o.shipping_address;

-- 3. Right Join: Customers with address details
SELECT c.first_name, a.street
FROM Addresses a
RIGHT JOIN Customers c ON a.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Addresses and orders
SELECT a.address_id, o.order_id
FROM Addresses a
LEFT JOIN Orders o ON a.street = o.shipping_address
UNION
SELECT a.address_id, o.order_id
FROM Addresses a
RIGHT JOIN Orders o ON a.street = o.shipping_address
WHERE a.address_id IS NULL;

-- 5. Subquery (Simple): Default addresses
SELECT street, city
FROM Addresses
WHERE is_default = TRUE AND customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE loyalty_points > 100
);

-- 6. Subquery (Complex): Addresses for customers with multiple orders
SELECT street, city
FROM Addresses a
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 2
);

-- 7. Function (Aggregation): Count addresses by state
SELECT state, COUNT(*) AS address_count
FROM Addresses
GROUP BY state;

-- 8. Function (String): Format full addresses
SELECT address_id, CONCAT(street, ', ', city, ', ', state) AS full_address
FROM Addresses
WHERE is_default = TRUE;

-- 9. Basic Operation (INSERT): Add a new address
INSERT INTO Addresses (address_id, customer_id, address_type, street, city, state, zip_code, country, is_default, notes)
VALUES (21, 1, 'Billing', '1818 Main St', 'Miami', 'FL', '33102', 'USA', FALSE, 'Secondary billing');

-- 10. Update/Delete: Update default addresses
UPDATE Addresses
SET is_default = FALSE
WHERE customer_id IN (SELECT customer_id FROM Customers WHERE city = 'New York') AND address_type = 'Shipping';

-- Subscriptions Table Queries
-- 1. Inner Join: Subscriptions with customer details
SELECT s.subscription_id, c.first_name, s.plan_name
FROM Subscriptions s
INNER JOIN Customers c ON s.customer_id = c.customer_id;

-- 2. Left Join: Subscriptions with order counts
SELECT s.plan_name, COUNT(o.order_id) AS order_count
FROM Subscriptions s
LEFT JOIN Orders o ON s.customer_id = o.customer_id
GROUP BY s.plan_name;

-- 3. Right Join: Customers with subscription details
SELECT c.first_name, s.plan_name
FROM Subscriptions s
RIGHT JOIN Customers c ON s.customer_id = c.customer_id;

-- 4. Full Join (Emulated): Subscriptions and payments
SELECT s.subscription_id, p.payment_id
FROM Subscriptions s
LEFT JOIN Payments p ON s.customer_id = p.customer_id
UNION
SELECT s.subscription_id, p.payment_id
FROM Subscriptions s
RIGHT JOIN Payments p ON s.customer_id = p.customer_id
WHERE s.subscription_id IS NULL;

-- 5. Subquery (Simple): High-amount subscriptions
SELECT plan_name, amount
FROM Subscriptions
WHERE amount > (SELECT AVG(amount) FROM Subscriptions);

-- 6. Subquery (Complex): Subscriptions for frequent buyers
SELECT plan_name
FROM Subscriptions s
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP=m
    BY customer_id
    HAVING COUNT(*) > 2
);

-- 7. Function (Aggregation): Total subscription amount by plan
SELECT plan_name, SUM(amount) AS total_amount
FROM Subscriptions
GROUP BY plan_name;

-- 8. Function (Date): Subscription duration
SELECT subscription_id, DATEDIFF(end_date, start_date) AS duration_days
FROM Subscriptions
WHERE is_active = TRUE;

-- 9. Basic Operation (SELECT): Select active subscriptions
SELECT subscription_id, plan_name
FROM Subscriptions
WHERE is_active = TRUE;

-- 10. Update/Delete: Cancel expired subscriptions
UPDATE Subscriptions
SET is_active = FALSE
WHERE end_date < '2025-05-25';

-- GiftCards Table Queries
-- 1. Inner Join: GiftCards with customer details
SELECT g.giftcard_id, c.first_name, g.balance
FROM GiftCards g
INNER JOIN Customers c ON g.customer_id = c.customer_id;

-- 2. Left Join: Gift cards with order details
SELECT g.giftcard_id, o.order_id, g.balance
FROM GiftCards g
LEFT JOIN Orders o ON g.order_id = o.order_id;

-- 3. Right Join: Orders with gift card details
SELECT o.order_id, g.giftcard_id
FROM GiftCards g
RIGHT JOIN Orders o ON g.order_id = o.order_id;

-- 4. Full Join (Emulated): Gift cards and payments
SELECT g.giftcard_id, p.payment_id
FROM GiftCards g
LEFT JOIN Payments p ON g.order_id = p.order_id
UNION
SELECT g.giftcard_id, p.payment_id
FROM GiftCards g
RIGHT JOIN Payments p ON g.order_id = p.order_id
WHERE g.giftcard_id IS NULL;

-- 5. Subquery (Simple): High-balance gift cards
SELECT giftcard_id, balance
FROM GiftCards
WHERE balance > (SELECT AVG(balance) FROM GiftCards);

-- 6. Subquery (Complex): Gift cards for high-value orders
SELECT giftcard_id, balance
FROM GiftCards g
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE total_price > 500
);

-- 7. Function (Aggregation): Total gift card balance by customer
SELECT c.first_name, SUM(g.balance) AS total_balance
FROM GiftCards g
JOIN Customers c ON g.customer_id = c.customer_id
GROUP BY c.first_name;

-- 8. Function (Numeric): Format gift card balances
SELECT giftcard_id, FORMAT(balance, 'C') AS formatted_balance
FROM GiftCards
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new gift card
INSERT INTO GiftCards (giftcard_id, customer_id, card_number, balance, issue_date, expiry_date, status, is_active, order_id, notes)
VALUES (21, 1, 'GC1234567910', 50.00, '2025-05-25', DATEADD(YEAR, 1, '2025-05-25'), 'Active', TRUE, 21, 'Gift card for new order');

-- 10. Update/Delete: Deactivate expired gift cards
UPDATE GiftCards
SET is_active = FALSE
WHERE expiry_date < '2025-05-25';

-- Coupons Table Queries
-- 1. Inner Join: Coupons with order details
SELECT c.coupon_id, o.order_id, c.discount_amount
FROM Coupons c
INNER JOIN Orders o ON c.order_id = o.order_id;

-- 2. Left Join: Coupons with product details
SELECT c.coupon_id, p.product_name, c.discount_amount
FROM Coupons c
LEFT JOIN Orders o ON c.order_id = o.order_id
JOIN Products p ON o.product_id = p.product_id;

-- 3. Right Join: Orders with coupon details
SELECT o.order_id, c.coupon_id
FROM Coupons c
RIGHT JOIN Orders o ON c.order_id = o.order_id;

-- 4. Full Join (Emulated): Coupons and discounts
SELECT c.coupon_id, d.discount_code
FROM Coupons c
LEFT JOIN Discounts d ON c.order_id = (SELECT order_id FROM Orders WHERE product_id = d.product_id)
UNION
SELECT c.coupon_id, d.discount_code
FROM Coupons c
RIGHT JOIN Discounts d ON c.order_id = (SELECT order_id FROM Orders WHERE product_id = d.product_id)
WHERE c.coupon_id IS NULL;

-- 5. Subquery (Simple): High-discount coupons
SELECT coupon_id, discount_amount
FROM Coupons
WHERE discount_amount > (SELECT AVG(discount_amount) FROM Coupons);

-- 6. Subquery (Complex): Coupons for high-value orders
SELECT coupon_id, discount_amount
FROM Coupons c
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE total_price > 500
);

-- 7. Function (Aggregation): Total discount amount by status
SELECT status, SUM(discount_amount) AS total_discount
FROM Coupons
GROUP BY status;

-- 8. Function (String): Uppercase coupon codes
SELECT coupon_id, UPPER(coupon_code) AS coupon_code
FROM Coupons
WHERE is_active = TRUE;

-- 9. Basic Operation (INSERT): Add a new coupon
INSERT INTO Coupons (coupon_id, coupon_code, order_id, discount_amount, issue_date, expiry_date, status, is_active, max_uses, notes)
VALUES (21, 'GADGET20', 21, 20.00, '2025-05-25', DATEADD(MONTH, 1, '2025-05-25'), 'Active', TRUE, 1, 'Gadget coupon');

-- 10. Update/Delete: Deactivate used coupons
UPDATE Coupons
SET is_active = FALSE
WHERE status = 'Used';

-- Feedback Table Queries
-- 1. Inner Join: Feedback with customer details
SELECT f.feedback_id, c.first_name, f.rating
FROM Feedback f
INNER JOIN Customers c ON f.customer_id = c.customer_id;

-- 2. Left Join: Feedback with order details
SELECT f.feedback_id, o.order_id, f.comment
FROM Feedback f
LEFT JOIN Orders o ON f.order_id = o.order_id;

-- 3. Right Join: Orders with feedback details
SELECT o.order_id, f.feedback_id
FROM Feedback f
RIGHT JOIN Orders o ON f.order_id = o.order_id;

-- 4. Full Join (Emulated): Feedback and reviews
SELECT f.feedback_id, r.review_id
FROM Feedback f
LEFT JOIN Reviews r ON f.customer_id = r.customer_id AND f.order_id = r.product_id
UNION
SELECT f.feedback_id, r.review_id
FROM Feedback f
RIGHT JOIN Reviews r ON f.customer_id = r.customer_id AND f.order_id = r.product_id
WHERE f.feedback_id IS NULL;

-- 5. Subquery (Simple): High-rated feedback
SELECT feedback_id, rating
FROM Feedback
WHERE rating > (SELECT AVG(rating) FROM Feedback);

-- 6. Subquery (Complex): Feedback for high-quantity orders
SELECT feedback_id, comment
FROM Feedback f
WHERE order_id IN (
    SELECT order_id
    FROM Orders
    WHERE quantity > 2
);

-- 7. Function (Aggregation): Average rating by category
SELECT category, AVG(rating) AS avg_rating
FROM Feedback
GROUP BY category;

-- 8. Function (String): Abbreviate feedback comments
SELECT feedback_id, SUBSTRING(comment, 1, 50) AS short_comment
FROM Feedback
WHERE is_anonymous = FALSE;

-- 9. Basic Operation (SELECT): Select approved feedback
SELECT feedback_id, comment
FROM Feedback
WHERE status = 'Approved';

-- 10. Update/Delete: Approve pending feedback
UPDATE Feedback
SET status = 'Approved'
WHERE feedback_date < DATEADD(DAY, -7, '2025-05-25') AND status = 'Pending';

-- Logs Table Queries
-- 1. Inner Join: Logs with employee details
SELECT l.log_id, e.first_name, l.action
FROM Logs l
INNER JOIN Employees e ON l.user_id = e.employee_id;

-- 2. Left Join: Logs with customer details
SELECT l.log_id, c.first_name, l.table_name
FROM Logs l
LEFT JOIN Customers c ON l.user_id = c.customer_id;

-- 3. Right Join: Employees with log details
SELECT e.first_name, l.log_id
FROM Logs l
RIGHT JOIN Employees e ON l.user_id = e.employee_id;

-- 4. Full Join (Emulated): Logs and orders
SELECT l.log_id, o.order_id
FROM Logs l
LEFT JOIN Orders o ON l.record_id = o.order_id AND l.table_name = 'Orders'
UNION
SELECT l.log_id, o.order_id
FROM Logs l
RIGHT JOIN Orders o ON l.record_id = o.order_id AND l.table_name = 'Orders'
WHERE l.log_id IS NULL;

-- 5. Subquery (Simple): Logs for order-related actions
SELECT log_id, action
FROM Logs
WHERE record_id IN (
    SELECT order_id
    FROM Orders
    WHERE total_price > 500
);

-- 6. Subquery (Complex): Logs for high-budget department actions
SELECT log_id, action
FROM Logs l
WHERE table_name = 'Employees' AND user_id IN (
    SELECT employee_id
    FROM Employees
    WHERE department_id IN (
        SELECT department_id
        FROM Departments
        WHERE budget > 200000
    )
);

-- 7. Function (Aggregation): Count logs by category
SELECT category, COUNT(*) AS log_count
FROM Logs
GROUP BY category;

-- 8. Function (String): Format log details
SELECT log_id, CONCAT(action, ' on ', table_name) AS action_summary
FROM Logs
WHERE status = 'Success';

-- 9. Basic Operation (INSERT): Add a new log
INSERT INTO Logs (log_id, user_id, action, table_name, record_id, log_date, ip_address, status, details, category)
VALUES (21, 1, 'Insert', 'Orders', 21, '2025-05-25 09:57:00', '192.168.1.21', 'Success', 'New order added', 'Order');

-- 10. Update/Delete: Clear old logs
DELETE FROM Logs
WHERE log_date < DATEADD(MONTH, -12, '2025-05-25');
