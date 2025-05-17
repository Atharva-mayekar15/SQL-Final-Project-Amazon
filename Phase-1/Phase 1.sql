-- Creating the Amazon database
CREATE DATABASE Amazon;
USE Amazon;

-- Table 1: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT,
    price DECIMAL(10, 2),
    stock_quantity INT,
    supplier_id INT,
    rating FLOAT,
    release_date DATE,
    is_active BOOLEAN,
    description TEXT
);

-- Insert 20 records into Products
INSERT INTO Products (product_id, product_name, category_id, price, stock_quantity, supplier_id, rating, release_date, is_active, description) VALUES
(1, 'Laptop Pro', 1, 999.99, 50, 101, 4.5, '2023-01-15', TRUE, 'High-performance laptop'),
(2, 'Wireless Mouse', 2, 29.99, 200, 102, 4.0, '2022-06-10', TRUE, 'Ergonomic wireless mouse'),
(3, 'Smartphone X', 1, 799.99, 30, 103, 4.8, '2023-03-20', TRUE, 'Latest smartphone model'),
(4, 'Headphones', 3, 59.99, 100, 104, 4.2, '2022-09-05', TRUE, 'Noise-canceling headphones'),
(5, 'Tablet', 1, 499.99, 60, 105, 4.3, '2023-02-10', TRUE, '10-inch tablet'),
(6, 'USB Cable', 2, 9.99, 500, 106, 3.9, '2021-12-01', TRUE, 'Durable USB-C cable'),
(7, 'Monitor', 1, 199.99, 40, 107, 4.6, '2022-11-15', TRUE, '27-inch LED monitor'),
(8, 'Keyboard', 2, 49.99, 150, 108, 4.1, '2022-07-20', TRUE, 'Mechanical keyboard'),
(9, 'Smart Watch', 4, 249.99, 80, 109, 4.4, '2023-04-01', TRUE, 'Fitness tracking watch'),
(10, 'Speaker', 3, 89.99, 120, 110, 4.0, '2022-10-10', TRUE, 'Bluetooth speaker'),
(11, 'Camera', 1, 599.99, 25, 111, 4.7, '2023-05-05', TRUE, 'DSLR camera'),
(12, 'Charger', 2, 19.99, 300, 112, 3.8, '2021-11-01', TRUE, 'Fast charger'),
(13, 'Router', 5, 129.99, 70, 113, 4.3, '2022-08-15', TRUE, 'Wi-Fi 6 router'),
(14, 'Earbuds', 3, 39.99, 200, 114, 4.2, '2023-01-25', TRUE, 'Wireless earbuds'),
(15, 'Printer', 1, 149.99, 35, 115, 4.0, '2022-12-20', TRUE, 'Inkjet printer'),
(16, 'Mouse Pad', 2, 12.99, 400, 116, 3.7, '2021-10-05', TRUE, 'Comfortable mouse pad'),
(17, 'External HDD', 6, 79.99, 90, 117, 4.5, '2023-03-10', TRUE, '1TB external drive'),
(18, 'Webcam', 2, 69.99, 110, 118, 4.1, '2022-09-25', TRUE, 'HD webcam'),
(19, 'Smart Bulb', 7, 24.99, 250, 119, 4.3, '2023-02-15', TRUE, 'Wi-Fi smart bulb'),
(20, 'Power Bank', 2, 34.99, 180, 120, 4.0, '2022-11-30', TRUE, '10000mAh power bank');

-- Table 2: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    registration_date DATE
);

-- Insert 20 records into Customers
INSERT INTO Customers (customer_id, first_name, last_name, email, phone, address, city, state, zip_code, registration_date) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St', 'New York', 'NY', '10001', '2023-01-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak Ave', 'Los Angeles', 'CA', '90001', '2023-02-01'),
(3, 'Alice', 'Johnson', 'alice.j@email.com', '555-0103', '789 Pine Rd', 'Chicago', 'IL', '60601', '2023-03-01'),
(4, 'Bob', 'Brown', 'bob.brown@email.com', '555-0104', '101 Maple Dr', 'Houston', 'TX', '77001', '2023-04-01'),
(5, 'Carol', 'Davis', 'carol.d@email.com', '555-0105', '202 Birch Ln', 'Phoenix', 'AZ', '85001', '2023-05-01'),
(6, 'David', 'Wilson', 'david.w@email.com', '555-0106', '303 Cedar St', 'Philadelphia', 'PA', '19101', '2023-06-01'),
(7, 'Emma', 'Moore', 'emma.m@email.com', '555-0107', '404 Elm Ave', 'San Antonio', 'TX', '78201', '2023-07-01'),
(8, 'Frank', 'Taylor', 'frank.t@email.com', '555-0108', '505 Spruce Rd', 'San Diego', 'CA', '92101', '2023-08-01'),
(9, 'Grace', 'Anderson', 'grace.a@email.com', '555-0109', '606 Willow Dr', 'Dallas', 'TX', '75201', '2023-09-01'),
(10, 'Henry', 'Thomas', 'henry.t@email.com', '555-0110', '707 Aspen Ln', 'San Jose', 'CA', '95101', '2023-10-01'),
(11, 'Isabella', 'Jackson', 'isabella.j@email.com', '555-0111', '808 Laurel St', 'Austin', 'TX', '73301', '2023-11-01'),
(12, 'James', 'White', 'james.w@email.com', '555-0112', '909 Magnolia Ave', 'Seattle', 'WA', '98101', '2023-12-01'),
(13, 'Kelly', 'Harris', 'kelly.h@email.com', '555-0113', '1010 Olive Rd', 'Denver', 'CO', '80201', '2024-01-01'),
(14, 'Liam', 'Martin', 'liam.m@email.com', '555-0114', '1111 Poplar Dr', 'Boston', 'MA', '02101', '2024-02-01'),
(15, 'Mia', 'Thompson', 'mia.t@email.com', '555-0115', '1212 Sycamore Ln', 'Miami', 'FL', '33101', '2024-03-01'),
(16, 'Noah', 'Garcia', 'noah.g@email.com', '555-0116', '1313 Walnut St', 'Portland', 'OR', '97201', '2024-04-01'),
(17, 'Olivia', 'Martinez', 'olivia.m@email.com', '555-0117', '1414 Chestnut Ave', 'Atlanta', 'GA', '30301', '2024-05-01'),
(18, 'Peter', 'Robinson', 'peter.r@email.com', '555-0118', '1515 Hazel Rd', 'Charlotte', 'NC', '28201', '2024-06-01'),
(19, 'Quinn', 'Clark', 'quinn.c@email.com', '555-0119', '1616 Fir Dr', 'Las Vegas', 'NV', '89101', '2024-07-01'),
(20, 'Rachel', 'Lewis', 'rachel.l@email.com', '555-0120', '1717 Linden Ln', 'Orlando', 'FL', '32801', '2024-08-01');

-- Table 3: Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    total_price DECIMAL(10, 2),
    shipping_address VARCHAR(200),
    status VARCHAR(50),
    payment_method VARCHAR(50),
    tracking_number VARCHAR(50)
);

-- Insert 20 records into Orders
INSERT INTO Orders (order_id, customer_id, product_id, order_date, quantity, total_price, shipping_address, status, payment_method, tracking_number) VALUES
(1, 1, 1, '2023-01-10', 1, 999.99, '123 Main St, New York, NY 10001', 'Delivered', 'Credit Card', 'TRK123456'),
(2, 2, 2, '2023-02-15', 2, 59.98, '456 Oak Ave, Los Angeles, CA 90001', 'Shipped', 'PayPal', 'TRK123457'),
(3, 3, 3, '2023-03-20', 1, 799.99, '789 Pine Rd, Chicago, IL 60601', 'Processing', 'Credit Card', 'TRK123458'),
(4, 4, 4, '2023-04-25', 3, 179.97, '101 Maple Dr, Houston, TX 77001', 'Delivered', 'Debit Card', 'TRK123459'),
(5, 5, 5, '2023-05-30', 1, 499.99, '202 Birch Ln, Phoenix, AZ 85001', 'Shipped', 'Credit Card', 'TRK123460'),
(6, 6, 6, '2023-06-05', 5, 49.95, '303 Cedar St, Philadelphia, PA 19101', 'Delivered', 'PayPal', 'TRK123461'),
(7, 7, 7, '2023-07-10', 1, 199.99, '404 Elm Ave, San Antonio, TX 78201', 'Processing', 'Credit Card', 'TRK123462'),
(8, 8, 8, '2023-08-15', 2, 99.98, '505 Spruce Rd, San Diego, CA 92101', 'Shipped', 'Debit Card', 'TRK123463'),
(9, 9, 9, '2023-09-20', 1, 249.99, '606 Willow Dr, Dallas, TX 75201', 'Delivered', 'Credit Card', 'TRK123464'),
(10, 10, 10, '2023-10-25', 2, 179.98, '707 Aspen Ln, San Jose, CA 95101', 'Processing', 'PayPal', 'TRK123465'),
(11, 11, 11, '2023-11-30', 1, 599.99, '808 Laurel St, Austin, TX 73301', 'Shipped', 'Credit Card', 'TRK123466'),
(12, 12, 12, '2023-12-05', 4, 79.96, '909 Magnolia Ave, Seattle, WA 98101', 'Delivered', 'Credit Card', 'TRK123467'),
(13, 13, 13, '2024-01-10', 1, 129.99, '1010 Olive Rd, Denver, CO 80201', 'Processing', 'Debit Card', 'TRK123468'),
(14, 14, 14, '2024-02-15', 3, 119.97, '1111 Poplar Dr, Boston, MA 02101', 'Shipped', 'Credit Card', 'TRK123469'),
(15, 15, 15, '2024-03-20', 1, 149.99, '1212 Sycamore Ln, Miami, FL 33101', 'Delivered', 'PayPal', 'TRK123470'),
(16, 16, 16, '2024-04-25', 6, 77.94, '1313 Walnut St, Portland, OR 97201', 'Processing', 'Credit Card', 'TRK123471'),
(17, 17, 17, '2024-05-30', 1, 79.99, '1414 Chestnut Ave, Atlanta, GA 30301', 'Shipped', 'Debit Card', 'TRK123472'),
(18, 18, 18, '2024-06-05', 2, 139.98, '1515 Hazel Rd, Charlotte, NC 28201', 'Delivered', 'Credit Card', 'TRK123473'),
(19, 19, 19, '2024-07-10', 5, 124.95, '1616 Fir Dr, Las Vegas, NV 89101', 'Processing', 'PayPal', 'TRK123474'),
(20, 20, 20, '2024-08-15', 2, 69.98, '1717 Linden Ln, Orlando, FL 32801', 'Shipped', 'Credit Card', 'TRK123475');

