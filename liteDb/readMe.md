# LiteDB - A terminal-based Lightweight Database Management System
LiteDB is a minified yet powerful terminal-based database management system (DBMS) written in Ruby. It's designed to handle SQL queries for database operations with both case-insensitive and case-sensitive support. This lightweight DBMS uses CSV files as its storage backend, making it easy to work with and perfect for small to medium-sized projects.

## Features
- **SQL Query Support:** LiteDB supports essential SQL query commands like SELECT, INSERT, UPDATE, and DELETE.

- **Case Insensitivity:** You can use SQL queries in either uppercase or lowercase letters, making it user-friendly and flexible.

- **CSV-Based Storage:** LiteDB stores data in CSV files, making it easy to work with and suitable for small-scale projects.

- **Powerful Query Engine:** Utilizes regular expressions, hash manipulation, loops, block arguments, and merge sort algorithms for efficient query processing.

## Installation
LiteDB requires Ruby to be installed on your system. You can install it using the following steps:

1. Clone this repository to your local machine:
   
```
git clone https://github.com/yourusername/LiteDB.git

cd liteDb
```

## Usage

1. On the terminal, run:
   
```
ruby my_sqlite_cli.rb  
```
2. Interact with LiteDB through the command-line interface (CLI). Here are some sample SQL queries:

**SELECT**

```
SELECT name,email FROM nba_player_data WHERE name='Matt Zunic'
```

**INSERT**

*specific columns*
```
INSERT INTO nba_player_data (name, year_start, year_end, position) VALUES ('Alaa Abdelnaby34', 1991, 1995, 'F-C')
```
*All columns*
```
INSERT INTO nba_player_data VALUES (Alaa Abdelnaby34,1991,1995,F-C,6-10,240,"June 24, 1968",Duke University)
```
**UPDATE**
```
UPDATE nba_player_data SET name = 'Bill Renamed', year_start = '2330' WHERE name = 'Bill Zopf', year_start = '1971'
```
**DELETE**
```
DELETE FROM nba_player_data WHERE name = 'John'
```
