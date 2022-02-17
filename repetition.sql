-- Zapytania 1
-- 1
SELECT CompanyName, Address FROM Customers
WHERE City = 'London'

-- 2
SELECT CompanyName, Address FROM Customers
WHERE City = 'London' OR City = 'Madrid'

-- 3
SELECT ProductName, UnitPrice From Products
WHERE UnitPrice > 40

-- 4
SELECT ProductName, UnitPrice From Products
WHERE UnitPrice > 40
ORDER BY UnitPrice ASC

-- 5
SELECT COUNT(*) FROM Products
WHERE UnitPrice > 40

-- 6
SELECT COUNT(*) FROM Products
WHERE UnitPrice > 40 AND UnitsInStock > 100

-- 7 
SELECT COUNT(*) FROM Products
WHERE UnitPrice > 40 AND UnitsInStock > 100 AND CategoryID BETWEEN 2 AND 3

-- 8
SELECT ProductName, UnitPrice FROM Products as p
JOIN Categories as c on c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Seafood'

-- 9 
SELECT COunt(*) FROM Employees
WHERE YEAR(BirthDate) < 1960 AND City = 'London'

-- 10
SELECT TOP 5 FirstName + ' ' + LastName FROM Employees
ORDER BY YEAR(BirthDate) ASC

-- 11
SELECT COunt(*) FROM Employees
WHERE YEAR(BirthDate) BETWEEN 1950 AND 1955 AND City = 'London' AND YEAR(BirthDate) BETWEEN 1958 AND 1960

-- 12 
SELECT ProductName FROM Products
WHERE Discontinued = 0

-- 13 
SELECT OrderID, CustomerID FROM Orders
WHERE OrderDate < DATEFROMPARTS(1996,09,1)

-- 14
SELECT CompanyName, City + ' ' + Address FROM Customers
WHERE CompanyName LIKE'%the%' 

-- 15 
SELECT CompanyName, City + ' ' + Address FROM Customers
WHERE CompanyName LIKE'B%' OR CompanyName LIKE'W%'

-- 16 
SELECT ProductName From Products
WHERE UnitPrice > 20 AND (ProductName LIKE'%C' OR ProductID < 40)

-- 17 18 19 raporty

-- 20
SELECT CompanyName FROM Suppliers 
WHERE Fax IS NULL AND HomePage IS NULL AND (Country = 'USA' OR Country = 'Germany')

-- 21
SELECT COUNT(*) FROM Products
WHERE QuantityPerUnit LIKE'%Bottle%' OR QuantityPerUnit LIKE '%Glass'
 
-- 22
SELECT COUNT(CategoryID), CategoryID FROM Products
GROUP BY CategoryID
ORDER BY COUNT(CategoryID) DESC

-- 23
SELECT CategoryID, SUM(UnitsInStock) FROM Products
GROUP BY CategoryID
ORDER BY SUM(UnitsInStock) ASC


-- ZAPYTANIA 2

-- 1
SELECT OrderID, UnitPrice, Quantity, UnitPrice * Quantity, 1.15 * UnitPrice, UnitPrice * Discount, UnitPrice * 1.15 * Discount FROM [Order Details]

-- 2
SELECT TitleOfCourtesy  + FirstName + ' ' + LastName + ', ur. ' + CONVERT(varchar,BirthDate,4) +
', zatrudniony w dniu ' + CONVERT(varchar, HireDate,4)+ ', adres: ' + Address + ', ' + City + ', ' +
PostalCode + ', ' + Country  FROM Employees
ORDER BY BirthDate ASC

-- 3
SELECT TOP 3  TitleOfCourtesy  + FirstName + ' ' + LastName +', zatrudniony: ' + CONVERT(varchar, HireDate,4) FROM Employees
ORDER BY HireDate DESC

-- 4
SELECT COUNT(*) FROM Employees
WHERE  Region IS NOT NULL

-- 5
SELECT AVG(UnitPrice) FROM Products

-- 6
SELECT AVG(UnitPrice) FROM Products
WHERE UnitsInStock >= 30

