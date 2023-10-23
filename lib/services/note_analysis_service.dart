import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/history_view_controller.dart';
import '../models/analysis/analysis_model.dart';
import '../models/note/note_model.dart';

class NoteAnalysisService {
  Stream<List<NoteModel>> getNoteEntriesListOnDate(DateTime date) {
    return HistoryViewController()
        .getNoteEntriesListOnDate(date)
        .snapshots(includeMetadataChanges: true)
        .map(
          (QuerySnapshot<Map<String, dynamic>> query) => [
            ...query.docs.map(
              (e) => NoteModel.fromJson(e.data()),
            )
          ],
        );
  }

  Stream<List<AnalysisModel>> getAnalysisEntriesListOnDate(DateTime date) {
    return HistoryViewController()
        .getAnalysisEntriesListOnDate(date)
        .snapshots(includeMetadataChanges: true)
        .map(
          (QuerySnapshot<AnalysisModel> event) => <AnalysisModel>[
            ...event.docs.map(
              (QueryDocumentSnapshot<AnalysisModel> e) => e.data(),
            )
          ],
        );
  }
}
