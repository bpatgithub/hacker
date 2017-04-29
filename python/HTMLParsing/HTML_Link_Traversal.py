import urllib
import re # regualr expressoin
from BeautifulSoup import *

def read_inputs():
    # This function reads input for the program.
    # example: http://python-data.dr-chuck.net/known_by_Erina.html
    url = raw_input("Enter URL: ") or "http://python-data.dr-chuck.net/known_by_Erina.html"
    # how many links to Traverse.
    numlinks = raw_input("Enter number of links to Traverse: ") or 7
    # what is the position of the link.
    linkpos = raw_input("Enter link position: ") or 19

    return url, numlinks, linkpos

def fread(url_input):
    # read file and beautify it.
    fhand = urllib.urlopen(url_input).read()

    fbeauty = BeautifulSoup(fhand)
    #print fbeauty
    return fbeauty

def link_traverse(b_obj, no_links, link_pos):

    new_url=''
    # Traverse the links in the doc.
    #print b_obj
    tags = b_obj('a')
    #print tags
    cnt = 0
    for tag in tags:
        if (cnt == int(link_pos)-2):
            new_url = tag.get('href', None)
            print "the tag is: ", new_url
        cnt += 1
    
    return new_url

# starting main logic.
# read inputs
(url_in, numlinks_in, linkpos_in) = read_inputs()


# read file and beautify it.
beauty_obj = fread(url_in)


# Traverse through the different links.
n = 0
while n < int(numlinks_in):
    print "url is and n=", url_in, n
    b_obj = fread(url_in)
    url_in = link_traverse(b_obj, numlinks_in, linkpos_in)
    n += 1