-- Table 4: Suppliers
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_name VARCHAR(50),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    contract_date DATE
);

-- Insert 20 records into Suppliers
INSERT INTO Suppliers (supplier_id, supplier_name, contact_name, contact_email, contact_phone, address, city, state, zip_code, contract_date) VALUES
(101, 'TechTrend', 'Mike Lee', 'mike.lee@techtrend.com', '555-0201', '123 Tech St', 'San Francisco', 'CA', '94101', '2022-01-01'),
(102, 'GadgetWorld', 'Sarah Kim', 'sarah.kim@gadgetworld.com', '555-0202', '456 Gadget Ave', 'Seattle', 'WA', '98102', '2022-02-01'),
(103, 'ElectroMart', 'Tom Chen', 'tom.chen@electromart.com', '555-0203', '789 Electro Rd', 'Austin', 'TX', '73303', '2022-03-01'),
(104, 'SoundVibe', 'Lisa Wong', 'lisa.wong@soundvibe.com', '555-0204', '101 Sound Dr', 'Boston', 'MA', '02104', '2022-04-01'),
(105, 'TechBit', 'James Park', 'james.park@techbit.com', '555-0205', '202 Tech Ln', 'Chicago', 'IL', '60605', '2022-05-01'),
(106, 'CableCo', 'Emma Liu', 'emma.liu@cableco.com', '555-0206', '303 Cable St', 'Miami', 'FL', '33106', '2022-06-01'),
(107, 'ScreenTech', 'David Xu', 'david.xu@screentech.com', '555-0207', '404 Screen Ave', 'Denver', 'CO', '80207', '2022-07-01'),
(108, 'KeyCraft', 'Anna Patel', 'anna.patel@keycraft.com', '555-0208', '505 Key Rd', 'Phoenix', 'AZ', '85008', '2022-08-01'),
(109, 'WearTech', 'Robert Gupta', 'robert.gupta@weartech.com', '555-0209', '606 Wear Dr', 'Portland', 'OR', '97209', '2022-09-01'),
(110, 'AudioPeak', 'Emily Tran', 'emily.tran@audiopeak.com', '555-0210', '707 Audio Ln', 'Atlanta', 'GA', '30310', '2022-10-01'),
(111, 'CamTech', 'Mark Singh', 'mark.singh@camtech.com', '555-0211', '808 Cam St', 'Dallas', 'TX', '75211', '2022-11-01'),
(112, 'ChargeIt', 'Sophie Brown', 'sophie.brown@chargeit.com', '555-0212', '909 Charge Ave', 'Houston', 'TX', '77012', '2022-12-01'),
(113, 'NetGear', 'Chris Davis', 'chris.davis@netgear.com', '555-0213', '1010 Net Rd', 'San Diego', 'CA', '92113', '2023-01-01'),
(114, 'EarTech', 'Laura Kim', 'laura.kim@eartech.com', '555-0214', '1111 Ear Dr', 'Los Angeles', 'CA', '90014', '2023-02-01'),
(115, 'PrintPro', 'Alan Wu', 'alan.wu@printpro.com', '555-0215', '1212 Print Ln', 'New York', 'NY', '10015', '2023-03-01'),
(116, 'PadTech', 'Rachel Lee', 'rachel.lee@padtech.com', '555-0216', '1313 Pad St', 'Philadelphia', 'PA', '19116', '2023-04-01'),
(117, 'StoreTech', 'Kevin Yang', 'kevin.yang@storetech.com', '555-0217', '1414 Store Ave', 'San Antonio', 'TX', '78217', '2023-05-01'),
(118, 'WebVision', 'Megan Hall', 'megan.hall@webvision.com', '555-0218', '1515 Web Rd', 'Charlotte', 'NC', '28218', '2023-06-01'),
(119, 'LightSmart', 'Brian Clark', 'brian.clark@lightsmart.com', '555-0219', '1616 Light Dr', 'Las Vegas', 'NV', '89119', '2023-07-01'),
(120, 'PowerUp', 'Julia Adams', 'julia.adams@powerup.com', '555-0220', '1717 Power Ln', 'Orlando', 'FL', '32820', '2023-08-01');

-- Table 5: Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_category_id INT,
    description TEXT,
    created_date DATE,
    is_active BOOLEAN,
    display_order INT,
    image_url VARCHAR(200),
    meta_title VARCHAR(100),
    meta_description VARCHAR(200)
);

-- Insert 20 records into Categories
INSERT INTO Categories (category_id, category_name, parent_category_id, description, created_date, is_active, display_order, image_url, meta_title, meta_description) VALUES
(1, 'Electronics', NULL, 'Electronic gadgets and devices', '2022-01-01', TRUE, 1, 'electronics.jpg', 'Electronics', 'Shop for gadgets and devices'),
(2, 'Accessories', 1, 'Device accessories', '2022-01-02', TRUE, 2, 'accessories.jpg', 'Accessories', 'Find device accessories'),
(3, 'Audio', 1, 'Audio equipment', '2022-01-03', TRUE, 3, 'audio.jpg', 'Audio', 'Explore audio equipment'),
(4, 'Wearables', 1, 'Wearable technology', '2022-01-04', TRUE, 4, 'wearables.jpg', 'Wearables', 'Discover wearable tech'),
(5, 'Networking', 1, 'Networking devices', '2022-01-05', TRUE, 5, 'networking.jpg', 'Networking', 'Shop networking devices'),
(6, 'Storage', 1, 'Storage solutions', '2022-01-06', TRUE, 6, 'storage.jpg', 'Storage', 'Find storage solutions'),
(7, 'Home', NULL, 'Home automation', '2022-01-07', TRUE, 7, 'home.jpg', 'Home Automation', 'Smart home devices'),
(8, 'Books', NULL, 'Books and literature', '2022-01-08', TRUE, 8, 'books.jpg', 'Books', 'Browse books'),
(9, 'Clothing', NULL, 'Apparel and fashion', '2022-01-09', TRUE, 9, 'clothing.jpg', 'Clothing', 'Shop clothing'),
(10, 'Sports', NULL, 'Sports equipment', '2022-01-10', TRUE, 10, 'sports.jpg', 'Sports', 'Sports gear'),
(11, 'Toys', NULL, 'Toys and games', '2022-01-11', TRUE, 11, 'toys.jpg', 'Toys', 'Find toys and games'),
(12, 'Beauty', NULL, 'Beauty products', '2022-01-12', TRUE, 12, 'beauty.jpg', 'Beauty', 'Shop beauty products'),
(13, 'Health', NULL, 'Health and wellness', '2022-01-13', TRUE, 13, 'health.jpg', 'Health', 'Health products'),
(14, 'Furniture', NULL, 'Home furniture', '2022-01-14', TRUE, 14, 'furniture.jpg', 'Furniture', 'Shop furniture'),
(15, 'Appliances', NULL, 'Home appliances', '2022-01-15', TRUE, 15, 'appliances.jpg', 'Appliances', 'Home appliances'),
(16, 'Tools', NULL, 'Tools and hardware', '2022-01-16', TRUE, 16, 'tools.jpg', 'Tools', 'Shop tools'),
(17, 'Garden', NULL, 'Garden supplies', '2022-01-17', TRUE, 17, 'garden.jpg', 'Garden', 'Garden supplies'),
(18, 'Pet Supplies', NULL, 'Pet products', '2022-01-18', TRUE, 18, 'pets.jpg', 'Pet Supplies', 'Shop pet products'),
(19, 'Automotive', NULL, 'Car accessories', '2022-01-19', TRUE, 19, 'automotive.jpg', 'Automotive', 'Car accessories'),
(20, 'Office', NULL, 'Office supplies', '2022-01-20', TRUE, 20, 'office.jpg', 'Office', 'Office supplies');

-- Table 6: Reviews
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    rating INT,
    comment TEXT,
    review_date DATE,
    is_verified BOOLEAN,
    helpful_votes INT,
    response TEXT,
    status VARCHAR(50)
);

-- Insert 20 records into Reviews
INSERT INTO Reviews (review_id, product_id, customer_id, rating, comment, review_date, is_verified, helpful_votes, response, status) VALUES
(1, 1, 1, 5, 'Amazing laptop!', '2023-01-20', TRUE, 10, 'Thank you!', 'Approved'),
(2, 2, 2, 4, 'Good mouse, but battery life could be better', '2023-02-20', TRUE, 5, 'We appreciate your feedback', 'Approved'),
(3, 3, 3, 5, 'Best smartphone ever', '2023-03-25', TRUE, 15, 'Glad you love it!', 'Approved'),
(4, 4, 4, 3, 'Decent headphones', '2023-04-30', TRUE, 3, 'Thanks for your review', 'Approved'),
(5, 5, 5, 4, 'Great tablet for the price', '2023-06-01', TRUE, 8, 'We value your input', 'Approved'),
(6, 6, 6, 2, 'Cable broke after a month', '2023-06-10', TRUE, 2, 'Sorry, we’ll send a replacement', 'Approved'),
(7, 7, 7, 5, 'Fantastic monitor', '2023-07-15', TRUE, 12, 'Thank you!', 'Approved'),
(8, 8, 8, 4, 'Solid keyboard', '2023-08-20', TRUE, 6, 'Glad you like it', 'Approved'),
(9, 9, 9, 5, 'Love this smartwatch', '2023-09-25', TRUE, 9, 'Awesome to hear!', 'Approved'),
(10, 10, 10, 3, 'Speaker is okay', '2023-10-30', TRUE, 4, 'Thanks for your feedback', 'Approved'),
(11, 11, 11, 5, 'Amazing camera quality', '2023-12-01', TRUE, 11, 'Thank you!', 'Approved'),
(12, 12, 12, 4, 'Charger works well', '2023-12-10', TRUE, 7, 'We appreciate that', 'Approved'),
(13, 13, 13, 5, 'Fast router', '2024-01-15', TRUE, 10, 'Glad you love it', 'Approved'),
(14, 14, 14, 4, 'Good earbuds', '2024-02-20', TRUE, 5, 'Thanks for your review', 'Approved'),
(15, 15, 15, 3, 'Printer jams occasionally', '2024-03-25', TRUE, 3, 'We’ll look into this', 'Approved'),
(16, 16, 16, 4, 'Nice mouse pad', '2024-04-30', TRUE, 6, 'Thank you!', 'Approved'),
(17, 17, 17, 5, 'Reliable HDD', '2024-06-01', TRUE, 8, 'Glad you like it', 'Approved'),
(18, 18, 18, 4, 'Clear webcam', '2024-06-10', TRUE, 5, 'We appreciate your feedback', 'Approved'),
(19, 19, 19, 5, 'Smart bulb is great', '2024-07-15', TRUE, 9, 'Thank you!', 'Approved'),
(20, 20, 20, 4, 'Good power bank', '2024-08-20', TRUE, 7, 'Glad you like it', 'Approved');

