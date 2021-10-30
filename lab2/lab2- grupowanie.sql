-- część 1
--1
SELECT Count(*) FROM [Products]
WHERE UnitPrice < 10 OR UnitPrice > 20

--2
SELECT TOP 1 UnitPrice FROM Products
Where UnitPrice < 20
Order by UnitPrice DESC

--3
SELECT MAX(UnitPrice) as 'max', MIN(UnitPrice) as 'min', AVG(UnitPrice) as 'avg' FROM Products
WHERE QuantityPerUnit LIKE'%bottle%'

--4
SELECT * FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)

--5 
SELECT  SUM(Quantity * (UnitPrice * (1 - Discount)))  FROM [Order Details]
WHERE OrderID = 10250



--Część 2

--1
SELECT OrderID, MAX(UnitPrice * (1 - Discount)) FROM [Order Details]
GROUP BY OrderID

--2
SELECT OrderID  FROM [Order Details]
GROUP BY OrderID
ORDER By MAX(UnitPrice * (1 - Discount)) ASC

--3
SELECT OrderID, MAX(UnitPrice * (1 - Discount)) as 'max', MIN(UnitPrice * (1 - Discount)) as 'max' FROM [Order Details]
GROUP BY OrderID

--4
SELECT ShipVia, COUNT(*) FROM Orders 
GROUP BY ShipVia

--5 
SELECT TOP 1 ShipVia, COUNT(*) as 'count'FROM Orders 
WHERE YEAR(ShippedDate) = 1997
GROUP BY ShipVia
ORDER BY count DESC



--Część 3

--1
SELECT OrderID, Count(*) as 'count' FROM [Order Details]
GROUP BY OrderID 
HAVING  Count(*) > 5

--2 
SELECT CustomerID, COUNT(*), SUM(Quantity * UnitPrice * (1 - Discount)) as 'Price' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE YEAR(ShippedDate) = 1998
GROUP BY CustomerID
HAVING COUNT(*) > 8
ORDER BY Price DESC

