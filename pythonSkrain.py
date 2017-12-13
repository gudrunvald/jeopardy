import csv
import string
import psycopg2
import connectToDB

host = 'localhost'
dbname = 'storaverkefnid'   #Setjið inn ykkar dbname 
user = 'postgres'           #Setjið inn ykkar username
password = '********'     #Setjið inn ykkar password

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)

def csvReader():
    text = csv.reader(open("out.csv", encoding="utf8"))
    returnList = []
    counter = 0
    for row in text:
        tempTuple = row[0].split(";")
        returnList.append(tempTuple)
    return returnList

myList = csvReader()
print(myList[0])


cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)

'''
numberOfRowsToInsert = 2000
counter = 0
insertString = "insert into questionnouns (questionnoun, jeopardyId) values "
values = ''
for item in myList:

    item[1] = item[1].replace("'", "''")
    if len(values) > 0:
        values = values + ","
    values = values + "('{}',{})".format(item[1], item[0])
    counter += 1

    if counter == numberOfRowsToInsert:
        cursor.execute(insertString + values)
        values = ''
        counter = 0

if counter > 0:
    cursor.execute(insertString + values)
    values = ''
    counter = 0

#categories = set()
#rounds = set()
#shownumbers = set()
'''

'''
for item in myList:
    shownumbers.add(item[0])
    rounds.add(item[2])
    categories.add(item[3])
'''


#catLength = len(categories)
#print(len(rounds))

'''
numberOfRowsToInsert = 2000
counter = 0
insertCatString = "insert into categories (category) values " 
catValues = ''

for c in categories:
    c = c.replace("'", "''")
    if len(catValues) > 0:
        catValues = catValues + ","
    catValues = catValues + "('{}')".format(c)
    counter += 1

    if counter == numberOfRowsToInsert:
        cursor.execute(insertCatString + catValues)
        catValues = ''
        counter = 0

if counter > 0:
    cursor.execute(insertCatString + catValues)
    catValues = ''
    counter = 0



numberOfRoundsToInsert = 4
roundValues = ''
insertRoundString = "insert into rounds (round) values "
counter = 0
for r in rounds:
    r = r.replace("'", "''")
    if len(roundValues) > 0:
        roundValues = roundValues + ","
    roundValues = roundValues + "('{}')".format(r)
    counter += 1

    if counter == numberOfRoundsToInsert:
        cursor.execute(insertRoundString + roundValues)
        roundValues = ''
        counter = 0

if counter > 0:
    cursor.execute(insertRoundString + roundValues)
    roundValues = ''
    counter = 0



numberOfShowsToInsert = 1000
showValues = ''
insertShowString = "insert into shownumbers (shownumber) values "
counter = 0
for s in shownumbers:
    if len(showValues) > 0:
        showValues = showValues + ","
    showValues = showValues + "({})".format(s)
    counter += 1

    if counter == numberOfShowsToInsert:
        cursor.execute(insertShowString + showValues)
        showValues = ''
        counter = 0

if counter > 0:
    cursor.execute(insertShowString + showValues)
    showValues = ''
    counter = 0


numberOfRoundsToInsert = 2000
jeopardyValues = ''
insertRoundString = "insert into jeopardy (shownumber, airdate, rounds, categories, valueindollars, question, answer) values "
counter = 0
for item in myList:
    item[2] = item[2].replace("'", "''")
    item[3] = item[3].replace("'", "''")
    item[5] = item[5].replace("'", "''")
    item[6] = item[6].replace("'", "''")
    temp = item[4][1:]
    if (temp == "one"):
        temp = 0
    else:
        temp = str.replace(temp, ',', '')
    value = int(temp)

    if len(jeopardyValues) > 0:
        jeopardyValues = jeopardyValues + ","
    jeopardyValues = jeopardyValues + "({},'{}','{}','{}',{},'{}','{}')".format(item[0], item[1], item[2], item[3], value, item[5], item[6])
    counter += 1

    if counter == numberOfRoundsToInsert:
        cursor.execute(insertRoundString + jeopardyValues)
        jeopardyValues = ''
        counter = 0

if counter > 0:
    cursor.execute(insertRoundString + jeopardyValues)
    jeopardyValues = ''
    counter = 0

'''



conn.commit()
cursor.close()
conn.close()
