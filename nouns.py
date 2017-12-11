import pandas as pd
from textblob import TextBlob as tb


data = pd.read_csv("jeopardy_first_1000.csv", engine='python', encoding="utf8")
pd.set_option('display.max_colwidth', 4000) # til að birta alla spurninguna
pd.set_option('display.max_rows', 250000) # til að birta allar línur en ekki bara fyrstu og síðustu

#print(data.head(250000).loc[:, ['Question']])
#print(data.loc[:, ['Category']])

blob = tb(str(data.head(250000).loc[:, ['Question']]))

#blob = tb(str(data.head(250000).loc[:, ['Answer']]))
#print(blob)
#print(blob.noun_phrases)


f = open('noun_list.csv', 'w')
#print(blob.noun_phrases)
for word in blob.noun_phrases:
#    f.write(word + "\n")
#þetta er ekki að skila því sem ég vil, en set þetta hér til að það sé eitthvað í gangi :)
    print(word + " - " + str(blob.word_counts[word]))
f.close()