-- 7
SELECT AVG(UnitPrice) FROM Products
WHERE UnitsInStock > (SELECT AVG(UnitsInStock) FROM Products)

-- 8
SELECT SUM(Quantity) FROM [Order Details]
WHERE UnitPrice > 30

--9 
SELECT AVG(UnitPrice), MAX(UnitPrice), MIN(UnitPrice) FROM Products
WHERE QuantityPerUnit LIKE'%bottle%'

-- 10
SELECT ProductName, ProductID, CategoryID, UnitPrice FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM PRODUCTS)


-- ZAPYTANIA 3

-- 11
SELECT SUM(UnitPrice * (1- Discount)) FROM [Order Details]
WHERE OrderID = 10250

-- 12 
SELECT MAX(UnitPrice * (1 - Discount)), OrderID  FROM [Order Details]
GROUP BY OrderID 
ORDER BY MAX(UnitPrice * (1 - Discount)) DESC

-- 13
SELECT MAX(UnitPrice * (1 - Discount)), MIN(UnitPrice * (1 - Discount)), OrderID  FROM [Order Details]
GROUP BY OrderID 

-- 14 
SELECT MAX(UnitPrice * (1 - Discount)) - MIN(UnitPrice * (1 - Discount)) FROM [Order Details]
GROUP BY OrderID 

-- 15
SELECT ShipVia, COUNT(*) FROM Orders
GROUP By ShipVia

-- 16
SELECT TOP 1 ShipVia, COUNT(*) FROM Orders
WHERE YEAR(ShippedDate) = 1997
GROUP By ShipVia
ORDER BY COUNT(*) DESC

-- 17
SELECT OrderID, COUNT(*)FROM [Order Details]
Group By OrderID
HAVING COUNT(*) > 5

-- 18
SELECT CustomerID, COunt(*) FROM Orders as o
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1998 
GROUP BY o.CustomerID
Having COunt(*) > 8
Order By SUM(UnitPrice * Quantity * ( 1 - Discount)) DESC

-- Zapytania 4

-- 1
SELECT ProductName, UnitPrice, CompanyName, Address+' '+City+' '+PostalCode+' '+Country AS'Adres'  FROM Products, Suppliers
WHERE UnitPrice BETWEEN 20 AND 30 AND Products.SupplierID = Suppliers.SupplierID

SELECT ProductName, UnitPrice, s.Address+' '+City+' '+PostalCode+' '+Country AS'Adres'  FROM Products as p
INNER JOIN Suppliers as s on s.SupplierID = p.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30

-- 2
SELECT ProductName, UnitsInStock FROM Products, Suppliers
WHERE Products.SupplierID = Suppliers.SupplierID AND Suppliers.CompanyName = 'Tokyo Traders'

SELECT ProductName, UnitsInStock FROM Suppliers as s
INNER JOIN Products as p on s.SupplierID = p.SupplierID
WHERE CompanyName LIKE'Tokyo Traders'

-- 3
SELECT COmpanyName, Address + ' ' + City FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders
                        WHERE YEAR(OrderDate) = 1997)


SELECT CompanyName , Address + ' ' + City FROM Customers as c
WHERE c.CustomerID not in ( SELECT cu.CustomerID FROM Customers as  cu 
                            LEFT JOIN Orders as o on c.CustomerID = o.CustomerID
                            WHERE YEAR(o.OrderDate) = 1997)

-- 4
SELECT CompanyName, Phone FROM Suppliers, Products
WHERE Products.UnitsInStock = 0 AND Suppliers.SupplierID = Products.SupplierID

SELECT CompanyName, Phone FROM Suppliers as s 
INNER JOIN Products as p on s.SupplierID = p.SupplierID
WHERE p.UnitsInStock = 0

-- 5
SELECT ProductName, UnitPrice, CompanyName + ' '+  Address + ' ' + City FROM Products, Categories, Suppliers
WHERE Suppliers.SupplierID = Products.SupplierID AND Categories.CategoryID = Products.CategoryID AND CategoryName = 'Meat/Poultry' AND UnitPrice BETWEEN 20 AND 30


