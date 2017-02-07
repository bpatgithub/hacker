import urllib
import xml.etree.ElementTree as ET

serviceurl = 'http://python-data.dr-chuck.net/comments_309095.xml'

uhand = urllib.urlopen(serviceurl)
data = uhand.read()

#print "data is ", data
xtree = ET.fromstring(data)

# now lets' find all count elements from this XML.
counts = xtree.findall('.//count')

total = 0
cnt = 0
for count in counts:
    total += int(count.text)
    cnt += 1

print "total is", total
print "total elements are ", cnt
