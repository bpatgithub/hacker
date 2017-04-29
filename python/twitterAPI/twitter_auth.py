import urllib
import oauth2
import __private_bp_twtr_hidden as btwit

def auth_aug(url, parameters):
    secrets = btwit.oauth()
    #print secrets
    consumer = oauth2.Consumer(secrets['consumer_key'], secrets['consumer_secret'])
    token = oauth2.Token(secrets['token_key'],secrets['token_secret'])

    oauth_request = oauth2.Request.from_consumer_and_token(consumer,
            token=token, http_method='GET', http_url=url, parameters=parameters)
    oauth_request.sign_request(oauth2.SignatureMethod_HMAC_SHA1(), consumer, token)
    return oauth_request.to_url()


def test_twtr_auth():
    print "calling twitter "
    url = auth_aug('https://api.twitter.com/1.1/statuses/user_timeline.json',
        {'screen_name': 'bpateltwit', 'count': '2'} )
    #print "url is ", url

    twt_connection = urllib.urlopen(url)
    data = twt_connection.read()
    #print data
    #print '#####'
    headers = twt_connection.info().dict
    #print headers

test_twtr_auth()
