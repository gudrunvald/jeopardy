import csv
import string
import psycopg2
import connectToDB

host = 'localhost'
dbname = 'hopverk'   	#Setjið inn ykkar dbname 
user = ''           	#Setjið inn ykkar username
password = ''     		#Setjið inn ykkar password


def csvReader():
    text = csv.reader(open("out_creeps.csv", encoding="utf8"))
    returnList = []
    counter = 0
    for row in text:
        #tempTuple = row[0].split(";")
        returnList.append(row)
    return returnList

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)
cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)

myList = csvReader()
print(myList[0][0])

numberOfRowsToInsert = 1000
counter = 0
insertString = "insert into creeps (name) values "
values = ''

for item in myList:
    item[0] = item[0].replace("'", "''")
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
