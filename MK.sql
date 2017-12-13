#Hlutfallið milli Íslands og Danmerkur
select (select count(question)
from jeopardy
where question like '%Iceland%')/(SELECT count(question)
from jeopardy
where question like '%Denmark%')::float;