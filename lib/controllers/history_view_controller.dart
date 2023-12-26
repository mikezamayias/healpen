import '../models/note/note_model.dart';
import '../services/firestore_service.dart';
import '../utils/logger.dart';

class HistoryViewController {
  /// Singleton constructor
  static final HistoryViewController _instance =
      HistoryViewController._internal();

  factory HistoryViewController() => _instance;

  HistoryViewController._internal();

  /// Deletes note from writing and analysis collections
  void deleteNote({
    required int timestamp,
  }) {
    FirestoreService()
        .writingCollectionReference()
        .doc(timestamp.toString())
        .delete()
        .then(
          (value) => logger.i(
            'Note deleted',
          ),
          onError: (error) => logger.i(
            'Failed to delete note: $error',
          ),
        );
    FirestoreService()
        .analysisCollectionReference()
        .doc(timestamp.toString())
        .delete()
        .then(
          (value) => logger.i(
            'Analysis deleted',
          ),
          onError: (error) => logger.i(
            'Failed to delete analysis: $error',
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
