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

--hvaða orð kemur oftast fyrir í svörum með 2 orð
SELECT answernoun, count(answernoun)
FROM answernouns
WHERE answernoun like '% %'
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--hvaða orð kemur oftast fyrir í svörum með 1 orð
SELECT answernoun, count(answernoun)
FROM answernouns
GROUP BY answernoun
ORDER BY count(answernoun) DESC;

--hvaða orð kemur oftast fyrir í spurningum með 2 orð
SELECT questionnoun, count(questionnoun)
FROM questionnouns
WHERE questionnoun like '% %'
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC; 

--hvaða orð kemur oftast fyrir í spurningum með 1 orð
SELECT questionnoun, count(questionnoun)
FROM questionnouns
GROUP BY questionnoun
ORDER BY count(questionnoun) DESC;

