--use [homework-23]

--Puzzle 1: In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. Please check out sample input and expected output.

select * from Dates
select Id, Dt,
right('0' + cast(month(dt) as varchar), 2) as MonthPrefixedWithZero
from Dates

--Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.
select 
count(distinct id) as ID,
max(rID) as rID,
sum(MaxVals) as TotalOfMaxVals
from (
		select id, rID, 
		max(Vals) as MaxVals
	from MyTabel
	group by id, rID) as dt
;

--Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. Please see the sample input and expected output.
;
select Id, Vals
from TestFixLengths
where len(Vals) between 6 and 10
and Vals is not null
and vals <> '';

--Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value. Please check out sample input and expected output.
;
select t.ID, t.Item, t.Vals
from TestMaximum t
join ( 
	select id, max(vals) as MaxVals
	from TestMaximum
	group by id ) m
on t.ID = m.ID and t.Vals = m.MaxVals
;

--Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, and then Sum the data using Id only. Please check out sample input and expected output.
;
select ID, sum(DataValue) as SumofMax
from (
select DetailedNumber, max(Vals) as DataValue, Id 
from SumOfMax
group by DetailedNumber, Id) as dt
group by ID

--Puzzle 6: In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.
;
select ID, a, b,
	case 
		when a - b != 0 then a - b
		else ''
		end as Output
from TheZeroPuzzle

--7. What is the total revenue generated from all sales?  
select sum( quantitysold * unitprice) as total_rev
from sales

--8. What is the average unit price of products?
select product,avg(unitprice) as avg_p
from sales
group by product

--9. How many sales transactions were recorded?  
select count(saleid) as trans_rec
from sales

--10. What is the highest number of units sold in a single transaction?  
select saleid, max(quantitysold) as max_q
from sales
group by saleid

--11. How many products were sold in each category?  
select category , count(product)
from sales
group by category

--12. What is the total revenue for each region?  
select region, sum( quantitysold * unitprice) as total_rev
from sales
group by region

--13. Which product generated the highest total revenue? 
with cte as(
   select product, sum( quantitysold * unitprice) as total_rev
   from sales
   group by product)
select product, total_rev
from cte
where total_rev = (
     select max(total_rev) as max_r
     from cte)
          
--14. Compute the running total of revenue ordered by sale date.
select *,
  sum( quantitysold * unitprice) over( order by saledate desc) as total_rev
from sales

--15. How much does each category contribute to total sales revenue?  
select category, sum( quantitysold * unitprice) as total_rev,
 (sum(quantitysold * unitprice) / (select sum( quantitysold * unitprice) from sales)) as categ_contr
from sales
group by category