SELECT ProductName, UnitPrice, CompanyName + ' '+  Address + ' ' + City FROM Products 
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 
WHERE(UnitPrice BETWEEN 20 AND 30) AND Categories.CategoryName = 'Meat/Poultry'

-- 6
SELECT ProductName, UnitPrice, CompanyName FROM Products, Categories, Suppliers
WHERE Products.CategoryID = Categories.CategoryID AND CategoryName = 'Confections' AND Suppliers.SupplierID = Products.SupplierID

SELECT ProductName, UnitPrice, Suppliers.CompanyName FROM Products
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID
JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = 'Confections'

-- 7 
SELECT Customers.CompanyName, Customers.Phone FROM Customers, Shippers, Orders
WHERE YEAR(ShippedDate) = 1997 AND Customers.CustomerID = Orders.CustomerID AND Orders.ShipVia = Shippers.ShipperID AND Shippers.CompanyName = 'United Package'


SELECT Customers.CompanyName, Customers.Phone FROM Customers 
JOIN Orders on Orders.CustomerID = Customers.CustomerID
JOIN Shippers on Shippers.ShipperID = Orders.ShipVia
WHERE Shippers.CompanyName = 'United Package' AND YEAR(ShippedDate) = 1997

-- 8
SELECT DISTINCT Customers.CompanyName, Customers.Phone From Customers, Orders, [Order Details], Products, Categories
WHERE Orders.CustomerID = Customers.CustomerID AND Orders.OrderID =[Order Details].OrderID 
AND Products.ProductID = [Order Details].ProductID AND Categories.CategoryID = Products.CategoryID AND Categories.CategoryName = 'Confections'


SELECT DISTINCT c.CompanyName, c.Phone FROM Customers as c
JOIN Orders as o on c.CustomerID = o.CustomerID
JOIN  [Order Details] as od on od.OrderID = o.OrderID
JOIN Products as p  on p.ProductID = od.ProductID
JOIN Categories as ca on ca.CategoryID = p.CategoryID
WHERE ca.CategoryName = 'Confections'


-- ZAPYTANIA 5

-- 3
SELECT DISTINCT c.CompanyName, c.Phone FROM Customers as c
WHERE c.CustomerID not in (SELECT cu.CustomerID FROM Customers as cu
                            LEFT JOIN Orders as o on o.CustomerID = c.CustomerID
                            LEFT JOIN [Order Details] as od on od.OrderID = o.OrderID
                            LEFT JOIN Products as p on od.ProductID = p.ProductID
                            LEFT JOIN Categories on Categories.CategoryID = p.CategoryID
                            WHERE Categories.CategoryName = 'Confections')


select distinct CompanyName, Phone 
from Customers c
	where not exists (select * from Orders o 
	where o.CustomerID = c.CustomerID and
	exists (select * from [Order Details] od
	where od.OrderID = o.OrderID and 
	exists (select * from Products p
	where p.ProductID = od.ProductID and 
	exists (select * from Categories cat
	where cat.CategoryID = p.CategoryID and CategoryName = 'Confections'))))    

-- 4 
SELECT  ord.ProductID, (SELECT MAX(Quantity) FROM [Order Details] as od WHERE ord.ProductID = od.ProductID ),ProductName  FROM [Order Details] as ord,Products as p
WHERE ord.ProductID = p.ProductID
Group BY ord.ProductID, ProductName

SELECT DISTINCt ProductName, Quantity FROM Products, [Order Details]
WHERE QUantity = (SELECT max(Quantity) FROM [Order Details] WHERE Products.ProductID = [Order Details].ProductID )

-- 5
SELECT AVG(UnitPrice) FROM Products
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < ( SELECT AVG(UnitPrice) FROM Products)

-- 6 
SELECT CategoryID, (SELECT AVG(UnitPrice) FROM Products as p WHERE p.CategoryID = Products.CategoryID) FROM Products
GROUP BY CategoryID

