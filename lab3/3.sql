-- 1 
SELECT SUM(UnitPrice * Quantity * ( 1 - Discount)) FROM [Order Details]
WHERE OrderID = 10250

-- 2
SELECT OrderID, MAX(UnitPrice) as 'maximum' From [Order Details]
GROUP BY OrderID
ORDER BY MAX(UnitPrice) DESC

-- 3
SELECT OrderID, MAX(UnitPrice) as 'maximum', MIN(UnitPrice) as 'minimum' From [Order Details]
GROUP BY OrderID

-- 4
SELECT MAX(UnitPrice) - MIN(UnitPrice) FROM [Order Details]
GROUP BY OrderID

-- 5
SELECT ShipVia, COUNT(*) FROM Orders
GROUP BY ShipVia

-- 6
SELECT TOP 1 ShipVia, Count(*) FROm Orders
WHERE YEAR(ShippedDate) = 1997
GROUP BY ShipVIa
ORDER BY COUNT(*) DESC

-- 7
SELECT COUNT(*) , OrderID FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(*) > 5


-- 8
SELECT CustomerID, Count(*), SUM(od.UnitPrice * od.Quantity * ( 1 - od.Discount)) FROM Orders
INNER JOIN [Order Details] as od on od.OrderID = Orders.OrderID
WHERE YEAR(ShippedDate) = 1998
GROUP BY CustomerID
Having Count(*) > 8
Order By SUM(UnitPrice * Quantity * ( 1 - Discount)) DESC