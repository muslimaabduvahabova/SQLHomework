# Lesson 5: Aliases, Unions, and Conditional columns

--1. Write a query that uses an alias to rename the ProductName column as Name in the Products table.
select ProductName as Name
from Products
--2. Write a query that uses an alias to rename the Customers table as Client for easier reference.
select *
from Customers as Client
--3. Use UNION to combine results from two queries that select ProductName from Products and ProductName from Products_Discounted.
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;
--4. Write a query to find the intersection of Products and Products_Discounted tables using INTERSECT.
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted
--6. Write a query to select distinct customer names and their corresponding Country using SELECT DISTINCT.
SELECT DISTINCT FirstName, Country
FROM Customers
--7. Write a query that uses CASE to create a conditional column that displays 'High' if Price > 1000, and 'Low' if Price <= 1000 from Products table.
SELECT ProductName,
 CASE 
 WHEN Price > 1000 THEN 'High'
 ELSE 'Low'
 END AS PriceCategory
FROM Products;
--8. Use IIF to create a column that shows 'Yes' if Stock > 100, and 'No' otherwise (Products_Discounted table, StockQuantity column).
SELECT ProductName,
IIF(StockQuantity > 100, 'Yes', 'No') AS StockAvailability
FROM Products_Discounted;
--9. Use UNION to combine results from two queries that select ProductName from Products and ProductName from OutOfStock tables.
select ProductName from Products
union
select ProductName from OutOfStock
--10. Write a query that returns the difference between the Products and Products_Discounted tables using EXCEPT.
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;
--11. Create a conditional column using IIF that shows 'Expensive' if the Price is greater than 1000, and 'Affordable' if less, from Products table.
SELECT ProductName,
 IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceCategory
FROM Products;
--12. Write a query to find employees in the Employees table who have either Age < 25 or Salary > 60000.
SELECT * FROM Employees
WHERE Age < 25 OR Salary > 60000;
--13. Use IF statement to update the salary of an employee based on their department, increase by 10% if they work in 'HR' or EmployeeID = 5
IF EXISTS (SELECT * FROM Employees WHERE DepartmentName = 'HR' OR EmployeeID = 5)
BEGIN
 UPDATE Employees
 SET Salary = Salary * 1.1
 WHERE DepartmentName = 'HR' OR EmployeeID = 5;
END;
--14. Use INTERSECT to show products that are common between Products and Products_Discounted tables.
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;
--15. Write a query that uses CASE to assign 'Top Tier' if SaleAmount > 500, 'Mid Tier' if SaleAmount BETWEEN 200 AND 500, and 'Low Tier' otherwise. (From Sales table)
SELECT SaleAmount,
 CASE 
 WHEN SaleAmount > 500 THEN 'Top Tier'
 WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
 ELSE 'Low Tier'
 END AS Tier
FROM Sales;
--16. Use EXCEPT to find customers ID who have placed orders but do not have a corresponding record in the Invoices table.
SELECT CustomerID FROM Orders
EXCEPT
SELECT CustomerID FROM Invoices;
--17. Write a query that uses a CASE statement to determine the discount percentage based on the quantity purchased. Use orders table. Result set should show  customerid, quantity and discount percentage. The discount should be applied as follows:
--        More than 1 item: 3% 
        --Between 1 and 3 items : 5% 
        --Otherwise: 7%  
SELECT CustomerID,
 Quantity,
 CASE
  WHEN Quantity > 1 THEN 3
  WHEN Quantity BETWEEN 1 AND 3 THEN 5
  ELSE 7
  END AS DiscountPercentage
FROM Orders;


select * from Products

select * from Customers

select * from Products_Discounted

select * from Sales

select * from Orders

select * from Invoices

select * from Employees


CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    CustomerID INT,
    InvoiceDate DATE,
    TotalAmount DECIMAL(10, 2)
);

