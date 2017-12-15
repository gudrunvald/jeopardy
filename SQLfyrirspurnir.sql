-- Airdate raðað eftir ári
SELECT airdate
  FROM jeopardy
WHERE airdate ~* '[0-9][0-9]/[0-9][0-9]/*'
GROUP BY airdate
ORDER BY substring(airdate, 6, 9);

--- Fjöldi spurninga um Ísland og Danmörk
select count(question)
from jeopardy
where question like '%Denmark%'
UNION
select count(question)
from jeopardy
where question like '%Iceland%';

--- Fjöldi spurninga um Ísland og Danmörk
select count(question)
from jeopardy
where question like '%Denmark%'
UNION
select count(question)
from jeopardy
where question like '%Iceland%';


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

--- Listi af spurningum að virði 2000, 
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
  count(*) FILTER (WHERE question like '%Iceland%' OR answer LIKE '%Iceland%') as Iceland
, count(*) FILTER (WHERE question like '%Denmark%' OR answer LIKE '%Denmark%') as Denmark
, count(*) FILTER (WHERE question like '%Finland%' OR answer LIKE '%Finland%') as Finland
, count(*) FILTER (WHERE question like '%Sweden%' OR answer LIKE '%Sweden%') as Sweden
, count(*) FILTER (WHERE question like '%Norway%' OR answer LIKE '%Norway%') as Norway
, count(*) FILTER (WHERE question like '%Faroe Islands%' OR answer LIKE '%Faroe Islands%') as Faroe_Islands
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

--Hvaða orð kemur oftast fyrir í spurningum með 1 orð
SELECT questionnoun, count(questionnoun)
FROM questionnouns
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC;
--- 
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
GROUP BY airdate
ORDER BY count(airdate) DESC;

-- Spurningar sem voru spurðar 05/04/2000
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

-- Hversu margar spurningar um karlkynið
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

-- Meðalvirði svara sem innihalda fræga persónu er 
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer);

-- Meðalverð fyrir fræga karlmenn er 
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.person FROM persons p
WHERE p.person LIKE a.answer AND p.gender = 'male');

-- Meðalverð fyrir frægar konur er 
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

-- Algengustu leikararnir
SELECT answer, count(answer)
FROM jeopardy
WHERE answer LIKE (
  SELECT p.person FROM persons p
  WHERE p.person LIKE jeopardy.answer)
GROUP BY jeopardy.answer
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

-- Meðalvirði svara sem innihalda creep er
SELECT avg(a.valueindollars)
FROM jeopardy a
WHERE a.answer LIKE (SELECT p.name FROM creeps p
WHERE p.name LIKE a.answer);

-- Leita að creeps í svörum og spurningum
SELECT j.answer, j.question, j.categories, j.valueindollars
FROM jeopardy j
WHERE j.answer LIKE (
  SELECT a.name
  FROM creeps a
  WHERE a.name LIKE j.answer)
OR j.question LIKE (
  SELECT a.name
  FROM creeps a
  WHERE a.name LIKE j.question);

-- Algengustu creepin
SELECT answer, count(answer)
FROM jeopardy
WHERE answer LIKE (
  SELECT p.name FROM creeps p
  WHERE name LIKE jeopardy.answer)
GROUP BY jeopardy.answer
ORDER BY count(answer) DESC;

-- Mesta polarity í spurningum
SELECT jeopardy.question, polarity 
FROM sentiments, jeopardy 
WHERE polarity > 0.8
AND sentiments.id = jeopardy.id;

-- Minnsta polarity í spurningum
SELECT jeopardy.question, polarity 
FROM sentiments, jeopardy 
WHERE polarity < -0.8
AND sentiments.id = jeopardy.id;

-- Hlutdrægustu spurningarnar
SELECT jeopardy.question, subjectivity 
FROM sentiments, jeopardy 
WHERE sentiments.subjectivity < 0.2
AND sentiments.id = jeopardy.id;

-- Algengustu categeries
SELECT categories, count(categories)
FROM jeopardy
GROUP BY categories
ORDER BY count(categories) DESC;