# NCAE Web

## Installing PostgreSQL

1. Upgrade packages and install PostgreSQL package and pip

```
sudo apt upgrade && sudo apt install postgresql python3-pip -y
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

## Installing Flask and psycopg2

