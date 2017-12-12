from textblob import TextBlob
from dependencies import test2

print(test2.testing)

mystring = "Hello dark, my old friend, hello is it me your look for, my, my, my friend, mother, was in get home. home is where the heart is"

blob = TextBlob(mystring)
print('Blob: ', mystring)

word = 'darkness'
print('Count of ', word, ': ', blob.words.count(word))
#print('Count of ', word, ': ', blob.noun_phrases.count(word))

bloblist = blob.split()
striplist = [x.strip(',') for x in bloblist]

print('striplist: ', striplist)

mostcommonword = ''
wordcount = 0

for w in striplist:
	print(w, '\t', blob.words.count(w))
	if blob.words.count(w) > wordcount
	mostcommonword = w

print('mostcommonword: ', mostcommonword)

nounlist = blob.noun_phrases
print('nounlist: ', nounlist)

