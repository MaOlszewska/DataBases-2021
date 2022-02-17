-- 3 

SELECT DISTINCT m.firstname + ' ' + m.lastname FROM juvenile as j
INNER JOIN member as m on  m.member_no = j.member_no 
INNER JOIN loan as l on l.member_no = m.member_no 
INNER JOIN title as t on t.title_no = l.title_no
INNER JOIN loanhist as lh on lh.title_no = t.title_no
WHERE t.title = 'Walking' AND (YEAR(lh.in_date) = 2001 AND MONTH(lh.in_date) =12 AND  DAY(lh.in_date) = 14)

SELECT * FROM member

-------------------------------------------------------------- MARCJAN 2015/2016 ----------------------------------------------
-- 3 Dla każdego dziecka zapisanego w bibliotece wyświetl jego imię i nazwisko, adres zamieszkania, imię i nazwisko rodzica (opiekuna) oraz liczbę wypożyczonych 
-- książek w grudniu 2001 roku przez dziecko i opiekuna. *) Uwzględnij tylko te dzieci, dla których liczba wypożyczonych książek jest większa od 1

SELECT chm.firstname + ' ' + chm.lastname, (SELECT COUNT(*) FROM loanhist as lh 
                                            WHERE lh.member_no = j.member_no AND YEAR(due_date) = 2001 AND MONTH(due_date) = 12),
 street + ' ' + city + ' ' + state, pam.firstname + ' ' + pam.lastname, (SELECT COUNT(*) FROM loanhist as lh 
                                                                        WHERE lh.member_no = a.member_no AND YEAR(due_date) = 2001 AND MONTH(due_date) = 12) 
FROM juvenile as j
INNER JOIN member as chm on chm.member_no = j.member_no 
INNER JOIN adult as a on a.member_no = j.adult_member_no
INNER JOIN member as pam on pam.member_no = j.adult_member_no
WHERE  (SELECT COUNT(*) FROM loanhist as lh WHERE lh.member_no = j.member_no AND YEAR(due_date) = 2001 AND MONTH(due_date) = 12) > 1



--4
-- Podaj listę członków biblioteki (imię, nazwisko) mieszkających w Arizonie (AZ), którzy mają
-- więcej niż dwoje dzieci zapisanych do biblioteki oraz takich, którzy mieszkają w Kalifornii (CA)
-- i mają więcej niż troje dzieci zapisanych do bibliotek. Dla każdej z tych osób podaj liczbę książek
-- przeczytanych (oddanych) przez daną osobę i jej dzieci w grudniu 2001 (użyj operatora union).