-- Table 7: Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(50),
    status VARCHAR(50),
    currency VARCHAR(10),
    notes TEXT
);

-- Insert 20 records into Payments
INSERT INTO Payments (payment_id, order_id, customer_id, amount, payment_date, payment_method, transaction_id, status, currency, notes) VALUES
(1, 1, 1, 999.99, '2023-01-10', 'Credit Card', 'TXN123456', 'Completed', 'USD', 'Payment for laptop'),
(2, 2, 2, 59.98, '2023-02-15', 'PayPal', 'TXN123457', 'Completed', 'USD', 'Payment for mouse'),
(3, 3, 3, 799.99, '2023-03-20', 'Credit Card', 'TXN123458', 'Pending', 'USD', 'Payment for smartphone'),
(4, 4, 4, 179.97, '2023-04-25', 'Debit Card', 'TXN123459', 'Completed', 'USD', 'Payment for headphones'),
(5, 5, 5, 499.99, '2023-05-30', 'Credit Card', 'TXN123460', 'Completed', 'USD', 'Payment for tablet'),
(6, 6, 6, 49.95, '2023-06-05', 'PayPal', 'TXN123461', 'Completed', 'USD', 'Payment for cables'),
(7, 7, 7, 199.99, '2023-07-10', 'Credit Card', 'TXN123462', 'Pending', 'USD', 'Payment for monitor'),
(8, 8, 8, 99.98, '2023-08-15', 'Debit Card', 'TXN123463', 'Completed', 'USD', 'Payment for keyboard'),
(9, 9, 9, 249.99, '2023-09-20', 'Credit Card', 'TXN123464', 'Completed', 'USD', 'Payment for smartwatch'),
(10, 10, 10, 179.98, '2023-10-25', 'PayPal', 'TXN123465', 'Pending', 'USD', 'Payment for speaker'),
(11, 11, 11, 599.99, '2023-11-30', 'Credit Card', 'TXN123466', 'Completed', 'USD', 'Payment for camera'),
(12, 12, 12, 79.96, '2023-12-05', 'Credit Card', 'TXN123467', 'Completed', 'USD', 'Payment for charger'),
(13, 13, 13, 129.99, '2024-01-10', 'Debit Card', 'TXN123468', 'Pending', 'USD', 'Payment for router'),
(14, 14, 14, 119.97, '2024-02-15', 'Credit Card', 'TXN123469', 'Completed', 'USD', 'Payment for earbuds'),
(15, 15, 15, 149.99, '2024-03-20', 'PayPal', 'TXN123470', 'Completed', 'USD', 'Payment for printer'),
(16, 16, 16, 77.94, '2024-04-25', 'Credit Card', 'TXN123471', 'Pending', 'USD', 'Payment for mouse pad'),
(17, 17, 17, 79.99, '2024-05-30', 'Debit Card', 'TXN123472', 'Completed', 'USD', 'Payment for HDD'),
(18, 18, 18, 139.98, '2024-06-05', 'Credit Card', 'TXN123473', 'Completed', 'USD', 'Payment for webcam'),
(19, 19, 19, 124.95, '2024-07-10', 'PayPal', 'TXN123474', 'Pending', 'USD', 'Payment for smart bulb'),
(20, 20, 20, 69.98, '2024-08-15', 'Credit Card', 'TXN123475', 'Completed', 'USD', 'Payment for power bank');

-- Table 8: Shipments
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    warehouse_id INT,
    shipping_date DATE,
    carrier VARCHAR(50),
    tracking_number VARCHAR(50),
    status VARCHAR(50),
    estimated_delivery DATE,
    shipping_cost DECIMAL(10, 2),
    notes TEXT
);

-- Insert 20 records into Shipments
INSERT INTO Shipments (shipment_id, order_id, warehouse_id, shipping_date, carrier, tracking_number, status, estimated_delivery, shipping_cost, notes) VALUES
(1, 1, 1, '2023-01-11', 'UPS', 'TRK123456', 'Delivered', '2023-01-15', 15.99, 'Express shipping'),
(2, 2, 2, '2023-02-16', 'FedEx', 'TRK123457', 'In Transit', '2023-02-20', 10.99, 'Standard shipping'),
(3, 3, 1, '2023-03-21', 'USPS', 'TRK123458', 'Processing', '2023-03-25', 12.99, 'Priority mail'),
(4, 4, 3, '2023-04-26', 'UPS', 'TRK123459', 'Delivered', '2023-04-30', 14.99, 'Express shipping'),
(5, 5, 2, '2023-05-31', 'FedEx', 'TRK123460', 'In Transit', '2023-06-04', 11.99, 'Standard shipping'),
(6, 6, 1, '2023-06-06', 'USPS', 'TRK123461', 'Delivered', '2023-06-10', 9.99, 'Priority mail'),
(7, 7, 3, '2023-07-11', 'UPS', 'TRK123462', 'Processing', '2023-07-15', 13.99, 'Express shipping'),
(8, 8, 2, '2023-08-16', 'FedEx', 'TRK123463', 'In Transit', '2023-08-20', 10.99, 'Standard shipping'),
(9, 9, 1, '2023-09-21', 'USPS', 'TRK123464', 'Delivered', '2023-09-25', 12.99, 'Priority mail'),
(10, 10, 3, '2023-10-26', 'UPS', 'TRK123465', 'Processing', '2023-10-30', 14.99, 'Express shipping'),
(11, 11, 2, '2023-12-01', 'FedEx', 'TRK123466', 'In Transit', '2023-12-05', 11.99, 'Standard shipping'),
(12, 12, 1, '2023-12-06', 'USPS', 'TRK123467', 'Delivered', '2023-12-10', 9.99, 'Priority mail'),
(13, 13, 3, '2024-01-11', 'UPS', 'TRK123468', 'Processing', '2024-01-15', 13.99, 'Express shipping'),
(14, 14, 2, '2024-02-16', 'FedEx', 'TRK123469', 'In Transit', '2024-02-20', 10.99, 'Standard shipping'),
(15, 15, 1, '2024-03-21', 'USPS', 'TRK123470', 'Delivered', '2024-03-25', 12.99, 'Priority mail'),
(16, 16, 3, '2024-04-26', 'UPS', 'TRK123471', 'Processing', '2024-04-30', 14.99, 'Express shipping'),
(17, 17, 2, '2024-05-31', 'FedEx', 'TRK123472', 'In Transit', '2024-06-04', 11.99, 'Standard shipping'),
(18, 18, 1, '2024-06-06', 'USPS', 'TRK123473', 'Delivered', '2024-06-10', 9.99, 'Priority mail'),
(19, 19, 3, '2024-07-11', 'UPS', 'TRK123474', 'Processing', '2024-07-15', 13.99, 'Express shipping'),
(20, 20, 2, '2024-08-16', 'FedEx', 'TRK123475', 'In Transit', '2024-08-20', 10.99, 'Standard shipping');

-- Table 9: Warehouses
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100),
    address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    manager_name VARCHAR(50),
    contact_phone VARCHAR(15),
    capacity INT,
    operational_since DATE
);

-- Insert 20 records into Warehouses
INSERT INTO Warehouses (warehouse_id, warehouse_name, address, city, state, zip_code, manager_name, contact_phone, capacity, operational_since) VALUES
(1, 'NY Warehouse', '123 Warehouse St', 'New York', 'NY', '10001', 'John Smith', '555-0301', 10000, '2020-01-01'),
(2, 'LA Warehouse', '456 Depot Ave', 'Los Angeles', 'CA', '90001', 'Jane Doe', '555-0302', 8000, '2020-02-01'),
(3, 'Chicago Warehouse', '789 Storage Rd', 'Chicago', 'IL', '60601', 'Alice Brown', '555-0303', 9000, '2020-03-01'),
(4, 'Houston Warehouse', '101 Logistics Dr', 'Houston', 'TX', '77001', 'Bob Wilson', '555-0304', 8500, '2020-04-01'),
(5, 'Phoenix Warehouse', '202 Stock Ln', 'Phoenix', 'AZ', '85001', 'Carol Lee', '555-0305', 7000, '2020-05-01'),
(6, 'Philly Warehouse', '303 Depot St Barbara', 'Philadelphia', 'PA', '19101', 'David Kim', '555-0306', 7500, '2020-06-01'),
(7, 'San Antonio Warehouse', '404 Storage Ave', 'San Antonio', 'TX', '78201', 'Emma Chen', '555-0307', 8200, '2020-07-01'),
(8, 'San Diego Warehouse', '505 Logistics Rd', 'San Diego', 'CA', '92101', 'Frank Patel', '555-0308', 7800, '2020-08-01'),
(9, 'Dallas Warehouse', '606 Stock Dr', 'Dallas', 'TX', '75201', 'Grace Wong', '555-0309', 8300, '2020-09-01'),
(10, 'San Jose Warehouse', '707 Depot Ln', 'San Jose', 'CA', '95101', 'Henry Gupta', '555-0310', 7200, '2020-10-01'),
(11, 'Austin Warehouse', '808 Storage St', 'Austin', 'TX', '73301', 'Isabella Tran', '555-0311', 7400, '2020-11-01'),
(12, 'Seattle Warehouse', '909 Logistics Ave', 'Seattle', 'WA', '98101', 'James Yang', '555-0312', 7900, '2020-12-01'),
(13, 'Denver Warehouse', '1010 Stock Rd', 'Denver', 'CO', '80201', 'Kelly Liu', '555-0313', 7600, '2021-01-01'),
(14, 'Boston Warehouse', '1111 Depot Dr', 'Boston', 'MA', '02101', 'Liam Park', '555-0314', 7700, '2021-02-01'),
(15, 'Miami Warehouse', '1212 Storage Ln', 'Miami', 'FL', '33101', 'Mia Singh', '555-0315', 7100, '2021-03-01'),
(16, 'Portland Warehouse', '1313 Logistics St', 'Portland', 'OR', '97201', 'Noah Davis', '555-0316', 7300, '2021-04-01'),
(17, 'Atlanta Warehouse', '1414 Stock Ave', 'Atlanta', 'GA', '30301', 'Olivia Hall', '555-0317', 8000, '2021-05-01'),
(18, 'Charlotte Warehouse', '1515 Depot Rd', 'Charlotte', 'NC', '28201', 'Peter Clark', '555-0318', 7500, '2021-06-01'),
(19, 'Las Vegas Warehouse', '1616 Storage Dr', 'Las Vegas', 'NV', '89101', 'Quinn Adams', '555-0319', 7200, '2021-07-01'),
(20, 'Orlando Warehouse', '1717 Logistics Ln', 'Orlando', 'FL', '32801', 'Rachel Lee', '555-0320', 7400, '2021 gritted-08-01');

