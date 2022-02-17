-- Zapytania #1a z labów

--1 Wybierz nazwy i adresy klientów, mających siedziby w Londynie
--2 Wybierz nazwy i adresy klientów, mających siedziby w Londynie lub Madrycie
--3 Wybierz nazwy produktów, których cena jednostkowa jest większa niż 40
--4 Wybierz nazwy produktów, których cena jednostkowa jest większa niż 40, posortuj w porządku rosnącym
--5 Podaj ile jest produktów, których cena jednostkowa jest większa niż 40
--6 Podaj ile jest produktów, których cena jednostkowa jest większa niż 40, których stan magazynowy jest powyżej 100 sztuk
--7 Podaj ile jest produktów z kategorii 2-3, których cena jednostkowa jest większa niż 40, których stan magazynowy jest powyżej 100 sztuk

-- 1
SELECT CompanyName, Address, City FROM Customers
WHERE City = 'London'


-- 2
SELECT CompanyName, Address, City FROM Customers
WHERE City = 'London' OR City =  'Madrid'

--3 i 4
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice > 40
ORDER BY UnitPrice ASC

-- 5
SELECT  COUNT(UnitPrice) as 'count' FROM Products
WHERE UnitPrice > 40

--6
SELECT COUNT(UnitPrice) as 'count_Price' FROM Products
Where UnitPrice > 40 AND UnitsInStock > 100

--7
SELECT COUNT(*) as 'count' FROM Products
WHERE CategoryID BETWEEN 2 AND 3 AND UnitPrice > 40 AND UnitsInStock > 100


-- Zapytania #1b z labów

--8 *Podaj nazwy i ceny produktów z kategorii Seafood
--9 Podaj ilu jest pracowników, którzy urodzili się przed 1960 rokiem i mieszkają w Londynie.
--10 Podaj dane 5-ciu najstarszych pracowników.
--11 Podaj ilu jest pracowników, którzy urodzili się pomiędzy latami 1950-1955 lub 1958-60 i mieszkają w Londynie.
--12 Wyświetl aktualna listę produktów (atrybut Discontinued)
--13 Podaj ID zamówienia oraz ID klienta dla zamówień dokonanych przed 1.09.1996
--14 Podaj dane klientów, którzy w nazwie mają frazę 'the'
--15 Podaj dane klientów, których nazwa zaczyna się na literę 'B' lub 'W'
--16 Podaj dane produktów, których nazwa zaczyna się na literę 'C' lub których productid jest mniejszy niż 40, jednocześnie których cena jest większa niż 20.
--17 Wyświetl raport roczny sprzedaży - łączne kwoty w poszczególnych latach dla poszczególnych firm oraz w ujęciu całkowitym.
--18 Wyświetl raport roczny sprzedaży - łączne kwoty w poszczególnych latach, wraz ze sztukami.
--19 Wyświetl raport roczny sprzedaży - łączne kwoty w poszczególnych latach, wraz ze sztukami, w rozbiciu na kwartały. 
--20 Wyświetl dostawców, którzy nie posiadają strony internetowej, nie posiadają faxu, z kraju USA lub Germany
--21 Podaj ile jest produktów pakowanych w butelki/szkło
--22 Która kategoria produktów jest najliczniejsza (produkty w kategorii)?
--23 Wyświetl listę kategorii z uwzględnieniem łącznych stanów magazynowych, posortowaną rosnąco.


--8
SELECT p.ProductName, od.UnitPrice FROM Products as p
INNER JOIN [Order Details] as od on od.ProductID = p.ProductID
WHERE p.CategoryID = 8

--9 
SELECT COUNT(*) as count FROM Employees
WHERE YEAR(BirthDate) < 1960 AND City = 'London'

--10 
SELECT TOP 5 * FROM Employees
ORDER By YEAR(BirthDate) ASC

--11
SELECT COUNT(*) as count FROM Employees
WHERE (YEAR(BirthDate) BETWEEN 1950 AND 1955 OR YEAR(BirthDate) BETWEEN 1958 AND 1960) AND City = 'London'

--12
SELECT  ProductName FROM Products
WHERE Discontinued = 1

--13
SELECT CustomerID, OrderID FROM Orders
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
--18
--19

--20
SELECT * FROM Suppliers
WHERE (HomePage IS NULL AND Fax IS NULL) AND (Country = 'USA' OR Country = 'Germany')

--21
SELECT COUNT(*) as  count FROM Products
WHERE QuantityPerUnit LIKE'%bottle%' OR QuantityPerUnit LIKE '%glass%'

--22
SELECT Count(*) as cnt, CategoryID FROM Products
GROUP By CategoryID
ORDER By cnt  DESC

--23
SELECT SUM(UnitsInStock) as suma, CategoryID FROM Products
GROUP BY CategoryID
ORDER BY suma ASC