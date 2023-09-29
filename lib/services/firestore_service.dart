import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/analysis_view_controller.dart';
import '../models/analysis/analysis_model.dart';
import '../models/note/note_model.dart';
import '../models/sentence/sentence_model.dart';

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

  static Future<void> saveAnalysis(AnalysisModel analysisModel) async {
    log(
      '${analysisModel.toJson()}',
      name: 'FirestoreService:saveAnalysis() - analysis to save',
    );
    await analysisCollectionReference()
        .doc('${analysisModel.timestamp}')
        .set(analysisModel.toJson());
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
        await analysisCollectionReference()
            .where('wordCount', isNull: true)
            .get();
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

  static Future<void> removeAnalysisFromWritingDocument(
    DocumentSnapshot<Map<String, dynamic>> element,
  ) async {
    List<String> keys = [
      'sentimentScore',
      'sentimentMagnitude',
      'sentenceCount',
      'sentiment',
      'wordCount'
    ];
    for (String key in keys) {
      if (element.data()!.containsKey(key)) {
        FirestoreService.writingCollectionReference()
            .doc(element.id)
            .update({key: FieldValue.delete()}).then((_) {
          log(
            'Note ${element.id}, removing $key',
            name: 'FirestorService:analyzeSentiment',
          );
        }).catchError((error) {
          log(
            '$error',
            name: 'FirestorService:analyzeSentiment',
          );
        });
      }
    }
  }

  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
      getWritingDocumentsToRemoveAnalysis() async {
    List<String> filterKeys = [
      'sentimentScore',
      'sentimentMagnitude',
      'sentenceCount',
      'sentiment',
      'wordCount'
    ];
    // Get all documents from the writing collection
    QuerySnapshot<Map<String, dynamic>> writingSnapshot =
        await writingCollectionReference().get();
    List<DocumentSnapshot<Map<String, dynamic>>> writingDocuments =
        writingSnapshot.docs;

    // Filter the writing documents to only those that have the keys to be removed
    List<DocumentSnapshot<Map<String, dynamic>>> documentsToRemoveAnalysis =
        writingDocuments.where((doc) {
      for (String key in filterKeys) {
        if (doc.data()!.containsKey(key)) {
          return true;
        }
      }
      return false;
    }).toList();

    return documentsToRemoveAnalysis;
  }

  /// analyzeSentiment is a method in the FirestoreService class that
  /// takes a QueryDocumentSnapshot as input and returns an
  /// AnalyzeSentimentResponse object. It uses the Google Cloud Natural
  /// Language API to analyze the sentiment of the text in the
  /// QueryDocumentSnapshot. If the QueryDocumentSnapshot does not already have
  /// a sentiment field, the method retrieves the document from the
  /// writingCollectionReference, analyzes the sentiment using the Google Cloud
  /// Natural Language API, and saves the sentiment analysis results to the
  /// analysisCollectionReference. The method returns the
  /// AnalyzeSentimentResponse object.
  static Future<void> analyzeSentiment(
    DocumentSnapshot<Map<String, dynamic>> note,
  ) async {
    writingCollectionReference()
        .doc(note.id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> value) async {
      // AnalysisModel analysisModel = AnalysisModel.fromJson(
      //   NoteModel.fromJson(value.data()!).toJson(),
      // );
      final analysisModel = await AnalysisViewController.createNoteAnalysis(
        NoteModel.fromJson(value.data()!),
      );
      log(
        '${analysisModel.toJson()}',
        name: 'FirestorService:analyzeSentiment:analysisModel',
      );
      analysisCollectionReference().doc(note.id).set(analysisModel.toJson());
      for (SentenceModel sentence in analysisModel.sentences) {
        analysisCollectionReference()
            .doc(note.id)
            .collection('sentences')
            .doc(analysisModel.sentences.indexOf(sentence).toString())
            .set(sentence.toJson());
      }
      log(
        'added sentences',
        name: 'FirestorService:analyzeSentiment:${note.id}',
      );
    }).catchError((error) {
      throw error;
    });
  }
}
