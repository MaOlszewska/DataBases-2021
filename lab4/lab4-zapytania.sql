-- 1
SELECT ProductName, UnitPrice, s.Address+' '+City+' '+PostalCode+' '+Country AS'Adres'  FROM Products as p
INNER JOIN Suppliers as s on s.SupplierID = p.SupplierID
WHERE UnitPrice BETWEEN 20 AND 30

SELECT ProductName, UnitPrice, Address+' '+City+' '+PostalCode+' '+Country AS'Adres' FROM Products, Suppliers 
WHERE Suppliers.SupplierID = Products.SupplierID AND (UnitPrice BETWEEN 20 AND 30)

-- 2
SELECT CompanyName, ProductName, UnitsInStock FROM Suppliers as s
INNER JOIN Products as p on s.SupplierID = p.SupplierID
WHERE CompanyName LIKE'Tokyo Traders'

SELECT ProductName, UnitsInStock FROM Products, Suppliers 
WHERE(Suppliers.SupplierID = Products.SupplierID) AND Suppliers.CompanyName LIKE'Tokyo Traders'

-- 3

SELECT CompanyName , Address + ' ' + City FROM Customers as c
WHERE c.CustomerID not in ( SELECT cu.CustomerID FROM Customers as  cu 
                            LEFT JOIN Orders as o on c.CustomerID = o.CustomerID
                            WHERE YEAR(o.OrderDate) = 1997)


-- 4 

SELECT CompanyName, Phone FROM Suppliers as s 
INNER JOIN Products as p on s.SupplierID = p.SupplierID
WHERE p.UnitsInStock = 0

SELECT CompanyName, Phone FROM Suppliers, Products
WHERE (Suppliers.SupplierID = Products.SupplierID) AND UnitsInStock = 0

-- 5

SELECT ProductName, UnitPrice, Suppliers.Address FROM Suppliers, Products, Categories
WHERE (Categories.CategoryID = Products.CategoryID) AND (Products.SupplierID = Suppliers.SupplierID) AND (UnitPrice BETWEEN 20 AND 30) AND CategoryName LIKE'Meat/Poultry'

SELECT ProductName,UnitPrice,Suppliers.Address, Categories.CategoryName FROM Products 
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
JOIN Categories ON Products.CategoryID = Categories.CategoryID 
WHERE(UnitPrice BETWEEN 20 AND 30) AND Categories.CategoryName = 'Meat/Poultry'

-- 6

SELECT ProductName, UnitPrice, CompanyName FROM Products, Suppliers,Categories
WHERE (Categories.CategoryID = Products.CategoryID) AND (Suppliers.SupplierID = Products.SupplierID) AND (CategoryName = 'Confections')

SELECT ProductName, UnitPrice, Suppliers.CompanyName FROM Products
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID
JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = 'Confections'

-- 7

SELECT Customers.CompanyName, Customers.Phone FROM Customers 
JOIN Orders on Orders.CustomerID = Customers.CustomerID
JOIN Shippers on Shippers.ShipperID = Orders.ShipVia
WHERE Shippers.CompanyName = 'United Package' AND YEAR(ShippedDate) = 1997


-- 8
SELECT DISTINCT c.CompanyName, c.Phone FROM Customers as c
JOIN Orders as o on c.CustomerID = o.CustomerID
JOIN  [Order Details] as od on od.OrderID = o.OrderID
JOIN Products as p  on p.ProductID = od.ProductID
JOIN Categories as ca on ca.CategoryID = p.CategoryID
WHERE ca.CategoryName = 'Confections'
