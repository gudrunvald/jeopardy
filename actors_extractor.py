import csv
import string
import psycopg2
import connectToDB

g = open('actors_insert_commands.sql', 'w')
unwanteds = """,\"_ \-\/'\" __.\""""

######################################################
# Connect to DB

host = 'localhost'
dbname = 'hopverk'   	#Setjið inn ykkar dbname 
user = ''           	#Setjið inn ykkar username
password = ''     		#Setjið inn ykkar password

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"
conn_string = conn_string.format(host, dbname, user, password)
cursor, conn = connectToDB.connect_to_database(host, dbname, user, password)

######################################################
# Actors
f = open('actors.csv')
reader = csv.DictReader(f)

actors_data = []
for i in reader:
	actors_data.append(i)
f.close()

actors_set = set()
for i in actors_data:
	name = i['title']
	name = name.replace('_', ' ')
	name = name.replace("'", "´")
	name = name.strip(unwanteds)
	actors_set.add(name)

print('Actors: ', actors_set)
for a in actors_set:
	g.write("insert into persons(person, gender) values ('{}', '{}');\n".format(a, 'male'))

######################################################
# Actresses
a = open('actresses.csv')
reader = csv.DictReader(a)

actresses_data = []
for i in reader:
	actresses_data.append(i)
a.close()

actresses_set = set()
for i in actresses_data:
	name = i['title']
	name = name.replace('_', ' ')
	name = name.replace("'", "´")
	name = name.strip(unwanteds)
	actresses_set.add(name)

print('Actresses: ', actresses_set)
for a in actresses_set:
	g.write("insert into persons(person, gender) values ('{}', '{}');\n".format(a, 'female'))

######################################################
# Execute the insert lines



######################################################
# Close all connections
conn.commit()
cursor.close()
conn.close()
g.close()





