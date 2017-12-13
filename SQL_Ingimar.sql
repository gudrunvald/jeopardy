--- listi af spurningum að virði 2000
select question, valueindollars
from jeopardy
where valueindollars = 2000
GROUP BY question, valueindollars;

--- gap spurningar
SELECT question
from jeopardy
WHERE question LIKE '%\_\_\_\_%';

---lond
SELECT
  count(*) FILTER (WHERE question like '%Iceland%') as Iceland
, count(*) FILTER (WHERE question like '%Denmark%') as Denmark
, count(*) FILTER (WHERE question like '%Finland%') as Finland
, count(*) FILTER (WHERE question like '%Sweden%') as Sweden
, count(*) FILTER (WHERE question like '%Norway%') as Norway
, count(*) FILTER (WHERE question like '%Faroe Islands%') as Faroe_Islands
FROM jeopardy;
