import re

fhandle = open("ft.txt")

mylist = list()
total = 0
clnt = ""
trump = ""

# files.
clnt_file = open("clinton_transcript.txt", 'w')
trump_file = open("trump_transcript.txt", 'w')
#data = fhandle.read()

#print data
for line in fhandle:
    lstrip = line.strip()

    words = lstrip.split()

    if len(words) > 0:

        if words[0] == "CLINTON:" or words[0] == "HOLT:" or words[0] == "TRUMP:":
            candidate = words[0]
            print "first word is ", words[0]

        if words[0] == "CLINTON:":
            clnt = clnt + line
            clnt_file.write(lstrip)

        if words[0] == "TRUMP:":
            trump = trump + line
            trump_file.write(lstrip)

print "CLINTON#######"
print clnt

print "TRUMP #######"
print trump

clnt_file.close()
trump_file.close()

    #print "line is ", line
    #clinton = re.findall('CLINTON*?HOLT', line)
    #print clinton
    #print line
    #numlist = re.findall('[0-9]+', line)
    #print numlist
    #if len(numlist) > 0:
    #    for num in numlist:
    #        #print num
    #        total = total + int(num)
    #    #mylist.append(numlist)
