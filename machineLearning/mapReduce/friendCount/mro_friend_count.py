'''
Map Reduce object for table join.

author: bhavesh patel
'''
import json

class MapReduce:
    def __init__(self):
        self.intermediate = {}
        self.result = []

    def emit_intermediate(self, key, value):
        #self.intermediate[key]= value
        self.intermediate.setdefault(key,[])
        self.intermediate[key].append(value)

    def emit(self, value):
        self.result.append(value)

    def execute(self, data, mapper, reducer):
        for line in data:
            mapper(line)

        reducer(self.intermediate)

        jenc = json.JSONEncoder()
        for item in self.result:
            print(jenc.encode(item))
