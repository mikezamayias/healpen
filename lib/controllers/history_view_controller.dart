import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get historyStream =>
      FirestoreService.writingCollectionReference()
          .orderBy('timestamp', descending: true)
          .snapshots();

  /// Make historyStream from Stream<QuerySnapshot<Map<String, dynamic>>> to
  /// Stream<WritingModelEntry>
  Stream<List<NoteModel>> get notesStream => historyStream.map((event) {
        _writingEntries.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          // log(
          //   '${element.data()}',
          //   name: 'HistoryViewController:notesStream',
          // );
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
