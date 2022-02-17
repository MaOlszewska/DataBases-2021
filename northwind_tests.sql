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

----------------------------------------------------------   SIWIK 2019/2020  ------------------------------------------------------------------------

-- 1, 4, 5 - biblioteka

-- 2 Nazwy klientów którzy złożyli zamówienia w dniu 23/05/1997 oraz jeśli
-- obsługiwali te zamówienia pracownicy którzy mają podwłanych to ich wypisz
-- (imie i nazwisko)

SELECT c.CompanyName, o.OrderDate,(SELECT LastName FROM Employees as e
                                  WHERE e.EmployeeID = o.EmployeeID AND 1 < (SELECT COUNT(*) FROM Employees
                                                                            WHERE e.EmployeeID = ReportsTo) ) FROM Customers as c, Orders as o
WHERE c.CustomerID = o.CustomerID AND DATEFROMPARTS(1997,5,23) = o.OrderDate  

SELECT LastName FROM Employees, Orders
WHERE Orders.EmployeeID = Employees.EmployeeID AND DATEFROMPARTS(1997,5,23) = Orders.OrderDate  

SELECT * FROM Employees

-- 3  Dla każdego dostawcy wyswietl sumaryczna wartosc wykonanych zamowien
-- w okresie 1996-1998. Podziel ta informacje na lata i miesiace. Wyswietl tylko
-- tych, ktorychl sumaryczna wartosc wykonanych zamowien jest wieksza od
-- sredniej wartosci wykonanych zamówień w danym okresie.
 
SELECT s.ShipperID, s.CompanyName, (SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM [Order Details] as od, Orders as o
                                WHERE od.OrderID = o.OrderID AND o.ShipVIa = s.ShipperID AND YEAR(ShippedDate) BETWEEN 1996 AND 1998)  FROM Shippers as s


SELECT AVG(SUM(UnitPrice * Quantity * (1 - Discount))) FROM [Order Details] as od, Orders as o
WHERE od.OrderID = o.OrderID AND YEAR(ShippedDate) BETWEEN 1996 AND 1998
GROUP BY o.OrderID


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1
SELECT DISTINCT c.CompanyName, e.FirstName + ' ' + e.LastName, (SELECT COUNT(*) FROM Orders as o
                                                WHERE o.EmployeeID = e.EmployeeID AND o.CustomerID = c.CustomerID AND YEAR(OrderDate) = 1997) FROM Customers as c, Employees as e
Group BY c.CompanyName, e.FirstName + ' ' + e.LastName


-- 2 
;WITH T as (
SELECT e.EmployeeID, SUM(od.UnitPrice * od.QUantity * (1 - od.Discount))  as suma  FROM Employees as e
LEFT JOIN Orders as o on e.EmployeeID = o.EmployeeID
JOIN [Order Details] as od on od.OrderID = o.OrderID 
WHERE  (o.OrderID = od.OrderID AND YEAR(o.OrderDate) = 1997 AND MONTH(o.OrderDate) = 2) 
GROUP BY  o.OrderID,e.EmployeeID)  

SELECT FirstName + ' ' + LastName, SUM(T.suma) FROM Employees as e
LEFT JOIN T on t.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID

;WITH TESTOWA as(
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) as numery, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))+Freight as suma FROM Employees as e
LEFT OUTER JOIN [Orders] AS o ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] AS od ON o.OrderID = od.OrderID 
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 2 GROUP BY o.OrderID, e.EmployeeID, e.FirstName, e.LastName, o.Freight)

SELECT e.FirstName, e.LastName, t.numery, SUM(t.suma) FROM Employees e
LEFT JOIN TESTOWA t ON t.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, t.numery


----------- GLIWA 2015/2016 ------------------

-- 1 . Podać ID klienta, który złożył co najmniej jedno zamówienie w 1997 i nie złożył żadnego zamówienia
-- w 1996. Podać tylko tych klientów których ID zaczyna się na literę L. Bez podzapytań. Do każdego ID
-- dodatkowo podać nazwę firmy.

SELECT c.CustomerID, c.CompanyName FROM Customers as c
WHERE c.CustomerID in (SELECT CustomerID FROM Orders
                        WHERE YEAR(OrderDate) = 1997 )
AND c.CustomerID NOT IN (SELECT CustomerID FROM Orders  
                        WHERE YEAR(OrderDate) = 1996)
AND c.CompanyName LIKE'L%'

select distinct o1.customerid, C.CompanyName from orders as o1 left outer join orders as o2
on o1.CustomerID = o2.CustomerID and YEAR(o2.OrderDate) = 1996
inner join customers as C on o1.CustomerID = C.CustomerID
where o1.CustomerID like '[L]%' and year(o1.OrderDate) = 1997 and o2.OrderDate is null

