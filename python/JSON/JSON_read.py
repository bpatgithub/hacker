import json
import urllib

url = raw_input('Enter url : ') or 'http://python-data.dr-chuck.net/comments_309099.json'
uhead = urllib.urlopen(url)
data = uhead.read()

js = json.loads(data)
print json.dumps(js, indent=4)


cmt_dict = js["comments"]
print cmt_dict

cnt = 0
total = 0
for item in cmt_dict:
    print item['count']
    cnt += 1
    total += item['count']

print "item count is", cnt
print "total is ", total
