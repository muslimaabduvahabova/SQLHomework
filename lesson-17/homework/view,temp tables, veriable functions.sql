--1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
--Return: ProductID, TotalQuantity, TotalRevenue
;
create table #MonthlySales (ProductID int, TotalQuantity int, TotalRevenue int)
insert into #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
select p.ProductID,
		s.Quantity,
		s.Quantity * p.Price
	from Sales s 
	join Products p 
	on p.ProductID = s.ProductID
where month(s.SaleDate) = month (getdate() ) 
and year(s.SaleDate) = year (getdate() )
 
 select * from #MonthlySales

--2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--Return: ProductID, ProductName, Category, TotalQuantitySold
;
create view vw_ProductSalesSummary as 
select p.ProductID, 
		p.ProductName, 
		p.Category, 
		sum(s.Quantity) as TotalQuantitySold
from Products p 
join Sales s
on p.ProductID = s.ProductID
group by p.ProductID, p.ProductName, p.Category

select * from vw_ProductSalesSummary;

--3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--Return: total revenue for the given product ID
create function fn_GetTotalRevenueForProduct(@ProductID INT)
returns DECIMAL(18,2)
as 
begin 
declare @TotalRevenue  DECIMAL(18,2)
	
	select @TotalRevenue = sum(s.Quantity * p.Price)
	from Products p join Sales s
	on p.ProductID = s.ProductID
	where p.ProductID = @ProductID

	return @TotalRevenue;
end 


--4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.
;
create function fn_GetSalesByCategory(@Category VARCHAR(50))
returns table
as 
return 
declare @Category varchar(50)
(
	select p.ProductName, 
	TotalQuantity = sum(s.Quantity ),
	TotalRevenue = sum(s.Quantity * p.Price)
	from Products p join Sales s
	on p.ProductID = s.ProductID
	where p.Category = @Category
	group by p.ProductName
)
select * from fn_GetSalesByCategory(@Category)


--5. You have to create a function that get one argument as input from user and the function should return 
--'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:
