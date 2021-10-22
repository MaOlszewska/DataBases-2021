--9
SELECT COUNT(*) as 'count' FROM Employees
WHERE YEAR(BirthDate) < 1960 AND City = 'London'

--10 
SELECT TOP 5 * FROM Employees
ORDER BY YEAR(BirthDate) ASC

--11
SELECT COUNT(*) FROM Employees
WHERE (YEAR(BirthDate) BETWEEN 1950 AND 1955 OR YEAR(BirthDate) BETWEEN 1958 AND 1960) AND City = 'London'

--12
SELECT ProductName FROM Products
WHERE Discontinued = 1

--13
SELECT OrderID, CustomerID, OrderDate FROM Orders
WHERE DATEFROMPARTS(1996,09,1) > OrderDate

--14
SELECT CompanyName FROM Customers
WHERE CompanyName LIKE'%the%'

--15
SELECT CompanyName FROM Customers
WHERE CompanyName LIKE'B%' OR CompanyName LIKE'W%'

--16
SELECT * FROM Products
WHERE (ProductName LIKE'C%' OR ProductID < 40) AND UnitPrice > 20

--17



--18 i 19
SELECT SUM(Quantity) as 'cnt', SUM(Quantity * UnitPrice) as 'c',Year(OrderDate) as 'Year' FROM Orders as o
FULL OUTER JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)

--20
SELECT CompanyName FROM Suppliers
WHERE HomePage IS NULL AND Fax IS NULL AND (Country = 'USA' OR Country = 'Germany')

--21 
SELECT ProductName, QuantityPerUnit FROM Products
WHERE QuantityPerUnit LIKE'%Bottle%' OR QuantityPerUnit LIKE'%glass%'

--22
SELECT TOP 1 COUNT(CategoryID) as count, CategoryID   FROM Products
GROUP BY CategoryID
ORDER BY count DESC

--23
SELECT COUNT(UnitsInStock) as count, CategoryID FROM Products
GROUP BY CategoryID
ORDER BY count ASC