INSERT INTO Invoices (InvoiceID, CustomerID, InvoiceDate, TotalAmount) VALUES
(1, 1, '2023-01-05', 150.00),
(2, 2, '2023-01-07', 200.00),
(3, 3, '2023-01-10', 250.00),
(4, 4, '2023-01-12', 300.00),
(5, 5, '2023-01-15', 350.00),
(6, 6, '2023-01-18', 400.00),
(7, 7, '2023-01-20', 450.00),
(8, 8, '2023-01-23', 500.00),
(9, 9, '2023-01-25', 550.00),
(10, 10, '2023-01-28', 600.00),
(11, 11, '2023-02-02', 150.00),
(12, 12, '2023-02-04', 200.00),
(13, 13, '2023-02-07', 250.00),
(14, 14, '2023-02-09', 300.00),
(15, 15, '2023-02-11', 350.00),
(16, 16, '2023-02-13', 400.00),
(17, 17, '2023-02-15', 450.00),
(18, 18, '2023-02-17', 500.00),
(19, 19, '2023-02-19', 550.00),
(20, 20, '2023-02-21', 600.00),
(21, 21, '2023-02-24', 150.00),
(22, 22, '2023-02-26', 200.00),
(23, 23, '2023-02-28', 250.00),
(24, 24, '2023-03-02', 300.00),
(25, 25, '2023-03-04', 350.00),
(26, 26, '2023-03-06', 400.00),
(27, 27, '2023-03-08', 450.00),
(28, 28, '2023-03-10', 500.00),
(29, 29, '2023-03-12', 550.00),
(30, 30, '2023-03-14', 600.00),
(31, 31, '2023-03-17', 150.00),
(32, 32, '2023-03-19', 200.00),
(33, 33, '2023-03-21', 250.00),
(34, 34, '2023-03-23', 300.00),
(35, 35, '2023-03-25', 350.00),
(36, 36, '2023-03-27', 400.00),
(37, 37, '2023-03-29', 450.00),
(38, 38, '2023-03-31', 500.00),
(39, 39, '2023-04-02', 550.00),
(40, 40, '2023-04-04', 600.00);

CREATE TABLE OutOfStock (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50),
    StockQuantity INT
);


INSERT INTO OutOfStock VALUES
(1, 'Gaming Console', 500.00, 'Electronics', 0),
(2, 'Smartwatch', 250.00, 'Electronics', 0),
(3, 'Wireless Earbuds', 150.00, 'Electronics', 0),
(4, 'Projector', 700.00, 'Electronics', 0),
(5, 'Mechanical Keyboard', 120.00, 'Accessories', 0),
(6, 'Wireless Mouse', 45.00, 'Accessories', 0),
(7, 'Office Chair', 250.00, 'Furniture', 0),
(8, 'Standing Desk', 400.00, 'Furniture', 0),
(9, 'Marker Set', 20.00, 'Stationery', 0),
(10, 'Sketchbook', 35.00, 'Stationery', 0),
(11, 'Scanner', 220.00, 'Electronics', 0),
(12, 'Drone', 800.00, 'Electronics', 0),
(13, 'Power Drill', 90.00, 'Tools', 0),
(14, 'Sweater', 55.00, 'Clothing', 0),
(15, 'Shorts', 30.00, 'Clothing', 0),
(16, 'Raincoat', 75.00, 'Clothing', 0),
(17, 'Sandals', 40.00, 'Clothing', 0),
(18, 'Gloves', 15.00, 'Accessories', 0),
(19, 'Necklace', 120.00, 'Accessories', 0),
(20, 'Sunglasses', 80.00, 'Accessories', 0),
(21, 'Bedside Lamp', 45.00, 'Furniture', 0),
(22, 'Bookshelf', 150.00, 'Furniture', 0),
(23, 'Dictionary', 25.00, 'Stationery', 0),
(24, 'Wall Clock', 60.00, 'Furniture', 0),
(25, 'Thermos', 35.00, 'Accessories', 0),
(26, 'Backpack', 60.00, 'Accessories', 0),
(27, 'Recliner', 550.00, 'Furniture', 0),
(28, 'Freezer', 750.00, 'Electronics', 0),
(29, 'Induction Cooktop', 300.00, 'Electronics', 0),
(30, 'Oven', 600.00, 'Electronics', 0),
(31, 'Humidifier', 90.00, 'Electronics', 0),
(32, 'Vacuum Cleaner', 250.00, 'Electronics', 0),
(33, 'Electric Kettle', 45.00, 'Electronics', 0),
(34, 'Smart Light Bulb', 30.00, 'Accessories', 0),
(35, 'Water Purifier', 120.00, 'Electronics', 0),
(36, 'Popcorn Maker', 50.00, 'Electronics', 0),
(37, 'Rice Cooker', 70.00, 'Electronics', 0),
(38, 'Food Processor', 90.00, 'Electronics', 0),
(39, 'Deep Fryer', 80.00, 'Electronics', 0),
(40, 'Robot Vacuum', 500.00, 'Electronics', 0);

