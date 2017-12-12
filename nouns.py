import pandas as pd
import os
from textblob import TextBlob as tb
#########
import psycopg2

host = 'localhost'
dbname = 'storaverkefnid'
user = ''
password = ''

conn_string = "host='{}' dbname='{}' user='{}' password='{}'"

conn_string = conn_string.format(host, dbname, user, password)

try:
    conn = psycopg2.connect(conn_string)
except psycopg2.OperationalError as e:
    print('Connection failed!')
    print('Error message: ', e)
    exit()

cursor = conn.cursor()

spurning = input('Question: ')

s = """select question,id
from jeopardy;"""

values = [spurning,]

query = cursor.mogrify(s, values)

print(query)

cursor.execute(query)

try:
    records = cursor.fetchall()
    print('Question {} are: '.format(spurning))
    for i in records:
        print(i[0])

except:
    print('no records')

conn.commit()
cursor.close()
conn.close()
#################

data = pd.read_csv("jeopardy_first_1000.csv", engine='python', encoding="utf8")
pd.set_option('display.max_colwidth', 4000) # til ad birta spurningarnar í heild
pd.set_option('display.max_rows', 250000) # til ad birta allar línur en ekki bara fyrstu og sídustu

if os.path.exists('noun_list.csv'):
    os.remove('noun_list.csv')

f = open('noun_list.csv', 'a')

for index, row in data.iterrows():
    #í staðinn fyrir str(row['Question']) vil ég sækja í gagnagrunninn
    rowblob = tb(str(row['Question']))
    #print(rowblob.noun_phrases)
    for word in rowblob.noun_phrases:
        f.write(word + "\n")
    for tag in rowblob.tags:
        if tag[1] == 'NN' or tag[1] == 'NNP' or tag[1] == 'NNS':
            f.write(tag[0] + "\n")

f.close()
