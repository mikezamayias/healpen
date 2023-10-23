import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/note_analyzer.dart';
import '../models/analysis/analysis_model.dart';
import '../models/note/note_model.dart';
import '../models/sentence/sentence_model.dart';

class FirestoreService {
  // Singleton Constructor
  FirestoreService._();

  static final instance = FirestoreService._();

  factory FirestoreService() => instance;

  // Attributes
  final User currentUser = FirebaseAuth.instance.currentUser!;

  // Methods
  CollectionReference<NoteModel> writingCollectionReference() {
    return FirebaseFirestore.instance
        .collection('writing-temp')
        .doc(currentUser.uid)
        .collection('notes')
        .withConverter<NoteModel>(
          fromFirestore: (snapshot, _) => NoteModel.fromJson(snapshot.data()!),
          toFirestore: (noteModel, _) => noteModel.toJson(),
        );
  }

  CollectionReference<AnalysisModel> analysisCollectionReference() {
    return FirebaseFirestore.instance
        .collection('analysis-temp')
        .doc(currentUser.uid)
        .collection('notes')
        .withConverter<AnalysisModel>(
          fromFirestore: (snapshot, _) =>
              AnalysisModel.fromJson(snapshot.data()!),
          toFirestore: (analysisModel, _) => analysisModel.toJson(),
        );
  }

  DocumentReference<Map<String, dynamic>> preferencesCollectionReference() {
    return FirebaseFirestore.instance
        .collection('preferences-temp')
        .doc(currentUser.uid);
  }

  Future<void> saveNote(NoteModel noteModel) async {
    log(
      '${noteModel.toJson()}',
      name: 'FirestoreService:saveNote() - note to save',
    );
    await writingCollectionReference()
        .doc('${noteModel.timestamp}')
        .set(noteModel);
  }

  Future<void> saveAnalysis(AnalysisModel analysisModel) async {
    log(
      '${analysisModel.toJson()}',
      name: 'FirestoreService:saveAnalysis() - analysis to save',
    );
    await analysisCollectionReference()
        .doc('${analysisModel.timestamp}')
        .set(analysisModel);
  }

  Stream<QuerySnapshot<AnalysisModel>> getAnalysisBetweenDates(
      DateTime start, DateTime end) {
    return analysisCollectionReference()
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: start.millisecondsSinceEpoch,
        )
        .where(
          'timestamp',
          isLessThanOrEqualTo: end.millisecondsSinceEpoch,
        )
        .snapshots();
  }

  Future<List<DocumentSnapshot<NoteModel>>> getDocumentsToAnalyze() async {
    // Get all documents from the writing collection
    QuerySnapshot<NoteModel> writingSnapshot =
        await writingCollectionReference().get();
    List<DocumentSnapshot<NoteModel>> writingDocuments = writingSnapshot.docs;

    // Get all documents from the analysis collection
    QuerySnapshot<AnalysisModel> analysisSnapshot =
        await analysisCollectionReference()
            .where('wordCount', isNull: true)
            .get();
    List<QueryDocumentSnapshot<AnalysisModel>> analysisDocuments =
        analysisSnapshot.docs;

    // Get the IDs of the documents in the analysis collection
    Set<String> analysisIds = analysisDocuments.map((doc) => doc.id).toSet();

    // Filter the writing documents to only include those whose ID is not in the analysis collection
    List<DocumentSnapshot<NoteModel>> documentsToAnalyze =
        writingDocuments.where((doc) => !analysisIds.contains(doc.id)).toList();

    return documentsToAnalyze;
  }

  Future<DocumentSnapshot<NoteModel>> getNote(
    int timestamp,
  ) {
    return writingCollectionReference().doc('$timestamp').get();
  }

  Future<DocumentSnapshot<AnalysisModel>> getAnalysis(
    int timestamp,
  ) {
    return analysisCollectionReference().doc('$timestamp').get();
  }

  Future<void> removeAnalysisFromWritingDocument(
    DocumentSnapshot<NoteModel> element,
  ) async {
    List<String> keys = [
      'sentimentScore',
      'sentimentMagnitude',
      'sentenceCount',
      'sentiment',
      'wordCount'
    ];
    for (String key in keys) {
      if (element.data()!.toJson().toString().contains(key)) {
        writingCollectionReference()
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

  Future<List<DocumentSnapshot<NoteModel>>>
      getWritingDocumentsToRemoveAnalysis() async {
    List<String> filterKeys = [
      'sentimentScore',
      'sentimentMagnitude',
      'sentenceCount',
      'sentiment',
      'wordCount'
    ];
    // Get all documents from the writing collection
    QuerySnapshot<NoteModel> writingSnapshot =
        await writingCollectionReference().get();
    List<DocumentSnapshot<NoteModel>> writingDocuments = writingSnapshot.docs;

    // Filter the writing documents to only those that have the keys to be removed
    List<DocumentSnapshot<NoteModel>> documentsToRemoveAnalysis =
        writingDocuments.where((doc) {
      for (String key in filterKeys) {
        if (doc.data()!.toJson().toString().contains(key)) {
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
  Future<void> analyzeSentiment(
    DocumentSnapshot<NoteModel> note,
  ) async {
    writingCollectionReference()
        .doc(note.id)
        .get()
        .then((DocumentSnapshot<NoteModel> value) async {
      // AnalysisModel analysisModel = AnalysisModel.fromJson(
      //   NoteModel.fromJson(value.data()!).toJson(),
      // );
      final analysisModel = await NoteAnalyzer.createNoteAnalysis(
        value.data()!,
      );
      log(
        '${analysisModel.toJson()}',
        name: 'FirestorService:analyzeSentiment:analysisModel',
      );
      analysisCollectionReference().doc(note.id).set(analysisModel);
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
