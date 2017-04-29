# Project Title
Hacking with simple Google GeoData API.

JSON_google_georead.py

This program takes name of town, e.g. Stanford.  It will fetch GeoData using Google API and display details of the locaiton.



## Getting Started

Install python2.x, preferably 2.7.

### Testing JSON_google_georead.py

**Sample Input**
Stanford

**Sample Output**
(python2) Bhaveshs-MacBook-Air:googleAPI admin$ python JSON_google_georead.py
Enter location: Stanford
http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=Stanford
{
    "status": "OK",
    "results": [
        {
            "geometry": {
                "location": {
                    "lat": 37.4274745,
                    "lng": -122.169719
                },
                "viewport": {
                    "northeast": {
                        "lat": 37.42882348029149,
                        "lng": -122.1683700197085
                    },
                    "southwest": {
                        "lat": 37.42612551970849,
                        "lng": -122.1710679802915
                    }
                },
                "location_type": "APPROXIMATE"
            },
            "address_components": [
                {
                    "long_name": "450",
                    "types": [
                        "street_number"
                    ],
                    "short_name": "450"
                },
                {
                    "long_name": "Serra Mall",
                    "types": [
                        "route"
                    ],
                    "short_name": "Serra Mall"
                },
                {
                    "long_name": "Stanford",
                    "types": [
                        "locality",
                        "political"
                    ],
                    "short_name": "Stanford"
                },
                {
                    "long_name": "California",
                    "types": [
                        "administrative_area_level_1",
                        "political"
                    ],
                    "short_name": "CA"
                },
                {
                    "long_name": "United States",
                    "types": [
                        "country",
                        "political"
                    ],
                    "short_name": "US"
                },
                {
                    "long_name": "94305",
                    "types": [
                        "postal_code"
                    ],
                    "short_name": "94305"
                }
            ],
            "place_id": "ChIJneqLZyq7j4ARf2j8RBrwzSk",
            "formatted_address": "450 Serra Mall, Stanford, CA 94305, USA",
            "types": [
                "establishment",
                "locality",
                "point_of_interest",
                "political",
                "university"
            ]
        }
    ]
}

ChIJneqLZyq7j4ARf2j8RBrwzSk

### Testing XML_read_google_map.py

**Sample Input**
Stanford

**Sample Output**
(python2) Bhaveshs-MacBook-Air:googleAPI admin$ python XML_read_google_map.py
Please enter an address: Stanford
Getting data for from google for  http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=Stanford
lat and lng are  37.4274745 -122.1697190
formatted adddress is  450 Serra Mall, Stanford, CA 94305, USA

## Authors

* **Bhavesh Patel**

## License

## Acknowledgments

Dr. Chuck, University of Michigan