SELECT m.firstname, m.lastname,
(SELECT COUNT(*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) AS children,

(SELECT COUNT(*) FROM loanhist AS lh WHERE
(lh.member_no = a.member_no OR
lh.member_no IN (SELECT j.member_no FROM juvenile AS j WHERE j.adult_member_no = a.member_no))
AND YEAR(in_date) = 2001 AND MONTH(in_date) = 12) AS Returned

FROM adult AS a
INNER JOIN member AS m
ON a.member_no = m.member_no
WHERE a.state = 'AZ' AND (SELECT COUNT(*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) > 2

UNION

SELECT m.firstname, m.lastname,
(SELECT COUNT(*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) AS Children,

(SELECT COUNT(*) FROM loanhist AS lh WHERE
(lh.member_no = a.member_no OR
lh.member_no IN (SELECT j.member_no FROM juvenile AS j WHERE j.adult_member_no = a.member_no))
AND YEAR(in_date) = 2001 AND MONTH(in_date) = 12) AS Returned

FROM adult AS a
INNER JOIN member AS m
ON a.member_no = m.member_no
WHERE a.state = 'CA' AND (SELECT COUNT(*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) > 3;




--1)
-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki. Interesuje nas imię, nazwisko,
-- data urodzenia dziecka, adres zamieszkania, imię i nazwisko rodzica oraz liczba aktualnie wypożyczonych książek.

SELECT chm.firstname + ' ' + chm.lastname,(SELECT COUNT(*) FROM loanhist as lh 
                                            WHERE lh.member_no = j.member_no), a.street, a.city, a.state, am.firstname + ' ' + am.lastname FROM juvenile as j
INNER JOIN member as chm on j.member_no = chm.member_no
INNER JOIN adult as a on a.member_no = j.adult_member_no
INNER JOIN member as am on j.adult_member_no = am.member_no

-- 2) Podaj listę wszystkich dorosłych, którzy mieszkają w Arizonie i mają dwójkę dzieci zapisanych do biblioteki oraz listę dorosłych, mieszkających w Kalifornii 
-- i mają 3 dzieci. Dla każdej z tych osób podaj liczbę książek przeczytanych w grudniu 2001 przez tę osobę i jej dzieci. (Arizona - 'AZ', Kalifornia - 'CA'

SELECT firstname + ' ' + lastname, state, (SELECT COUNT(*) FROM loanhist as lh WHERE lh.member_no = am.member_no AND YEAR(lh.in_date) = 2001 AND  MONTH(lh.in_date) = 12) + 
(SELECT COUNT(*) FROM loanhist as lh, juvenile as j WHERE  j.member_no = lh.member_no AND j.adult_member_no = am.member_no  AND YEAR(lh.in_date) = 2001 AND  MONTH(lh.in_date) = 12  )FROM member as am
INNER JOIN adult as a on am.member_no = a.member_no AND a.state = 'AZ'
WHERE 2 = (SELECT COUNT(*) FROM juvenile as j 
           WHERE a.member_no = j.adult_member_no)

UNION 

SELECT firstname + ' ' + lastname, state, (SELECT COUNT(*) FROM loanhist as lh WHERE lh.member_no = am.member_no  AND YEAR(lh.in_date) = 2001 AND  MONTH(lh.in_date) = 12) + 
(SELECT COUNT(*) FROM loanhist as lh, juvenile as j WHERE  j.member_no = lh.member_no AND j.adult_member_no = am.member_no  AND YEAR(lh.in_date) = 2001 AND  MONTH(lh.in_date) = 12  ) FROM member as am
INNER JOIN adult as a on am.member_no = a.member_no AND a.state = 'CA'
WHERE 3 = (SELECT COUNT(*) FROM juvenile as j 
           WHERE a.member_no = j.adult_member_no)


SELECT m.firstname, m.lastname, a.state,
	(SELECT COUNT (*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) AS 'IloscDzieci',
	(SELECT COUNT (*) FROM loanhist AS lh WHERE
		(lh.member_no = a.member_no OR lh.member_no IN 
		(SELECT j.member_no FROM juvenile AS j WHERE j.adult_member_no = a.member_no))
		AND YEAR(in_date) = 2001 AND MONTH(in_date) = 12) AS 'KsiazkiPrzeczytane'
	FROM adult AS a JOIN member AS m ON a.member_no = m.member_no
	WHERE a.state = 'AZ' AND (SELECT COUNT(*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) = 2
UNION
SELECT m.firstname, m.lastname, a.state,
	(SELECT COUNT (*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) AS 'IloscDzieci',
	(SELECT COUNT (*) FROM loanhist AS lh WHERE
		(lh.member_no = a.member_no OR lh.member_no IN (SELECT j.member_no FROM juvenile AS j WHERE j.adult_member_no = a.member_no)) 
		AND YEAR(in_date) = 2001 AND MONTH(in_date) = 12) AS 'KsiazkiPrzeczytane'
	FROM adult AS a JOIN member AS m ON a.member_no = m.member_no
	WHERE a.state = 'CA' AND (SELECT COUNT (*) FROM juvenile AS j WHERE j.adult_member_no = a.member_no) = 3  

-- Wypisz wszystkich członków biblioteki (imie i nazwisko, adres), liczba
-- aktualnie zarezerwowanych ksiazek oraz sumaryczna liczba dni zalegania z
-- wypozyczonymi ksiazkami. Dla kazdego czytelnika podaj informacje czy jest
-- dzieckiem czy doroslym, jezeli jest dzieckiem i zalegal z oddaniem ksiazek
-- wyswietl imie i nazwisko opiekuna prawnego.

select distinct m.firstname + ' ' + m.lastname, a.street + ' ' + a.city + ' ' + a.state,
(select count(*) from reservation as r
where r.member_no = m.member_no),
(select (sum(datediff(day , out_date, in_date))) from loanhist as l where l.member_no = m.member_no),
iif(j.member_no is null, 'adult', 'juvenile') as status
from member as m
left join juvenile j on m.member_no = j.member_no
left join adult a on (m.member_no = a.member_no and j.member_no is null) or (j.adult_member_no = a.member_no);


-- Wybierz członków biblioteki, ktůrzy nie wypożyczyli w 1996 r. książki, której
-- autorem jest Samuel Smiles, w języku arabskim. Napisz w 2 wersjach: bez
-- podzapytań i z podzapytaniami.


SELECT DISTINCT member_no FROM member 
WHERE member_no not in 
(SELECT lh.member_no FROM loanhist as lh
INNER JOIN item as i on i.isbn = lh.isbn 
INNER JOIN title as t on t.title_no = lh.title_no
WHERE t.author = 'Samuel Smiles' AND YEAR(lh.due_date) = 1996 AND i.translation = 'ARABIC' )

select distinct m.member_no from member as m
where m.member_no not in (select lh.member_no from loanhist as lh where year(lh.out_date) = 1996 and lh.isbn in 
(select i.isbn from item as i where i.translation = 'ARABIC' and i.title_no in (select t.title_no from title t where t.author = 'Samuel Smiles')))


select distinct m2.member_no from member as m
inner join loanhist l on m.member_no = l.member_no and year(l.out_date) = 1996
inner join item i on l.isbn = i.isbn and i.translation = 'ARABIC'
inner join title t on i.title_no = t.title_no and t.author = 'Samuel Smiles'
right outer join member as m2 on m2.member_no = m.member_no
where m.member_no is null;


-- Wypisz imiona, nazwiska i adresy członków biblioteki wraz z informację, czy są dorosłym czy
-- dzieckiem (przy dzieciach dopisz ich opiekuna prawnego) oraz długiem za przetrzymywanie
-- książek.

 
select m.firstname + ' ' + m.lastname + ' ' + m.middleinitial as name,
 a.street + ' ' + a.city + ' ' + a.state as address,
 (select sum(lh.fine_assessed) from loanhist as lh
 where lh.member_no = m.member_no) as 'kara', 'adult'
from member as m
inner join adult a on m.member_no = a.member_no
union
select m.firstname + ' ' + m.lastname + ' ' + m.middleinitial as name,
 a.street + ' ' + a.city + ' ' + a.state as address,
 (select sum(lh.fine_assessed) from loanhist as lh
 where lh.member_no = m.member_no) as 'kara',
 m2.firstname + ' ' + m2.lastname + ' ' + m2.middleinitial as name2
from member as m
 inner join juvenile j on j.member_no = m.member_no
 inner join adult a on j.adult_member_no = a.member_no
 inner join member m2 on m2.member_no = a.member_no

-- Wybierz imiona, nazwiska i adresy członków biblioteki z Kalifornii (dzieci i dorosłych) oraz
-- tych dorosłych, którzy wypożyczyli ponad 3 książki (włącznie z obecnie wypożyczonymi).

SELECT firstname + ' ' + lastname + ' ' + middleinitial, street + ' ' + city + ' ' + state FROM member as m, adult as a
INNER JOIN juvenile as j on j.adult_member_no = a.member_no
WHERE state = 'CA' AND m.member_no = a.member_no


-- Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001

SELECT TOP 1 t.author, Count(*) FROM member as m
INNER JOIN juvenile as j on j.member_no = m.member_no
INNER JOIN loan as l on l.member_no = m.member_no
INNER JOIN title as t on l.title_no = l.title_no
INNER JOIN loanhist as lh on lh.title_no = t.title_no
INNER JOIN adult as a on j.adult_member_no = a.member_no AND a.[state] = 'AZ'
WHERE YEAR(lh.due_date) = 2001
GROUP BY t.author
ORDER BY COUNT(*) DESC

