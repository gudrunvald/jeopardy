#Hlutfallið milli Íslands og Danmerkur
select (select count(question)
from jeopardy
where question like '%Iceland%')/(SELECT count(question)
from jeopardy
where question like '%Denmark%')::float;

#Hversu margir kk og kvk leikarar
SELECT (select count(gender)
FROM persons
WHERE gender like '%male%') as Males,
(SELECT count(gender)
from persons
where gender like '%female%') as Females;