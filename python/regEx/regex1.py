import re

fhandle = open("reg_ex_file.data")

mylist = list()
total = 0

for line in fhandle:
    line = line.strip()
    #print line
    numlist = re.findall('[0-9]+', line)
    #print numlist
    if len(numlist) > 0:
        for num in numlist:
            #print num
            total = total + int(num)
        #mylist.append(numlist)

print total
