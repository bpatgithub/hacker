import json
import urllib

location = raw_input("Enter location: ") or "Gauhati University"

service_url="http://maps.googleapis.com/maps/api/geocode/json?"
url = service_url + urllib.urlencode({'sensor':'false', 'address':location})

print url
uhand = urllib.urlopen(url)
data = uhand.read()

jsdata = json.loads(data)
print json.dumps(jsdata, indent=4)
print '####'
print jsdata["results"][0]["place_id"]
