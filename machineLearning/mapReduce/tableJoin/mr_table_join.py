'''
Join two tables using MapReduce.

SELECT *
FROM Orders, LineItem
WHERE Order.order_id = LineItem.order_id

Each input record is a list of strings representing a tuple in the database.
Each list element corresponds to a different attribute of the table

The first item (index 0) in each record is a string that identifies the table the record originates from.
This field has two possible values:

"line_item" indicates that the record is a line item.
"order" indicates that the record is an order.
The second element (index 1) in each record is the order_id.

LineItem records have 17 attributes including the identifier string.
Order records have 10 elements including the identifier string.

author: bhavesh patel
'''
import mro_table_join as mr
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
    if line[0] == 'order':
        mro.emit_intermediate_order(line[1], line)
    else:
        mro.emit_intermediate_li(line[1], line)


# Part 3
# Reducer:  Combines two records with same key in the dictionary.
def reducer(orders, li):
    for likey, livalue in li.items():
        for okey, ovalue in orders.items():
            if likey == okey:
                # let's iteraet through all records in line item.
                for rec in livalue:
                    #print(ovalue[0]) #[0] to get first and only record.
                    joint_rec = ovalue[0]+rec
                    print(str(joint_rec))
                    joint_rec = []

# Part 4
# Load data and executes mr (map reduce).
inputdata = open(sys.argv[1])
mro.execute(inputdata, mapper, reducer)
