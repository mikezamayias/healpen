import '../models/note/note_model.dart';
import '../services/firestore_service.dart';

class HistoryViewController {
  /// Singleton constructor
  static final HistoryViewController _instance =
      HistoryViewController._internal();

  factory HistoryViewController() => _instance;

  HistoryViewController._internal();

  /// Deletes note from writing and analysis collections
  Future<void> deleteNote({required int timestamp}) async {
    await FirestoreService()
        .writingCollectionReference()
        .doc(timestamp.toString())
        .delete();
    await FirestoreService()
        .analysisCollectionReference()
        .doc(timestamp.toString())
        .delete();
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
