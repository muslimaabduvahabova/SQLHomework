--use [homework-16]

--1: De-Group the Data
with cte as (
 select Product, Quantity
 from Grouped
 union all
 select Product, Quantity - 1
 from cte
 where Quantity - 1 > 0)
 select Product, 1 as Quantity
 from cte
 

--2: Region Sales Report
;
with Region as (
select distinct Region 
from #RegionSales),

Distributor as (
select distinct  Distributor 
from #RegionSales),

Crossjoin as (
select r.Region,
		d.Distributor
from Distributor d
cross join Region r)

select cj.Region,
		cj.Distributor,
		isnull(rs.Sales, 0) as Sales
	from  Crossjoin cj  
		left join #RegionSales rs 
		on cj.Distributor = rs.Distributor  
		and cj.Region = rs.Region
	order by cj.Distributor, cj.Region;


--3. Managers With At Least 5 Reports
;
select name 
from Employee 
where id in (
select managerId 
from Employee 
group by managerId 
having count(*) >= 5)


--4. Products Ordered in February 2020 (>= 100 units)
;
select p.product_name,
		sum(o.unit) as unit
	from Orders o 
		join Products p
			on p.product_id  = o.product_id
		where o.order_date >= '2020-02-01'
			and o.order_date < '2020-03-01'
		group by p.product_name
		having sum(o.unit) >= 100;


--5. Most Frequent Vendor Per Customer
;
with VendorCounts as (
select CustomerID, 
		Vendor, 
		count(*) as Totalorder
			from Orders
				group by CustomerID, Vendor)
select vc.CustomerID, 
		vc.Vendor
	from VendorCounts vc 
		where vc.Totalorder = (
select max(vc2.Totalorder) 
		from VendorCounts vc2
			where vc2.CustomerID = vc.CustomerID)
				order by CustomerID asc


--6.  Prime Number Check Using WHILE
DECLARE @Check_Prime INT = 91
declare @starting_number int = 2 
declare @prime1 int = 1

while 
	@starting_number*@starting_number <= @Check_Prime
begin 
	if @Check_Prime % @starting_number = 0
		begin
			set @prime1 = 0
			break 
		end
	else set @starting_number = @starting_number + 1
end;
with cte as 
(
select @Check_Prime as number 
)
select case when @prime1 = 0 then 'This number is not prime'
else 'This number is prime' end as Result from cte 


--7. Signals per Device
;
with cte as
(
select Device_id, Locations, count(locations) as number_of_location from  Device
group by Device_id, Locations
),
cte2 as (select max(number_of_location) as max_number from  cte
group by Device_id
), 
cte3 as (
select Device_id, locations from cte join cte2 on cte.number_of_location = cte2.max_number
), 
cte4 as (select Device_id, count(distinct locations) as no_of_location, count(locations) as no_of_signals from  Device
group by Device_id
) 
select cte3.Device_id, no_of_location, locations as max_signal_location, no_of_signals  
from cte3 join cte4 on cte3.Device_id = cte4.Device_id 


--8. Employees Earning Above Department Average
;
with cte as (
select DeptID, avg(Salary) as avgSalary 
from Employee1
group by DeptID 
)
select e.EmpID, e.EmpName, e.Salary 
from cte join Employee1 e 
on e.DeptID = cte.DeptID
where e.Salary > avgSalary
order by e.EmpID asc


--9. Office Lottery Winnings
;
with Matchcount as (
select TicketID, COUNT(*) as Matchcount  
from Tickets t join WinningNumbers w
on t.Number = w.Number
group by TicketID
),
winnings as (
select TicketID,
	case
		when Matchcount = (select count(*) from WinningNumbers) then 100
	else 10
end as prize 
from Matchcount)
SELECT CONCAT('Total Winning = $', SUM(Prize)) AS Result FROM Winnings;



--10. Spending by Platform per Date
;
with cte as (
	select User_id, Spend_date, 
		max(case when Platform = 'Mobile' then 1 else 0 end) as IsMobile,
		max(case when Platform = 'Desktop' then 1 else 0 end) as IsDesktop
	from Spending
group by User_id, Spend_date
),
cte2 as (
	select cte.User_id, cte.Spend_date,
		case 
		when IsMobile = 1 and IsDesktop = 1 then 'Both'
		when IsMobile = 1 and IsDesktop = 0 then 'Mobile'
		when IsMobile = 0 and IsDesktop = 1 then 'Desktop'
		else 'None'
		end as Platform
from cte
),
cte3 as (
	select s.Spend_date, 
	cte2.Platform, 
	sum(s.Amount) as Total_Amount,
	count(distinct s.User_id) as Total_users
		from Spending s 
		join cte2
			on s.User_id = cte2.User_id
			and s.Spend_date = cte2.Spend_date 
		group by s.Spend_date, cte2.Platform
),
Dates as (
	select distinct Spend_date 
	from Spending
),
Platforms as (
	select 'Mobile' as Platform
	union all
	select 'Desktop'
	union all
	select 'Both'
),
cte4 as (
select d.Spend_date, p.Platform
from Dates d
cross join Platforms p
)
select 
	cte4.Platform,
	cte4.Spend_date,
	isnull(Total_Amount, 0) as Total_Amount,
	isnull(Total_users, 0) as Total_users
		from cte4 
		left join cte3 
		on cte3.Spend_date = cte4.Spend_date
	and cte3.Platform = cte4.Platform


