'''
Create an Inverted index.
Given a set of documents, an inverted index is a dictionary where each word is associated with a list of
the document identifiers in which that word appears.

The input is a 2-element list: [document_id, text]
The output should be a (word, document ID list) tuple

author: bhavesh patel
'''
import mro_book_reference as mr
import sys
import json
# Part 1
# create map reduce object.
mro = mr.MapReduce()

# Part 2
# Mapper:  tokenizes each doc and emits key-value pair.
def mapper(record):
    book_name = record[0]
    book_content = record[1]
    for w in book_content.split():
        # emit_intermediate blindly append and we will have lots of duplicates.
        # for example, word "the" appeared 5 times, then we will have "the" as key with 5 values
        # repeating same book name value.  We will reduce it in reducer function.
        mro.emit_intermediate(w,book_name)

# Part 3
# Reducer:  Sums up the list of occurrence counts and emits a count for word.
def reducer(data):
    red_data = {}
    for key, value in data.items():  # too many values so use .itmes()
        #print("key is " + key + " value is " + str(value))
        val = set(value)  # remove duplicates using set function as set can have only unique values.
        red_data[key] = list(val)
    mro.emit(red_data)

# Part 4
# Load data and executes mr (map reduce).
inputdata = open(sys.argv[1])
mro.execute(inputdata, mapper, reducer)
