import numpy as np

def read_data():
    tsfile = raw_input("Enter Tablo Script File Name: ") or "ts.csv"
    pwfile = raw_input("Enter PHI Web File Name: ") or "web.csv"

    # Numpy array
    tsdata = np.genfromtxt(tsfile, dtype=None, delimiter=',', names=True)
    pwdata = np.genfromtxt(pwfile, dtype=None, delimiter=',', names=True)

    tsdata.sort(order=['sequence'])
    pwdata.sort(order=['sequence'])

    tssize = len(tsdata)
    pwsize = len(pwdata)

    if tssize > pwsize:
        max_raws=tssize
    else:
        max_raws=pwsize

    return (tsdata, pwdata, max_raws)

#print "sequence is ", tsdata['sequence'], pwdata['sequence']

(tsdata, pwdata, max_raws) = read_data()


tsseq = []
for data in tsdata:
    #print data
    tsseq.append(data[1])
    cols = len(data)
print "ts seq", tsseq
print "total cols are ", cols

pwseq = []
for data in pwdata:
    #print data
    pwseq.append(data[1])
print "pw seq", pwseq

# let's get unique data from each list.
uniqpw = filter(lambda x: x not in tsseq, pwseq)
print "TabloScript is missing these seuqneces ", uniqpw

uniqts = filter(lambda x: x not in pwseq, tsseq)
print "PHI web is missing these seuqneces ", uniqts


print "####  Missing records ####"
for i in uniqpw:
    print "Missing in TS", pwdata[pwdata['sequence']==i]

for i in uniqts:
    print "Missing in PHI", tsdata[tsdata['sequence']==i]

n=1
c=1
while n <= max_raws:
    if n in uniqts or n in uniqpw:
        n+=1
        continue
    else:
        tsrow = tsdata[tsdata['sequence']==n]
        pwrow = pwdata[pwdata['sequence']==n]
        print "*****Field mismatch for seq no ", n
        for x in range(cols):
            #print "ts value are ", tsrow[0][i]
            if tsrow[0][x] != pwrow[0][x]:
                print "TS : PHI ", tsrow[0][x], " : ", pwrow[0][x]
    n+=1
