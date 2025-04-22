--Lesson 13 ----Practice: String Functions, Mathematical Functions, Date and time Functions

Notes before doing the tasks: Tasks should be solved using SQL Server. It does not matter the solutions are uppercase or lowercase, which means case insensitive. Using alies names does not matter in scoring your work. Students are scored based on what their query returns(does it fulfill the requirments). One way of solution is enough if it is true, other ways might be suggested but should not affect the score.

--Easy Tasks

1.You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
select 
concat(EMPLOYEE_ID, '-', FIRST_NAME, ' ',  LAST_NAME) 
from Employees 
Where EMPLOYEE_ID = 100

2.Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
select 
replace(PHONE_NUMBER, '124', '999') 
from Employees

3.That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees first names.(Employees)
select FIRST_NAME as FIRST_NAME,
len(FIRST_NAME) as NameLength
from Employees
where FIRST_NAME like 'A%' 
or FIRST_NAME like 'J%'
or FIRST_NAME like 'M%'
order by FIRST_NAME

4.Write an SQL query to find the total salary for each manager ID.(Employees table)
select MANAGER_ID, 
SUM(SALARY) AS Total_Salary
from Employees
group by MANAGER_ID

5.Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
select Year1,
	case 
	when Max1 >= Max2 and Max1 >= Max3 then Max1
	when Max2 >= Max1 and Max2 >= Max3 then Max2
	else Max3
	end as Highest
from TestMax


6.Find me odd numbered movies description is not boring.(cinema)
select * from cinema
where id % 2 = 1 
and description <> 'boring'


7.You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
select * 
	from SingleOrder
	order by 
	case
	when id = 0 then 1
	else 0
	end, id


8.Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
select coalesce(id, ssn, passportid, itin) as contact from person 


9.Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date, rounded to two decimal places).(Employees)
with empcte as (
select 
	EMPLOYEE_ID,
	FIRST_NAME,
	LAST_NAME,
	HIRE_DATE,
	ROUND(DATEDIFF(day, HIRE_DATE, GETDATE()) / 365.0, 2) AS YearsofCompany from Employees)
select * from empcte 
where YearsofCompany > 10 and YearsofCompany < 15


10.Find the employees who have a salary greater than the average salary of their respective department.(Employees)
with cteEmp as(
select DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
from Employees 
group by DEPARTMENT_ID)
select  Employees.DEPARTMENT_ID,
  cteEmp.AvgSalary from cteEmp join  Employees
on cteEmp.DEPARTMENT_ID = Employees.DEPARTMENT_ID
and Employees.SALARY > AvgSalary


----Medium Tasks
1.Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.

2.split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
select FullName,
	LEFT(FullName, CHARINDEX(' ', FullName)-1) AS FirstName,
	SUBSTRING(FullName, 
	CHARINDEX(' ', FullName)+1,
	CHARINDEX(' ', FullName, CHARINDEX (' ', FullName)+1) - CHARINDEX(' ', FullName)-1) AS MiddleName,
	RIGHT(FullName,LEN(FullName) - CHARINDEX(' ', FullName, CHARINDEX(' ', FullName)+1)) AS LastName
FROM Students


3.For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
select CustomerID, OrderID, DeliveryState
from Orders
where DeliveryState = 'TX'
AND CustomerID IN(
SELECT CustomerID 
from Orders
where DeliveryState = 'CA')


4.Write an SQL query to transform a table where each product has a total quantity into a new table where each row represents a single unit of that product.For example, if A and B, it should be A,B and B,A.(Ungroup)
with cte as (
select ProductDescription, Quantity
from Ungroup
union all
select ProductDescription, Quantity - 1
from cte
where Quantity - 1 > 0)
select ProductDescription, 1 as Quantity
from cte