-- Table 10: Inventory
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    warehouse_id INT,
    quantity INT,
    last_updated DATE,
    min_stock_level INT,
    max_stock_level INT,
    reorder_quantity INT,
    status VARCHAR(50),
    notes TEXT
);

-- Insert 20 records into Inventory
INSERT INTO Inventory (inventory_id, product_id, warehouse_id, quantity, last_updated, min_stock_level, max_stock_level, reorder_quantity, status, notes) VALUES
(1, 1, 1, 50, '2023-01-15', 10, 100, 50, 'In Stock', 'Laptop stock'),
(2, 2, 2, 200, '2023-02-10', 50, 300, 100, 'In Stock', 'Mouse stock'),
(3, 3, 1, 30, '2023-03-20', 5, 50, 20, 'Low Stock', 'Smartphone stock'),
(4, 4, 3, 100, '2023-04-05', 20, 150, 50, 'In Stock', 'Headphones stock'),
(5, 5, 2, 60, '2023-05-10', 10, 80, 30, 'In Stock', 'Tablet stock'),
(6, 6, 1, 500, '2023-06-01', 100, 600, 200, 'In Stock', 'Cable stock'),
(7, 7, 3, 40, '2023-07-15', 5, 60, 20, 'Low Stock', 'Monitor stock'),
(8, 8, 2, 150, '2023-08-20', 30, 200, 50, 'In Stock', 'Keyboard stock'),
(9, 9, 1, 80, '2023-09-01', 15, 100, 40, 'In Stock', 'Smartwatch stock'),
(10, 10, 3, 120, '2023-10-10', 20, 150, 50, 'In Stock', 'Speaker stock'),
(11, 11, 2, 25, '2023-11-05', 5, 40, 15, 'Low Stock', 'Camera stock'),
(12, 12, 1, 300, '2023-12-01', 50, 400, 100, 'In Stock', 'Charger stock'),
(13, 13, 3, 70, '2024-01-15', 10, 90, 30, 'In Stock', 'Router stock'),
(14, 14, 2, 200, '2024-02-25', 40, 250, 100, 'In Stock', 'Earbuds stock'),
(15, 15, 1, 35, '2024-03-20', 5, 50, 20, 'Low Stock', 'Printer stock'),
(16, 16, 3, 400, '2024-04-05', 100, 500, 200, 'In Stock', 'Mouse pad stock'),
(17, 17, 2, 90, '2024-05-10', 15, 120, 50, 'In Stock', 'HDD stock'),
(18, 18, 1, 110, '2024-06-25', 20, 150, 50, 'In Stock', 'Webcam stock'),
(19, 19, 3, 250, '2024-07-15', 50, 300, 100, 'In Stock', 'Smart bulb stock'),
(20, 20, 2, 180, '2024-08-30', 30, 200, 50, 'In Stock', 'Power bank stock');

-- Table 11: Promotions
CREATE TABLE Promotions (
    promotion_id INT PRIMARY KEY,
    promotion_name VARCHAR(100),
    product_id INT,
    discount_percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN,
    created_by VARCHAR(50),
    max_uses INT,
    description TEXT
);

-- Insert 20 records into Promotions
INSERT INTO Promotions (promotion_id, promotion_name, product_id, discount_percentage, start_date, end_date, is_active, created_by, max_uses, description) VALUES
(1, 'Laptop Sale', 1, 10.00, '2023-01-01', '2023-01-31', FALSE, 'Admin1', 100, 'Laptop discount'),
(2, 'Mouse Deal', 2, 15.00, '2023-02-01', '2023-02-28', FALSE, 'Admin2', 200, 'Mouse discount'),
(3, 'Smartphone Promo', 3, 5.00, '2023-03-01', '2023-03-31', FALSE, 'Admin3', 50, 'Smartphone discount'),
(4, 'Headphones Offer', 4, 20.00, '2023-04-01', '2023-04-30', FALSE, 'Admin4', 150, 'Headphones discount'),
(5, 'Tablet Sale', 5, 10.00, '2023-05-01', '2023-05-31', FALSE, 'Admin5', 80, 'Tablet discount'),
(6, 'Cable Deal', 6, 25.00, '2023-06-01', '2023-06-30', FALSE, 'Admin6', 300, 'Cable discount'),
(7, 'Monitor Promo', 7, 15.00, '2023-07-01', '2023-07-31', FALSE, 'Admin7', 60, 'Monitor discount'),
(8, 'Keyboard Offer', 8, 10.00, '2023-08-01', '2023-08-31', FALSE, 'Admin8', 200, 'Keyboard discount'),
(9, 'Smartwatch Sale', 9, 5.00, '2023-09-01', '2023-09-30', FALSE, 'Admin9', 100, 'Smartwatch discount'),
(10, 'Speaker Deal', 10, 20.00, '2023-10-01', '2023-10-31', FALSE, 'Admin10', 150, 'Speaker discount'),
(11, 'Camera Promo', 11, 10.00, '2023-11-01', '2023-11-30', FALSE, 'Admin11', 40, 'Camera discount'),
(12, 'Charger Offer', 12, 15.00, '2023-12-01', '2023-12-31', FALSE, 'Admin12', 250, 'Charger discount'),
(13, 'Router Sale', 13, 10.00, '2024-01-01', '2024-01-31', TRUE, 'Admin13', 90, 'Router discount'),
(14, 'Earbuds Deal', 14, 20.00, '2024-02-01', '2024-02-28', TRUE, 'Admin14', 200, 'Earbuds discount'),
(15, 'Printer Promo', 15, 5.00, '2024-03-01', '2024-03-31', TRUE, 'Admin15', 50, 'Printer discount'),
(16, 'Mouse Pad Offer', 16, 25.00, '2024-04-01', '2024-04-30', TRUE, 'Admin16', 300, 'Mouse pad discount'),
(17, 'HDD Sale', 17, 15.00, '2024-05-01', '2024-05-31', TRUE, 'Admin17', 120, 'HDD discount'),
(18, 'Webcam Deal', 18, 10.00, '2024-06-01', '2024-06-30', TRUE, 'Admin18', 150, 'Webcam discount'),
(19, 'Smart Bulb Promo', 19, 20.00, '2024-07-01', '2024-07-31', TRUE, 'Admin19', 250, 'Smart bulb discount'),
(20, 'Power Bank Offer', 20, 10.00, '2024-08-01', '2024-08-31', TRUE, 'Admin20', 200, 'Power bank discount');

-- Table 12: Returns
CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    customer_id INT,
    return_date DATE,
    reason VARCHAR(200),
    status VARCHAR(50),
    refund_amount DECIMAL(10, 2),
    return_method VARCHAR(50),
    notes TEXT
);

-- Insert 20 records into Returns
INSERT INTO Returns (return_id, order_id, product_id, customer_id, return_date, reason, status, refund_amount, return_method, notes) VALUES
(1, 1, 1, 1, '2023-01-20', 'Defective', 'Approved', 999.99, 'Mail', 'Laptop not working'),
(2, 2, 2, 2, '2023-02-25', 'Wrong item', 'Approved', 59.98, 'Mail', 'Received wrong mouse'),
(3, 3, 3, 3, '2023-03-30', 'Changed mind', 'Pending', 799.99, 'Store', 'No longer needed'),
(4, 4, 4, 4, '2023-05-01', 'Damaged', 'Approved', 179.97, 'Mail', 'Headphones broken'),
(5, 5, 5, 5, '2023-06-05', 'Defective', 'Approved', 499.99, 'Mail', 'Tablet screen issue'),
(6, 6, 6, 6, '2023-06-15', 'Wrong item', 'Approved', 49.95, 'Store', 'Received wrong cable'),
(7, 7, 7, 7, '2023-07-20', 'Changed mind', 'Pending', 199.99, 'Mail', 'No longer needed'),
(8, 8, 8, 8, '2023-08-25', 'Damaged', 'Approved', 99.98, 'Mail', 'Keyboard keys broken'),
(9, 9, 9, 9, '2023-09-30', 'Defective', 'Approved', 249.99, 'Store', 'Smartwatch not charging'),
(10, 10, 10, 10, '2023-11-01', 'Wrong item', 'Approved', 179.98, 'Mail', 'Received wrong speaker'),
(11, 11, 11, 11, '2023-12-05', 'Changed mind', 'Pending', 599.99, 'Mail', 'No longer needed'),
(12, 12, 12, 12, '2023-12-15', 'Damaged', 'Approved', 79.96, 'Store', 'Charger not working'),
(13, 13, 13, 13, '2024-01-20', 'Defective', 'Approved', 129.99, 'Mail', 'Router not connecting'),
(14, 14, 14, 14, '2024-02-25', 'Wrong item', 'Approved', 119.97, 'Mail', 'Received wrong earbuds'),
(15, 15, 15, 15, '2024-03-30', 'Changed mind', 'Pending', 149.99, 'Store', 'No longer needed'),
(16, 16, 16, 16, '2024-05-01', 'Damaged', 'Approved', 77.94, 'Mail', 'Mouse pad torn'),
(17, 17, 17, 17, '2024-06-05', 'Defective', 'Approved', 79.99, 'Mail', 'HDD not detected'),
(18, 18, 18, 18, '2024-06-15', 'Wrong item', 'Approved', 139.98, 'Store', 'Received wrong webcam'),
(19, 19, 19, 19, '2024-07-20', 'Changed mind', 'Pending', 124.95, 'Mail', 'No longer needed'),
(20, 20, 20, 20, '2024-08-25', 'Damaged', 'Approved', 69.98, 'Mail', 'Power bank not charging');

