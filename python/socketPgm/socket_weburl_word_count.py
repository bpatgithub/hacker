

import urllib
import json

#fhand = urllib.urlopen('http://www.politico.com/story/2016/07/full-transcript-donald-trump-nomination-acceptance-speech-at-rnc-225974')

#fhand = urllib.urlopen('http://www.py4inf.com/code/romeo.txt')

fhand = urllib.urlopen('https://www.washingtonpost.com/news/the-fix/wp/2016/09/26/the-first-trump-clinton-presidential-debate-transcript-annotated')
word_total = 0

counts = dict()
for line in fhand:
    #print line.strip()
    words = line.split()
    word_total += len(words)
    for word in words:
        counts[word] = counts.get(word,0) + 1

prt_sort =  sorted(counts.items(), key=lambda x: x[1])

print(json.dumps(prt_sort, indent = 4))

print "total words are ", word_total
#print counts
