import 'package:mynotes/service/cloud/database_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudNote
{
  String id;
  String text;
  String userId;

  CloudNote({required this.id, required this.text, required this.userId});

  CloudNote.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    id = snapshot.id,
    text = snapshot.data()[COLUMNS.TEXT] as String,
    userId = snapshot.data()[COLUMNS.USER_ID] as String;

  CloudNote.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) :
    id = snapshot.id,
    text = snapshot.data()![COLUMNS.TEXT] as String,
    userId = snapshot.data()![COLUMNS.USER_ID] as String;
}