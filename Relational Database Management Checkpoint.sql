create database RDBMSCheckpoint
GO

USE RDBMSCheckpoint
GO

CREATE TABLE wine (
    NumW INT PRIMARY KEY,
    Category VARCHAR(255),
    Year INT,
    Degree DECIMAL(5,2)
);
GO

CREATE TABLE producer (
    NumP INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Region VARCHAR(255)
);
GO

CREATE TABLE harvest (
    NumW INT FOREIGN KEY (NumW) REFERENCES wine(NumW),
    NumP INT FOREIGN KEY (NumP) REFERENCES producer(NumP),
    Quantity INT,  
);
GO

INSERT INTO wine (NumW, Category, Year, Degree)
VALUES 
(1, 'Red', 2018, 13.5),
(2, 'White', 2019, 12.0),
(3, 'Rose', 2020, 11.5);


INSERT INTO producer (NumP, FirstName, LastName, Region) 
VALUES 
(1, 'John', 'Doe', 'Napa Valley'),
(2, 'Jane', 'Smith', 'Bordeaux'),
(3, 'Emily', 'Johnson', 'Tuscany');


INSERT INTO harvest (NumW, NumP, Quantity) 
VALUES 
(1, 1, 500),
(1, 2, 300),
(2, 2, 400),
(2, 3, 600),
(3, 1, 700),
(3, 3, 500);

SELECT * FROM producer

SELECT * FROM producer
ORDER BY FirstName, LastName;

SELECT * FROM producer
WHERE Region = 'Tuscany';

SELECT SUM(Quantity) AS TotalQuantity
FROM harvest
WHERE NumW = 4;


SELECT  w.Category,
 SUM(h.Quantity) AS TotalQuantity
FROM  wine w
JOIN harvest h ON w.NumW = h.NumW
GROUP BY w.Category;


SELECT DISTINCT p.FirstName, p.LastName
FROM producer p
JOIN harvest h ON p.NumP = h.NumP
WHERE p.Region = 'Tuscany'
AND h.Quantity > 300
ORDER BY p.FirstName, p.LastName;


SELECT w.NumW
FROM wine w
JOIN harvest h ON w.NumW = h.NumW
WHERE w.Degree > 12 AND h.NumP = 24;
