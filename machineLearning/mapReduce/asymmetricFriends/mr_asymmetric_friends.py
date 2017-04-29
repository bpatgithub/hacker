'''
Find all Asymmetric relationship in a friend circle.
The relationship "friend" is often symmetric, meaning that if I am your friend,
you are my friend. MapReduce algorithm to check whether this property
holds. It will generate a list of all non-symmetric friend relationships.

Map Input
Each input record is a 2 element list [personA, personB] where personA is a
string representing the name of a person and personB is a string representing
the name of one of personA's friends. Note that it may or may not be the case
that the personA is a friend of personB.

Reduce Output
The output should be all pairs (friend, person) such that (person, friend)
appears in the dataset but (friend, person) does not.

author: bhavesh patel
'''
import mro_asymmetric_friends as mr
import sys
import json
# Part 1
# create map reduce object.
mro = mr.MapReduce()

# Part 2
# Mapper:  tokenizes each doc and emits key-value pair.
def mapper(record):
    mro.emit_intermediate(record[0], record[1])

# Part 3
# Reducer:  Sums up the list of occurrence counts and emits a count for word.
def reducer(key, list_of_values):
    # first let's create list of all names.
    list = []
    opp_friend_list = None

    for friend in list_of_values:
        #if my friend has a list, check to see if I am in his friend list.
        flist = mro.intermediate.get(friend, None)
        if flist == None:  # My friend has no friends!
            mro.emit([friend, key])
            mro.emit([key, friend])
        else: # my friend has friends.
            # Am I in his list?
            if key not in flist:
                mro.emit([friend,key])
                mro.emit([key, friend])

# Part 4
# Load data and executes mr (map reduce).
inputdata = open(sys.argv[1])
mro.execute(inputdata, mapper, reducer)
