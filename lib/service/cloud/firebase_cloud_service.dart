import 'dart:developer' as dev show log;

import 'package:mynotes/service/cloud/cloud_exceptions.dart';
import 'package:mynotes/service/cloud/cloud_note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/service/cloud/database_constants.dart';

class FirebaseCloudStorage 
{
  FirebaseCloudStorage._singletonConstructor();
  static final FirebaseCloudStorage _instance = FirebaseCloudStorage._singletonConstructor();
  static FirebaseCloudStorage get instance => _instance;

  Future<void> deleteNote({required String noteId}) async
  {
    try
    {
      await FirebaseFirestore.instance
      .collection(TABLES.NOTES)
      .doc(noteId)
      .delete();
    }
    catch (e)
    {
      dev.log(e.toString());
      throw CloudDeleteNoteException();
    }
  }

  Future<void> updateNote({required String noteId, required String text}) async
  {
    try
    {
      await FirebaseFirestore.instance
        .collection(TABLES.NOTES)
        .doc(noteId)
        .update({COLUMNS.TEXT : text});
    }
    catch (e)
    {
      dev.log(e.toString());
      throw CloudUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> streamNotes({required String userId})
  {
    return FirebaseFirestore.instance
      .collection(TABLES.NOTES)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((documentSnapshot) => CloudNote
          .fromQuerySnapshot(documentSnapshot)
        )
        .where((note) => note.userId == userId)
      );
  }

  Future<CloudNote> readNote({required String noteId}) async
  {
    return await FirebaseFirestore.instance
      .collection(TABLES.NOTES)
      .doc(noteId)
      .get()
      .then((snapshot) => CloudNote.fromDocumentSnapshot(snapshot));
  }

  Future<Iterable<CloudNote>> readAllNotesByUser({required String userId}) async 
  {
    try 
    {
      var iterable = await FirebaseFirestore.instance
        .collection(TABLES.NOTES)
        .where(COLUMNS.USER_ID, isEqualTo: userId)
        .get()
        .then((snapshots) =>
          snapshots.docs.map((snapshot) => 
            CloudNote.fromQuerySnapshot(snapshot))
        );

      return iterable.toList();
    }
    catch (e)
    {
      dev.log(e.toString());
      throw CloudReadNoteException();
    }
  }

  Future<CloudNote> createNote({required String userId}) async 
  {
    try
    {
      final note = {
        COLUMNS.USER_ID : userId,
        COLUMNS.TEXT : ''
      };

      final snapshot = await FirebaseFirestore.instance
        .collection('Notes')
        .add(note)
        .then((value) => value.get());

      return CloudNote.fromDocumentSnapshot(snapshot);
    }
    catch (e)
    {
      dev.log(e.toString());
      throw CloudCreateNoteException();
    }
  }
}
