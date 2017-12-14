-- Airdate raðað eftir ári
SELECT airdate
  FROM jeopardy
WHERE airdate ~* '[0-9][0-9]/[0-9][0-9]/*'
GROUP BY airdate
ORDER BY substring(airdate, 6, 9);

-- Hlutfallið milli Íslands og Danmerkur Ingimar: 0.585
select (select count(question)
from jeopardy
where question like '%Iceland%')/(SELECT count(question)
from jeopardy
where question like '%Denmark%')::float;

-- Fjöldi frægra karla og kvenna 
-- Ingimar: karlar = 16.277, konur = 7488
SELECT (select count(gender)
FROM persons
WHERE gender like '%male%') as Males,
(SELECT count(gender)
from persons
where gender like '%female%') as Females;

--- Listi af spurningum að virði 2000, 
-- Ingimar: 12.828
select question, valueindollars
from jeopardy
where valueindollars = 2000
GROUP BY question, valueindollars;

--- Spurningar með gap, Ingimar: 852
SELECT question
from jeopardy
WHERE question LIKE '%\_\_\_\_%';

--- Fjöldi spurninga um Norðurlöndin
/*
Ingimar:
Ísland: 86
Danmörk: 147
Finnland: 76
Svíðþjóð: 138
Noregur: 136
Færeyjar: 3
*/
SELECT
  count(*) FILTER (WHERE question like '%Iceland%') as Iceland
, count(*) FILTER (WHERE question like '%Denmark%') as Denmark
, count(*) FILTER (WHERE question like '%Finland%') as Finland
, count(*) FILTER (WHERE question like '%Sweden%') as Sweden
, count(*) FILTER (WHERE question like '%Norway%') as Norway
, count(*) FILTER (WHERE question like '%Faroe Islands%') as Faroe_Islands
FROM jeopardy;

--Hvaða orð kemur oftast fyrir í svörum með 2 orð
-- Ingimar: New york
SELECT answernoun, count(answernoun)
FROM answernouns
WHERE answernoun like '% %'
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--Hvaða orð kemur oftast fyrir í svörum með 1 orð
-- Ingimar John
SELECT answernoun, count(answernoun)
FROM answernouns
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--Hvaða orð kemur oftast fyrir í spurningum með 2 orð
-- Á ekki við, spurning um að sleppa
SELECT questionnoun, count(questionnoun)
FROM questionnouns
WHERE questionnoun like '% %'
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC; 

--Hvaða orð kemur oftast fyrir í spurningum með 1 orð
-- Ingimar: name
SELECT questionnoun, count(questionnoun)
FROM questionnouns
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC;
--- 
SELECT * FROM jeopardy;

SELECT * FROM categories;

-- Allar spurningar um Ísland
-- Ingimar: fyrsta row: "This bird was not ..."
SELECT question, answer, categories
FROM jeopardy
WHERE lower(question) LIKE '%iceland%'
OR lower(answer) LIKE '%iceland%';

-- Flestar spurningarnar voru 05/04/2000
-- Ingimar: 19/05/1997 og 13/11/2007 og count er 62
SELECT airdate, count(airdate)
FROM jeopardy
GROUP BY airdate
ORDER BY count(airdate) DESC;

-- Ingimar: fyrsta row: "In an 1864 letter, ..."
SELECT question, airdate
FROM jeopardy
WHERE airdate = '05/04/2000';

-- Færeyjar
-- Ingimar: fyrsta row: "from their name, ..."
SELECT question, answer, categories
from jeopardy
WHERE lower(question) LIKE '%faroe islands%'
OR lower(answer) LIKE '%faroe islands%';

------------ PERSÓNUR ------------
-- Ingimar: fyrsta row: \weird_al\"_yankovich"
SELECT * FROM persons
GROUP BY person
ORDER BY person;

--Ingimar: 8789
SELECT count(gender)
FROM persons
WHERE gender = 'male';

-- Losna við alla linka úr datagrunninum
DELETE FROM jeopardy WHERE question LIKE '%<a href%';

-- Öll svör sem innihalda fræga persónu
-- Ingimar: fyrsta row: "Cher, she starred... oscar... 800"
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer);

-- Öll svör og spurningar sem innihalda fræga persónu
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE 
(SELECT p.person FROM persons p
WHERE person LIKE a.answer)
OR a.question LIKE 
(SELECT p2.person FROM persons p2
WHERE person LIKE a.question);

