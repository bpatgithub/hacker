'''
Map Reduce object.

author: bhavesh patel
'''
import json

class MapReduce:
    def __init__(self):
        self.intermediate = {}
        self.result = []

    def emit_intermediate(self, key, value):
        self.intermediate.setdefault(key, [])
        self.intermediate[key].append(value)

    def emit(self, value):
        self.result.append(value)

    def execute(self, data, mapper, reducer):
        for line in data:
            pair = json.loads(line)
            mapper(pair)

        #print("inter value is " + str(self.intermediate))

        for key in self.intermediate:
            reducer(key, self.intermediate[key])

        jenc = json.JSONEncoder()
        for item in self.result:
            print(jenc.encode(item))
