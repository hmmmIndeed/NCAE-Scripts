# NCAE Web

## Installing PostgreSQL

1. Upgrade packages and install PostgreSQL package

```
sudo apt upgrade && sudo apt install postgresql -y
```

2. Start/enable PostgreSQL and login as the newly made postgres (`-i` is the same as `--login` and `-u user` specifies the user). Then, start the PostgreSQL command prompt.
(This newly made user is automatically a PostgreSQL admin user.)

```
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo -iu postgres psql
```

3. Create a database called `flask_db`

```
CREATE DATABASE flask_db;
```

4. Create database user `asulk` (or whatever name) for this project (replace `password` with a decent password) and grant them all privileges

```
CREATE USER asulk WITH PASSWORD 'password';
GRANT ALL PRIVILEGES ON DATABASE flask_db TO asulk;
```

5. Ensure the database was created with `\l` and quit psql with `\q`. Also, use `exit` to return back to the previous user.

## Installing Flask (and psycopg2)

1. Upgrade packages and install anything related to python that's needed to setup Flask

```
sudo apt update && sudo apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools python3-venv -y
```

2. Create and move to a new directory for the python project

```
mkdir ~/myproject
cd ~/myproject
```

3. Create a virtual environment named `website` (or whatever name) to store the Flask project’s Python requirements and then activate it

```
python3 -m venv website
source website/bin/activate
```

4. Use pip to install flask and psycopg2-binary

```
pip install flask psycopg2-binary
```

## Setting up Flask

1. Create a file to initialize the database

```
nano ~/myproject/init_db.py
```

Add this example to `init_db.py`

```py
import os
import psycopg2

conn = psycopg2.connect(
        host="localhost",
        database="flask_db",
        user=os.environ['DB_USERNAME'],
        password=os.environ['DB_PASSWORD'])

# Open a cursor to perform database operations
cur = conn.cursor()

# Execute a command: this creates a new table
cur.execute('DROP TABLE IF EXISTS books;')
cur.execute('CREATE TABLE books (id serial PRIMARY KEY,'
                                 'title varchar (150) NOT NULL,'
                                 'author varchar (50) NOT NULL,'
                                 'pages_num integer NOT NULL,'
                                 'review text,'
                                 'date_added date DEFAULT CURRENT_TIMESTAMP);'
                                 )

# Insert data into the table

cur.execute('INSERT INTO books (title, author, pages_num, review)'
            'VALUES (%s, %s, %s, %s)',
            ('A Tale of Two Cities',
             'Charles Dickens',
             489,
             'A great classic!')
            )


cur.execute('INSERT INTO books (title, author, pages_num, review)'
            'VALUES (%s, %s, %s, %s)',
            ('Anna Karenina',
             'Leo Tolstoy',
             864,
             'Another great classic!')
            )

conn.commit()

cur.close()
conn.close()
```




## Sources

# PostgreSQL installation and setup

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-22-04 (just Step 1 but don't install postgresql-contrib)

https://www.digitalocean.com/community/tutorials/how-to-use-a-postgresql-database-in-a-flask-application (just Step 1)

# Flask installation and setup

https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-22-04 (just Steps 1 & 2)

https://www.digitalocean.com/community/tutorials/how-to-use-a-postgresql-database-in-a-flask-application (now Step 2)


