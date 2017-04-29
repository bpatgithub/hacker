'''
Read real time twit data.
Analyze sentiment.
'''

import oauth2
import urllib2 as urllib
import __private_bp_twtr_hidden as btwit

_debug = 0

http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

def twitterreq(url, method, parameters):

    http_method = method
    secrets = btwit.oauth()
    #print secrets
    consumer = oauth2.Consumer(secrets['consumer_key'], secrets['consumer_secret'])
    token = oauth2.Token(secrets['token_key'],secrets['token_secret'])

    oauth_request = oauth2.Request.from_consumer_and_token(consumer,
            token=token, http_method=http_method, http_url=url, parameters=parameters)
    oauth_request.sign_request(oauth2.SignatureMethod_HMAC_SHA1(), consumer, token)

    headers = oauth_request.to_header()

    if http_method == "POST":
        encoded_post_data = req.to_postdata()
    else:
        encoded_post_data = None
        url = oauth_request.to_url()

    opener = urllib.OpenerDirector()
    opener.add_handler(http_handler)
    opener.add_handler(https_handler)

    response = opener.open(url, encoded_post_data)

    return response

def twit_data():
    # Twitter api refeerence has details on rest api, streaming api etc.
    #https://dev.twitter.com/docs
    # we can use search api too.  Somehow it was giving me only one result.  more hacking required.
    #url="https://api.twitter.com/1.1/search/tweets.json?q=trump&src=typd"
    # if we want to use live streaming twitter data, here is the url.
    # Long/Lat for San Francisco and New York City:  -122.75,36.8,-121.75,37.8,-74,40,-73,41
    #url = "https://stream.twitter.com/1.1/statuses/sample.json?language=en&location=-122.75,36.8,-121.75,37.8,-74,40,-73,41"
    url = "https://stream.twitter.com/1.1/statuses/sample.json?language=en"

    parameters = []

    response = twitterreq(url, "GET", parameters)
    for line in response:
        print line.strip()

if __name__ == '__main__':
    twit_data()
