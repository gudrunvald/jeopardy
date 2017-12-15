# Jeopardy Pub-Quiz Generator

Written for T-316-GAVI at Reykjavik University, fall 2017.

### About
From a database of over 200.000 Jeopardy questions and answers you can generate a pub-quiz with topics of your choosing.

You could also skip questions of high negativity and those that ask about individuals outed as sexual predadors in the #metoo revolution.


### Getting started

#### Get the repository
* To download the project go to https://github.com/gudrunvald/jeopardy.
* To clone the project using gitbash:
	* $git clone https://github.com/gudrunvald/jeopardy.git

#### Install dependencies
* TextBlob (http://textblob.readthedocs.io/en/dev/install.html)
	* $ pip3 install -U textblob
	* $ python -m textblob.download_corpora

* Requests (http://docs.python-requests.org/en/master/)
	* $ pip3 install requests

* LXML (http://lxml.de/)
	* $ pip3 install lxml

* Psycopg2 (http://initd.org/psycopg/)
	* $ pip3 install psycopg2 

#### Create tables in database
* Create a database. Run the create table sql commands from createtables.sql.

#### Populate the tables
* Run the Python code from pythonSkrain.py to insert values into your tables. Nouns.py is used to populate the noun files, using pandas.

#### SQL queries
* All sql queries are in the file SQLfyrirspurnir.sql
