--ĆWICZENIE II - OPERACJE AGREGACJI

--1.1 Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia i wynik zwraca posortowany w malejącej kolejności(wg wartości sprzedaży)
SELECT OrderID, SUM(UnitPrice * Quantity) as Price FROM [Order Details]
GROUP BY OrderID
ORDER BY Price DESC

--1.2 Zmodyfikuj zapytanie z punktu1, tak aby zwracało pierwszych 10 wierszy
SELECT TOP 10 OrderID, SUM(UnitPrice * Quantity) as Price FROM [Order Details]
GROUP BY OrderID
ORDER BY Price DESC

--1.3 Zmodyfikuj zapytanie z punktu 2, tak aby zwracało 10 pierwszych produktów wliczajać równorzędne



--2.1 Podaj liczbę zamówioncyh jednostek produktów dla produktów o identyfikatorze < 3.
SELECT ProductID, SUM(Quantity) FROM [Order Details]
WHERE ProductID < 3
GROUP By ProductID

--2.2 Zmodyfikuj zapytanie z punktu 1. tak aby podawało liczbę zamówionych jednostek produktu dla wsyztskich produktów.
SELECT ProductID, SUM(Quantity) FROM [Order Details]
GROUP By ProductID

--2.3 Podaj wartosć zamówienia dla kazdego zamówienia, dla którego łączna liczba zamawiancyh jednostek produktów jest > 250
SELECT  OrderID, SUM(Quantity*unitPrice)  as cnt FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) > 250

--3.1  Napisz polecnie, które oblicza sumaryczną ilość zamówioncyh towarów i porządkuje wg productid i orderied oraz wykonuje kalkulacje rollup.
SELECT SUM(Quantity) as Total , ProductID, OrderID FROM [Order Details]
GROUP BY ProductID, OrderID
WITH ROLLUP

--3.2 Zmodyfikuj zapytanie z punktu 1., tak aby ograniczyć wynik tylko do produktu o numerze 50.
select productid, orderid, sum(quantity) as total from [Order Details]
group by productid, orderid
with rollup
having productid = 50

--3.3 Jakie jest znaczenie wartości null w kolumnie productid i orderid?

--3.4 Zmodyfikuj polecenie z punktu 1. używając operatora cube zamiast rollup. Użyj również funkcji Gropuing na kolumnach productID i Order ID do rozróżnienia między sumarycznymi i szczegółowymi wierszami w zbiorze
SELECT SUM(Quantity) as Total , GROUPING(ProductID), GROUPING(OrderID), OrderID, ProductID FROM [Order Details]
GROUP BY ProductID, OrderID
WITH CUBE


--3.5 Które wiersze są podsumowaniami?
--Które podsumowują według produktu, a które według zamówienia?
--Podsumowaniami są wiersze, które w komórce productid lub orderid zawierają NULL.
--Jeżeli NULL jest w orderid, to wiersz podsumowuje wg produktu, jeżeli NULL w productid, 
-- to wg zamówienia.


