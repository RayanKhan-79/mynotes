// import 'package:flutter/cupertino.dart';
// import 'package:mynotes/service/crud/database_constants.dart' show COLUMNS;

// @immutable
// class DatabaseNote extends Object
// {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSynced;

//   const DatabaseNote({required this.id, required this.userId, required this.text, required this.isSynced});

//   DatabaseNote.fromRow(Map<String, Object?> map) :
//     id = map[COLUMNS.ID] as int,
//     userId = map[COLUMNS.USER_ID] as int,
//     text = map[COLUMNS.TEXT] as String,
//     isSynced = (map[COLUMNS.IS_SYNCED] as int == 0) ? false : true;

//   @override
//   String toString()
//   {
//     return 'Note {Id: $id, UserId: $userId, Text: $text, Synced?: $isSynced}';
//   }

//   @override
//   bool operator==(covariant DatabaseNote other) 
//   {
//     return id == other.id;
//   }

//   @override
//   int get hashCode => id.hashCode;

// }