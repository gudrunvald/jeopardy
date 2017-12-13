import csv
import string
import psycopg2
import connectToDB

host = 'localhost'
dbname = 'storaverkefnid'   	#Setjið inn ykkar dbname 
user = 'postgres'           	#Setjið inn ykkar username
password = '**********'     		#Setjið inn ykkar password


def csvReaderMale():
    text = csv.reader(open("actors.csv", encoding="utf8"))
    returnList = []
    counter = 0
    for row in text:
    	if counter == 0:
    		counter+=1
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
    		counter+=1
    	else:
    		temp = row[1]
    		returnList.append(temp)
    return returnList

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)
cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)

maleList = csvReaderMale()
femaleList = csvReaderFemale()
personsSet = set()

numberOfRowsToInsert = 1000
counter = 0
insertString = "insert into persons (person, gender) values "
values = ''

for item in maleList:
	personsSet.add((item, "male"))
for item in femaleList:
	personsSet.add((item, "female"))

#print(personsSet)
listOfPersons = list(personsSet)
print(listOfPersons[0][0])

for item in listOfPersons:
    temp = item[0].replace("'", "''")
    if len(values) > 0:
        values = values + ","
    values = values + "('{}','{}')".format(temp, item[1])
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





