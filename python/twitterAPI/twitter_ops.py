import urllib
import twitter_auth as ta
import json

TWITTER_URL = 'https://api.twitter.com/1.1/friends/list.json'

while True:
    acct = raw_input("Enter twitter account :")
    if (len(acct) < 1): break
    url = ta.auth_aug(TWITTER_URL, {'screen_name': acct, 'count': '10'})
    uhand = urllib.urlopen(url)
    data = uhand.read()
    headers = uhand.info().dict

    js = json.loads(data)
    #print json.dumps(js, indent=4)

    for item in js['users']:
        print "user ", item['screen_name'], "twitted about "
        print item['status']['text']
        print "on ", item['created_at']
