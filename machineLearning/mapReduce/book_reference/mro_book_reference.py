'''
Map Reduce object for book reference.

author: bhavesh patel
'''
import json

class MapReduce:
    def __init__(self):
        self.intermediate = {}
        self.result = {}

    def emit_intermediate(self, key, value):
        self.intermediate.setdefault(key, [])
        self.intermediate[key].append(value)

    def emit(self, data):
        self.result = data

    def execute(self, data, mapper, reducer):
        extra_char_tab = str.maketrans("./?!;", "     ")
        for line in data:
            line = line.translate(extra_char_tab)
            jdata = json.loads(line.lower())
            mapper(jdata)

        reducer(self.intermediate)

        print(type(self.result))
        for key, value in self.result.items():
            res = []
            res.append(key)
            res.append(value)
            print(res)
