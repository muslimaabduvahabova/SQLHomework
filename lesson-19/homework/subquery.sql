--create database [homework-19]
--use [homework-19]

--1. Find Employees with Minimum Salary
;
select * from employees
where salary = (select min(salary) from employees)


--2. Find Products Above Average Price
;
select * from products
where price > (select avg(price) from products)


--3. Find Employees in Sales Department
;
select * from employees
where department_id = (select id from departments where department_name = 'Sales')


--4. Find Customers with No Orders
;
select * from customers
where customer_id not in (select customer_id from orders )


--5. Find Products with Max Price in Each Category
--Aggregation and Grouping in Subqueries
;
select * from products p1
where p1.price = 
(select max(price) from products p2 where p1.category_id = p2.category_id) --Correlated Subqueries


--6. Find Employees in Department with Highest Average Salary
;
SELECT *
FROM Employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM Employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC);

--7. Find Employees Earning Above Department Average
;
select * from employeess e1
where e1.salary > 
(select avg(salary) from employeess e2 where e1.department_id = e2.department_id group by department_id)


--8. Find Students with Highest Grade per Course
;
select s.student_id,
		s.name,
		g.course_id,
		g.grade
	from students s
	join grades g
on s.student_id = g.student_id
where g.grade = (select max(grade) from grades where course_id = g.course_id)


--9. Find Third-Highest Price per Category 
;
select * from productss p1 
where p1.price = (
select min(price) from 
(select distinct top 3 p2.price from productss p2
where p1.category_id = p2.category_id
order by p2.price desc) as top_price)


--10. Find Employees Between Company Average and Department Max Salary
;
select * from employeesss
;
select * from employeesss e1
where salary > (
select avg(salary) from employeesss)
and salary < (
select max(salary) from employeesss e2 where e1.department_id = e2.department_id)



