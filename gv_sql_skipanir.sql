SELECT * FROM jeopardy;

SELECT * FROM categories;

-- Allar spurningar um ísland
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


SELECT * from persons;