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
    required NoteModel noteModel,
  }) {
    FirestoreService()
        .writingCollectionReference()
        .doc(noteModel.timestamp.toString())
        .delete()
        .then(
          (value) => log(
            'Note deleted',
            name:
                'HistoryViewController().deleteNote(${noteModel.timestamp.toString()})',
          ),
          onError: (error) => log(
            'Failed to delete note: $error',
            name:
                'HistoryViewController().deleteNote(${noteModel.timestamp.toString()})',
          ),
        );
    FirestoreService()
        .analysisCollectionReference()
        .doc(noteModel.timestamp.toString())
        .delete()
        .then(
          (value) => log(
            'Analysis deleted',
            name:
                'HistoryViewController().deleteNote(${noteModel.timestamp.toString()})',
          ),
          onError: (error) => log(
            'Failed to delete analysis: $error',
            name:
                'HistoryViewController().deleteNote(${noteModel.timestamp.toString()})',
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
