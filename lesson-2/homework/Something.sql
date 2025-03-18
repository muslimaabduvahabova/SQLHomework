--1. Create table 'Employees' with columns; 'EmpID' int 'name' varchar(50), and 'salary' (DECIMAL(10,2)).
create table Employees (Empid int, name varchar(50), salary decimal(10,2))
drop table Employees 

--2. Insert three records into the 'Employees' table using different INSERT INTO approaches (single-row insert and multiple-row insert) 
insert into Employees (Empid, name, salary) values (1,'Harry', 50000.00), (2,'Hermione', 55000.50), (3,'Ron', 60000.75)
insert into Employees (Empid, name, salary) values (4,'luna', 55000.60)
insert into Employees (Empid, name, salary) values (5,'Draco', 65000.50)
insert into Employees (Empid, name, salary) values (6,'Nevill', 60000.65)

--3. Update the 'salary' of an employee where 'EmpID=1'
Update Employees 
set salary =52000.00
where Empid = 1

--4. Delete a record from the 'Employees' table where 'EmpID=2'
delete from Employees 
where Empid = 2

--5. Demonstrate the difference between `DELETE`, `TRUNCATE`, and `DROP` commands on a test table.
delete from Employees
--DELETE deletes rows, but the table structure remains.
truncate table Employees
--TRUNCATE completely clears the table.
drop table Employees 
--DROP deletes a table completely (data and structure disappear)

--6. Modify the `Name` column in the `Employees` table to `VARCHAR(100)`.
create table Employees (EmpID int, name varchar(50), salary decimal(10,2))
insert into Employees (Empid, name, salary) values (1,'Harry', 50000.00), (2,'Hermione', 55000.50), (3,'Ron', 60000.75)
insert into Employees (Empid, name, salary) values (4,'luna', 55000.60)
insert into Employees (Empid, name, salary) values (5,'Draco', 65000.50)
insert into Employees (Empid, name, salary) values (6,'Nevill', 60000.65)
alter table Employees 
alter column name varchar (100)
select * from Employees

--7. Add a new column `Department` (`VARCHAR(50)`) to the `Employees` table.
alter table Employees 
add Department varchar(50)

--8. Change the data type of the `Salary` column to `FLOAT`.
alter table Employees
alter column Salary FLOAT

--9. Create another table `Departments` with columns `DepartmentID` (INT, PRIMARY KEY) and `DepartmentName` (VARCHAR(50)).
drop table Departments
create table Departments (DepartmentID int primary key, DepartmentName varchar(50))

--10. Remove all records from the `Employees` table without deleting its structure.
delete from Employees 

--11. Insert five records into the `Departments` table using `INSERT INTO SELECT` from an existing table.
select * from Departments
insert into Departments (DepartmentID, DepartmentName) values (1,'Harry'), (2,'Hermione'), (3,'Ron')
insert into Departments (DepartmentID, DepartmentName) values (4,'luna')
insert into Departments (DepartmentID, DepartmentName) values (5,'Draco')
insert into Departments (DepartmentID, DepartmentName) values (6,'Nevill')
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'Harry' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 1)
UNION ALL
SELECT 2, 'Hermione' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 2)
UNION ALL
SELECT 3, 'Ron' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 3)
UNION ALL
SELECT 4, 'Luna' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 4)
UNION ALL
SELECT 5, 'Draco' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 5)
insert into Departments (DepartmentID, DepartmentName) 
select DepartmentID, DepartmentName from Departments where DepartmentID < 5 
select * from DEpartments
delete from Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'Harry' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 1)
UNION ALL
SELECT 2, 'Hermione' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 2)
UNION ALL
SELECT 3, 'Ron' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 3)
UNION ALL
SELECT 4, 'Luna' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 4)
UNION ALL
SELECT 5, 'Draco' WHERE NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = 5);
insert into Departments (DepartmentID, DepartmentName) 
select DepartmentID, DepartmentName from Departments where DepartmentID < 5 

--12. Update the `Department` of all employees where `Salary > 5000` to 'Management'.
update Employees
set Departments = 'Management'
where Salary > 5000
select top 5 * from Employees
INSERT INTO Employees (EmpID, name, salary, Department)  
VALUES  
(1, 'John', 6000, 'IT'),  
(2, 'Anna', 4500, 'HR'),  
(3, 'Mike', 7000, 'Finance'),  
(4, 'Sara', 4800, 'Marketing'),  
(5, 'David', 5500, 'IT');
update Employees 
set Department = 'Management' 
where salary > 5000
select top 5 * from Employees

--13. Write a query that removes all employees but keeps the table structure intact.
delete from Employees 
--difference between DELETE and TRUNCATE.
--DELETE FROM EMLOYEES - deleted all rows, but leaves the table and allows you to ROLLBACL changes.
--TRUNCATE TABLE EMPLOYEES - clears the table faster, but cannot be ROLLEDBACK. 

--14. Drop the `Department` column from the `Employees` table.
select * from Employees
INSERT INTO Employees (EmpID, Name, Salary, Department) VALUES
(1, 'John Doe', 6000, 'IT'),
(2, 'Jane Smith', 4500, 'HR'),
(3, 'Michael Brown', 7000, 'Management'),
(4, 'Emily Davis', 5500, 'Finance'),
(5, 'David Wilson', 4800, 'Sales');
alter table Employees
drop column Department

--15. Rename the `Employees` table to `StaffMembers` using SQL commands.
EXEC sp_rename 'Employees', 'StaffMembers'

--16. Write a query to completely remove the `Departments` table from the database.
drop table Departments 
select * from Departments 
--this query completely deletes the Departments table along with all its data and structure.

--17. Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255),
    Category VARCHAR(100),
    Price DECIMAL(10,2),
    Description TEXT)

--18. Add a CHECK constraint to ensure Price is always greater than 0.
alter table Products
add constraint chk_price Check (Price > 0)

--19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.
alter table Products
add StockQuantity int default 50

--20. Rename Category to ProductCategory
exec sp_rename 'Products.Category', 'ProductCategory', 'COLUMN'

--21. Insert 5 records into the Products table using standard INSERT INTO queries.
insert into Products (ProductID, ProductName, ProductCategory, Price, StockQuantity) values (1, 'Laptop', 'Electronics', 1200.99, 30),
(2, 'Phone', 'Electronics', 800.50, 50),
(3, 'Table', 'Furniture', 150.75, 20),
(4, 'Chair', 'Furniture', 75.25, 40),
(5, 'Headphones', 'Accessories', 199.99, 25)

--22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
select * into Products_Backup from Products

--23. Rename the Products table to Inventory.
exec sp_rename 'Products', 'Inventory'

--24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
alter table Inventory 
alter column Price FLOAT 
sp_help 'Inventory'
SELECT name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('Inventory')
alter table Inventory
drop constraint chk_price

--25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.
alter table Inventory
add ProductCode int identity(1000,5)
sp_help 'Inventory'
select * from Inventory