-- Table 13: Wishlists
CREATE TABLE Wishlists (
    wishlist_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    added_date DATE,
    priority INT,
    notes TEXT,
    is_active BOOLEAN,
    last_updated DATE,
    category_id INT,
    status VARCHAR(50)
);

-- Insert 20 records into Wishlists
INSERT INTO Wishlists (wishlist_id, customer_id, product_id, added_date, priority, notes, is_active, last_updated, category_id, status) VALUES
(1, 1, 1, '2023-01-05', 1, 'Want for work', TRUE, '2023-01-05', 1, 'Active'),
(2, 2, 2, '2023-02-10', 2, 'Nice mouse', TRUE, '2023-02-10', 2, 'Active'),
(3, 3, 3, '2023-03-15', 1, 'New phone', TRUE, '2023-03-15', 1, 'Active'),
(4, 4, 4, '2023-04-20', 3, 'For music', TRUE, '2023-04-20', 3, 'Active'),
(5, 5, 5, '2023-05-25', 2, 'For travel', TRUE, '2023-05-25', 1, 'Active'),
(6, 6, 6, '2023-06-01', 4, 'Extra cables', TRUE, '2023-06-01', 2, 'Active'),
(7, 7, 7, '2023-07-05', 1, 'For gaming', TRUE, '2023-07-05', 1, 'Active'),
(8, 8, 8, '2023-08-10', 2, 'Typing comfort', TRUE, '2023-08-10', 2, 'Active'),
(9, 9, 9, '2023-09-15', 1, 'Fitness tracking', TRUE, '2023-09-15', 4, 'Active'),
(10, 10, 10, '2023-10-20', 3, 'For parties', TRUE, '2023-10-20', 3, 'Active'),
(11, 11, 11, '2023-11-25', 1, 'Photography', TRUE, '2023-11-25', 1, 'Active'),
(12, 12, 12, '2023-12-01', 4, 'Extra charger', TRUE, '2023-12-01', 2, 'Active'),
(13, 13, 13, '2024-01-05', 2, 'Home network', TRUE, '2024-01-05', 5, 'Active'),
(14, 14, 14, '2024-02-10', 3, 'For workouts', TRUE, '2024-02-10', 3, 'Active'),
(15, 15, 15, '2024-03-15', 1, 'For office', TRUE, '2024-03-15', 1, 'Active'),
(16, 16, 16, '2024-04-20', 4, 'Mouse comfort', TRUE, '2024-04-20', 2, 'Active'),
(17, 17, 17, '2024-05-25', 2, 'Backup storage', TRUE, '2024-05-25', 6, 'Active'),
(18, 18, 18, '2024-06-01', 1, 'Video calls', TRUE, '2024-06-01', 2, 'Active'),
(19, 19, 19, '2024-07-05', 3, 'Smart home', TRUE, '2024-07-05', 7, 'Active'),
(20, 20, 20, '2024-08-10', 2, 'Travel power', TRUE, '2024-08-10', 2, 'Active');

-- Table 14: Carts
CREATE TABLE Carts (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    added_date DATE,
    last_updated DATE,
    is_active BOOLEAN,
    total_price DECIMAL(10, 2),
    notes TEXT,
    status VARCHAR(50)
);

-- Insert 20 records into Carts
INSERT INTO Carts (cart_id, customer_id, product_id, quantity, added_date, last_updated, is_active, total_price, notes, status) VALUES
(1, 1, 1, 1, '2023-01-05', '2023-01-05', TRUE, 999.99, 'For work', 'Active'),
(2, 2, 2, 2, '2023-02-10', '2023-02-10', TRUE, 59.98, 'For home', 'Active'),
(3, 3, 3, 1, '2023-03-15', '2023-03-15', TRUE, 799.99, 'New phone', 'Active'),
(4, 4, 4, 3, '2023-04-20', '2023-04-20', TRUE, 179.97, 'For music', 'Active'),
(5, 5, 5, 1, '2023-05-25', '2023-05-25', TRUE, 499.99, 'For travel', 'Active'),
(6, 6, 6, 5, '2023-06-01', '2023-06-01', TRUE, 49.95, 'Extra cables', 'Active'),
(7, 7, 7, 1, '2023-07-05', '2023-07-05', TRUE, 199.99, 'For gaming', 'Active'),
(8, 8, 8, 2, '2023-08-10', '2023-08-10', TRUE, 99.98, 'Typing comfort', 'Active'),
(9, 9, 9, 1, '2023-09-15', '2023-09-15', TRUE, 249.99, 'Fitness tracking', 'Active'),
(10, 10, 10, 2, '2023-10-20', '2023-10-20', TRUE, 179.98, 'For parties', 'Active'),
(11, 11, 11, 1, '2023-11-25', '2023-11-25', TRUE, 599.99, 'Photography', 'Active'),
(12, 12, 12, 4, '2023-12-01', '2023-12-01', TRUE, 79.96, 'Extra charger', 'Active'),
(13, 13, 13, 1, '2024-01-05', '2024-01-05', TRUE, 129.99, 'Home network', 'Active'),
(14, 14, 14, 3, '2024-02-10', '2024-02-10', TRUE, 119.97, 'For workouts', 'Active'),
(15, 15, 15, 1, '2024-03-15', '2024-03-15', TRUE, 149.99, 'For office', 'Active'),
(16, 16, 16, 6, '2024-04-20', '2024-04-20', TRUE, 77.94, 'Mouse comfort', 'Active'),
(17, 17, 17, 1, '2024-05-25', '2024-05-25', TRUE, 79.99, 'Backup storage', 'Active'),
(18, 18, 18, 2, '2024-06-01', '2024-06-01', TRUE, 139.98, 'Video calls', 'Active'),
(19, 19, 19, 5, '2024-07-05', '2024-07-05', TRUE, 124.95, 'Smart home', 'Active'),
(20, 20, 20, 2, '2024-08-10', '2024-08-10', TRUE, 69.98, 'Travel power', 'Active');

-- Table 15: Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    hire_date DATE,
    department_id INT,
    role VARCHAR(50),
    salary DECIMAL(10, 2),
    status VARCHAR(50)
);

-- Insert 20 records into Employees
INSERT INTO Employees (employee_id, first_name, last_name, email, phone, hire_date, department_id, role, salary, status) VALUES
(1, 'Michael', 'Scott', 'michael.s@email.com', '555-0401', '2020-01-01', 1, 'Manager', 80000.00, 'Active'),
(2, 'Dwight', 'Schrute', 'dwight.s@email.com', '555-0402', '2020-02-01', 2, 'Sales', 60000.00, 'Active'),
(3, 'Jim', 'Halpert', 'jim.h@email.com', '555-0403', '2020-03-01', 2, 'Sales', 62000.00, 'Active'),
(4, 'Pam', 'Beesly', 'pam.b@email.com', '555-0404', '2020-04-01', 3, 'Receptionist', 50000.00, 'Active'),
(5, 'Stanley', 'Hudson', 'stanley.h@email.com', '555-0405', '2020-05-01', 2, 'Sales', 61000.00, 'Active'),
(6, 'Phyllis', 'Vance', 'phyllis.v@email.com', '555-0406', '2020-06-01', 2, 'Sales', 60000.00, 'Active'),
(7, 'Angela', 'Martin', 'angela.m@email.com', '555-0407', '2020-07-01', 4, 'Accountant', 65000.00, 'Active'),
(8, 'Kevin', 'Malone', 'kevin.m@email.com', '555-0408', '2020-08-01', 4, 'Accountant', 64000.00, 'Active'),
(9, 'Oscar', 'Martinez', 'oscar.m@email.com', '555-0409', '2020-09-01', 4, 'Accountant', 66000.00, 'Active'),
(10, 'Ryan', 'Howard', 'ryan.h@email.com', '555-0410', '2020-10-01', 5, 'Temp', 45000.00, 'Active'),
(11, 'Kelly', 'Kapoor', 'kelly.k@email.com', '555-0411', '2020-11-01', 6, 'Customer Service', 52000.00, 'Active'),
(12, 'Erin', 'Hannon', 'erin.h@email.com', '555-0412', '2020-12-01', 3, 'Receptionist', 50000.00, 'Active'),
(13, 'Toby', 'Flenderson', 'toby.f@email.com', '555-0413', '2021-01-01', 7, 'HR', 67000.00, 'Active'),
(14, 'Meredith', 'Palmer', 'meredith.p@email.com', '555-0414', '2021-02-01', 2, 'Sales', 60000.00, 'Active'),
(15, 'Creed', 'Bratton', 'creed.b@email.com', '555-0415', '2021-03-01', 8, 'Quality Assurance', 55000.00, 'Active'),
(16, 'Darryl', 'Philbin', 'darryl.p@email.com', '555-0416', '2021-04-01', 9, 'Warehouse', 58000.00, 'Active'),
(17, 'Roy', 'Anderson', 'roy.a@email.com', '555-0417', '2021-05-01', 9, 'Warehouse', 57000.00, 'Active'),
(18, 'Jan', 'Levinson', 'jan.l@email.com', '555-0418', '2021-06-01', 1, 'Manager', 85000.00, 'Active'),
(19, 'David', 'Wallace', 'david.w@email.com', '555-0419', '2021-07-01', 1, 'CEO', 100000.00, 'Active'),
(20, 'Holly', 'Flax', 'holly.f@email.com', '555-0420', '2021-08-01', 7, 'HR', 68000.00, 'Active');

-- Table 16: Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id INT,
    location VARCHAR(100),
    budget DECIMAL(10, 2),
    created_date DATE,
    is_active BOOLEAN,
    contact_email VARCHAR(100),
    phone VARCHAR(15),
    description TEXT
);

