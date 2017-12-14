import csv
from lxml import html
import requests
r = requests.get('http://time.com/5015204/harvey-weinstein-scandal/')

tree = html.fromstring(r.content)
creeps1 = tree.xpath('//h2/text()')
creeps2 = (tree.xpath('//h2/*/text()'))

creeps3 = creeps1 + creeps2
creeps4 = []

for creep in creeps3:
    if creep == "Ford":
        creeps3.remove(creep)
for creep in creeps3:
    creeps4.append(creep.split(".", 1)[1])

print(creeps4)

f = open('out_creeps.csv', 'w') # w fyrir 'skrifa' ekki lesa

for creep in creeps4:
    f.write(creep + "\n")

f.close()
