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

cursor_q = conn.cursor()
cursor_a = conn.cursor()

questionSet = set()
questionsList = []

answerSet = set()
answerList = []

#206406
for item in range(2, 20):
    q = """select id, question from jeopardy where id=""" + str(item) + """;"""
    a = """select id, answer from jeopardy where id=""" + str(item) + """;"""

    query_q = cursor_q.mogrify(q)
    query_a = cursor_a.mogrify(a)

    cursor_q.execute(query_q)
    cursor_a.execute(query_a)


    try:
        questions = cursor_q.fetchall()
        answers = cursor_a.fetchall()

        for i in questions:
            questionSet.add(i)
        for i in answers:
            answerSet.add(i)
    except:
        print('no records')

conn.commit()
cursor_q.close()
cursor_a.close()
conn.close()
#################

# hér notuðum við pandas til að byrja með en enduðum á að sleppa því og lesa beint inn úr gagnagrunni:
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

with open("out_questions.csv","w") as g:
    wr = csv.writer(g,delimiter=";")
    for value in questionsList:
        wr.writerow(value)

tempList = list(answerSet)
# sækir nafnliði, svo nafnorð
for index in tempList:
    item = index[1].lower()
    rowblob = tb(item)
    for word in rowblob.noun_phrases:
        answerList.append((index[0], word))
    for tag in rowblob.tags:
        if tag[1] == 'NN' or tag[1] == 'NNS':
            answerList.append((index[0], tag[0]))

with open("out_answers.csv","w") as g:
    wr = csv.writer(g,delimiter=";")
    for value in answerList:
        wr.writerow(value)
