import re
import sqlite3


# read the data from the URL.
def read_data(FILE):
    fhand = open(FILE)
    #print data

    return fhand

# create table inside the database.
def db_ops():
    conn = sqlite3.connect('testdb.sqlite')
    cursor = conn.cursor()

    cursor.execute('DROP TABLE IF EXISTS Counts')

    cursor.execute('CREATE TABLE Counts (org TEXT, count integer)')

    return cursor, conn


#insert and update the database.
def get_domain(fhandle, cur):
    for line in fhandle:
        #print line
        if line.startswith('From: '):
            words = line.split()
            #print words[1]
            pos = words[1].find('@')
            domain = words[1][pos+1:]
            print domain

            update_db(domain, cur)

def update_db(domain, cur):
    cur.execute('SELECT count FROM Counts WHERE org = ?', (domain, ))
    try:
        count = cur.fetchone()[0]
        cur.execute('UPDATE Counts SET count = count + 1 WHERE org = ?', (domain,))
    except:
        cur.execute('INSERT INTO Counts (org, count) VALUES (?, 1)', (domain,))


# main() program.
FILE="mbox.txt"

file_hand = read_data(FILE)

cur, con = db_ops()

get_domain(file_hand, cur)

# now commit data.
con.commit()
