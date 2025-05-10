--create database [homework-22]
--use [homework-22]

--Easy Questions

--1. Compute Running Total Sales per Customer
select customer_id, customer_name, product_category, order_date,total_amount,
sum(total_amount) over (partition by customer_id order by order_date) as RunningTotal
from sales_data

--2. Count the Number of Orders per Product Category
select product_category, order_date, 
count(total_amount) over(partition by product_category) as NumberofOrders
from sales_data

--3. Find the Maximum Total Amount per Product Category
select product_category, 
max(total_amount) over(partition by product_category) as MaxTotalAmount
from sales_data

--4. Find the Minimum Price of Products per Product Category
select product_category, 
min(unit_price) over(partition by product_category) as MinPriceofProducts
from sales_data

--5. Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
select sale_id, order_date, total_amount, 
avg(total_amount) over(order by order_date
rows between 1 preceding and 1 following) as MovingAvgofSales
from sales_data

--6. Find the Total Sales per Region
select region,
sum(total_amount) as TotalSalesPerRegion
from sales_data
group by region

--7. Compute the Rank of Customers Based on Their Total Purchase Amount
select customer_id, sum(total_amount) as total_amount,
 rank() over(order by sum(total_amount) desc) as ranked_totalAmount
 from sales_data
 group by customer_id

--8. Calculate the Difference Between Current and Previous Sale Amount per Customer
select * from 
(select customer_id, order_date, total_amount, lag(total_amount) over(partition by customer_id 
order by order_date) as lag_totalAmount 
from sales_data) as dt
where lag_totalAmount - total_amount = 1

--9. Find the Top 3 Most Expensive Products in Each Category
select * from (
select customer_name, order_date, product_category, unit_price,  
dense_rank() over(partition by product_category order by unit_price desc) as dense_rankProducts
from sales_data) dt
where dense_rankProducts <= 3


--10. Compute the Cumulative Sum of Sales Per Region by Order Date
select *,
sum(total_amount) over(partition by Region 
order by order_date asc) as SumSales
from sales_data


--Medium Questions

--11. Compute Cumulative Revenue per Product Category
select *,
sum(total_amount) over(partition by product_category 
order by order_date asc) as SumSales
from sales_data

--12. Here you need to find out the sum of previous values. Please go through the sample input and expected output.
select id,
sum(id) over(order by id rows between unbounded preceding and current row) as SumPreValues
from Ids

--13. Sum of Previous Values to Current Value
select Value, 
sum(Value) over(order by Value rows 1 preceding) as "Sum of Previous"
from OneColumn 

--14. Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.
select ID, Vals,
((dense_rank() over(order by ID) - 1) * 2) +
row_number() over(partition by ID order by Vals ) as RowNumber
from Row_Nums

--15. Find customers who have purchased items from more than one product_category
select customer_id,
count(distinct product_category) as category_count
from sales_data
group by customer_id
having count(distinct product_category) > 1

--16. Find Customers with Above-Average Spending in Their Region
select * from
(select customer_id, customer_name, total_amount, region, 
avg(total_amount) over(partition by region) as avg_region_amount
from sales_data) as dt
where total_amount <  avg_region_amount

--17. Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.
select *, dense_rank() 
over(partition by region order by total_spending) as same_rank
from(
select customer_id, region,
sum(total_amount) as total_spending
from sales_data
group by customer_id, region) as dt

--18. Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
select *, 
sum(total_amount) over (
  partition by customer_id
  order by order_date
) as cumulative_sales
from sales_data

--19. Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

--20. Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

--21. Identify Products that prices are above the average product price

--22. In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.

--23. Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.

--24. From following set of integers, write an SQL statement to determine the expected outputs

--25. In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.
