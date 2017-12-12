import pandas as pd
import os
from textblob import TextBlob as tb
import psycopg2
import csv

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

questionSet = set()
questionsList = []

#206406
for item in range(2, 206406):
    s = """select id, question from jeopardy where id=""" + str(item) + """;"""
    query = cursor.mogrify(s)
    cursor.execute(query)

    try:
        records = cursor.fetchall()
        for i in records:
            questionSet.add(i)
    except:
        print('no records')

conn.commit()
cursor.close()
conn.close()
#################

#data = pd.read_csv("jeopardy_first_1000.csv", engine='python', encoding="utf8")
#pd.set_option('display.max_colwidth', 40) # til ad birta spurningarnar í heild
#pd.set_option('display.max_rows', 250000) # til ad birta allar línur en ekki bara fyrstu og sídustu

tempList = list(questionSet)
# sækir nafnliði, svo nafnorð
for index in tempList:
    item = index[1].lower()
    rowblob = tb(item)
    for word in rowblob.noun_phrases:
        questionsList.append((index[0], word))
    for tag in rowblob.tags:
        if tag[1] == 'NN' or tag[1] == 'NNS':
            questionsList.append((index[0], tag[0]))

with open("out.csv","w") as g:
    wr = csv.writer(g,delimiter=";")
    for value in questionsList:
        wr.writerow(value)

f.close()