-- 2 
-- Wypisać zamówienia, których koszt jest mniejszy niż połowa maksymalnej ceny jednostkowej
-- produktów z kategorii "Seafood". Do każdego zamówienia podać ten koszt.

SELECT OrderID, Sum(UnitPrice * Quantity * (1 - Discount)) FROM  [Order Details] as od
GROUP BY OrderID
HAVING Sum(UnitPrice * Quantity * (1 - Discount)) < (SELECT 0.5 * MAX(UnitPrice) FROM Products
                                                    INNER JOIN Categories as c on Products.CategoryID = c.CategoryID AND c.categoryname = 'seafood')

select od.orderid, SUM(od.unitprice*od.quantity * (1 - Discount)) as order_value from [order details] as od
group by od.orderid
having SUM(od.unitprice*od.quantity) < 0.5*(select max(p.unitprice) from products as p where
p.categoryid in(select categoryid from categories where categoryname = 'Seafood') )

-- 3
SELECT FirstName + ' ' + LastName FROM Employees as e
WHERE e.EmployeeID IN (SELECT ReportsTO FROM Employees)

-- 4 Podać imię i nazwisko (w jednej kolumnie) pracownika, który obsłużył zamówienie o największej
--wartości w 1998 roku. Należy także podać wartość tego zamówienia
 
SELECT TOP 1 e.FirstName + ' ' + e.LastName, SUM(UnitPrice * Quantity * (1 - Discount)) as suma FROM Employees as e 
INNER JOIN Orders as o on e.EmployeeID = o.EmployeeID AND  YEAR(OrderDate) = 1998
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY e.FirstName + ' ' + e.LastName
ORDER BY suma DESC

-- 1
-- Wyświetl CustomerID klientów, którzy mają więcej niż 25 zamówień. Użyj podzapytań.

SELECT DISTINCT o.CustomerID FROM Orders as o
WHERE 25 < (SELECT COUNT(*) FROM Orders 
            WHERE Orders.CustomerID = o.CustomerID)

-- 2. Podaj OrderID i cenę przesyłki, dla tego zamówienia, którego cena przesyłki jest większa niż średnia
-- opłata za wszystkie przesyłki i była wysłana do Londynu.

SELECT OrderID, Freight FROM Orders as o
WHERE o.Freight > (SELECT AVG(Freight) FROM Orders) AND ShipCity = 'London'

-- 3. Wypisz CustomerID klientów, którzy nie zamówili nic w 1997 roku oraz ich CustomerID nie kończy się
-- na A oraz C. Użyj mechanizmu podzapytań.

SELECT CustomerID FROM Customers as c
WHERE  c.CustomerID NOT IN (SELECT CustomerID FROM Orders WHERE YEAR(OrderDate) = 1997) 
AND c.CustomerID NOT LIKE '%A' AND c.CustomerID NOT LIKE '%C' 

-- 4  Podaj imię i nazwisko (w jednej kolumnie) pracowników, którzy mają więcej niż 3 podwładnych. Nie
-- używaj mechanizmu podzapytań.

SELECT FirstName + ' ' + LastName FROM Employees as e 
WHERE 3 < (SELECT COUNT(*) FROM Employees
            WHERE e.EmployeeID in (SELECT ReportsTo FROM Employees))

---------------------------------------------MARCJAN 2015/2016 ------------------------------------------

-- 1 Dla każdego klienta znajdź wartość wszystkich złożonych zamówień (weź pod uwagę koszt przesyłki)
SELECT CustomerID, SUM(UnitPrice * Quantity * (1 - Discount)) FROM  Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
GROUP BY CustomerID 

-- 2
-- Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997 roku? Jeśli tak, wyświetl ich dane adresowe. Wykonaj za pomocą operatorów:
-- a)join b)in c)exist

SELECT CustomerID FROM Customers as c 
WHERE  c.CustomerID NOT IN (SELECT CustomerID FROM Orders WHERE YEAR(OrderDate) = 1997)

SELECT CustomerID FROM Customers as c 
WHERE NOT EXISTS (SELECT CustomerID FROM Orders as o WHERE c.CustomerID = o.CustomerID AND YEAR(OrderDate) = 1997)

SELECT c.CustomerID, o.OrderDate FROM Customers as c 
LEFT JOIN Orders as o on c.CustomerID = o.CustomerID AND YEAR(o.OrderDate) = 1997
WHERE o.OrderDate IS NULL

-- 4 Dla każdej kategorii produktów wypisz po miesiącach wartość sprzedanych z niej produktów. Interesują nas tylko lata 1996-1997
SELECT c.CategoryName, MONTH(OrderDate), YEAR(OrderDate), SUM(od.UnitPrice * od.QUantity * (1 - od.Discount)) FROM Categories as c
JOIN Products as p on c.CategoryID = p.CategoryID
JOIN [Order Details] as od on od.ProductID = p.ProductID
JOIN Orders as o on o.OrderID = od.OrderID
WHERE YEAR(OrderDate) BETWEEN 1996 AND 1997
GROUP BY c.CategoryName, MONTH(OrderDate), YEAR(OrderDate)
Order BY CategoryName, MONTH(OrderDate), YEAR(OrderDate)