-- Insert 20 records into Departments
INSERT INTO Departments (department_id, department_name, manager_id, location, budget, created_date, is_active, contact_email, phone, description) VALUES
(1, 'Management', 19, 'New York', 500000.00, '2020-01-01', TRUE, 'mgmt@email.com', '555-0501', 'Oversees operations'),
(2, 'Sales', 1, 'Chicago', 300000.00, '2020-01-02', TRUE, 'sales@email.com', '555-0502', 'Handles sales'),
(3, 'Reception', 1, 'Los Angeles', 100000.00, '2020-01-03', TRUE, 'reception@email.com', '555-0503', 'Front desk'),
(4, 'Accounting', 7, 'Houston', 200000.00, '2020-01-04', TRUE, 'accounting@email.com', '555-0504', 'Financial records'),
(5, 'Temp', 1, 'Phoenix', 50000.00, '2020-01-05', TRUE, 'temp@email.com', '555-0505', 'Temporary staff'),
(6, 'Customer Service', 11, 'Philadelphia', 150000.00, '2020-01-06', TRUE, 'cs@email.com', '555-0506', 'Customer support'),
(7, 'HR', 13, 'San Antonio', 180000.00, '2020-01-07', TRUE, 'hr@email.com', '555-0507', 'Human resources'),
(8, 'Quality Assurance', 15, 'San Diego', 120000.00, '2020-01-08', TRUE, 'qa@email.com', '555-0508', 'Product quality'),
(9, 'Warehouse', 16, 'Dallas', 250000.00, '2020-01-09', TRUE, 'warehouse@email.com', '555-0509', 'Inventory management'),
(10, 'Marketing', 18, 'San Jose', 220000.00, '2020-01-10', TRUE, 'marketing@email.com', '555-0510', 'Promotions'),
(11, 'IT', 19, 'Austin', 280000.00, '2020-01-11', TRUE, 'it@email.com', '555-0511', 'Tech support'),
(12, 'Logistics', 16, 'Seattle', 200000.00, '2020-01-12', TRUE, 'logistics@email.com', '555-0512', 'Shipping'),
(13, 'Finance', 7, 'Denver', 230000.00, '2020-01-13', TRUE, 'finance@email.com', '555-0513', 'Budget planning'),
(14, 'R&D', 19, 'Boston', 300000.00, '2020-01-14', TRUE, 'rd@email.com', '555-0514', 'Research'),
(15, 'Legal', 18, 'Miami', 190000.00, '2020-01-15', TRUE, 'legal@email.com', '555-0515', 'Compliance'),
(16, 'Training', 13, 'Portland', 110000.00, '2020-01-16', TRUE, 'training@email.com', '555-0516', 'Employee training'),
(17, 'Security', 16, 'Atlanta', 170000.00, '2020-01-17', TRUE, 'security@email.com', '555-0517', 'Safety'),
(18, 'Maintenance', 15, 'Charlotte', 130000.00, '2020-01-18', TRUE, 'maintenance@email.com', '555-0518', 'Facility upkeep'),
(19, 'Procurement', 7, 'Las Vegas', 210000.00, '2020-01-19', TRUE, 'procurement@email.com', '555-0519', 'Supplies'),
(20, 'Events', 11, 'Orlando', 140000.00, '2020-01-20', TRUE, 'events@email.com', '555-0520', 'Company events');

-- Use the existing Amazon database
USE Amazon;

-- Table 17: Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    payment_id INT,
    order_id INT,
    customer_id INT,
    amount DECIMAL(10, 2),
    transaction_date DATE,
    status VARCHAR(50),
    gateway VARCHAR(50),
    response_code VARCHAR(50),
    notes TEXT
);

-- Insert 20 records into Transactions
INSERT INTO Transactions (transaction_id, payment_id, order_id, customer_id, amount, transaction_date, status, gateway, response_code, notes) VALUES
(1, 1, 1, 1, 999.99, '2023-01-10', 'Success', 'Stripe', '200', 'Laptop payment'),
(2, 2, 2, 2, 59.98, '2023-02-15', 'Success', 'PayPal', '200', 'Mouse payment'),
(3, 3, 3, 3, 799.99, '2023-03-20', 'Pending', 'Stripe', '100', 'Smartphone payment'),
(4, 4, 4, 4, 179.97, '2023-04-25', 'Success', 'Visa', '200', 'Headphones payment'),
(5, 5, 5, 5, 499.99, '2023-05-30', 'Success', 'Stripe', '200', 'Tablet payment'),
(6, 6, 6, 6, 49.95, '2023-06-05', 'Success', 'PayPal', '200', 'Cable payment'),
(7, 7, 7, 7, 199.99, '2023-07-10', 'Pending', 'Stripe', '100', 'Monitor payment'),
(8, 8, 8, 8, 99.98, '2023-08-15', 'Success', 'Visa', '200', 'Keyboard payment'),
(9, 9, 9, 9, 249.99, '2023-09-20', 'Success', 'Stripe', '200', 'Smartwatch payment'),
(10, 10, 10, 10, 179.98, '2023-10-25', 'Pending', 'PayPal', '100', 'Speaker payment'),
(11, 11, 11, 11, 599.99, '2023-11-30', 'Success', 'Stripe', '200', 'Camera payment'),
(12, 12, 12, 12, 79.96, '2023-12-05', 'Success', 'Visa', '200', 'Charger payment'),
(13, 13, 13, 13, 129.99, '2024-01-10', 'Pending', 'Stripe', '100', 'Router payment'),
(14, 14, 14, 14, 119.97, '2024-02-15', 'Success', 'PayPal', '200', 'Earbuds payment'),
(15, 15, 15, 15, 149.99, '2024-03-20', 'Success', 'Stripe', '200', 'Printer payment'),
(16, 16, 16, 16, 77.94, '2024-04-25', 'Pending', 'Visa', '100', 'Mouse pad payment'),
(17, 17, 17, 17, 79.99, '2024-05-30', 'Success', 'PayPal', '200', 'HDD payment'),
(18, 18, 18, 18, 139.98, '2024-06-05', 'Success', 'Stripe', '200', 'Webcam payment'),
(19, 19, 19, 19, 124.95, '2024-07-10', 'Pending', 'Visa', '100', 'Smart bulb payment'),
(20, 20, 20, 20, 69.98, '2024-08-15', 'Success', 'PayPal', '200', 'Power bank payment');

-- Table 18: Discounts
CREATE TABLE Discounts (
    discount_id INT PRIMARY KEY,
    discount_code VARCHAR(50),
    product_id INT,
    percentage DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    is_active BOOLEAN,
    max_uses INT,
    created_by VARCHAR(50),
    description TEXT
);

-- Insert 20 records into Discounts
INSERT INTO Discounts (discount_id, discount_code, product_id, percentage, start_date, end_date, is_active, max_uses, created_by, description) VALUES
(1, 'SAVE10', 1, 10.00, '2023-01-01', '2023-01-31', FALSE, 100, 'Admin1', 'Laptop discount'),
(2, 'MOUSE15', 2, 15.00, '2023-02-01', '2023-02-28', FALSE, 200, 'Admin2', 'Mouse discount'),
(3, 'PHONE5', 3, 5.00, '2023-03-01', '2023-03-31', FALSE, 50, 'Admin3', 'Smartphone discount'),
(4, 'HEAD20', 4, 20.00, '2023-04-01', '2023-04-30', FALSE, 150, 'Admin4', 'Headphones discount'),
(5, 'TABLET10', 5, 10.00, '2023-05-01', '2023-05-31', FALSE, 80, 'Admin5', 'Tablet discount'),
(6, 'CABLE25', 6, 25.00, '2023-06-01', '2023-06-30', FALSE, 300, 'Admin6', 'Cable discount'),
(7, 'MONITOR15', 7, 15.00, '2023-07-01', '2023-07-31', FALSE, 60, 'Admin7', 'Monitor discount'),
(8, 'KEYBOARD10', 8, 10.00, '2023-08-01', '2023-08-31', FALSE, 200, 'Admin8', 'Keyboard discount'),
(9, 'WATCH5', 9, 5.00, '2023-09-01', '2023-09-30', FALSE, 100, 'Admin9', 'Smartwatch discount'),
(10, 'SPEAKER20', 10, 20.00, '2023-10-01', '2023-10-31', FALSE, 150, 'Admin10', 'Speaker discount'),
(11, 'CAMERA10', 11, 10.00, '2023-11-01', '2023-11-30', FALSE, 40, 'Admin11', 'Camera discount'),
(12, 'CHARGER15', 12, 15.00, '2023-12-01', '2023-12-31', FALSE, 250, 'Admin12', 'Charger discount'),
(13, 'ROUTER10', 13, 10.00, '2024-01-01', '2024-01-31', TRUE, 90, 'Admin13', 'Router discount'),
(14, 'EARBUDS20', 14, 20.00, '2024-02-01', '2024-02-28', TRUE, 200, 'Admin14', 'Earbuds discount'),
(15, 'PRINTER5', 15, 5.00, '2024-03-01', '2024-03-31', TRUE, 50, 'Admin15', 'Printer discount'),
(16, 'PAD25', 16, 25.00, '2024-04-01', '2024-04-30', TRUE, 300, 'Admin16', 'Mouse pad discount'),
(17, 'HDD15', 17, 15.00, '2024-05-01', '2024-05-31', TRUE, 120, 'Admin17', 'HDD discount'),
(18, 'WEBCAM10', 18, 10.00, '2024-06-01', '2024-06-30', TRUE, 150, 'Admin18', 'Webcam discount'),
(19, 'BULB20', 19, 20.00, '2024-07-01', '2024-07-31', TRUE, 250, 'Admin19', 'Smart bulb discount'),
(20, 'BANK10', 20, 10.00, '2024-08-01', '2024-08-31', TRUE, 200, 'Admin20', 'Power bank discount');

-- Table 19: Taxes
CREATE TABLE Taxes (
    tax_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    tax_rate DECIMAL(5, 2),
    tax_amount DECIMAL(10, 2),
    tax_date DATE,
    tax_type VARCHAR(50),
    region VARCHAR(50),
    status VARCHAR(50),
    notes TEXT
);

