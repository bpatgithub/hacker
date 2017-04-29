'''
Let's count frequency of hastags among all hastags.
author: bhavesh patel
'''
import sys
import json

def get_hastags_info(tf):
    hash_count = 0
    hash_frequency = {}
    for line in tf:
        try: # throws codec error sometime, so let's try!
            tweet = json.loads(line.lower())
            hashtags = tweet['entities']['hashtags']
            for ht in hashtags:
                ht_text = ht['text']
                hash_frequency[ht_text] = int(hash_frequency.get(ht_text,0)) + 1
                hash_count += 1
        except:
            continue
        continue

    # now let's print word frequencye - non zero values.
    for key, value in hash_frequency.items():
        if value != 0:
            # I was getting print error.  So using encoding to print on terminal.
            print("hash %s count is %d") % (key.encode('ascii', 'ignore'), value)
            print("hash %s pct count is %.10f") % (key.encode('ascii', 'ignore'), (value/float(hash_count)))

def main():
    tweet_file = open(sys.argv[1])
    get_hastags_info(tweet_file)

if __name__ == '__main__':
    main()
