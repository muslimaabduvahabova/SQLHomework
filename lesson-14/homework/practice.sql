--create database [homework-14]
--use [homework-14]



--# Easy Tasks
--1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
select 
	left(name, charindex(',', name) - 1) as Name,
	ltrim(right(name, len(name) - charindex(',', name))) as Surname
from TestMultipleColumns

--2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
select *
	from TestPercent
		where Strs like '%[%]%'


--3. In this puzzle you will have to split a string based on dot(.).(Splitter)

SELECT 
  LEFT(Vals, CHARINDEX('.', Vals) - 1) AS Part1,
  CASE 
    WHEN CHARINDEX('.', Vals) > 0 AND CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1) > 0 THEN
      SUBSTRING(Vals, 
                CHARINDEX('.', Vals) + 1, 
                CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1) - CHARINDEX('.', Vals) - 1)
    ELSE NULL
  END AS Part2,
  CASE 
    WHEN LEN(Vals) - LEN(REPLACE(Vals, '.', '')) >= 2 THEN
      RIGHT(Vals, LEN(Vals) - CHARINDEX('.', Vals, CHARINDEX('.', Vals) + 1))
    ELSE NULL
  END AS Part3
FROM Splitter;


--4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') AS Result;


--5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
SELECT * 
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

--6. Write a SQL query to count the occurrences of a substring within a string in a given column.(Not table)
SELECT 
  (LEN('abcabcabc') - LEN(REPLACE('abcabcabc', 'abc', ''))) / LEN('abc') AS SubstringCount;
   

--7. Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT 
  LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;


--8. write a SQL query that finds out employees who earn more than their managers.(Employee)
SELECT e1.Name
FROM Employee e1
JOIN Employee e2 ON e1.ManagerID = e2.ID
WHERE e1.Salary > e2.Salary;


select * from Employee

--# Medium Tasks
--1. Write a SQL query to separate the integer values and the character values into two different columns.(SeperateNumbersAndCharcters)
SELECT 
    Value,
    REPLACE(TRANSLATE(Value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ', 52)), ' ', '') AS Numbers,
    REPLACE(TRANSLATE(Value, '0123456789', REPLICATE(' ', 10)), ' ', '') AS Characters
FROM SeperateNumbersAndCharcters;


--2. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT Id
FROM (
    SELECT 
        Id,
        RecordDate,
        Temperature,
        LAG(Temperature) OVER (ORDER BY RecordDate) AS PrevTemp
    FROM Weather
) AS TempCompare
WHERE Temperature > PrevTemp;


--3. Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT player_id, device_id
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity
) AS ranked
WHERE rn = 1;


--4. Write an SQL query that reports the first login date for each player.(Activity)
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;


--5. Your task is to split the string into a list using a specific separator (such as a space, comma, etc.), and then return the third item from that list.(fruits)
SELECT 
  TRIM(value) AS third_item
FROM (
  SELECT 
    value = PARSENAME(REPLACE(fruit_list, ',', '.'), 1)
  FROM fruits
) AS sub


--6. Write a SQL query to create a table where each character from the string will be converted into a row, with each row having a single column.(sdgfhsdgfhs@121313131)
WITH chars AS (
  SELECT 
    TOP (LEN('sdgfhsdgfhs@121313131')) 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
  FROM master.dbo.spt_values
)
SELECT 
  SUBSTRING('sdgfhsdgfhs@121313131', n, 1) AS character
FROM chars;


--7. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
SELECT 
  p1.id,
  CASE 
    WHEN p1.code = 0 THEN p2.code
    ELSE p1.code
  END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;


--8. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)
select * from WeekPercentagePuzzle
;
with cte as (
select Area,
		Date,
		isnull(SalesLocal, 0) as SalesLocal,
		isnull(SalesRemote, 0) as SalesRemote,
		DayName,
		DayOfWeek,
		FinancialWeek,
		MonthName,
		FinancialYear
from WeekPercentagePuzzle 
),
cte2 as (
select Area, 
		FinancialWeek,
		sum(SalesLocal + SalesRemote) as sumSales
	from cte
group by Area, FinancialWeek
),
cte3 as (
select cte.Area,
       cte.FinancialWeek,
       cte.Date,
       cte.DayName,
         case 
           when cte2.sumSales > 0 then round((cte.SalesLocal + cte.SalesRemote) * 100.0 / cte2.sumSales, 3)
         else 0
      end as Percentage
     from cte 
   join cte2
   on cte.Area = cte2.Area
   and cte.FinancialWeek = cte2.FinancialWeek)
select * from cte3 
order by Area, FinancialWeek, Date;


--# Difficult Tasks
--1. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
--2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
--3. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)
--4. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
--5. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)



