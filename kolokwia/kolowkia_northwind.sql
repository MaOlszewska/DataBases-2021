-- Zamówienia z Freight większym niż AVG danego roku

SELECT OrderID, sum(Freight) FROM  Orders
GROUP BY OrderID
HAVING sum(Freight) > (SELECT AVG(Freight) FROM ORDERS) 

-- 3. Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach.
SELECT DISTINCT CustomerID FROM Orders as o
INNER JOIN [Order Details] as od on o.orderID = od.OrderID
INNER JOIN Products as p on p.ProductID = od.ProductID
INNER JOIN Categories as  c on c.CategoryID = p.CategoryID
WHERE c.CategoryName NOT LIKE'Seafood'

-- Dla każdego klienta najczęściej zamawianą kategorię w dwóch wersjach.
SELECT  CustomerID, COUNT(CategoryName) FROM Orders as o
INNER JOIN [Order Details] as od on o.orderID = od.OrderID
INNER JOIN Products as p on p.ProductID = od.ProductID
INNER JOIN Categories as  c on c.CategoryID = p.CategoryID
GROUP BY o.CustomerID


------------------------------------------------------------------GLIWA 2015/2016 ---------------------------------------------------------------

-- 1. Podać ID klienta, który złożył co najmniej jedno zamówienie w 1997 
-- i nie złożył żadnego zamówienia w 1996. Podać tylko tych klientów których ID
-- zaczyna się na literę L. Do każdego ID dodatkowo podać nazwę firmy.

SELECT CustomerID, CompanyName FROM Customers as c
WHERE CustomerID LIKE'L%' AND c.CustomerID NOT IN (SELECT cu.CustomerID FROM Customers as cu
                                                    JOIN Orders as o on cu.CustomerID = o.CustomerID
                                                    WHERE YEAR(OrderDate) = 1996)
AND (SELECT COUNT(*) FROM Orders 
    WHERE Orders.CustomerID = c.CustomerID AND YEAR(OrderDate) = 1997) > 1

select distinct o1.customerid, C.CompanyName from orders as o1 left outer join orders as o2
on o1.CustomerID = o2.CustomerID and YEAR(o2.OrderDate) = 1996
inner join customers as C on o1.CustomerID = C.CustomerID
where o1.CustomerID like '[L]%' and year(o1.OrderDate) = 1997 and o2.OrderDate is null

-- 2 Wypisać zamówienia, których koszt jest mniejszy niż połowa maksymalnej 
-- ceny jednostkowej
-- produktów z kategorii "Seafood". Do każdego zamówienia podać ten koszt.

SELECT OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) FROM [Order Details] as od
GROUP BY OrderID
HAVING SUM(UnitPrice * Quantity * (1 - Discount))  < 0.5 * (SELECT  MAX(UnitPrice) FROM Products,Categories
                WHERE Products.CategoryID = Categories.CategoryID 
                AND CategoryName = 'Seafood')

select od.orderid, SUM(od.unitprice*od.quantity) as order_value from [order details] as od
group by od.orderid
having SUM(od.unitprice*od.quantity) < 0.5*(select max(p.unitprice) from products as p where
p.categoryid in(select categoryid from categories where categoryname = 'Seafood') )

-- 3 Podać imię i nazwisko (razem) pracowników, którzy mają podwładnych. Bez join'ów

SELECT FirstName + ' ' + LastName FROM Employees 
WHERE EmployeeID in (SELECT ReportsTo FROM Employees)

SELECT * FROM Employees


-- 4 Podać imię i nazwisko (w jednej kolumnie) pracownika, który obsłużył
-- zamówienie o największej wartości w 1998 roku. 
-- Należy także podać wartość tego zamówienia.

SELECT TOP 1 FirstName + ' ' + LastName, SUM(UnitPrice * Quantity * (1 - Discount) ) FROM Employees
JOIN Orders as o on o.EmployeeID = Employees.EmployeeID
JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1998 
GROUP BY FirstName + ' ' + LastName, o.OrderID
ORDER BY SUM(UnitPrice * Quantity *(1 - Discount)) DESC

-- 1 Wyświetl CustomerID klientów, którzy mają więcej niż 25 zamówień

SELECT DISTINCT CustomerID FROM Orders as o
WHERE 25 < (SELECT COUNT(*) FROM Orders as ord
            WHERE o.CustomerID = ord.CustomerID)


-- 2 Podaj OrderID i cenę przesyłki, dla tego zamówienia, 
-- którego cena przesyłki jest większa niż średnia
-- opłata za wszystkie przesyłki i była wysłana do Londynu

SELECT AVG(Freight) FROM Orders

SELECT OrderID, Freight, ShipCity FROM Orders
WHERE Freight > (SELECT AVG(Freight) FROM Orders) AND ShipCity = 'London'

-- 3 . Wypisz CustomerID klientów, którzy nie zamówili nic w 1997 roku 
-- oraz ich CustomerID nie kończy się na A oraz C. Użyj mechanizmu podzapytań.

SELECT CustomerID FROM Customers as c
WHERE c.CustomerID NOT IN (SELECT CustomerID FROM Orders as o
                             WHERE YEAR(o.OrderDate) = 1997)
AND c.CustomerID NOT LIKE'%A' AND c.CustomerID NOT LIKE'%C'

-- 4 Podaj imię i nazwisko (w jednej kolumnie) pracowników,
-- którzy mają więcej niż 3 podwładnych 

SELECT LastName, reportsto FROM Employees

SELECT FirstName + ' ' + LastName FROM Employees as e
WHERE 3 < (SELECT COUNT(*) FROM Employees
            WHERE e.EmployeeID = Employees.ReportsTo )

-------------------------------------------------------------------------------------------------------------------------------------