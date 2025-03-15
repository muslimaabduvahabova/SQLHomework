--7. Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
--DQL (data query language) [select]
create table Students (id int primary key, name varchar(50), age int)
insert into Students (id, name, age) values (1, 'Harry', 14)
insert into Students (id, name, age) values (2, 'Ron', 15)
insert into Students (id, name, age) values (3, 'Harmione', 14)
insert into Students (id, name, age) values (4, 'Jinni', 13)
select * from Students
--DML (data manipulation language) [insert, update, delete)
insert into Students (id, name, age) values (5, 'Luna', 14)
update Students set age =13 where name = 'Jinni'
delete from Students where name = 'Luna'
--DDL (data definition language) [create, alter, drop]
create table Theachers (id int primary key, name varchar(50), subject varchar(50))
alter table Students add Email varchar(100)
drop table Theachers 
--DCL (data control language) [grant, revoke]
CREATE LOGIN test_user WITH PASSWORD = 'StrongPassword123'
create user test_user for login test_user
grant select on Students to test_user
revoke select on Students from test_user
--TSL (transaction control language) [commit, rollback, save transaction]
begin transaction
insert into Students (id,name, age) values (5, 'Draco', 14)
save transaction save1
insert into Students (id,name, age) values (6, 'Luna', 14)
rollback transaction save1 
rollback transaction

--1. Define the following terms: data, database, relational database, and table.
--Data - refers to raw facts, numbers, or information that is collected for analysis.
--Database is an organized collection of data stored and managed in a structured way.
--Relational Database is a type of database that stores data in tables.
--Table in a database is a collection of data organized in rows and columns.


