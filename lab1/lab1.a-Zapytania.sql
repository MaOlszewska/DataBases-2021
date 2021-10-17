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
SELECT COUNT(*) FROM Products
WHERE CategoryID BETWEEN 2 AND 3 AND UnitPrice > 40 AND UnitsInStock > 100


