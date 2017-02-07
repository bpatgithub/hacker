import urllib
from BeautifulSoup import *

# reading all lines and using read() allows one big string, instead of reading each line.
fcontent = urllib.urlopen('http://python-data.dr-chuck.net/comments_309098.html').read()

# beautifulsoup formatted content
bcontent = BeautifulSoup(fcontent)

# now let's retrieve tags which starts with span as asked in exercise.


tags = bcontent('span')

# these tags are special but more like dictionary.
#print tags

counter = 0
total = 0
# we can go through tags to print different things.
for tag in tags:
   #print 'TAG:',tag
   #print 'class value:',tag.get('class', None)
   #print 'Contents:',tag.contents[0]
   #print 'Attrs:',tag.attrs
   counter += 1
   print counter
   total += int(tag.contents[0])
   print total

print "total tags are ", counter
print "sum of all values is ", total
