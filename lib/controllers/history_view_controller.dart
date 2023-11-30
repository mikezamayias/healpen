import 'dart:developer';

import '../models/note/note_model.dart';
import '../services/firestore_service.dart';

class HistoryViewController {
  /// Singleton constructor
  static final HistoryViewController _instance =
      HistoryViewController._internal();

  factory HistoryViewController() => _instance;

  HistoryViewController._internal();

  /// Deletes note from writing and analysis collections
  deleteNote({
    required int timestamp,
  }) {
    FirestoreService()
        .writingCollectionReference()
        .doc(timestamp.toString())
        .delete()
        .then(
          (value) => log(
            'Note deleted',
            name:
                'HistoryViewController().deleteNote(${timestamp.toString()})',
          ),
          onError: (error) => log(
            'Failed to delete note: $error',
            name:
                'HistoryViewController().deleteNote(${timestamp.toString()})',
          ),
        );
    FirestoreService()
        .analysisCollectionReference()
        .doc(timestamp.toString())
        .delete()
        .then(
          (value) => log(
            'Analysis deleted',
            name:
                'HistoryViewController().deleteNote(${timestamp.toString()})',
          ),
          onError: (error) => log(
            'Failed to delete analysis: $error',
            name:
                'HistoryViewController().deleteNote(${timestamp.toString()})',
          ),
        );
  }

  Future<void> noteToggleFavorite({
    required NoteModel noteModel,
  }) async {
    await FirestoreService()
        .writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .update({
      'isFavorite': !noteModel.isFavorite,
    });
  }

  Future<void> noteTogglePrivate({
    required NoteModel noteModel,
  }) async {
    await FirestoreService()
        .writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .update({
      'isPrivate': !noteModel.isPrivate,
    });
  }
}
