import sqlite3
import xml.etree.ElementTree as ET


# Read XML file.
def read_xml():
    file = raw_input("What's the file name") or "./tracks/Library.xml"

    data = ET.parse(file)

    # this xml data file has 3 level of dict tag.
    stuff = data.findall('dict/dict/dict')

    print "total entries are ", len(stuff)

    return stuff

# read two tag data like <key>Year</key><integer>1979</integer>
def read_tag_val(data, tag):
    found = False
    for stuff in data:
        if found : return stuff.text
        if stuff.tag == 'key' and stuff.text == tag:
            found = True
    return None

# enter data in db.
def enter_data_in_db(xml_data, db_cur):
    for entry in xml_data:
        # get the second tag value.
        trackid = read_tag_val(entry, 'Track ID')
        print "track id is ", trackid
        trackname = read_tag_val(entry, 'Name')
        print "track name is ", trackname
        artistname = read_tag_val(entry, 'Artist')
        print "artist is ", artistname
        album = read_tag_val(entry, 'Album')
        print "album is ", album
        genre = read_tag_val(entry, 'Genre')
        print "Genre is ", genre
        timelength = read_tag_val(entry, 'Total Time')
        print "timelength is ", timelength
        rating = read_tag_val(entry, 'Rating')
        print "rating is ", rating
        trackid = read_tag_val(entry, 'Track ID')
        print "track id is ", trackid
        playcount = read_tag_val(entry, 'Play Count')
        print "play count is ", playcount

        if trackname is None or artistname is None or album is None or genre is None: continue

        db_cur.execute('''
        INSERT OR IGNORE INTO Artist (name)
        VALUES (?)''',(artistname,))

        db_cur.execute('SELECT id from Artist WHERE name = ?', (artistname,))
        artist_id = db_cur.fetchone()[0]

        db_cur.execute('''
        INSERT OR IGNORE INTO Album (title, artist_id)
        VALUES (?, ?)''',(album,artist_id))

        db_cur.execute('SELECT id from Album WHERE title = ?', (album,))
        album_id = db_cur.fetchone()[0]
        print "album is ", album_id

        db_cur.execute('''
        INSERT OR IGNORE INTO Genre (name)
        VALUES (?)''', (genre,))

        db_cur.execute('SELECT id from Genre WHERE name = ?', (genre,))
        genre_id = db_cur.fetchone()[0]
        print "genre id is ", genre_id

        db_cur.execute('''
        INSERT OR IGNORE INTO Track (title, album_id, genre_id, len)
        VALUES (?, ?, ?, ?)''', (trackname, album_id, genre_id, timelength))


# Create schema.
def create_schema():
    conn = sqlite3.connect('testdb.sqlite')
    cur = conn.cursor()

    # let's drop all the tables.
    cur.execute('DROP TABLE Artist')
    cur.execute('DROP TABLE Genre')
    cur.execute('DROP TABLE Album')
    cur.execute('DROP TABLE Track')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Artist (
        id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        name    TEXT UNIQUE
        )
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Genre (
        id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        name    TEXT UNIQUE
        )
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Album (
        id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        artist_id  INTEGER,
        title   TEXT UNIQUE
        )
    ''')

    cur.execute('''
        CREATE TABLE IF NOT EXISTS Track (
        id  INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
        title TEXT  UNIQUE,
        album_id  INTEGER,
        genre_id  INTEGER,
        len INTEGER, rating INTEGER, count INTEGER
        )
    ''')

    return cur, conn

cursor, connection = create_schema()

data = read_xml()

enter_data_in_db(data, cursor)

# commit data.
connection.commit()
