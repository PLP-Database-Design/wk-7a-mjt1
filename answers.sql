-- ######################################
-- Question 1: Achieving 1NF (First Normal Form) 🛠️
-- ######################################

-- Problem:
-- The ProductDetail table has a column 'Products' with multiple comma-separated values.
-- This violates 1NF, which requires that each column must contain atomic (indivisible) values.

-- Goal:
-- Transform the table so that each row contains only a single product for a given order.

-- Step 1: Create the original table with multi-valued 'Products' column
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Step 2: Insert the sample data
INSERT INTO ProductDetail VALUES 
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 3: Transform into 1NF using STRING_SPLIT (SQL Server syntax)
-- This separates the comma-separated values into individual rows
SELECT 
    OrderID,
    CustomerName,
    LTRIM(RTRIM(value)) AS Product  -- Trim spaces around each product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

-- Note:
-- If using PostgreSQL, you can use: unnest(string_to_array(Products, ','))
-- In MySQL 8+, you could use JSON_TABLE or a stored procedure to achieve similar results.

-- ######################################
-- Question 2: Achieving 2NF (Second Normal Form) 🧩
-- ######################################

-- Problem:
-- The OrderDetails table is in 1NF, but not 2NF.
-- The primary key is (OrderID, Product), but CustomerName depends only on OrderID.
-- This is a partial dependency, which violates 2NF.

-- Goal:
-- Eliminate partial dependencies by decomposing the table into two:
-- 1. Orders table: contains OrderID and CustomerName
-- 2. OrderItems table: contains OrderID, Product, Quantity

-- Step 1: Create the normalized Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create the normalized OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert data into Orders table (one row per OrderID)
INSERT INTO Orders VALUES 
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Step 4: Insert data into OrderItems table (one row per product per order)
INSERT INTO OrderItems VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Now, both tables are in 2NF:
-- - In Orders: CustomerName fully depends on the key (OrderID)
-- - In OrderItems: Quantity fully depends on the composite key (OrderID, Product)
