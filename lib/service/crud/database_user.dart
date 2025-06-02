// import 'package:flutter/cupertino.dart';
// import 'package:mynotes/service/crud/database_constants.dart' show COLUMNS;

// @immutable
// class DatabaseUser extends Object 
// {
//   final int id;
//   final String email;

//   const DatabaseUser({required this.id, required this.email});

//   DatabaseUser.fromRow(Map<String, Object?> map) : 
//     id = map[COLUMNS.ID] as int,
//     email = map[COLUMNS.EMAIL] as String;

//   @override
//   String toString() 
//   {
//     return 'Person {Id: $id, Email: $email}';  
//   }

//   @override
//   bool operator ==(covariant DatabaseUser other) 
//   {
//     return id == other.id;
//   }

//   @override
//   int get hashCode => id.hashCode;
// }