5.Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT 
  STUFF((
    SELECT CONCAT(' ', String)
    FROM DMLTable
    ORDER BY SequenceNumber
    FOR XML PATH(''), TYPE
  ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS QueryText



6.Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
If the employee has worked for less than 1 year → 'New Hire'
If the employee has worked for 1 to 5 years → 'Junior'
If the employee has worked for 5 to 10 years → 'Mid-Level'
If the employee has worked for 10 to 20 years → 'Senior'
If the employee has worked for more than 20 years → 'Veteran'(Employees)

WITH CTE AS (
	SELECT *,
       ROUND(DATEDIFF(DAY, HIRE_DATE, GETDATE()) / 365.0, 2) AS YearsWorked
FROM Employees)
SELECT EMPLOYEE_ID,
	FIRST_NAME,
	LAST_NAME,
	HIRE_DATE,
	YearsWorked,
	case
		WHEN YearsWorked < 1 THEN 'New Hire'
		WHEN YearsWorked >= 1 AND YearsWorked < 5 THEN 'Junior'
		WHEN YearsWorked >= 5 AND YearsWorked < 10 THEN 'Mid-Level'
		WHEN YearsWorked >= 10 AND YearsWorked < 20 THEN 'Senior'
		ELSE 'Veteran' 
		END AS EmploymentStage
FROM CTE 

7.Find the employees who have a salary greater than the average salary of their respective department(Employees)
with cteEmp as(
select DEPARTMENT_ID, AVG(SALARY) AS AvgSalary
from Employees 
group by DEPARTMENT_ID)
select  Employees.DEPARTMENT_ID,
  cteEmp.AvgSalary from cteEmp join  Employees
on cteEmp.DEPARTMENT_ID = Employees.DEPARTMENT_ID
and Employees.SALARY > AvgSalary


8.Find all employees whose names (concatenated first and last) contain the letter "a" and whose salary is divisible by 5(Employees)
select * from Employees
where 
	lower(concat(FIRST_NAME, LAST_NAME)) like '%a%'
	and cast(SALARY as int) % 5 = 0


9.The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
WITH EmpWithYears AS (
    SELECT 
        EMPLOYEE_ID,
        DEPARTMENT_ID,
        DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsWorked
    FROM Employees),
EmpCounts AS (
    SELECT 
        DEPARTMENT_ID,
        COUNT(*) AS TotalEmployees,
        SUM(CASE WHEN YearsWorked > 3 THEN 1 ELSE 0 END) AS MoreThan3Years
    FROM EmpWithYears
    GROUP BY DEPARTMENT_ID)
SELECT 
    DEPARTMENT_ID,
    TotalEmployees,
    MoreThan3Years,
    ROUND(100.0 * MoreThan3Years / TotalEmployees, 2) AS PercentageOver3Years
FROM EmpCounts;



10.Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
SELECT 
    JobDescription,
    MIN(SpacemanID) AS MostExperiencedID,
    MAX(SpacemanID) AS LeastExperiencedID
FROM Personal
GROUP BY JobDescription;

----Difficult Tasks
1.Write an SQL query that replaces each row with the sum of its value and the previous rows value. (Students table)
WITH cteEmp AS (
    SELECT EmployeeID,
           ManagerID,
           JobTitle,
           0 AS Level
    FROM Employee
    WHERE JobTitle = 'President'
    UNION ALL
    SELECT e.EmployeeID,
           e.ManagerID,
           e.JobTitle,
           cte.Level + 1 AS Level
    FROM Employee e
    INNER JOIN cteEmp cte ON e.ManagerID = cte.EmployeeID)
SELECT EmployeeID,
       JobTitle,
       Level
FROM cteEmp
ORDER BY Level, EmployeeID;


3.You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)


4.Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT s1.StudentName, s1.Birthday
FROM Student s1
JOIN Student s2 ON s1.Birthday = s2.Birthday
WHERE s1.StudentName < s2.StudentName
ORDER BY s1.Birthday, s1.StudentName;

5.You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT
    LEAST(PlayerA, PlayerB) AS Player1,
    GREATEST(PlayerA, PlayerB) AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY
    LEAST(PlayerA, PlayerB),
    GREATEST(PlayerA, PlayerB)
ORDER BY
    Player1, Player2;
