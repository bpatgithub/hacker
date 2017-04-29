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
        extra_char_tab = str.maketrans("./,?!", "     ")
        for line in data:
            line = line.translate(extra_char_tab)
            line = line.strip()
            mapper(line.lower())

        for key in self.intermediate:
            reducer(key, self.intermediate[key])

        jenc = json.JSONEncoder()
        for item in self.result:
            print(jenc.encode(item))
