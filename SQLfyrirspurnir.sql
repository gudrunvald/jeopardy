-- Hlutfallið milli Íslands og Danmerkur
select (select count(question)
from jeopardy
where question like '%Iceland%')/(SELECT count(question)
from jeopardy
where question like '%Denmark%')::float;

-- Fjöldi frægra karla og kvenna
SELECT (select count(gender)
FROM persons
WHERE gender like '%male%') as Males,
(SELECT count(gender)
from persons
where gender like '%female%') as Females;

--- Listi af spurningum að virði 2000
select question, valueindollars
from jeopardy
where valueindollars = 2000
GROUP BY question, valueindollars;

--- Spurningar með gap
SELECT question
from jeopardy
WHERE question LIKE '%\_\_\_\_%';

--- Fjöldi spurninga um Norðurlöndin
SELECT
  count(*) FILTER (WHERE question like '%Iceland%') as Iceland
, count(*) FILTER (WHERE question like '%Denmark%') as Denmark
, count(*) FILTER (WHERE question like '%Finland%') as Finland
, count(*) FILTER (WHERE question like '%Sweden%') as Sweden
, count(*) FILTER (WHERE question like '%Norway%') as Norway
, count(*) FILTER (WHERE question like '%Faroe Islands%') as Faroe_Islands
FROM jeopardy;

--Hvaða orð kemur oftast fyrir í svörum með 2 orð
SELECT answernoun, count(answernoun)
FROM answernouns
WHERE answernoun like '% %'
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--Hvaða orð kemur oftast fyrir í svörum með 1 orð
SELECT answernoun, count(answernoun)
FROM answernouns
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--Hvaða orð kemur oftast fyrir í spurningum með 2 orð
SELECT questionnoun, count(questionnoun)
FROM questionnouns
WHERE questionnoun like '% %'
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC; 

--Hvaða orð kemur oftast fyrir í spurningum með 1 orð
SELECT questionnoun, count(questionnoun)
FROM questionnouns
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC;

SELECT * FROM jeopardy;

SELECT * FROM categories;

-- Allar spurningar um Ísland
SELECT question, answer, categories
FROM jeopardy
WHERE lower(question) LIKE '%iceland%'
OR lower(answer) LIKE '%iceland%';

-- Flestar spurningarnar voru 05/04/2000
SELECT airdate, count(airdate)
FROM jeopardy
GROUP BY count(airdate)
ORDER BY count(airdate);

SELECT question, airdate
FROM jeopardy
WHERE airdate = '05/04/2000';

-- Færeyjar
SELECT question, answer, categories
from jeopardy
WHERE lower(question) LIKE '%faroe islands%'
OR lower(answer) LIKE '%faroe islands%';

------------ PERSÓNUR ------------
SELECT * FROM persons
GROUP BY person
ORDER BY person;

SELECT count(gender)
FROM persons
WHERE gender = 'male';

-- Losna við alla linka úr datagrunninum
DELETE FROM jeopardy WHERE question LIKE '%<a href%';

-- Öll svör sem innihalda fræga persónu
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer);

-- Öll svör sem innihalda karlkyns fræga persónu
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer AND gender = 'male');

-- Öll svör sem innihalda kvenkyns fræga persónu
SELECT a.answer AS Celeb_in_answer, a.question, a.categories, a.valueindollars
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE person LIKE a.answer AND gender = 'female');

-- Finna Morgan Freeman
SELECT person, gender
FROM persons
WHERE lower(person) LIKE '%morgan freeman%';

-- Meðalvirði svars fyrir ákveðinn einstakling
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
SELECT avg(valueindollars)
FROM jeopardy
WHERE lower(answer) LIKE '%meryl streep%';

-- Meðalvirði svara fyrir karlkyns leikara
SELECT avg(valueindollars) AS Average_value_for_morgan_freeman
FROM jeopardy
WHERE answer LIKE (SELECT person
  FROM persons
  WHERE lower(gender) = 'male');

-- Meðalvirði svara sem innihalda fræga persónu er 619.962
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer);

-- Meðalverð fyrir fræga karlmenn er 617.450
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer AND p.gender = 'male');

-- Meðalverð fyrir frægar konur er 623.419
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer AND p.gender = 'female');

-- Finna svör sem eru ártöl
SELECT question, (answer)::INT
FROM jeopardy
WHERE lower(question) LIKE '%year%'
AND jeopardy.answer ~* '^-?[1-9]\d*$'
ORDER BY answer;

-- Algengustu ártölin
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









