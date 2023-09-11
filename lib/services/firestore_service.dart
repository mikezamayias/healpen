import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note/note_model.dart';

class FirestoreService {
  // Singleton Constructor
  FirestoreService._();

  static final instance = FirestoreService._();

  factory FirestoreService() => instance;

  // Attributes
  static final User currentUser = FirebaseAuth.instance.currentUser!;

  // Methods
  static CollectionReference<Map<String, dynamic>>
      writingCollectionReference() {
    return FirebaseFirestore.instance
        .collection('writing-temp')
        .doc(currentUser.uid)
        .collection('notes');
  }

  static Future<void> saveNote(NoteModel noteModel) async {
    log(
      '${noteModel.toDocument()}',
      name: 'FirestoreService:saveNote() - note to save',
    );
    await writingCollectionReference()
        .doc('${noteModel.timestamp}')
        .set(noteModel.toDocument());
  }
}
