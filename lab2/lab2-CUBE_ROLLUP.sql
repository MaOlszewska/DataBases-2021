-- ROLLUP Używa się jesli się che aby dane były hierarchiczne, jeśli wykonamy ROLLUP na trzech argumetach - ROLLUP(a, b, c) To wykona się GROUP BY (a, b, c), GROUP BY(a, b),
-- GROUP BY(a) i GROUP BY po całości, a więc ROLLUP jes równoważne wykonaniu N+1 grupowań.
-- Jest to bardziej efektywne zapytanie, niż osobne grupowanie i późniejsze łączenie za pomocą UNION.
-- Natomiast CUBE stosuje się jeśli się chce otrzymać wszytskie możlwie kombinacje, dla CUBE(a, b, c) Otrzymamy 2^3 operacji grupowań.


-- Przykłady zastosowań w bazie Northwind

-- Używając ROLLUP w wyniku takiego zapytania dostaniemy ilości produktów z danej kategori i sumy ich cen najpierw pogrupowane według ID dostawcy i ID kategori, 
-- Następinie tylko dla ID kategori produktu niezaleznie od dostawcy  i jescze wynik dla całosci czyli łaczą ilość produktów i sume ich cen.
-- Wartość NULL oznacza, że dana kolumna nie wchodzi w skład grupowania.
SELECT COUNT(*) AS 'quantity', SUM(UnitPrice) as 'sumPrices', CategoryID, SupplierID FROM Products
GROUP BY CategoryID, SupplierID
WITH ROLLUP


-- Zamieniając miejscami SuppilerID i CategoryID w wyniku pojawi się grupowanie według samego ID dostawcy, a grupowania według Kategori nie bedzie, czyli w tym przypadku
-- nie dowiemy się ile jest produktów w każdej kategorii i jaka jest suma ich cen.
SELECT COUNT(*) AS 'quantity', SUM(UnitPrice) as 'sumPrices', CategoryID, SupplierID FROM Products
GROUP BY ROLLUP (SupplierID, CategoryID)


-- Natomiast używająć CUBE dostaniemy w wyniku wszystkie możliwe kombinacje, czyli grupowanie według samej kategori lub dostawcy, kategorii i dostawcy, a także wynik całościowy.
SELECT COUNT(*) AS 'quantity', SUM(UnitPrice) as 'sumPrices', CategoryID, SupplierID FROM Products
GROUP BY CategoryID, SupplierID
WITH CUBE
