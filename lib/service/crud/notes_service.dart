// import 'dart:async';
// import 'package:mynotes/service/crud/database_constants.dart';
// import 'package:mynotes/service/crud/databse_note.dart';
// import 'package:mynotes/service/crud/database_user.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';


// class NotesService
// {
//   Database? _databaseInstance;
//   List<DatabaseNote> _cache = [];
//   late final StreamController<List<DatabaseNote>> controller;

//   NotesService._singletonConstructor()
//   {
//     controller = StreamController<List<DatabaseNote>>.broadcast();
//     controller.onListen = () {
//       controller.sink.add(_cache);
//     };
//   }
//   static final NotesService _instance = NotesService._singletonConstructor();
//   static NotesService get instance => _instance;
//   Database? get db => _databaseInstance;

//   Future<void> assertDatabseIsInitialized() async
//   {
//     if (_databaseInstance == null)
//         await this.open(); 
//   }

//   Future<DatabaseUser> fetchOrCreateUser({required String email}) async
//   {
//     assertDatabseIsInitialized();
//     try 
//     {
//       return await fetchUserByEmail(email: email);
//     } 
//     on Exception 
//     {
//       return await createUser(email: email);
//     }
//     catch (e)
//     {
//       rethrow;
//     }

//   }

//   Future<void> updateCache({required DatabaseUser user}) async
//   {
//     _cache = await fetchAllNotesByUser(user: user);
//     controller.add(_cache);
//   }

//   Future<DatabaseNote> updateNote({required int noteId, required String text}) async
//   {
//     this.assertDatabseIsInitialized();
//     final record = {
//       COLUMNS.TEXT : text,
//       COLUMNS.IS_SYNCED : false,
//     };
//     await _databaseInstance!.update(TABLES.NOTES, record, where: '${COLUMNS.ID} = ?', whereArgs: [noteId]);
//     final note = await fetchNoteById(noteId: noteId);

//     _cache.removeWhere((note) => note.id == noteId);
//     _cache.add(note);
//     controller.add(_cache);

//     return note;
//   }

//   Future<List<DatabaseNote>> fetchAllNotes() async
//   {
//     this.assertDatabseIsInitialized();

//     final notesOwned = await _databaseInstance!.query(TABLES.NOTES);
//     List<DatabaseNote> list = [];
//     for (int i = 0; i < notesOwned.length; i += 1)
//       list[i] = DatabaseNote.fromRow(notesOwned[i]);

//     return list;
//   }

//   Future<List<DatabaseNote>> fetchAllNotesByUser({required DatabaseUser user}) async
//   {
//     this.assertDatabseIsInitialized();

//     final notesOwned = await _databaseInstance!.query(TABLES.NOTES, where: '${COLUMNS.USER_ID} = ?', whereArgs: [user.id]);
//     List<DatabaseNote> list = [];
//     for (int i = 0; i < notesOwned.length; i += 1)
//       list.add(DatabaseNote.fromRow(notesOwned[i]));

//     return list;
//   }

//   Future<DatabaseNote> fetchNoteById({required int noteId}) async
//   {
//     this.assertDatabseIsInitialized();

//     final queryOutput = await _databaseInstance!.query(TABLES.NOTES, limit: 1, where: '${COLUMNS.ID} = ?', whereArgs: [noteId]);
//     if (queryOutput.isEmpty)
//       throw Exception('Could Not Find Note');

//     final note = DatabaseNote.fromRow(queryOutput[0]);
    
//     _cache.removeWhere((note) => note.id == noteId);
//     _cache.add(note);
//     controller.add(_cache);
    
//     return note;
//   }

//   Future<void> deleteAllNotes() async 
//   {
//     this.assertDatabseIsInitialized();
//     await _databaseInstance!.delete(TABLES.NOTES);

//     _cache.clear();
//     controller.add(_cache);
//   }

//   Future<void> deleteNote({required int noteId}) async
//   {
//     this.assertDatabseIsInitialized();

//     final rowsAffected = await _databaseInstance!.delete(TABLES.NOTES, where: '${COLUMNS.ID} = ?', whereArgs: [noteId]);
//     if (rowsAffected == 0) 
//       throw Exception('Could Not Delete Note');

//     _cache.removeWhere((item) => item.id == noteId);
//     controller.add(_cache);
//   }

//   Future<DatabaseNote> createNote({required DatabaseUser owner}) async
//   {
//     this.assertDatabseIsInitialized();

//     await this.fetchUserByEmail(email: owner.email);

//     final record = {
//       COLUMNS.USER_ID : owner.id,
//       COLUMNS.TEXT : '',
//       COLUMNS.IS_SYNCED : true,
//     };

//     final id = await _databaseInstance!.insert(TABLES.NOTES, record);

//     final note = DatabaseNote(id: id, userId: owner.id, text: '', isSynced: true);
//     _cache.add(note);
//     controller.add(_cache);
//     return note;
//   }

//   Future<DatabaseUser> fetchUserByEmail({required String email}) async
//   {
//     await this.assertDatabseIsInitialized();

//     final queryResults = await _databaseInstance!.query(TABLES.USER, where: '${COLUMNS.EMAIL} = ?', whereArgs: [email]);
//     if (queryResults.isEmpty) 
//       throw Exception('Database User Does Not Exist');
    
//     return DatabaseUser.fromRow(queryResults[0]);
//   }

//   Future<DatabaseUser> createUser({required String email}) async
//   {
//     this.assertDatabseIsInitialized();

//     final queryRows = await _databaseInstance!.query(TABLES.USER, where: '${COLUMNS.EMAIL} = ?', whereArgs: [email]); 
//     if (queryRows.isNotEmpty) 
//       throw Exception('Databse User Already Exists');

//     final userId = await _databaseInstance!.insert(TABLES.USER, {COLUMNS.EMAIL:email});

//     return DatabaseUser(id: userId, email: email);  
//   }

//   Future<void> deleteUser({required String email}) async
//   {
//     this.assertDatabseIsInitialized();

//     final rowsAffected = await _databaseInstance!.delete(TABLES.USER, where: '${COLUMNS.EMAIL} = ?', whereArgs: [email]);
//     if (rowsAffected == 0) 
//       throw Exception('Couldn\'t delete user');
//   }

//   Future<void> close() async
//   {
//     assertDatabseIsInitialized();

//     await _databaseInstance!.close();
//     _databaseInstance = null;
//   }

//   Future<void> open() async
//   {
//     if (_databaseInstance != null)
//       return;

//     final String databasePath = join((await getApplicationDocumentsDirectory()).path, DATABASE_FILE_NAME);

//     _databaseInstance = await openDatabase(databasePath);
//     await _databaseInstance!.execute(SQLiteApi.CREATE_USER_TABLE);
//     await _databaseInstance!.execute(SQLiteApi.CREATE_NOTES_TABLE);
//   } 
// }