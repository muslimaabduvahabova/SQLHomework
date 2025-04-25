--create database [homework-15]
--use [homework-15]

--# Easy Tasks

--1. Create a numbers table using a recursive query.
with Numbers as (
select 1 as n 
union all 
select n + 1
from Numbers
where n <100 )
select * from Numbers
option (maxrecursion 100)

--2. Beginning at 1, this script uses a recursive statement to double the number for each record
with Doubles as (
select 1 as n
union all 
select n * 2
from Doubles
where n * 2 <= 100)
select * from Doubles

--3. Write a query to find the total sales per employee using a derived table.(Sales, Employees)
;
select e.EmployeeID,
		e.FirstName,
		e.LastName,
		s.TotalAmount
from Employees e
join (
	select EmployeeID,
	SUM(SalesAmount) as TotalAmount
	from Sales
	group by EmployeeID
) s on e.EmployeeID = s.EmployeeID 

--4. Create a CTE to find the average salary of employees.(Employees)
;
with cte as (
select EmployeeID,
		FirstName,
		LastName,
		avg(Salary) as AvgSalary
	from Employees
group by EmployeeID, FirstName, LastName)
select * from cte 

--5. Write a query using a derived table to find the highest sales for each product.(Sales, Products)
;
select p.ProductName,
		p.ProductID,
		s.MaxSale
from Products p 
join (
select ProductID,
		max(SalesAmount) as MaxSale
	from Sales
group by ProductID
) s on p.ProductID = s.ProductID;

--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
;
with SalesCount as (
	select EmployeeID,
	COUNT(SalesAmount) as SaleCount
from Sales
group by EmployeeID
)
SELECT e.EmployeeID,
		e.FirstName,
		e.LastName,
		s.SaleCount
	from SalesCount s 
	join Employees e
	on e.EmployeeID = s.EmployeeID
where s.SaleCount > 5

--7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
;
with ProductSales as (
select ProductID,
		sum(SalesAmount) as TotalSales
	from Sales
group by ProductID
)
SELECT p.ProductID,
		p.ProductName,
		ps.TotalSales
	from ProductSales ps
	join Products p
	on p.ProductID = ps.ProductID
where ps.TotalSales > 500;

--8. Create a CTE to find employees with salaries above the average salary.(Employees)
;
with HighSalary as (
select avg(Salary) as AvgSalary
	from Employees
)
select e.EmployeeID,
		e.FirstName,
		e.LastName,
		e.Salary
	from Employees e
	join HighSalary hs 
	on e.Salary > hs.AvgSalary;

--9. Write a query to find the total number of products sold using a derived table.(Sales, Products)
select p.ProductID,
		p.ProductName,
		s.TotalSold
from Products p 
join (
select ProductID,
		count(*) as TotalSold
	from Sales
group by ProductID
) s on p.ProductID = s.ProductID;

--10. Use a CTE to find the names of employees who have not made any sales.(Sales, Employees)
;
with SalesCount as (
	select EmployeeID
	from Sales
	group by EmployeeID
)
select e.EmployeeID,
		e.FirstName,
		e.LastName
	from Employees e
left join SalesCount s
on e.EmployeeID > s.EmployeeID
where s.EmployeeID is null;



--# Medium Tasks

--1. This script uses recursion to calculate factorials
with FactorialCTE as (
select 1 as Number, 1 as Factorial
union all 
select f.Number + 1, (f.Number + 1)* f.Factorial
from FactorialCTE f
where f.Number < 10
)
select * from FactorialCTE

--2. This script uses recursion to calculate Fibonacci numbers
with FibonacciCTE as (
select 0 as Number, 0 as Fibonacci
union all 
select 1 as Number, 1 as Fibonacci
union all
select f.Number + 1, f.Fibonacci + prev.Fibonacci
from FibonacciCTE f
left join FibonacciCTE prev
on f.Number = prev.Number + 1
where f.Number < 10
)
select * from FibonacciCTE
where Number >= 0

