-- 1

-- 1.1 WYbierz nazwy i numery telefonów klientów, którym w 197 roku przesyłki dostarczała firma United Package 

SELECT c.CompanyName, c.Phone FROM Customers as c
JOIN Orders as o on o.CustomerID = c.CustomerID
JOIN Shippers as s on s.ShipperID = o.ShipVia
WHERE YEAR(o.OrderDate) = 1997 AND s.CompanyName = 'United Package'

-- 1.2 WYbierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections

SELECT DISTINCT c.CompanyName, c.Phone FROM Customers as c
JOIN Orders as o on o.CustomerID = c.CustomerID
JOIN [Order Details] as od on od.OrderID = o.OrderID
JOIN Products as p on od.ProductID = p.ProductID
JOIN Categories on Categories.CategoryID = p.CategoryID
WHERE Categories.CategoryName = 'Confections'

-- 1.3
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


-- 2

-- 2.1 Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek.

SELECT DISTINCt ProductName, Quantity FROM Products, [Order Details]
WHERE QUantity = (SELECT max(Quantity) FROM [Order Details] WHERE Products.ProductID = [Order Details].ProductID )

-- 2.2 Podaj wsyztskie produkty, których cena jest mniejsza niż średnia cena produktu.

SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM Products)

-- 2.3 Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii.
SELECT ProductName, UnitPrice FROM Products as p
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM Products 
                    WHERE p.CategoryID = Products.CategoryID)


-- 3

-- 3.1 Dla każdego produktu podaj jego nazwę, cenę, średnią cene wsyztskich produktó oraz różnice miedzy ceną produktu a średnią ceną wsyztskich produktów .

SELECT ProductName, UnitPrice, (SELECT AVG(UnitPrice) FROM Products), UnitPrice -  (SELECT AVG(UnitPrice) FROM Products) FROM Products
-- 3.2 Dla każdego produktu podaj jego nazwę, cenę, średnią cene wsyztskich produktów w kategorii oraz różnice między ceną produktu, a średnią ceną wszystkich produktów w kategorii

SELECT ProductName, CategoryName, UnitPrice, 
(SELECT AVG(UnitPrice) FROM Products WHERE Categories.CategoryID = Products.CategoryID), 
UnitPrice - (SELECT AVG(UnitPrice) FROM Products WHERE Categories.CategoryID = Products.CategoryID)  FROM Products, Categories
WHERE Categories.CategoryID = Products.CategoryID


-- 4

-- 4.1 Podaj łączną wartość zamówienia o nuemrze 1025 (uwzględnij cene za przesyłkę)

SELECT  Freight + (SELECT SUM(UnitPrice * (Quantity * (1 - Discount))) FROM [Order Details] WHERE OrderID = 10250 )  FROM Orders 
WHERE OrderID = 10250

-- 4.2 Podaj łączną wartość zamówienia każdego zamówinia.

SELECT OrderID, Freight + (SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM [Order Details] WHERE Orders.OrderID = [Order Details].OrderID ) FROM Orders

-- 4.3 Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak pokaż ich dane adresowe.

SELECT c.CompanyName, Address + ' ' + City FROM Customers as c
WHERE not exists (SELECT * FROM Orders as o 
                 WHERE o.CustomerID = c.CustomerID AND YEAR(o.OrderDate) = 1997)

SELECT CompanyName , Address + ' ' + City FROM Customers as c
WHERE c.CustomerID not in ( SELECT cu.CustomerID FROM Customers as  cu 
                            LEFT JOIN Orders as o on c.CustomerID = o.CustomerID
                            WHERE YEAR(o.OrderDate) = 1997)

-- 4.4 Podaj Produkty kupowane przez więcej ni jednego klienta


                        
SELECT P.ProductName
FROM Products AS P
WHERE (
    SELECT COUNT(O.CustomerID) FROM [Order Details] AS OD
    INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
    WHERE OD.ProductID = P.ProductID
    GROUP BY OD.ProductID
) > 1


-- 5


-- 5.1 Dla każdego pracownika (imię i nazwisko) Podaj łączną wartość zamówień obsłużonych przez tego pracownika(Przy oblicznaiu wartości zamównień uwzględnij cenę za przesyłkę)

SELECT e.FirstName +' '+  e.LastName, SUM(o.freight + od.UnitPrice * od.Quantity * (1 - od.Discount)) FROM Employees as e
INNER JOIN Orders as o on  o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY e.FirstName +' '+  e.LastName



-- 5.2 Który z pracowników obsłużył zamówinie ao najwiekszej wartości w 1997 r
SELECT TOP 1 e.FirstName +' '+  e.LastName, SUM(o.freight + od.UnitPrice * od.Quantity * (1 - od.Discount)) FROM Employees as e
INNER JOIN Orders as o on  o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY e.FirstName +' '+  e.LastName
ORDER BY SUM(o.freight + od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC

-- 5.3
SELECT E.FirstName + ' ' + E.LastName,SUM(O.Freight + OD.UnitPrice * OD.Quantity * (1-OD.Discount)) FROM Employees AS E
LEFT OUTER JOIN Employees AS E2 ON E.EmployeeID = E2.ReportsTo
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
WHERE E2.EmployeeID IS NOT NULL    -- IS NULL 
GROUP BY E.FirstName, E.LastName



