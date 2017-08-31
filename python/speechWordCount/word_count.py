import urllib
import json
import matplotlib.pyplot as plt
#from wordcloud import WordCloud

file = input('Enter text file name: ')
fhand = open(file)
word_total = 0

counts = dict()
for line in fhand:
    #print line.strip()
    words = line.split()
    word_total += len(words)
    for word in words:
        word = word.lower()
        counts[word] = counts.get(word,0) + 1

prt_sort =  sorted(counts.items(), key=lambda x: x[1])

print(json.dumps(prt_sort, indent = 4))

print(word_total)
print(counts)

