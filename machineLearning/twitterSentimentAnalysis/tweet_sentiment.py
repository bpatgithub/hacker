'''
Pass two files:
1.  Tweet data
2.  Sentiment word file (From: http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010)

We count sentiment based on sentinment score in the sentiment file for each tweet data.
author: bhavesh patel
'''
import sys
import json

def process_sentiment_file(fp):
    scores = {}
    for line in fp:
        term, value = line.split('\t')
        scores[term] = int(value)
    return scores

def get_sentinment_values(tf, scores):
    words = []
    sentiment_values = {}
    for line in tf:
        try: # throws codec error sometime, so let's try!
            tweet = json.loads(line.lower())
            tweet_text = tweet['text']
            words = tweet_text.split()
 	    #print("words are %s ") % words.encode('ascii', 'ignore')
 	    #print("words are %s ") % words
        except:
            continue
        sent_value = 0
        for word in words:
            #if word in scores:
	    #print("word is %s ") % word.encode('ascii', 'ignore')
	    #print("word is %s ") % word
            sentiment_values[word] = int(sentiment_values.get(word, 0)) + int(scores.get(word, 0))
            sent_value = sent_value + int(scores.get(word, 0))
        # we can print sentiment value for each tweet.
        print(sent_value)
    # now let's print sum all sentiment values of each word in all tweets- only non-zero values.
    for key, value in sentiment_values.items():
        if value != 0:
            print("%s %d") % (key, value)

def main():
    sentiment_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])
    scores = process_sentiment_file(sentiment_file)
    get_sentinment_values(tweet_file, scores)

if __name__ == '__main__':
    main()