-- 1 
-- Dla każdego produktu podaj nazwę jego kategorii, nazwę produktu, cenę, średnią cenę wszystkich
-- produktów danej kategorii, różnicę między ceną produktu a średnią ceną wszystkich produktów
-- danej kategorii, dodatkowo dla każdego produktu podaj wartośc jego sprzedaży w marcu 1997

SELECT ProductName, CategoryName, UnitPrice, 
(SELECT AVG(UnitPrice) FROM Products WHERE Products.CategoryID = c.CategoryID ),
UnitPrice - (SELECT AVG(UnitPrice) FROM Products WHERE Products.CategoryID = c.CategoryID ),
(SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM [Order Details] as od
INNER JOIN Orders as o on o.OrderID = od.OrderID
WHERE od.ProductID = p.ProductID AND YEAR(o.OrderDate) = '1997' AND MONTH(o.OrderDate) = '3') FROM Products as p
INNER JOIN Categories as c on c.CategoryID = p.CategoryID
ORDER BY c.CategoryName

SELECT cat.CategoryName, p.ProductName, p.UnitPrice,
(SELECT AVG(UnitPrice) FROM Products AS p2 WHERE p2.CategoryID = p.CategoryID) AS AVGPrice,
p.UnitPrice - (SELECT AVG(UnitPrice) FROM Products AS p2 WHERE p2.CategoryID = p.CategoryID) AS Diff,
(SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) FROM [Order Details] AS od
INNER JOIN Orders AS o
ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
AND MONTH(o.OrderDate) = 3
AND od.ProductID = p.ProductID) AS MarchValue
FROM Categories AS cat
INNER JOIN Products AS p
ON p.CategoryID = cat.CategoryID
ORDER BY cat.CategoryName

-- 2
-- Dla każdego pracownika (imie i nazwisko) podaj łączną wartość zamówień obsłużonych
-- przez tego pracownika (z ceną za przesyłkę). Uwzględnij tylko pracowników, którzy mają podwładnych.

SELECT e.EmployeeID, FirstName + ' ' + LastName, SUM(od.Quantity * od.UnitPrice * ( 1- od.Discount)) + (SELECT SUM(oo.Freight) FROM Orders as oo WHERE oo.EmployeeID = e.EmployeeID) FROM Employees as e
INNER JOIN Orders as o on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
WHERE e.EmployeeID in (SELECT ReportsTo FROM Employees) 
GROUP BY FirstName + ' ' + LastName, e.EmployeeID


SELECT e.FirstName, e.LastName,
SUM(od.UnitPrice * od.Quantity * (1 - od.Discount))
+
(SELECT SUM(o2.Freight) FROM Orders AS o2 WHERE o2.EmployeeID = e.EmployeeID)
AS TotalValue
FROM Employees AS e
INNER JOIN Orders AS o
ON o.EmployeeID = e.EmployeeID
INNER JOIN [Order Details] AS od
ON od.OrderID = o.OrderID
WHERE e.EmployeeID IN (SELECT ReportsTo FROM Employees WHERE ReportsTo IS NOT NULL)
GROUP BY e.EmployeeID, e.FirstName, e.LastName


-- 3
-- Czy są jacyś klienci, którzy nie złożyli żadnego zamówienia w 1997, jeśli tak pokaż
-- ich nazwy i dane adresowe (3 wersje - join, in, exists).

SELECT CompanyName FROM Customers as c
LEFT JOIN Orders AS o on o.CustomerID = c.CustomerID AND YEAR(o.OrderDate) = 1997
WHERE o.CustomerID IS NULL

SELECT CompanyName FROM  Customers as c
WHERE c.CustomerID NOT IN (SELECT CustomerID FROM Orders  WHERE YEAR(OrderDate) = 1997)

SELECT CompanyName FROM  Customers as c
WHERE NOT EXISTS (SELECT CustomerID FROM Orders  WHERE YEAR(OrderDate) = 1997 AND Orders.CustomerID = c.CustomerID)

SELECT CompanyName FROM  Customers as c
WHERE NOT EXISTS (SELECT * FROM Orders  WHERE YEAR(OrderDate) = 1997 AND Orders.CustomerID = c.CustomerID)


-- 1
-- 1) Dla każdego pracownika, który ma podwładnego podaj wartość obsłużonych przez niego przesyłek w grudniu 1997. Uwzględnij rabat i opłatę za przesyłkę.

