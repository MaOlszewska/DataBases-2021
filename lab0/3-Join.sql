-- ĆWICZENIE III - OPERACJE ZŁĄCZENIA


--1.1 Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek oraz nazwę klienta.
select o.OrderID, sum(Quantity) as 'qty', CompanyName from Orders as o
inner join [Order Details] as od on od.OrderID = o.orderID
inner join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, CompanyName

--1.2 Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia dla których łączna liczba zamówionych jednostek jest większa niż 250.
select o.OrderID, sum(Quantity), c.CompanyName from Orders as o
inner join [Order Details] as od on od.OrderID = o.orderID
inner join Customers as c on c.CustomerID = o.CustomerID
group by o.OrderID, c.CompanyName
HAVING sum(Quantity) > 250

--1.3 Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta.
SELECT o.OrderID, CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
GROUP BY o.OrderID, CompanyName

--1.4 Zmodyfikuj poprzedni przykłąd, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250.
SELECT o.OrderID, CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
GROUP BY o.OrderID, CompanyName
HAVING sum(Quantity) > 250

--1.5 Zmodyfikuj poprzedni przykłąd tak żeby dodac jeszcze imię i nazwisko pracownika obsługującego zamówinie.
SELECT o.OrderID, FirstName + LastName as 'EmployeeName', CompanyName, SUM(Quantity * UnitPrice * (1 - discount)) as 'value' FROM Orders as o
INNER JOIN [Order Details] as od on od.OrderID = o.orderID
INNER JOIN Customers as c on c.CustomerID = o.CustomerID
INNER JOIN Employees as emp on emp.EmployeeID = o.EmployeeID
GROUP BY o.OrderID, CompanyName, FirstName + LastName
HAVING sum(Quantity) > 250



--2.1 Dla każdegj kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów.
SELECT  sum(Quantity) as 'Count', CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  CategoryName

--2.2 Dla każdej kategorii produktu, podaj łączną wartość zamówień.
SELECT  sum(Quantity * od.UnitPrice * (1 - discount)) as 'Count', CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  CategoryName

--2.3 Posortuj wyniki w zapytaniu z punktu 2.2 wg:
--    a  łącznej wartości zamówień
--    b  łącznej liczbny zamówionych przez klientów towarów.
SELECT  SUM(Quantity) as 'Count', SUM(Quantity * od.UnitPrice * (1 - discount)) as 'val', CategoryName FROM Categories as c 
INNER JOIN Products as p on p.CategoryID = c.CategoryID
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
GROUP BY  CategoryName

--a 
ORDER BY val DESC
--b
ORDER BY Count DESC



--3.1 Dla każdego przewoźnika, podaj liczbę zamówień, któe przewieźli w 1997r.

SELECT  count(CompanyName) as 'count', CompanyName FROM Shippers as s 
INNER JOIN Orders as o on s.ShipperID = o.ShipVia
WHERE YEAR(ShippedDate) = '1997'
GROUP BY CompanyName

--3.2 Który przewoźnik był najaktywniejszy(przewiózł największą liczbę zamówień) w 1997r, podaj nazwę tego przewoźnika.
SELECT TOP 1 count(CompanyName) as 'conut', CompanyName FROM Shippers as s
INNER JOIN Orders as o on s.ShipperID = o.ShipVia
WHERE YEAR(ShippedDate) = '1997'
GROUP By CompanyName
ORDER BY conut DESC

--3.3 Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i nazwisko
SELECT TOP 1 count(o.EmployeeID) as 'cnt', FirstName , LastName  FROM Orders as o
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
WHERE YEAR(o.ShippedDate) = '1997'
GROUP BY FirstName, LastName
ORDER BY cnt DESC



--4.1 Dla każdego pracownika(Imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika.
SELECT FirstName,LastName, SUM(Quantity * UnitPrice * (1 - discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
GROUP BY e.EmployeeID, FirstName, LastName

--4.2  Który z pracowników obsłużył zamówienia o największej wartosci w 1997, podaj imię i nazwisko
SELECT TOP 1 FirstName, LastName, SUM(Quantity * UnitPrice * (1 - discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
WHERE YEAR(ShippedDate) = '1997' 
GROUP BY e.EmployeeID, FirstName, LastName
ORDER BY val DESC

--4.3a Ogranicz wynik z pkt 1 tylko do tych pracowników którzy mają podwładnych.
SELECT FirstName, LastName, SUM(Quantity * UnitPrice * (1 - discount)) as 'val' FROM  Orders as o 
INNER JOIN Employees as e on e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] as od on o.OrderID = od.OrderID
GROUP BY e.EmployeeID, FirstName, LastName