-- Insert 20 records into Taxes
INSERT INTO Taxes (tax_id, order_id, product_id, tax_rate, tax_amount, tax_date, tax_type, region, status, notes) VALUES
(1, 1, 1, 8.00, 80.00, '2023-01-10', 'Sales Tax', 'NY', 'Applied', 'Laptop tax'),
(2, 2, 2, 7.50, 4.50, '2023-02-15', 'Sales Tax', 'CA', 'Applied', 'Mouse tax'),
(3, 3, 3, 8.25, 66.00, '2023-03-20', 'Sales Tax', 'IL', 'Pending', 'Smartphone tax'),
(4, 4, 4, 8.50, 15.30, '2023-04-25', 'Sales Tax', 'TX', 'Applied', 'Headphones tax'),
(5, 5, 5, 7.00, 35.00, '2023-05-30', 'Sales Tax', 'AZ', 'Applied', 'Tablet tax'),
(6, 6, 6, 6.50, 3.25, '2023-06-05', 'Sales Tax', 'PA', 'Applied', 'Cable tax'),
(7, 7, 7, 8.00, 16.00, '2023-07-10', 'Sales Tax', 'TX', 'Pending', 'Monitor tax'),
(8, 8, 8, 7.50, 7.50, '2023-08-15', 'Sales Tax', 'CA', 'Applied', 'Keyboard tax'),
(9, 9, 9, 8.25, 20.62, '2023-09-20', 'Sales Tax', 'TX', 'Applied', 'Smartwatch tax'),
(10, 10, 10, 6.50, 11.70, '2023-10-25', 'Sales Tax', 'CA', 'Pending', 'Speaker tax'),
(11, 11, 11, 7.00, 42.00, '2023-11-30', 'Sales Tax', 'TX', 'Applied', 'Camera tax'),
(12, 12, 12, 8.00, 6.40, '2023-12-05', 'Sales Tax', 'WA', 'Applied', 'Charger tax'),
(13, 13, 13, 7.50, 9.75, '2024-01-10', 'Sales Tax', 'CO', 'Pending', 'Router tax'),
(14, 14, 14, 8.25, 9.90, '2024-02-15', 'Sales Tax', 'MA', 'Applied', 'Earbuds tax'),
(15, 15, 15, 6.50, 9.75, '2024-03-20', 'Sales Tax', 'FL', 'Applied', 'Printer tax'),
(16, 16, 16, 7.00, 5.46, '2024-04-25', 'Sales Tax', 'OR', 'Pending', 'Mouse pad tax'),
(17, 17, 17, 8.00, 6.40, '2024-05-30', 'Sales Tax', 'GA', 'Applied', 'HDD tax'),
(18, 18, 18, 7.50, 10.50, '2024-06-05', 'Sales Tax', 'NC', 'Applied', 'Webcam tax'),
(19, 19, 19, 8.25, 10.32, '2024-07-10', 'Sales Tax', 'NV', 'Pending', 'Smart bulb24, 20, 20, 6.50, 4.55, '2024-08-15', 'Sales Tax', 'FL', 'Applied', 'Power bank tax');

-- Table 20: Addresses
CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    customer_id INT,
    address_type VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    country VARCHAR(50),
    is_default BOOLEAN,
    notes TEXT
);

-- Insert 20 records into Addresses
INSERT INTO Addresses (address_id, customer_id, address_type, street, city, state, zip_code, country, is_default, notes) VALUES
(1, 1, 'Billing', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE, 'Primary billing'),
(2, 2, 'Shipping', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE, 'Primary shipping'),
(3, 3, 'Billing', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', TRUE, 'Office address'),
(4, 4, 'Shipping', '101 Maple Dr', 'Houston', 'TX', '77001', 'USA', TRUE, 'Home address'),
(5, 5, 'Billing', '202 Birch Ln', 'Phoenix', 'AZ', '85001', 'USA', TRUE, 'Primary billing'),
(6, 6, 'Shipping', '303 Cedar St', 'Philadelphia', 'PA', '19101', 'USA', TRUE, 'Primary shipping'),
(7, 7, 'Billing', '404 Elm Ave', 'San Antonio', 'TX', '78201', 'USA', TRUE, 'Office address'),
(8, 8, 'Shipping', '505 Spruce Rd', 'San Diego', 'CA', '92101', 'USA', TRUE, 'Home address'),
(9, 9, 'Billing', '606 Willow Dr', 'Dallas', 'TX', '75201', 'USA', TRUE, 'Primary billing'),
(10, 10, 'Shipping', '707 Aspen Ln', 'San Jose', 'CA', '95101', 'USA', TRUE, 'Primary shipping'),
(11, 11, 'Billing', '808 Laurel St', 'Austin', 'TX', '73301', 'USA', TRUE, 'Office address'),
(12, 12, 'Shipping', '909 Magnolia Ave', 'Seattle', 'WA', '98101', 'USA', TRUE, 'Home address'),
(13, 13, 'Billing', '1010 Olive Rd', 'Denver', 'CO', '80201', 'USA', TRUE, 'Primary billing'),
(14, 14, 'Shipping', '1111 Poplar Dr', 'Boston', 'MA', '02101', 'USA', TRUE, 'Primary shipping'),
(15, 15, 'Billing', '1212 Sycamore Ln', 'Miami', 'FL', '33101', 'USA', TRUE, 'Office address'),
(16, 16, 'Shipping', '1313 Walnut St', 'Portland', 'OR', '97201', 'USA', TRUE, 'Home address'),
(17, 17, 'Billing', '1414 Chestnut Ave', 'Atlanta', 'GA', '30301', 'USA', TRUE, 'Primary billing'),
(18, 18, 'Shipping', '1515 Hazel Rd', 'Charlotte', 'NC', '28201', 'USA', TRUE, 'Primary shipping'),
(19, 19, 'Billing', '1616 Fir Dr', 'Las Vegas', 'NV', '89101', 'USA', TRUE, 'Office address'),
(20, 20, 'Shipping', '1717 Linden Ln', 'Orlando', 'FL', '32801', 'USA', TRUE, 'Home address');

-- Table 21: Subscriptions
CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    billing_cycle VARCHAR(50),
    amount DECIMAL(10, 2),
    is_active BOOLEAN,
    notes TEXT
);

-- Insert 20 records into Subscriptions
INSERT INTO Subscriptions (subscription_id, customer_id, plan_name, start_date, end_date, status, billing_cycle, amount, is_active, notes) VALUES
(1, 1, 'Prime', '2023-01-01', '2024-01-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(2, 2, 'Prime', '2023-02-01', '2024-02-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(3, 3, 'Music', '2023-03-01', '2024-03-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(4, 4, 'Video', '2023-04-01', '2024-04-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(5, 5, 'Prime', '2023-05-01', '2024-05-01  'Prime', '2023-06-01', '2024-06-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(6, 6, 'Music', '2023-07-01', '2024-07-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(7, 7, 'Video', '2023-08-01', '2024-08-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(8, 8, 'Prime', '2023-09-01', '2024-09-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(9, 9, 'Music', '2023-10-01', '2024-10-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(10, 10, 'Video', '2023-11-01', '2024-11-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(11, 11, 'Prime', '2023-12-01', '2024-12-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(12, 12, 'Music', '2024-01-01', '2025-01-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(13, 13, 'Video', '2024-02-01', '2025-02-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(14, 14, 'Prime', '2024-03-01', '2025-03-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(15, 15, 'Music', '2024-04-01', '2025-04-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(16, 16, 'Video', '2024-05-01', '2025-05-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(17, 17, 'Prime', '2024-06-01', '2025-06-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership'),
(18, 18, 'Music', '2024-07-01', '2025-07-01', 'Active', 'Monthly', 9.99, TRUE, 'Music subscription'),
(19, 19, 'Video', '2024-08-01', '2025-08-01', 'Active', 'Monthly', 8.99, TRUE, 'Video subscription'),
(20, 20, 'Prime', '2024-09-01', '2025-09-01', 'Active', 'Annual', 139.00, TRUE, 'Prime membership');

-- Table 22: GiftCards
CREATE TABLE GiftCards (
    giftcard_id INT PRIMARY KEY,
    customer_id INT,
    card_number VARCHAR(50),
    balance DECIMAL(10, 2),
    issue_date DATE,
    expiry_date DATE,
    status VARCHAR(50),
    is_active BOOLEAN,
    order_id INT,
    notes TEXT
);

-- Insert 20 records into GiftCards
INSERT INTO GiftCards (giftcard_id, customer_id, card_number, balance, issue_date, expiry_date, status, is_active, order_id, notes) VALUES
(1, 1, 'GC1234567890', 50.00, '2023-01-01', '2024-01-01', 'Active', TRUE, 1, 'Gift card for laptop'),
(2, 2, 'GC1234567891', 25.00, '2023-02-01', '2024-02-01', 'Active', TRUE, 2, 'Gift card for mouse'),
(3, 3, 'GC1234567892', 100.00, '2023-03-01', '2024-03-01', 'Active', TRUE, 3, 'Gift card for smartphone'),
(4, 4, 'GC1234567893', 75.00, '2023-04-01', '2024-04-01', 'Active', TRUE, 4, 'Gift card for headphones'),
(5, 5, 'GC1234567894', 50.00, '2023-05-01', '2024-05-01', 'Active', TRUE, 5, 'Gift card for tablet'),
(6, 6, 'GC1234567895', 20.00, '2023-06-01', '2024-06-01', 'Active', TRUE, 6, 'Gift card for cable'),
(7, 7, 'GC1234567896', 60.00, '2023-07-01', '2024-07-01', 'Active', TRUE, 7, 'Gift card for monitor'),
(8, 8, 'GC1234567897', 40.00, '2023-08-01', '2024-08-01', 'Active', TRUE, 8, 'Gift card for keyboard'),
(9, 9, 'GC1234567898', 80.00, '2023-09-01', '2024-09-01', 'Active', TRUE, 9, 'Gift card for smartwatch'),
(10, 10, 'GC1234567899', 30.00, '2023-10-01', '2024-10-01', 'Active', TRUE, 10, 'Gift card for speaker'),
(11, 11, 'GC1234567900', 90.00, '2023-11-01', '2024-11-01', 'Active', TRUE, 11, 'Gift card for camera'),
(12, 12, 'GC1234567901', 25.00, '2023-12-01', '2024-12-01', 'Active', TRUE, 12, 'Gift card for charger'),
(13, 13, 'GC1234567902', 50.00, '2024-01-01', '2025-01-01', 'Active', TRUE, 13, 'Gift card for router'),
(14, 14, 'GC1234567903', 35.00, '2024-02-01', '2025-02-01', 'Active', TRUE, 14, 'Gift card for earbuds'),
(15, 15, 'GC1234567904', 60.00, '2024-03-01', '2025-03-01', 'Active', TRUE, 15, 'Gift card for printer'),
(16, 16, 'GC1234567905', 20.00, '2024-04-01', '2025-04-01', 'Active', TRUE, 16, 'Gift card for mouse pad'),
(17, 17, 'GC1234567906', 45.00, '2024-05-01', '2025-05-01', 'Active', TRUE, 17, 'Gift card for HDD'),
(18, 18, 'GC1234567907', 70.00, '2024-06-01', '2025-06-01', 'Active', TRUE, 18, 'Gift card for webcam'),
(19, 19, 'GC1234567908', 55.00, '2024-07-01', '2025-07-01', 'Active', TRUE, 19, 'Gift card for smart bulb'),
(20, 20, 'GC1234567909', 40.00, '2024-08-01', '2025-08-01', 'Active', TRUE, 20, 'Gift card for power bank');

-- Table 23: Coupons
CREATE TABLE Coupons (
    coupon_id INT PRIMARY KEY,
    coupon_code VARCHAR(50),
    order_id INT,
    discount_amount DECIMAL(10, 2),
    issue_date DATE,
    expiry_date DATE,
    status VARCHAR(50),
    is_active BOOLEAN,
    max_uses INT,
    notes TEXT
);

-- Insert 20 records into Coupons
INSERT INTO Coupons (coupon_id, coupon_code, order_id, discount_amount, issue_date, expiry_date, status, is_active, max_uses, notes) VALUES
(1, 'SAVE20', 1, 20.00, '2023-01-01', '2023-01-31', 'Used', FALSE, 1, 'Laptop coupon'),
(2, 'MOUSE10', 2, 10.00, '2023-02-01', '2023-02-28', 'Used', FALSE, 1, 'Mouse coupon'),
(3, 'PHONE50', 3, 50.00, '2023-03-01', '2023-03-31', 'Active', TRUE, 1, 'Smartphone coupon'),
(4, 'HEAD15', 4, 15.00, '2023-04-01', '2023-04-30', 'Used', FALSE, 1, 'Headphones coupon'),
(5, 'TABLET25', 5, 25.00, '2023-05-01', '2023-05-31', 'Used', FALSE, 1, 'Tablet coupon'),
(6, 'CABLE5', 6, 5.00, '2023-06-01', '2023-06-30', 'Used', FALSE, 1, 'Cable coupon'),
(7, 'MONITOR30', 7, 30.00, '2023-07-01', '2023-07-31', 'Active', TRUE, 1, 'Monitor coupon'),
(8, 'KEYBOARD10', 8, 10.00, '2023-08-01', '2023-08-31', 'Used', FALSE, 1, 'Keyboard coupon'),
(9, 'WATCH20', 9, 20.00, '2023-09-01', '2023-09-30', 'Used', FALSE, 1, 'Smartwatch coupon'),
(10, 'SPEAKER15', 10, 15.00, '2023-10-01', '2023-10-31', 'Active', TRUE, 1, 'Speaker coupon'),
(11, 'CAMERA40', 11, 40.00, '2023-11-01', '2023-11-30', 'Used', FALSE, 1, 'Camera coupon'),
(12, 'CHARGER5', 12, 5.00, '2023-12-01', '2023-12-31', 'Used', FALSE, 1, 'Charger coupon'),
(13, 'ROUTER20', 13, 20.00, '2024-01-01', '2024-01-31', 'Active', TRUE, 1, 'Router coupon'),
(14, 'EARBUDS10', 14, 10.00, '2024-02-01', '2024-02-28', 'Used', FALSE, 1, 'Earbuds coupon'),
(15, 'PRINTER25', 15, 25.00, '2024-03-01', '2024-03-31', 'Used', FALSE, 1, 'Printer coupon'),
(16, 'PAD5', 16, 5.00, '2024-04-01', '2024-04-30', 'Active', TRUE, 1, 'Mouse pad coupon'),
(17, 'HDD15', 17, 15.00, '2024-05-01', '2024-05-31', 'Used', FALSE, 1, 'HDD coupon'),
(18, 'WEBCAM20', 18, 20.00, '2024-06-01', '2024-06-30', 'Used', FALSE, 1, 'Webcam coupon'),
(19, 'BULB10', 19, 10.00, '2024-07-01', '2024-07-31', 'Active', TRUE, 1, 'Smart bulb coupon'),
(20, 'BANK15', 20, 15.00, '2024-08-01', '2024-08-31', 'Used', FALSE, 1, 'Power bank coupon');

-- Table 24: Feedback
CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    customer_id INT,
    order_id INT,
    rating INT,
    comment TEXT,
    feedback_date DATE,
    is_anonymous BOOLEAN,
    status VARCHAR(50),
    response TEXT,
    category VARCHAR(50)
);

-- Insert 20 records into Feedback
INSERT INTO Feedback (feedback_id, customer_id, order_id, rating, comment, feedback_date, is_anonymous, status, response, category) VALUES
(1, 1, 1, 5, 'Great service!', '2023-01-20', FALSE, 'Approved', 'Thank you!', 'Service'),
(2, 2, 2, 4, 'Fast shipping', '2023-02-25', FALSE, 'Approved', 'Glad you liked it', 'Shipping'),
(3, 3, 3, 3, 'Product was okay', '2023-03-30', TRUE, 'Pending', 'We’ll review this', 'Product'),
(4, 4, 4, 5, 'Loved the headphones', '2023-05-01', FALSE, 'Approved', 'Awesome!', 'Product'),
(5, 5, 5, 4, 'Good tablet', '2023-06-05', FALSE, 'Approved', 'Thank you!', 'Product'),
(6, 6, 6, 2, 'Cable broke', '2023-06-15', TRUE, 'Approved', 'Sorry, we’ll replace it', 'Product'),
(7, 7, 7, 5, 'Amazing monitor', '2023-07-20', FALSE, 'Approved', 'Glad you love it', 'Product'),
(8, 8, 8, 4, 'Solid keyboard', '2023-08-25', FALSE, 'Approved', 'Thanks!', 'Product'),
(9, 9, 9, 5, 'Smartwatch is great', '2023-09-30', FALSE, 'Approved', 'Awesome!', 'Product'),
(10, 10, 10, 3, 'Speaker quality okay', '2023-11-01', TRUE, 'Pending', 'We’ll look into this', 'Product'),
(11, 11, 11, 5, 'Camera is fantastic', '2023-12-05', FALSE, 'Approved', 'Thank you!', 'Product'),
(12, 12, 12, 4, 'Charger works well', '2023-12-15', FALSE, 'Approved', 'Glad you like it', 'Product'),
(13, 13, 13, 5, 'Router is fast', '2024-01-20', FALSE, 'Approved', 'Awesome!', 'Product'),
(14, 14, 14, 4, 'Earbuds are good', '2024-02-25', FALSE, 'Approved', 'Thanks!', 'Product'),
(15, 15, 15, 3, 'Printer jams', '2024-03-30', TRUE, 'Pending', 'We’ll investigate', 'Product'),
(16, 16, 16, 4, 'Nice mouse pad', '2024-05-01', FALSE, 'Approved', 'Thank you!', 'Product'),
(17, 17, 17, 5, 'Reliable HDD', '2024-06-05', FALSE, 'Approved', 'Glad you love it', 'Product'),
(18, 18, 18, 4, 'Clear webcam', '2024-06-15', FALSE, 'Approved', 'Thanks!', 'Product'),
(19, 19, 19, 5, 'Smart bulb is cool', '2024-07-20', FALSE, 'Approved', 'Awesome!', 'Product'),
(20, 20, 20, 4, 'Good power bank', '2024-08-25', FALSE, 'Approved', 'Thank you!', 'Product');

-- Table 25: Logs
CREATE TABLE Logs (
    log_id INT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    table_name VARCHAR(50),
    record_id INT,
    log_date DATETIME,
    ip_address VARCHAR(50),
    status VARCHAR(50),
    details TEXT,
    category VARCHAR(50)
);

-- Insert 20 records into Logs
INSERT INTO Logs (log_id, user_id, action, table_name, record_id, log_date, ip_address, status, details, category) VALUES
(1, 1, 'Insert', 'Orders', 1, '2023-01-10 10:00:00', '192.168.1.1', 'Success', 'Order created', 'Order'),
(2, 2, 'Update', 'Products', 2, '2023-02-15 11:00:00', '192.168.1.2', 'Success', 'Updated stock', 'Product'),
(3, 3, 'Insert', 'Payments', 3, '2023-03-20 12:00:00', '192.168.1.3', 'Success', 'Payment processed', 'Payment'),
(4, 4, 'Delete', 'Carts', 4, '2023-04-25 13:00:00', '192.168.1.4', 'Success', 'Cart cleared', 'Cart'),
(5, 5, 'Insert', 'Reviews', 5, '2023-05-30 14:00:00', '192.168.1.5', 'Success', 'Review added', 'Review'),
(6, 6, 'Update', 'Customers', 6, '2023-06-05 15:00:00', '192.168.1.6', 'Success', 'Updated address', 'Customer'),
(7, 7, 'Insert', 'Shipments', 7, '2023-07-10 16:00:00', '192.168.1.7', 'Success', 'Shipment created', 'Shipment'),
(8, 8, 'Delete', 'Wishlists', 8, '2023-08-15 17:00:00', '192.168.1.8', 'Success', 'Wishlist removed', 'Wishlist'),
(9, 9, 'Insert', 'Promotions', 9, '2023-09-20 18:00:00', '192.168.1.9', 'Success', 'Promotion added', 'Promotion'),
(10, 10, 'Update', 'Inventory', 10, '2023-10-25 19:00:00', '192.168.1.10', 'Success', 'Stock updated', 'Inventory'),
(11, 11, 'Insert', 'Returns', 11, '2023-11-30 20:00:00', '192.168.1.11', 'Success', 'Return requested', 'Return'),
(12, 12, 'Delete', 'Categories', 12, '2023-12-05 21:00:00', '192.168.1.12', 'Success', 'Category removed', 'Category'),
(13, 13, 'Insert', 'Suppliers', 13, '2024-01-10 22:00:00', '192.168.1.13', 'Success', 'Supplier added', 'Supplier'),
(14, 14, 'Update', 'Employees', 14, '2024-02-15 23:00:00', '192.168.1.14', 'Success', 'Employee role updated', 'Employee'),
(15, 15, 'Insert', 'Departments', 15, '2024-03-20 10:00:00', '192.168.1.15', 'Success', 'Department created', 'Department'),
(16, 16, 'Delete', 'Orders', 16, '2024-04-25 11:00:00', '192.168.1.16', 'Success', 'Order canceled', 'Order'),
(17, 17, 'Insert', 'Payments', 17, '2024-05-30 12:00:00', '192.168.1.17', 'Success', 'Payment processed', 'Payment'),
(18, 18, 'Update', 'Products', 18, '2024-06-05 13:00:00', '192.168.1.18', 'Success', 'Price updated', 'Product'),
(19, 19, 'Insert', 'Reviews', 19, '2024-07-10 14:00:00', '192.168.1.19', 'Success', 'Review added', 'Review'),
(20, 20, 'Delete', 'Carts', 20, '2024-08-15 15:00:00', '192.168.1.20', 'Success', 'Cart cleared', 'Cart');