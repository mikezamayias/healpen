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

  static CollectionReference<Map<String, dynamic>>
      analysisCollectionReference() {
    return FirebaseFirestore.instance
        .collection('analysis-temp')
        .doc(currentUser.uid)
        .collection('notes');
  }

  static Future<void> saveNote(NoteModel noteModel) async {
    log(
      '${noteModel.toJson()}',
      name: 'FirestoreService:saveNote() - note to save',
    );
    await writingCollectionReference()
        .doc('${noteModel.timestamp}')
        .set(noteModel.toJson());
  }

  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getDocumentsToAnalyze() async {
    // Get all documents from the writing collection
    QuerySnapshot<Map<String, dynamic>> writingSnapshot =
        await writingCollectionReference().get();
    List<DocumentSnapshot<Map<String, dynamic>>> writingDocuments =
        writingSnapshot.docs;

    // Get all documents from the analysis collection
    QuerySnapshot<Map<String, dynamic>> analysisSnapshot =
        await analysisCollectionReference().get();
    List<DocumentSnapshot<Map<String, dynamic>>> analysisDocuments =
        analysisSnapshot.docs;

    // Get the IDs of the documents in the analysis collection
    Set<String> analysisIds = analysisDocuments.map((doc) => doc.id).toSet();

    // Filter the writing documents to only include those whose ID is not in the analysis collection
    List<DocumentSnapshot<Map<String, dynamic>>> documentsToAnalyze =
        writingDocuments.where((doc) => !analysisIds.contains(doc.id)).toList();

    return documentsToAnalyze;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getNote(
    int timestamp,
  ) {
    return writingCollectionReference().doc('$timestamp').snapshots();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getAnalysis(
    int timestamp,
  ) {
    return analysisCollectionReference().doc('$timestamp').snapshots();
  }
}
