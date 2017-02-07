import json
import sqlite3

# connect to db
conn = sqlite3.connect('rosterdb.sqlite')
cur = conn.cursor()

def cr_schema():
    cur.executescript('''
    DROP TABLE IF EXISTS User;
    DROP TABLE IF EXISTS Member;
    DROP TABLE IF EXISTS Course;

    CREATE TABLE User(
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        name TEXT UNIQUE
    );

    CREATE TABLE Course(
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        title TEXT UNIQUE
    );

    CREATE TABLE Member(
        user_id INTEGER,
        course_id INTEGER,
        role INTEGER,
        PRIMARY KEY (user_id, course_id)
    );

    ''')

def read_json():
    fname = raw_input('Enter file name: ') or "roster_data.json"

    str_data = open(fname).read()
    json_data = json.loads(str_data)

    return json_data

    #print json_data

def insert_data(j_data):
    for entry in j_data:
        name = entry[0]
        title = entry[1]
        role = entry[2]

        print name, title, role

        cur.execute('''INSERT OR IGNORE INTO User (name) values (?)''', (name,))
        cur.execute('''SELECT id FROM User WHERE name = ?''', (name,))
        user_id=cur.fetchone()[0]
        print "user id is ", user_id

        cur.execute('''INSERT OR IGNORE INTO Course (title) values (?)''', (title,))
        cur.execute('''SELECT id FROM Course WHERE title = ?''', (title,))
        title_id=cur.fetchone()[0]
        print "title id is ", title_id

        cur.execute('''INSERT OR IGNORE INTO Member (user_id, course_id, role)
            values (?, ?, ?)''', (user_id, title_id, role))




# create db schema.
cr_schema()

# read json file
j_data=read_json()

# insert data into db.
insert_data(j_data)
# commit daa.
conn.commit()
