-- ĆWICZENIE I - WYBIERANIE DANYCH

--1 Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książk
SELECT title, title_no FROM title

--2 Napisz polecenie, które wybiera tytuł o numerze 10
SELECT title, title_no From title
WHERE title_no = 10

--3 Napiasz polecnie, które wybiera numer czytelnika i karę dla tych czytelników, którzy maą kary między 8 a 9.
SELECT DISTINCT member_no, fine_assessed FROM loanhist
WHERE fine_assessed BETWEEN 8 AND 9

--4 Napisz polecenie, za pomocą, którego uzyskasz numer ksiazki i autora dla wsyztskich ksiązek których autorem jest Charles Dickens lub Jane Austen
SELECT author, title_no FROM title
WHERE author = 'Charles Dickens' OR author = 'Jane Austen'

--5 Napisz polecenie, które wybeira numer tytułu i tytuł dla wszystkich rekordów zawierających string "adventures" gdzieś w tytule
SELECT title_no, title FROM title
WHERE title LIKE '%adventures%'

--6 Napisz polecenie, które wybiera numer czytelnika, kare oraz zapłaconą karę dla wszytskich, którzy jeszcze nie zapłacili
SELECT member_no, fine_assessed, fine_paid FROM loanhist
WHERE fine_assessed IS NOT NULL AND fine_assessed != 0

--7 Napisz Polecenie, które wybiera wsyztskie unikalne pary miast i stanów z tablicy adult.
SELECT DISTINCT city, state FROM adult

--ĆWICZENIE II - MANIPULWOANIE WYNIKOWYM ZBIOREM

--1 Napisz polecenie, które wybeira wszytskie tytuły z tablicy title i wyświetla je w porządku alfabetycznym
SELECT title FROM title
ORDER BY title ASC 

--2 Napisz polecenie, które:
--wybiera numer członka biblioteki, isbn książki i wartość naliczonej kary dla wszystkich wypożyczeń, dla których naliczono karę
--stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny fine_as
--stwórz alias ‘double fine’ dla tej kolumny
SELECT DISTINCT member_no, isbn, fine_assessed FROM loanhist
WHERE fine_assessed IS NOT NULL AND fine_assessed != 0
SELECT fine_assessed * 2 as double_fine_assessed FROM loanhist as tab

--3 Napisz polecnie: 
--Generuj  pojedynczą kolumnę, która zawiera kolumny: imię członka biblioteki, inicjał drugiego imienia i nazwisko dla wsyztskich członków bibiloteki, ktorzy nazywają się Anderson
--nazwij tak powstałą kolumnę "email_name"
--Zmodyfikuj polecenie, tak by zwróciło listę proponowanych loginów utowrzonych poprzez połączenie imienia członka biblioteki z inicjałem drugiego imienia i pierwszymi dwoma literami nazwiska(wszystko małymi literałami)
--   Wykorzystaj funkcje SUBSTRING do uzyskania części kolumny znakowej oraz lower do zwrócenia wyniku małymi literami 
--   Wykorzytsaj operator (+) do połączenia stringów 

SELECT firstname + middleinitial + lastname as email_name FROM member
WHERE lastname = 'Anderson'
SELECT lower(firstname + middleinitial + SUBSTRING(lastname, 1, 2)) as email_name FROM member
WHERE lastname = 'Anderson'

--4 Napisz polecenie, które wybiera title i title_no z tablicy title
--    Wynikiem powinna byc pojedyncza kolumna o formacie jak w przykłądzie poniże:
--      The title is: Poems, title number 7
--    Czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o wyrażenie, które łaczy 4 elemnty

SELECT 'The title is: ' + title + ', title number ' + title_no FROM title

