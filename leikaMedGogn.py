import csv
import string
import psycopg2
import connectToDB

host = 'localhost'
dbname = 'storaverkefnid'
user = 'postgres'
password = '_Crossfit10'

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)

def csvReader():
	text = csv.reader(open("jeopardy2.csv", encoding="utf8"))
	returnList = []
	counter = 0
	for row in text:
		if counter == 0:
			counter += 1
		else:
			returnList.append(row)
	return returnList

myList = csvReader()
#print(myList[37])

print("Lets try to connect to the Dbfile")
cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)
print("Hey I made it here")
categories = set()
rounds = set()
shownumbers = set()

for item in myList:
	shownumbers.add(item[0])
	rounds.add(item[2])
	categories.add(item[3])

#print(shownumbers)
#print(rounds)
#print("\n")
#print(categories)
#print(len(categories))

categoriesList = list(categories)
categoriesList = sorted(categoriesList)
categoriesList[12269] = "I love New York"
print(categoriesList[12269])

f = open('insertcommands.sql', 'w')
#for c in categoriesList:
	#c = str.replace(c, '\'', '\'\'')
	#f.write("insert into categories (category) values('{}');\n".format(c))
#for r in rounds:
	#f.write("insert into rounds (round) values('{}');\n".format(r)
#for s in shownumbers:
	#f.write("insert into shownumbers (shownumber) values({});\n".format(s))
for item in myList:
	#print(j[4])
	temp = item[4][1:]
	#print(temp)
	cat = str.replace(item[3], '\'', '\'\'')
	question = str.replace(item[5], '\'', '\'\'')
	#print(question)
	answer = str.replace(item[6], '\'', '\'\'')
	#print(answer)
	if (temp == "one"):
		temp = 0
	else:
		temp = str.replace(temp, ',', '')
	value = int(temp)
	f.write("insert into jeopardy (shownumber, airdate, rounds, categories, valueindollars, question, answer) values({},'{}','{}','{}',{},'{}','{}' );\n".format(item[0], item[1], item[2], cat, value, question, answer))

	
cursor.close()
conn.close()
