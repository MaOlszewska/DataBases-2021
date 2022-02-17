--1Wyświetl wykaz zamówień, zawierający: id zamówienia, cenę jednostkową, ilość, wartość, cenę jednostkową powiększoną o 15%, wartość,
--a także kwoty rabatu w dwóch wariantach (dla ceny oryginalnej oraz ceny zmienionej)

SELECT OrderID, UnitPrice, Quantity, (UnitPrice * Quantity *(1 - Discount)) as "Value",
UnitPrice * 1.15 as "15% Price", (UnitPrice * 1.15 * Quantity * (1- Discount)) as "Value 15%"
FROM [Order Details]

--2 Wyświetl wykaz pracowników, w układzie: "[zwrot grzecznościowy][imię] [nazwisko], ur. [data], zatrudniony w dniu [data], adres: [adres],
--[miasto], [kod], [państwo]", posortowany rosnąco po dacie urodzenia.

SELECT TitleOfCourtesy  + FirstName + ' ' + LastName + ', ur. ' + CONVERT(varchar,BirthDate,4) +
', zatrudniony w dniu ' + CONVERT(varchar, HireDate,4)+ ', adres: ' + Address + ', ' + City + ', ' +
PostalCode + ', ' + Country  FROM Employees
ORDER BY BirthDate ASC

--3 Wyświetl wykaz 3 pracowników z najkrótszym stażem, w układzie: "[zwrot grzecznościowy] [imię] [nazwisko], zatrudniony: [data]"
SELECT TOP 3 TitleOfCourtesy  + FirstName + ' ' + LastName + ', zatrudniony: ' +  CONVERT(varchar, HireDate,4) FROM Employees
ORDER BY HireDate DESC

--4 Podaj ilu jest pracowników, dla których wartość atrybutu 'Region' nie jest pusta.
SELECT COUNT(*) FROM Employees
WHERE Region IS NOT NULL 

--5 Podaj średnią cenę produktu.
SELECT AVG(UnitPrice) FROM Products

--6 Podaj średnią cenę produktu, którego stan magazynowy wynosi co najmniej 30.
SELECT AVG(UnitPrice) FROM Products
WHERE UnitsInStock >= 30

--7 Podaj średnią cenę produktu, którego stan magazynowy jest wyższy niż średnia stanu magazynowego wszystkich produktów.
SELECT AVG(UnitPrice) FROM Products
WHERE UnitsInStock > (SELECT AVG(UnitsInStock) FROM Products)

--8 Podaj sumę produktów sprzedanych po cenie większej niż 30.
SELECT COUNT(*) FROM Products
WHERE UnitPrice > 30

--9 Podaj maksymalną, minimalną i średnią cenę produktu dla  produktów sprzedawanych w butelkach (‘bottle’)
SELECT AVG(UnitPrice), MAX(UnitPrice), MIN(UnitPrice) FROM Products
WHERE QuantityPerUnit LIKE'%bottle%'

--10 Wypisz informację o wszystkich produktach o cenie powyżej średniej ceny
SELECT * FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)