SELECT ProductName, CategoryID, UnitPrice FROM Products as p
Where p.UnitPrice < (SELECT AVG(UnitPrice) FROM Products WHERE p.CategoryID = Products.CategoryID)

-- 7 
SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products) as av, UnitPrice - (SELECT AVG(UnitPrice) FROM Products) FROM Products

-- 8
SELECT ProductNAme, CategoryName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products), UnitPrice -(SELECT AVG(UnitPrice) FROM Products)  FROM Products, Categories
WHERE Products.CategoryID = Categories.CategoryID

-- 9
SELECT Freight + (SELECT SUM(UnitPrice * Quantity *( 1 -Discount)) FROM [Order Details] WHERE OrderID = 10250) FROM Orders
WHERE Orders.OrderID = 10250

-- 10
SELECT OrderID, Freight + (SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID ) FROM Orders

-- 11 
SELECT DISTINCT c.CompanyName, City + ' ' + Address FROM Customers as c,Orders
WHERE c.CustomerID not IN(SELECT o.CustomerID FROM Orders as o WHERE YEAR(OrderDate) = 1997 )

SELECT CompanyName , Address + ' ' + City FROM Customers as c
WHERE c.CustomerID not in ( SELECT cu.CustomerID FROM Customers as  cu 
                            LEFT JOIN Orders as o on c.CustomerID = o.CustomerID
                            WHERE YEAR(o.OrderDate) = 1997)

SELECT c.CompanyName, Address + ' ' + City FROM Customers as c
WHERE not exists (SELECT * FROM Orders as o 
                 WHERE o.CustomerID = c.CustomerID AND YEAR(o.OrderDate) = 1997)

-- 12
SELECT ProductName FROM Products as p
WHERE (SELECT COunt(CustomerID) FROM [Order Details] as od 
        INNER JOIN Orders as o on od.OrderID = o.OrderID
        WHERE od.ProductID = p.ProductID
        GROUP BY od.ProductID) > 1

-- 13
SELECT FirstName + ' ' + LastName, (SELECT SUM(Quantity * UnitPrice * (1 - od.Discount) + o.Freight) FROM [Order Details] as od 
                                    INNER JOIN Orders as o on o.EmployeeID = e.EmployeeID
                                    WHERE o.OrderID = od.OrderID
                                     ) FROM Employees as e

SELECT e.FirstName +' '+  e.LastName, SUM(o.freight + od.UnitPrice * od.Quantity * (1 - od.Discount)) FROM Employees as e
INNER JOIN Orders as o on  o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY e.FirstName +' '+  e.LastName

SELECT * FROM Employees
-- 14 
-- Mają podwładnych
SELECT FirstName + ' ' + LastName, (SELECT SUM(Quantity * UnitPrice * (1 - od.Discount) + o.Freight) FROM [Order Details] as od 
                                    INNER JOIN Orders as o on o.EmployeeID = e.EmployeeID
                                    WHERE o.OrderID = od.OrderID
                                     ) FROM Employees as e

-- NIe mają podwładnych

--15
SELECT TOP 1 FirstName + ' ' + LastName, (SELECT SUM(Quantity * UnitPrice * (1 - od.Discount) + o.Freight) FROM [Order Details] as od 
                                    INNER JOIN Orders as o on o.EmployeeID = e.EmployeeID
                                    WHERE o.OrderID = od.OrderID AND YEAR(o.OrderDate) = 1997
                                     )  as 'sum'
FROM Employees as e
Order BY 'sum' DESC

SELECT  e.FirstName +' '+  e.LastName, SUM(o.freight + od.UnitPrice * od.Quantity * (1 - od.Discount)) as 'sum', (SELECT TOP 1 o1.Orderdate FROM Orders as o1 
                                                                                                            WHERE o1.EmployeeID = e.EmployeeID
                                                                                                            ORDER BY o1.OrderDate DESC) FROM Employees as e
INNER JOIN Orders as o on  o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY e.FirstName +' '+  e.LastName,e.EmployeeID
ORDER BY 'sum' DESC