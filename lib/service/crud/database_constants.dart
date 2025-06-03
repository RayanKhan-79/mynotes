// ignore_for_file: constant_identifier_names

const DATABASE_FILE_NAME = 'Notes.db';

class TABLES
{
  static const NOTES = 'Notes';
  static const USER = 'Users';
}

class COLUMNS
{
  static const ID = 'Id';
  static const EMAIL = 'email';
  static const USER_ID = 'userId';
  static const TEXT = 'text';
  static const IS_SYNCED = 'isSynced';
}

class SQLiteApi
{
  static const CREATE_USER_TABLE = 
  '''CREATE TABLE IF NOT EXISTS "Users" (
      "Id"	INTEGER NOT NULL UNIQUE,
      "email"	TEXT NOT NULL UNIQUE,
      PRIMARY KEY("Id" AUTOINCREMENT)
    );
  ''';
  static const CREATE_NOTES_TABLE = 
  '''CREATE TABLE IF NOT EXISTS "Notes" (
    "Id"	INTEGER NOT NULL UNIQUE,
    "userId"	INTEGER NOT NULL,
    "text"	TEXT,
    "isSynced"	INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY("Id" AUTOINCREMENT),
    FOREIGN KEY("userId") REFERENCES "Users"("Id")
  );
  ''';
}
