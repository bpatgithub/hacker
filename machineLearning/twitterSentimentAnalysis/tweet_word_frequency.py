'''
Let's count frequency of each word for all tweets.
author: bhavesh patel
'''
import sys
import json

def get_sentinment_values(tf):
    word_count = 0
    words = []
    word_frequency = {}
    for line in tf:
        try: # throws codec error sometime, so let's try!
            tweet = json.loads(line.lower())
            tweet_text = tweet['text']
            words = tweet_text.split()
        except:
            continue
        for word in words:
            # count frequency
            word_frequency[word] = int(word_frequency.get(word,0)) + 1
	    word_count += 1

    print("value of word_count is %d ") % word_count
    # now let's print word frequencye - non zero values.
    for key, value in word_frequency.items():
        if value != 0:
            # I was getting print error.  So using encoding to print on terminal.
            print("word %s count is %d") % (key.encode('ascii', 'ignore'), value)
            print("word %s pct count is %.10f") % (key.encode('ascii', 'ignore'), (value/float(word_count)))

def main():
    tweet_file = open(sys.argv[1])
    get_sentinment_values(tweet_file)

if __name__ == '__main__':
    main()
