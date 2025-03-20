--1. Define and explain the purpose of BULK INSERT in SQL Server. 
BULK INSERT Products  
FROM 'C:\data\Products.csv'   

--2. List four file formats that can be imported into SQL Server.
--there is four file formats that can be important into SQL Server.
--1) CVS (COMMA-SEPARATED VALUES) a simple text file where data is separated by commas.
--2) Excel - spreadsheet files that can be imported using SQL tools.
--3) JSON (JavaScrip Object Notation) a format used to store and exchange structured data. 
--4) XML (Extensuble Markup Language) another structured format, often used for data transfer.

--3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)
create table Products (PrID int primary key, PrName varchar(50), Price decimal(10,2))

--4. Insert three records into the Products table using INSERT INTO.
insert into Products (PrID, PrName, Price) values (1, 'Phone', 500.00), (2,'Laptop',1200.50), (3, 'Tablet', 300.75)
select * from Products 

--5. Explain the difference between NULL and NOT NULL with examples.
insert into Products (PrID, PrName, Price) values (4, 'Smartwatch', null) --the price is unknown
--null - means unknown or absent. 
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    OrderDate DATE NULL)
--Not null - when the data must be present.

--6. Add a UNIQUE constraint to the ProductName column in the Products table.
alter table Products
add constraint UQ_PrName unique (PrName)

--7. Write a comment in a SQL query explaining its purpose.
--a comment writes with this --
select * from Products 

--8. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
create table Categories (CategoryId int primary key, CategoryName varchar(50) unique)

--9. Explain the purpose of the IDENTITY column in SQL Server.
create table ExampleTable (ID int identity(1,1) primary key, Somedata varchar(100))
--IDENTITY(1,1) means that the firs value will be 1, and each subsequent value will incrase by 1.
--10. Use BULK INSERT to import data from a text file into the Products table.
select * from Products

--11. Create a FOREIGN KEY in the Products table that references the Categories table.
select * from Categories
alter table Pruducts
add CategoryID int
SELECT * FROM sys.tables
WHERE name = 'Categories'
DROP TABLE Categories
EXEC sp_help 'Categories'

SELECT DB_NAME() AS CurrentDatabase