--3. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
;
WITH SplitStringCTE AS (
    SELECT 1 AS Position, SUBSTRING('Example', 1, 1) AS Char
    UNION ALL
    SELECT Position + 1, SUBSTRING('Example', Position + 1, 1)
    FROM SplitStringCTE
    WHERE Position < LEN('Example') 
)
SELECT * FROM SplitStringCTE;

--4. Create a CTE to rank employees based on their total sales.(Employees, Sales)
;
WITH EmployeeSalesCTE AS (
    SELECT e.EmployeeID,
           e.FirstName,
           e.LastName,
           SUM(s.SalesAmount) AS TotalSales
    FROM Employees e
    JOIN Sales s ON e.EmployeeID = s.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
),
RankedEmployees AS (
    SELECT EmployeeID,
           FirstName,
           LastName,
           TotalSales,
           RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM EmployeeSalesCTE
)
SELECT * FROM RankedEmployees
ORDER BY SalesRank;

--5. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
SELECT TOP 5 EmployeeID, FirstName, LastName, OrderCount
FROM (
    SELECT e.EmployeeID,
           e.FirstName,
           e.LastName,
           COUNT(s.ProductID) AS OrderCount
    FROM Employees e
    LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
) AS EmployeeOrderCounts
ORDER BY OrderCount DESC;

--6. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
WITH SalesCTE AS (
    SELECT 
        MONTH(SaleDate) AS SaleMonth,
        YEAR(SaleDate) AS SaleYear,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesWithPreviousMonth AS (
    SELECT 
        SaleYear,
        SaleMonth,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY SaleYear, SaleMonth) AS PreviousMonthSales
    FROM SalesCTE
)
SELECT 
    SaleYear,
    SaleMonth,
    TotalSales,
    PreviousMonthSales,
    (TotalSales - PreviousMonthSales) AS SalesDifference
FROM SalesWithPreviousMonth
ORDER BY SaleYear, SaleMonth;

--7. Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT ProductName, SUM(SalesAmount) AS TotalSales
FROM (
    SELECT p.ProductName,
           s.SalesAmount
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
) AS SalesByCategory
GROUP BY ProductName
ORDER BY TotalSales DESC;

--8. Use a CTE to rank products based on total sales in the last year.(Sales, Products)
;
WITH SalesCTE AS (
    SELECT p.ProductID,
           p.ProductName,
           SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE YEAR(s.SaleDate) = YEAR(GETDATE()) - 1  
    GROUP BY p.ProductID, p.ProductName
),
RankedProducts AS (
    SELECT ProductID,
           ProductName,
           TotalSales,
           RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
    FROM SalesCTE
)
SELECT ProductID, ProductName, TotalSales, SalesRank
FROM RankedProducts
ORDER BY SalesRank;


--9. Create a derived table to find employees with sales over $5000 in each quarter.(Sales, Employees)
SELECT EmployeeID, FirstName, LastName, Quarter, TotalSales
FROM (
    SELECT e.EmployeeID,
           e.FirstName,
           e.LastName,
           DATEPART(QUARTER, s.SaleDate) AS Quarter,
           SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, DATEPART(QUARTER, s.SaleDate)
) AS SalesByQuarter
WHERE TotalSales > 5000
ORDER BY EmployeeID, Quarter;

--10. Use a derived table to find the top 3 employees by total sales amount in the last month.(Sales, Employees)
;
WITH SalesLastMonth AS (
    SELECT e.EmployeeID,
           e.FirstName,
           e.LastName,
           SUM(s.SalesAmount) AS TotalSales
    FROM Sales s
    JOIN Employees e ON s.EmployeeID = e.EmployeeID
    WHERE s.SaleDate >= '2025-01-01' AND s.SaleDate < '2025-02-01'  
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT TOP 3 EmployeeID, FirstName, LastName, TotalSales
FROM SalesLastMonth
ORDER BY TotalSales DESC;


--# Difficult Tasks

--1. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)
--2. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)
--3. This script uses recursion to display a running total where the sum cannot go higher than 10 or lower than 0.(Numbers)
--4. Given a table of employee shifts, and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and does not have an activity planned, label the time frame as “Work”. (Schedule,Activity)
--5. Create a complex query that uses both a CTE and a derived table to calculate sales totals for each department and product.(Employees, Sales, Products, Departments)


