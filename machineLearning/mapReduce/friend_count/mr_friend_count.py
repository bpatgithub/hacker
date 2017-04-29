'''
MapReduce algorithm to count the number of friends for each person.

Map Input

Each input record is a 2 element list [personA, personB] where personA is a
string representing the name of a person and personB is a string representing
the name of one of personA's friends. Note that it may or may not be the case
that the personA is a friend of personB.

author: bhavesh patel
'''
import mro_friend_count as mr
import sys
import json
# Part 1
# create map reduce object.
mro = mr.MapReduce()

# Part 2
# Mapper:  tokenizes each doc and emits key-value pair.
def mapper(record):
    # Emit order or line item.
    line = json.loads(record)
    mro.emit_intermediate(line[0], 1)


# Part 3
# Reducer:  Combines two records with same key in the dictionary.
def reducer(data):
    for key, value in data.items():
        cnt = 0
        for num in value:
            cnt += 1
        mro.emit((key, cnt))

# Part 4
# Load data and executes mr (map reduce).
inputdata = open(sys.argv[1])
mro.execute(inputdata, mapper, reducer)
