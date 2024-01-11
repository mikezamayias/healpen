import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/analysis_model_extensions.dart';
import '../extensions/date_time_extensions.dart';
import '../models/analysis/analysis_model.dart';
import '../models/note_tile_model.dart';
import '../utils/logger.dart';
import 'analysis_view_controller.dart';

/// Singleton Controller for the NoteView
class DateViewController {
  DateViewController._privateConstructor();
  static final DateViewController instance =
      DateViewController._privateConstructor();
  factory DateViewController() => instance;

  /// Initializes the NoteViewController on specific date
  DateViewController.initializeOnDate(WidgetRef ref, DateTime date) {
    date = date;
    ref.read(_dateAnalysisModelSetProvider.notifier).state =
        ref.watch(analysisModelSetProvider).getAnalysisBetweenDates(
              start: date.startOfDay(),
              end: date.endOfDay(),
            );
    ref.read(noteModelSetProvider.notifier).state = ref
        .watch(_dateAnalysisModelSetProvider)
        .map((AnalysisModel analysisModel) => NoteTileModel(analysisModel))
        .toSet();
    logger.i(
        'NoteViewController initialized on ${date.toEEEEMMMd()} with ${ref.watch(noteModelSetProvider).length} notes');
  }

  /// Attributes
  DateTime? date;

  /// Providers
  static final _dateAnalysisModelSetProvider =
      StateProvider<Set<AnalysisModel>>((ref) => <AnalysisModel>{});
  static final noteModelSetProvider =
      StateProvider<Set<NoteTileModel>>((ref) => <NoteTileModel>{});
  static final noteSelectionEnabledProvider =
      StateProvider<bool>((ref) => false);
  static final StateProvider<Set<NoteTileModel>> selectedNoteModelsProvider =
      StateProvider<Set<NoteTileModel>>(
    (ref) => {
      ...ref
          .watch(noteModelSetProvider)
          .where((element) => ref.watch(element.isSelectedProvider))
    },
  );

  static void toggleNoteSelection(WidgetRef ref) {
    ref.read(noteSelectionEnabledProvider.notifier).state =
        !ref.read(noteSelectionEnabledProvider);
  }

  static void selectAllNotes(WidgetRef ref) {
    ref.read(selectedNoteModelsProvider.notifier).state =
        ref.read(noteModelSetProvider);
    ref.read(selectedNoteModelsProvider).forEach((element) {
      ref.read(element.isSelectedProvider.notifier).state = true;
    });
  }

  static void deselectAllNotes(WidgetRef ref) {
    ref.read(selectedNoteModelsProvider).forEach((element) {
      ref.read(element.isSelectedProvider.notifier).state = false;
    });
    ref.read(selectedNoteModelsProvider.notifier).state = <NoteTileModel>{};
  }

  static void toggleNoteModelSelection(
    WidgetRef ref,
    NoteTileModel noteTileModel,
  ) {
    ref.read(noteTileModel.isSelectedProvider.notifier).state =
        !ref.read(noteTileModel.isSelectedProvider);
  }

  static bool allNotesSelected(WidgetRef ref) {
    return ref.watch(selectedNoteModelsProvider).length ==
        ref.watch(_dateAnalysisModelSetProvider).length;
  }

  static bool someNotesSelected(WidgetRef ref) {
    return ref.watch(selectedNoteModelsProvider).isNotEmpty;
  }

  static bool xorNotesSelected(WidgetRef ref) {
    return allNotesSelected(ref) || someNotesSelected(ref);
  }

  static void deleteSelectedNotes(WidgetRef ref) {
    // ref.read(selectedNoteModelsProvider).forEach((element) {
    //   ref.read(_dateAnalysisModelSetProvider.notifier).state.removeWhere(
    //         (analysisModel) => analysisModel.id == element.id,
    //       );
    // });
    // ref.read(noteModelSetProvider.notifier).state = ref
    //     .watch(_dateAnalysisModelSetProvider)
    //     .map((AnalysisModel analysisModel) => NoteTileModel(analysisModel))
    //     .toSet();
    // ref.read(selectedNoteModelsProvider.notifier).state = <NoteTileModel>{};
    ref.read(selectedNoteModelsProvider).forEach((NoteTileModel element) {
      logger.i(element.analysisModel.content);
    });
  }

  static void dispose(WidgetRef ref) {
    ref.read(noteSelectionEnabledProvider.notifier).state = false;
    ref.read(selectedNoteModelsProvider.notifier).state = <NoteTileModel>{};
    ref.read(_dateAnalysisModelSetProvider.notifier).state = <AnalysisModel>{};
    ref.read(noteModelSetProvider.notifier).state = <NoteTileModel>{};
    logger.i('NoteViewController disposed');
  }
}
