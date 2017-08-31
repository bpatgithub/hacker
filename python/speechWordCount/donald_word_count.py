import urllib
import json
import matplotlib.pyplot as plt
#from wordcloud import WordCloud

fhand = open("trump_clean_transcript.txt")
'''
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

print "total words are ", word_total
#print counts
'''

data = fhand.read()

'''
wcData = WordCloud().generate(data)

#create word cloud.
# Display the generated image:
# the matplotlib way:

plt.imshow(wcData)
plt.axis("off")
plt.show()
# take relative word frequencies into account, lower max_font_size
#wcData = WordCloud(background_color="white", max_words=50, max_font_size=40, random_state=42)
wcData = WordCloud(max_font_size=40, relative_scaling=.5, max_words=100, random_state=3).generate(data)
plt.figure()
plt.imshow(wcData)
plt.axis("off")
plt.show()
'''
