-- ĆWICZENIE III - OPERACJE ZŁĄCZENIA


--1.1 Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek oraz nazwę klienta.
select o.OrderID, sum(od.Quantity) as 'qty', c.CompanyName from Orders as o
inner join [Order Details] as od on od.OrderID = o.orderID
inner join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.CompanyName

--1.2 Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia dla których łączna liczba zamówionych jednostek jest większa niż 250.
select o.OrderID, sum(od.Quantity) as 'qty', c.CompanyName from Orders as o
inner join [Order Details] as od on od.OrderID = o.orderID
inner join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.CompanyName
HAVING sum(od.Quantity) > 250

--1.3 Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta.
SELECT o.OrderID, c.CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
GROUP BY o.OrderID, c.CompanyName

--1.4 Zmodyfikuj poprzedni przykłąd, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250.
SELECT o.OrderID, c.CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
GROUP BY o.OrderID, c.CompanyName
HAVING sum(Quantity) > 250

--1.5 Zmodyfikuj poprzedni przykłąd tak żeby dodac jeszcze imię i nazwisko pracownika obsługującego zamówinie.
SELECT o.OrderID, emp.FirstName + emp.LastName as 'EmployeeName', c.CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
INNER JOIN Employees as emp on emp.EmployeeID = o.EmployeeID
GROUP BY o.OrderID, c.CompanyName, emp.FirstName + emp.LastName
HAVING sum(Quantity) > 250



--2.1 Dla każdegj kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów.
SELECT  sum(od.Quantity) as 'Count', c.CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  c.CategoryName

--2.2 Dla każdej kategorii produktu, podaj łączną wartość zamówień.
SELECT  sum(od.Quantity * od.UnitPrice * (1 - od.discount)) as 'Count', c.CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  c.CategoryName

--2.3 Posortuj wyniki w zapytaniu z punktu 2.2 wg:
--    a  łącznej wartości zamówień
--    b  łącznej liczbny zamówionych przez klientów towarów.
SELECT  SUM(Quantity) as 'Count', SUM(od.Quantity * od.UnitPrice * (1 - od.discount)) as 'val', c.CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  c.CategoryName

--a 
ORDER BY val DESC
--b
ORDER BY Count DESC



--3.1 Dla każdego przewoźnika, podaj liczbę zamówień, któe przewieźli w 1997r.

SELECT  count(CompanyName) as 'count', s.CompanyName FROM Shippers as s 
INNER JOIN Orders as o on s.ShipperID = o.ShipVia
WHERE YEAR(ShippedDate) = '1997'
GROUP BY s.CompanyName

--3.2 Który przewoźnik był najaktywniejszy(przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika.
SELECT TOP 1 count(CompanyName) as 'conut', s.CompanyName FROM Shippers as s
INNER JOIN Orders as o on s.ShipperID = o.ShipVia
WHERE YEAR(ShippedDate) = '1997'
GROUP By s.CompanyName
ORDER BY conut DESC

--3.3 Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i nazwisko
SELECT TOP 1 count(o.EmployeeID) as 'cnt', e.FirstName , e.LastName  FROM Orders as o
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
WHERE YEAR(o.ShippedDate) = '1997'
GROUP BY e.FirstName, e.LastName
ORDER BY cnt DESC



--4.1 Dla każdego pracownika(Imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika.
SELECT e.FirstName,e.LastName, SUM(od.Quantity * od.UnitPrice * (1 - od.discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName

--4.2  Który z pracowników obsłużył zamówienia o największej wartosci w 1997, podaj imię i nazwisko
SELECT TOP 1 e.FirstName,e.LastName, SUM(od.Quantity * od.UnitPrice * (1 - od.discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
WHERE YEAR(o.ShippedDate) = '1997' 
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY val DESC

--4.3a Ogranicz wynik z pkt 1 tylko do tych pracowników którzy mają podwładnych.
SELECT e.FirstName,e.LastName, SUM(od.Quantity * od.UnitPrice * (1 - od.discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName

