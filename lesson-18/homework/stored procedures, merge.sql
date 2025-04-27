--create database [homework-18]
--use [homework-18]


--Task 1. Stored Procedure Tasks
;
create proc Department_Bonus
as 
begin 
create table #EmployeeBonus (EmployeeID int, FullName varchar(50), Department varchar(50), Salary int, BonusAmount int)
insert into #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
		select e.EmployeeID,
			e.FirstName + ' ' + e.LastName as FullName,
			e.Department,
			e.Salary,
			e.Salary * d.BonusPercentage / 100 as BonusAmount
		from Employees e
		join DepartmentBonus d
		on e.Department = d.Department
		
		select * from #EmployeeBonus
end

exec Department_Bonus


--Task 2. Stored Procedure Tasks
;
create proc Depname_and_increasePercent 
		@DepartmentName varchar(50), 
		@IncreasePercent float
	as 
	begin 
		update Employees 
		set Salary = Salary + (Salary * @IncreasePercent / 100)
		where Department = @DepartmentName
		
	select * from Employees 
	where Department = @DepartmentName
end

exec Depname_and_increasePercent 'Sales', 10


--Task 3 MERGE 
;
merge into Products_Current as target
using Products_New as source
on target.ProductID = source.ProductID
when matched and target.Price <> source.Price then 
	update set target.Price = source.Price, 
	target.ProductName = source.ProductName
when not matched by source then 
	delete 
when not matched by target then 
	insert (ProductID, ProductName, Price) 
	values (source.ProductID, source.ProductName, source.Price);


select * from Products_Current 


--Task 4  
;
select t.id,
	case
		when t.p_id is null then 'Root'
		when exists (select 1 from Tree where p_id = t.id) then 'Inner'
		else 'Leaf'
		end as type
from Tree t


--Task 5  
;
select 
	 s.user_id,
	 case 
		when count(c.user_id) = 0 then 0
		else count(case when c.action = 'confirmed' then 1 end) * 1.0 / count(c.user_id)
	end as confirmation_rate
from Signups s 
left join Confirmations c
on s.user_id = c.user_id
group by s.user_id


--Task 6 
;
select * from employees2 
where salary = (select min(salary) from employees2)


--Task 7
;
create proc GetProductSalesSummary (@ProductID int)
as 
begin
	select 
		p.ProductName,
		coalesce(sum(s.Quantity), 0) as TotalQuantitySold,
		coalesce(sum(s.Quantity * p.Price), 0) as TotalSalesAmount,
		min(s.SaleDate) as FirstSaleDate,
		max(s.SaleDate) as LastSaleDate
	from Products p
	left join Sales s 
	on p.ProductID = s.ProductID
	and p.ProductID = @ProductID
	group by p.ProductName 
end


exec GetProductSalesSummary @ProductID = 2;
             
