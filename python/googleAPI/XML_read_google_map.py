import urllib
import xml.etree.ElementTree as ET

serviceurl = 'http://maps.googleapis.com/maps/api/geocode/xml?'

while True:
    address = raw_input('Please enter an address: ') or "1830 Bering Drive, San Jose, CA, 95112"
    if len(address) < 1: break

    url = serviceurl + urllib.urlencode({'sensor':'false', 'address':address})
    print "Getting data for from google for ", url

    uhand = urllib.urlopen(url)
    data = uhand.read()

    xtree = ET.fromstring(data)

    # in googe response result is the parent element in xml tree.
    result = xtree.findall('result')

    lat = result[0].find('geometry').find('location').find('lat').text
    lng = result[0].find('geometry').find('location').find('lng').text

    location = result[0].find('formatted_address').text

    print "lat and lng are ", lat, lng
    print "formatted adddress is ", location
