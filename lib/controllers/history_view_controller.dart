import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';

class HistoryViewController {
  /// Singleton constructor
  static final HistoryViewController _instance =
      HistoryViewController._internal();

  factory HistoryViewController() => _instance;

  HistoryViewController._internal();

  /// Attributes
  final _writingEntries = <NoteModel>[];
  static late List<NoteModel> noteModels;

  /// Methods
  static List<NoteModel> get notesToAnalyze =>
      noteModels.where((element) => !element.isPrivate).toList();

  static Stream<QuerySnapshot<Map<String, dynamic>>> get historyStream =>
      FirestoreService.writingCollectionReference()
          .orderBy('timestamp', descending: true)
          // .limit(10)
          .snapshots(includeMetadataChanges: true);

  /// Get documents from Firestore of the given date
  Query<Map<String, dynamic>> getNoteEntriesListOnDate(
    DateTime date,
  ) {
    return FirestoreService.writingCollectionReference()
        .orderBy('timestamp', descending: true)
        .where('timestamp', isGreaterThanOrEqualTo: date.millisecondsSinceEpoch)
        .where('timestamp',
            isLessThan: date.add(1.days).millisecondsSinceEpoch);
  }

  /// Make historyStream from Stream<QuerySnapshot<Map<String, dynamic>>> to
  /// Stream<WritingModelEntry>
  Stream<List<NoteModel>> get notesStream => historyStream.map((event) {
        _writingEntries.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          _writingEntries.add(NoteModel.fromJson(element.data()));
        }
        return _writingEntries;
      });

  /// Deletes note from writing and analysis collections
  Future<void> deleteNote({
    required NoteModel noteModel,
  }) async {
    await FirestoreService.writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .delete();
    await FirestoreService.analysisCollectionReference()
        .doc(noteModel.timestamp.toString())
        .delete();
  }

  Future<void> noteToggleFavorite({
    required NoteModel noteModel,
  }) async {
    await FirestoreService.writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .update({
      'isFavorite': !noteModel.isFavorite,
    });
  }

  Future<void> noteTogglePrivate({
    required NoteModel noteModel,
  }) async {
    await FirestoreService.writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .update({
      'isPrivate': !noteModel.isPrivate,
    });
  }
}
