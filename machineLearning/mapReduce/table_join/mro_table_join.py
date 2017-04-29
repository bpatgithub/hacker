'''
Map Reduce object for table join.

author: bhavesh patel
'''
import json

class MapReduce:
    def __init__(self):
        self.orders = {}
        self.li = {}
        self.result = {}

    def emit_intermediate_order(self, key, value):
        #self.intermediate[key]= value
        self.orders.setdefault(key,[])
        self.orders[key].append(value)

    def emit_intermediate_li(self, key, value):
        #self.intermediate[key]= value
        self.li.setdefault(key,[])
        self.li[key].append(value)


    def execute(self, data, mapper, reducer):
        for line in data:
            mapper(line)

        #print("orders are " + str(self.orders))
        #print("li are " + str(self.li))

        reducer(self.orders, self.li)

        for key, value in self.result.items():
            res = []
            res.append(key)
            res.append(value)
            print(res)
