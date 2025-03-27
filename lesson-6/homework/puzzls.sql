create database [F24_class-6]
use [F24_class-6]

--Question: If all the columns have zero values, then don’t show that row. In this case,
--we have to remove the 5th row while selecting data.
--puzzle 1
--### Table Schema:
CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

--### Sample Data:
INSERT INTO TestMultipleZero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

	select * from TestMultipleZero
select top 5 * from TestMultipleZero order by A desc, B desc, C desc, D desc

--puzzle 2 
CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);
    INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

select * from InputTbl

select distinct case when col1 < col2 then col1 else col2 end, case when col1 > col2 then col1 else col2 end
from InputTbl

--puzzle 3

Puzzle 3: Find those with odd ids

create table section1(id int, name varchar(20))
insert into section1 values (1, 'Been'),
       (2, 'Roma'),
       (3, 'Steven'),
       (4, 'Paulo'),
       (5, 'Genryh'),
       (6, 'Bruno'),
       (7, 'Fred'),
       (8, 'Andro')

select * from section1
where id % 2 = 0

select 12%2
select 13%5

--puzzle 4
select top 1 * from section1 order by id asc

--puzzle 5
 select top 1 * from section1 order by id desc

 --puzzle 6
 select * from section1 
 where name like 'B%'

 --puzzle 7 

CREATE TABLE ProductCodes (
    Code VARCHAR(20)
);

INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

select * from ProductCodes
where code like '%@_%' escape '@'
