--create database [homework-21]
--use [homework-21]

--1. Write a query to assign a row number to each sale based on the SaleDate.
select *, row_number() over(order by SaleDate) as rownumber from ProductSales

--2. Write a query to rank products based on the total quantity sold (use DENSE_RANK())
select saleid, TotalQuantity, 
dense_rank() over(order by TotalQuantity desc) as ProductRank 
from (select SaleID, sum(quantity) as TotalQuantity from ProductSales group by SaleID 
) as productSales

--3. Write a query to identify the top sale for each customer based on the SaleAmount.
select CustomerID, SaleAmount, SaleDate from (
Select CustomerID, SaleDate, SaleAmount, 
row_number() over(partition by CustomerID order by SaleAmount desc) as rn  
from ProductSales) as RankedSales
where rn = 1 

--4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate using the LEAD() function
select SaleDate, SaleAmount, 
LEAD(SaleAmount) over (order by SaleDate desc) as LeadSaleAmount 
from ProductSales

--5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate using the LAG() function
select SaleDate, SaleAmount, 
lag(SaleAmount) over (order by SaleDate asc) as LagSaleAmount 
from ProductSales

--6. Write a query to rank each sale amount within each product category.
select ProductName, SaleAmount,
rank() over(partition by ProductName order by SaleAmount desc) as r
from ProductSales

--7. Write a query to identify sales amounts that are greater than the previous sale's amount
select SaleDate, SaleAmount from (
select SaleDate, SaleAmount,
lag(SaleAmount) over(order by SaleDate) as LagSaleAmount
from ProductSales) as ps 
where SaleAmount > LagSaleAmount

--8. Write a query to calculate the difference in sale amount from the previous sale for every product
select ProductName, SaleDate, SaleAmount,
lag(SaleAmount) over(partition by ProductName order by SaleDate) as LagSaleAmount
from ProductSales

--9. Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select SaleDate, SaleAmount,
coalesce(LEAD(SaleAmount) over(order by SaleDate),0) as nextSaleAmount,
(coalesce(lead(SaleAmount) over(order by SaleDate),0) - SaleAmount) /SaleAmount * 100 as PercentageSaleAmount
from ProductSales

--10. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select ProductName, SaleDate, SaleAmount,
	coalesce(SaleAmount / lag(SaleAmount) over(partition by ProductName order by SaleDate),0) as saleAmountRatio
from ProductSales

--11. Write a query to calculate the difference in sale amount from the very first sale of that product.
select ProductName, SaleAmount,
MIN(SaleDate) over(partition by ProductName order by SaleDate) as minsaleDate
from ProductSales

--12. Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
select ProductName, SaleDate, SaleAmount
from (
select ProductName, SaleDate, SaleAmount, 
lag(SaleAmount) over(partition by ProductName order by SaleDate) as PreviousSale
from ProductSales) as SaleswithPrevious
where SaleAmount > PreviousSale

--13. Write a query to calculate a "closing balance" for sales amounts which adds the current sale amount to a running total of previous sales.
select ProductName, SaleDate, SaleAmount, 
sum(SaleAmount) over(partition by ProductName order by SaleDate) as ClosingBalance
from ProductSales

--14. Write a query to calculate the moving average of sales amounts over the last 3 sales.
select ProductName, SaleDate, SaleAmount, 
avg(SaleAmount) over(partition by ProductName order by SaleDate 
rows between 2 preceding and current row) as MovingAverage
from ProductSales

--15. Write a query to show the difference between each sale amount and the average sale amount.
select ProductName, SaleDate, SaleAmount
from (
select ProductName, SaleDate, SaleAmount, 
SaleAmount - avg(SaleAmount) over(partition by ProductName order by SaleDate
rows between 2 preceding and current row) as PreviousSale
from ProductSales) as SaleswithPrevious
where SaleAmount > PreviousSale

--16.Find Employees Who Have the Same Salary Rank
select EmployeeID, Name, Department, Salary, SalaryRank from (
select EmployeeID, Name, Department, Salary,
rank() over(order by Salary desc) as SalaryRank
from Employees1) as RankedEmployees
where SalaryRank in (
select SalaryRank from(
select Salary,
rank() over(order by Salary desc) as SalaryRank 
from Employees1)as Subquery 
group by SalaryRank
having count(*) = 1);

--17. Identify the Top 2 Highest Salaries in Each Department
select EmployeeID, Name, Department, Salary, SalaryRank from (
select EmployeeID, Name, Department, Salary,
dense_rank() over(partition by Department order by Salary desc) as SalaryRank
from Employees1) as RankedEmployees
where SalaryRank <= 2

--18. Find the Lowest-Paid Employee in Each Department
select EmployeeID, Name, Department, Salary, SalaryRank from (
select EmployeeID, Name, Department, Salary,
row_number() over(partition by Department order by Salary asc) as SalaryRank
from Employees1) as RankedEmployees
where SalaryRank = 1

--19. Calculate the Running Total of Salaries in Each Department
select EmployeeID, Name, Department, Salary,
sum(Salary) over(partition by Department order by EmployeeID) as RunningTotal
from Employees1

--20. Find the Total Salary of Each Department Without GROUP BY
select Department, 
sum(salary) over(partition by Department) as TotalSalary
from Employees1

--21. Calculate the Average Salary in Each Department Without GROUP BY
select Department, 
avg(salary) over(partition by Department) as AvgSalary
from Employees1

--22. Find the Difference Between an Employee’s Salary and Their Department’s Average
select EmployeeID, Name, Department, Salary,
Salary - avg(Salary) over(partition by Department) as SalaryDifference
from Employees1

--23. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select EmployeeID, Name, Department, Salary, 
avg(Salary) over (order by HireDate 
rows between 1 preceding and 1 following) as AvgSalaryOver3Emp
from Employees1

--24. Find the Sum of Salaries for the Last 3 Hired Employees
Select sum(Salary) as TotalSalaryLast3Hired
from (
select Salary from Employees1
order by HireDate desc
offset 0 rows
fetch next 3 rows only ) as Last3Salary
