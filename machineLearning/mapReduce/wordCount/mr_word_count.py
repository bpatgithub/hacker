'''
Count words using map reduce.

author: bhavesh patel
'''
import mro_word_count as mr
import sys
# Part 1
# create map reduce object.
mro = mr.MapReduce()

# Part 2
# Mapper:  tokenizes each doc and emits key-value pair.
def mapper(record):
    words = record.split()
    for w in words:
      mro.emit_intermediate(w, 1)

# Part 3
# Reducer:  Sums up the list of occurrence counts and emits a count for word.
def reducer(key, list_of_values):
    total = 0
    for v in list_of_values:
      total += v
    mro.emit((key, total))

# Part 4
# Load data and executes mr (map reduce).
inputdata = open(sys.argv[1])
mro.execute(inputdata, mapper, reducer)
