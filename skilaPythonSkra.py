import csv
import string
import psycopg2
import connectToDB

host = 'localhost'
dbname = 'storaverkefnid'   	#Setjið inn ykkar dbname 
user = 'postgres'           	#Setjið inn ykkar username
password = '*********'     		#Setjið inn ykkar password

def csvReader1():
	text = csv.reader(open("jeopardy2.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		if counter == 0:
			counter += 1
		else:
			returnList.append(row)
	return returnList

def csvReader2():
	text = csv.reader(open("out_questions.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		tempTuple = row[0].split(";")
		returnList.append(tempTuple)
	return returnList

def csvReader3():
	text = csv.reader(open("out_answers.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		tempTuple = row[0].split(";")
		returnList.append(tempTuple)
	return returnList

def csvReaderMale():
	text = csv.reader(open("actors.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		if counter == 0:
			counter += 1
		else:
			temp = row[1]
			returnList.append(temp)
	return returnList

def csvReaderFemale():
	text = csv.reader(open("actresses.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		if counter == 0:
			counter += 1
		else:
			temp = row[1]
			returnList.append(temp)
	return returnList

def csvReaderSentiments():
	text = csv.reader(open("out_sentiments.csv", encoding="utf8"))
	returnList = [] 
	counter = 0
	for row in text:
		tempTuple = row[0].split(";")
		returnList.append(tempTuple)
	return returnList

def csvReaderCreeps():
    text = csv.reader(open("out_creeps.csv", encoding="utf8"))
    returnList = []
    counter = 0
    for row in text:
        returnList.append(row)
    return returnList


conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)
cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)

myList = csvReader1()

setShowNumbers = set()
setRounds = set()
setCategories = set()

for item in myList:
	setShowNumbers.add(item[0])
	setRounds.add(item[2])
	setCategories.add(item[3])

numberOfRowsToInsert = 2000
counter = 0
insertString = "insert into shownumbers (shownumber) values "
values = ''

for item in setShowNumbers:
	if len(values) > 0:
		values = values + ","
	values = values + "({})".format(item)
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0

insertString = "insert into categories (category) values "
for item in setCategories:
	item = item.replace("'", "''")
	if len(values) > 0:
		values = values + ","
	values = values + "('{}')".format(item)
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0

insertString = "insert into rounds (round) values "
for item in setRounds:
	item = item.replace("'", "''")
	if len(values) > 0:
		values = values + ","
	values = values + "('{}')".format(item)
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0

insertString = "insert into jeopardy (shownumber, airdate, rounds, categories, valueindollars, question, answer) values "

for item in myList:
	item[3] = item[3].replace("'", "''")
	item[5] = item[5].replace("'", "''")
	item[6] = item[6].replace("(", "")
	item[6] = item[6].replace(")", "")
	item[6] = item[6].replace("'", "''")
	item[4] = item[4][1:]
	if item[4] == "one":
		item[4] = 0
	else:
		item[4] = str.replace(item[4], ',', '')
	if (len(values) > 0):
		values = values + ","
	values = values + "({},'{}','{}','{}',{},'{}','{}')".format(item[0], item[1], item[2], item[3], item[4], item[5], item[6])
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0	

myList = csvReader2()
insertString = "insert into questionnouns (questionnoun, jeopardyId) values "
for item in myList:
	item[1] = item[1].replace("'", "''")
	if len(values) > 0:
		values = values + ","
	values = values + "('{}', {})".format(item[1], item[0])
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0


myList = csvReader3()
insertString = "insert into answernouns (answernoun, jeopardyId) values "
for item in myList:
	item[1] = item[1].replace("'", "''")
	if len(values) > 0:
		values = values + ","
	values = values + "('{}', {})".format(item[1], item[0])
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0


myList = csvReaderMale()
personSet = set()
for item in myList:
	personSet.add((item, "male"))

myList = csvReaderFemale()
for item in myList:
	personSet.add((item, "female"))

myList = list(personSet)
insertString = "insert into persons (person, gender) values "
for item in myList:
	temp = item[0].replace("'", "''")
	if len(values) > 0:
		values = values + ","
	values = values + "('{}', '{}')".format(temp, item[1])
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0


myList = csvReaderSentiments()
insertString = "insert into sentiments (polarity, subjectivity, jeopardyId) values "
for item in myList:
	if len(values) > 0:
		values = values + ","
	values = values + "({},{},{})".format(item[1], item[2], item[0])
	counter += 1

	if counter == numberOfRowsToInsert:
		cursor.execute(insertString + values)
		values = ''
		counter = 0

if counter > 0:
	cursor.execute(insertString + values)
	values = ''
	counter = 0


myList = csvReaderCreeps()
insertString = "insert into creeps (name) values "
for item in myList:
    item[0] = item[0].replace("'", "''")
    item[0] = item[0][1:]
    if len(values) > 0:
        values = values + ","
    values = values + "('{}')".format(item[0])
    counter += 1

    if counter == numberOfRowsToInsert:
        cursor.execute(insertString + values)
        values = ''
        counter = 0

if counter > 0:
    cursor.execute(insertString + values)
    values = ''
    counter = 0

conn.commit()
cursor.close()
conn.close()