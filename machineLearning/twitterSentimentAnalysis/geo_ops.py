'''
Geopy allows to convert coordinates to locaiton.
That can be very handy to understand where tweet data are coming from.
Well, I tried to use on tweet data after Oscar 2017.
Out of total 13,180 tweet I had, only 178 had locaiton :(
Hence, this script works but not being used.

author: bhavesh patel
'''
import geopy
import json

geolocator = geopy.Nominatim()
location = geolocator.reverse("52.509669, 13.376294")
print(location.raw['address']['state'])
#data = json.loads(location.raw)
#print(data)
#print(data['address'])
