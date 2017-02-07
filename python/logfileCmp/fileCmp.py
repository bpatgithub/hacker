import numpy as np

tsfile = raw_input("Enter Tablo Script File Name: ") or "ts.csv"
pwfile = raw_input("Enter PHI Web File Name: ") or "web.csv"

def get_line_col_counts(tsfile, pwfile):

    tslines = sum(1 for line in open(tsfile))
    pwlines = sum(1 for line in open(pwfile))

    fh = open(tsfile)

    for line in open(tsfile):
        cols=len(line.split(','))
        break

    print "cols are", cols


    # fine higher line.
    print "number of lines in Tablo Script is ", tslines
    print "number of lines in PHI Web is ", pwlines

    return(cols, tslines, pwlines)

def sorted_data(tsfile, pwfile):
    with open(tsfile) as t:
        next(t)
        tslines = [line.split(',') for line in t]
    #print "ts lines are ", tslines

    with open(pwfile) as p:
        next(p)
        pwlines = [line.split(',') for line in p]

    #print "pw lines are ", pwlines

    #tslines.sort(int(key=itemgetter(2)))
    #pwlines.sort(int(key=itemgetter(2)))

    tslines_s = sorted(tslines, key=lambda data_entry: int(tslines[1]))
    pslines_s = sorted(pslines, key=lambda data_entry: int(pslines[1]))


    return(tslines, pwlines)

def get_diff(tslines_n, pwlines_n, cols, tslines_s, pwlines_s):

    ln = 0
    while (ln < tslines_n):
        print "ts line seq ", tslines_s[ln][1]
        ln += 1




(cols, tslines_n, pwlines_n) = get_line_col_counts(tsfile, pwfile)

(tslines_s, pwlines_s) = sorted_data(tsfile, pwfile)

print "ts lines are ", tslines_s

get_diff(tslines_n, pwlines_n, cols, tslines_s, pwlines_s)