SELECT DISTINCT e.EmployeeID, e.LastName + ' ' + e.FirstName, SUM(Quantity * UnitPrice * (1 - Discount)) + (SELECT SUM(Freight) FROM Orders as oo WHERE oo.EmployeeID = e.EmployeeID) FROM Employees as e
INNER JOIN Orders as o on e.EmployeeID = o.EmployeeID 
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 12  AND e.EmployeeID in (SELECT ReportsTo FROM Employees)
GROUP BY e.LastName + ' ' + e.FirstName, e.EmployeeID


SELECT b.EmployeeID, b.LastName + ' ' + b.FirstName, 
(SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) + SUM(o.Freight) FROM [Order Details] as od
JOIN Orders AS o ON od.OrderID = o.OrderID 
WHERE o.EmployeeID = b.EmployeeID AND YEAR(o.OrderDate) = 1997 AND MONTH(O.OrderDate) = 12) FROM Employees AS e 
JOIN Employees AS b ON e.ReportsTo = b.EmployeeID
GROUP BY b.EmployeeID, b.LastName + ' ' + b.FirstName


-- 4) Podaj nazwy produktów, które nie były sprzedawane w marcu 1997.

SELECT p.ProductName FROM Products as p
WHERE p.ProductID not IN (SELECT ProductID FROM [Order Details] as od 
                          Inner JOIN Orders as o on o.OrderID = od.OrderID AND YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 3)

-- Podać ID klienta, który złożył co najmniej jedno zamówienie w 1997 i nie złożył żadnego zamówienia
-- w 1996. Podać tylko tych klientów których ID zaczyna się na literę L. Bez podzapytań. Do każdego ID
-- dodatkowo podać nazwę firmy.

SELECT DISTINCT o.CustomerID FROM Orders as o
WHERE o.CustomerID in (SELECT CustomerID FROM Orders WHERE Orders.CustomerID = o.CustomerID AND YEAR(OrderDate) = 1997)
AND o.CustomerID not in (SELECT CustomerID FROM Orders WHERE Orders.CustomerID = o.CustomerID AND YEAR(OrderDate) = 1996)
AND o.CustomerID LIKE 'L%'

-- Wypisać zamówienia, których koszt jest mniejszy niż połowa maksymalnej ceny jednostkowej
-- produktów z kategorii "Seafood". Do każdego zamówienia podać ten koszt.

SELECT OrderID, SUM(Quantity * UnitPrice * (1 - Discount)) FROM [Order Details] as od 
GROUP BY OrderID 
HAVING SUM(Quantity * UnitPrice * (1 - Discount)) < (SELECT 0.5* MAX(UnitPrice) FROM Products as p,Categories as c
WHERE p.CategoryID = c.CategoryID AND c.CategoryName = 'Seafood')

-- Podać imię i nazwisko (razem) pracowników, którzy mają podwładnych. Bez join'ów.

SELECT FirstName + ' '  + LAstName FROM Employees as e
WHERE e.EmployeeID IN ( SELECT ReportsTo FROM Employees)

-- Podać imię i nazwisko (w jednej kolumnie) pracownika, który obsłużył zamówienie o największej
-- wartości w 1998 roku. Należy także podać wartość tego zamówienia.

SELECT TOP 1 FirstName + ' '  + LAstName, o.orderid,SUM(Quantity * UnitPrice * (1 - Discount)) FROM Orders as o
INNER JOIN Employees as e ON e.EmployeeID = o.EmployeeID 
INNER JOIN [Order Details] as od ON o.OrderID = od.OrderID
WHERE YEAR(OrderDate) = 1998
GROUP BY FirstName + ' '  + LAstName, o.orderid
ORDER BY SUM(Quantity * UnitPrice * (1 - Discount)) DESC

select top 1 firstname+' '+lastname as name, o.OrderID, sum(unitprice*quantity) as price from
Employees as e inner join orders as o on e.EmployeeID = o.EmployeeID
inner join [order details] as od on o.OrderID = od.OrderID
where year(o.OrderDate) = 1998 group by firstname+' '+lastname, o.OrderID order by price DESC

-- Najczęściej wybierana kategoria w 1997 dla każdego klienta
SELECT CustomerID, c.CategoryName, COUNT(*) FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.OrderID
INNER JOIN Products as p on p.ProductID = od.ProductID
INNER JOIN Categories as c on c.CategoryID = p.CategoryID
WHERE YEAR(o.OrderDate) = 1998
GROUP BY CustomerID, c.CategoryName
ORDER BY CustomerID ASC

SELECT CustomerID, (SELECT TOP 1 CategoryName, (SELECT COUNT(*) FROM [Order Details] as od WHERE od.OrderID  = o.OrderID AND od.ProductID = p.ProductID AND p.CategoryID = c.CategoryID AND YEAR(o.OrderDate) = 1998 AND
ORDER BY COUNT(*) ASC) FROM  Categories as c, Products as p) 
FROM Orders as o