-- Öll svör og spurningar sem innihalda fræga persónu (create view til að geta leitað í því)
CREATE VIEW famous_qa AS
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer)
OR a.question LIKE (
  SELECT p2.person FROM persons p2
  WHERE person LIKE a.question)
ORDER BY a.answer;

-- Öll svör sem innihalda karlkyns fræga persónu
-- Ingimar: fyrsta row: "Liberace, this colorful..., MAY, 200"
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer AND gender = 'male');

-- Öll svör sem innihalda kvenkyns fræga persónu
-- Ingimar: fyrsta row: "Cher, she starred... oscar... 800"
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer AND gender = 'female');

-- Finna Morgan Freeman
SELECT person, gender
FROM persons
WHERE lower(person) LIKE '%morgan freeman%';

-- Meðalvirði svars fyrir ákveðinn einstakling
-- Ingimar: 561.11
SELECT avg(valueindollars) AS Average_value_for_this_person
FROM jeopardy
WHERE answer LIKE (SELECT person
  FROM persons
  WHERE lower(person) LIKE '%meryl streep%');

-- Persóna og virði
SELECT v.answer, v.valueindollars
FROM jeopardy v
WHERE lower(v.answer) LIKE '%meryl streep%';

-- Persóna og virði
-- Ingimar: 525
SELECT avg(valueindollars)
FROM jeopardy
WHERE lower(answer) LIKE '%meryl streep%';

-- Meðalvirði svara fyrir karlkyns leikara
-- Ingimar: fæ error
-- Margrét: fæ ERROR!!!!!!!!!
SELECT avg(valueindollars) AS Average_value_for_morgan_freeman
FROM jeopardy
WHERE answer LIKE (SELECT person
  FROM persons
  WHERE lower(gender) = 'male');

-- Meðalvirði svara sem innihalda fræga persónu er 
-- Guðrún: 619.962 
-- Ingimar: 587.5
--- Margrét: 587,5
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer);

-- Meðalverð fyrir fræga karlmenn er 
-- Guðrún: 617.450
-- Ingimar: 647.619
-- Margrét: 647.619
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer AND p.gender = 'male');

-- Meðalverð fyrir frægar konur er 
-- Guðrún: 623.419
-- Ingimar: 562.745
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer AND p.gender = 'female');

-- Finna svör sem eru ártöl
-- Ingimar: fyrsta row: indonesian; he's only ...
SELECT question, (answer)::INT
FROM jeopardy
WHERE lower(question) LIKE '%year%'
AND jeopardy.answer ~* '^-?[1-9]\d*$'
ORDER BY answer;

-- Algengustu ártölin
-- Ingimar: 2000
-- Margrét: 2000
SELECT (answer)::INT, count(answer)
FROM jeopardy
WHERE lower(question) LIKE '%year%'
AND answer ~*'^-?[1-9]\d*$'
GROUP BY answer
ORDER BY count(answer) DESC;

-- Leita af ákveðnu orði í spurningu eða svari
SELECT answer, question, categories, rounds
FROM jeopardy
WHERE lower(answer) LIKE '%leif ericson%'
OR lower(question) LIKE '%leif ericson%';

-- Algengustu persónurnar
SELECT (answer)::INT, count(answer)
FROM jeopardy
WHERE lower(question) LIKE '%year%'
AND answer ~*'^-?[1-9]\d*$'
GROUP BY answer
ORDER BY count(answer) DESC;

-- Öll svör og spurningar sem innihalda fræga persónu
SELECT a.answer AS Celeb_in_answer, p.person, count(p.person)
FROM jeopardy a, persons p
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer)
  OR
  a.question LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.question)
GROUP BY p.person, a.answer;

-- Öll svör sem innihalda fræga persónu
SELECT a.answer AS Celeb_in_answer, p.person, count(p.person)
FROM jeopardy a, persons p
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer);

--- Listi yfir alla perra
select name
from creeps;

---Listi yfir hversu margir perrar eru
select count(name)
from creeps;

--- Hversu margar spurningar eru um hvern perra
---ATHUGA FÆ ÞETTA EKKI RÉTT GETUR EINHVER HJÁLPAÐ MÉR
select c.name as Creeps_in_question, j.question, count(j.question)
from creeps c, jeopardy j
where c.name like (select j.question from jeopardy j
where question like c.name)
group by j.question, c.name;


