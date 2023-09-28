import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../controllers/writing_controller.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../services/firestore_service.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/show_healpen_dialog.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

enum AnalysisProgress {
  removingPreviousAnalysis,
  analyzingNotes,
  completed,
}

final progressProvider = StateProvider<int>((ref) => 0);
final listToAnalyzeLengthProvider = StateProvider<int>((ref) => 0);
final analysisProgressProvider = StateProvider<AnalysisProgress>(
    (ref) => AnalysisProgress.removingPreviousAnalysis);

class AnalyzeNotesTile extends ConsumerWidget {
  const AnalyzeNotesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Analyze notes',
      explanationString:
          'Update analysis of existing notes and analyze new ones.',
      onTap: () {
        vibrate(
          ref.watch(navigationReduceHapticFeedbackProvider),
          () async {
            double total = ref.watch(listToAnalyzeLengthProvider).toDouble();
            double progressValue =
                total == 0 ? 0.0 : ref.watch(progressProvider) / total;
            showHealpenDialog(
              context: context,
              doVibrate: ref.watch(navigationReduceHapticFeedbackProvider),
              customDialog: CustomDialog(
                titleString: 'Analyzing notes',
                enableContentContainer: false,
                contentWidget: Padding(
                  padding: EdgeInsets.all(gap),
                  child: FutureBuilder(
                    future: Future.value([
                      removePreviousAnalysis(ref),
                      analyzeNotes(ref),
                    ]),
                    builder: (context, snapshot) {
                      return CustomListTile(
                        backgroundColor: context.theme.colorScheme.surface,
                        textColor: context.theme.colorScheme.onSurface,
                        cornerRadius: radius - gap,
                        contentPadding: EdgeInsets.all(gap),
                        titleString: switch (
                            ref.watch(analysisProgressProvider)) {
                          AnalysisProgress.removingPreviousAnalysis =>
                            'Removing previous analysis',
                          AnalysisProgress.analyzingNotes => 'Analyzing notes',
                          AnalysisProgress.completed => 'Completed',
                        },
                        // title: AnimatedSwitcher(
                        //   duration: emphasizedDuration,
                        //   reverseDuration: emphasizedDuration,
                        //   switchInCurve: emphasizedCurve,
                        //   switchOutCurve: emphasizedCurve,
                        //   child: Text(
                        //     switch (ref.watch(analysisProgressProvider)) {
                        //       AnalysisProgress.removingPreviousAnalysis =>
                        //         'Removing previous analysis',
                        //       AnalysisProgress.analyzingNotes =>
                        //         'Analyzing notes',
                        //       AnalysisProgress.completed => 'Completed',
                        //     },
                        //   ),
                        // ),
                        enableSubtitleWrapper: false,
                        subtitle: ClipRRect(
                          borderRadius: BorderRadius.circular(radius - gap),
                          child: LinearProgressIndicator(
                            value: progressValue,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  CustomListTile(
                    cornerRadius: radius - gap,
                    responsiveWidth: true,
                    titleString: 'Close',
                    onTap: switch (ref.watch(analysisProgressProvider)) {
                      AnalysisProgress.completed => () {
                          vibrate(
                            ref.watch(navigationReduceHapticFeedbackProvider),
                            () {
                              context.navigator.pop();
                            },
                          );
                        },
                      _ => null
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> removePreviousAnalysis(WidgetRef ref) async {
  QuerySnapshot<Map<String, dynamic>> notesToAnalyze =
      await FirestoreService.writingCollectionReference()
          .where('sentiment', isNull: false)
          .get();
  ref.read(listToAnalyzeLengthProvider.notifier).state =
      notesToAnalyze.docs.length;

  log(
    ref.read(listToAnalyzeLengthProvider.notifier).state.toString(),
    name: 'removePreviousAnalysis:listToAnalyzeLength',
  );
  for (QueryDocumentSnapshot<Map<String, dynamic>> noteModel
      in notesToAnalyze.docs) {
    await WritingController().removeSentimentFromDocument(noteModel);
    ref.read(progressProvider.notifier).state++;
    log(
      ref.read(progressProvider.notifier).state.toString(),
      name: 'analyzeNotes:progress',
    );
  }
  ref.read(analysisProgressProvider.notifier).state =
      AnalysisProgress.analyzingNotes;
  ref.read(progressProvider.notifier).state = 0;
  log(
    ref.read(analysisProgressProvider.notifier).state.toString(),
    name: 'removePreviousAnalysis',
  );
  log(
    ref.read(progressProvider.notifier).state.toString(),
    name: 'analyzeNotes:progress',
  );
  return;
}

Future<void> analyzeNotes(WidgetRef ref) async {
  QuerySnapshot<Map<String, dynamic>> notesToAnalyze =
      await FirestoreService.writingCollectionReference()
          .where('sentiment', isNull: false)
          .get();
  ref.read(listToAnalyzeLengthProvider.notifier).state =
      notesToAnalyze.docs.length;

  log(
    ref.read(listToAnalyzeLengthProvider.notifier).state.toString(),
    name: 'analyzeNotes:listToAnalyzeLength',
  );
  for (QueryDocumentSnapshot<Map<String, dynamic>> noteModel
      in notesToAnalyze.docs) {
    await WritingController().analyzeSentiment(noteModel);
    ref.read(progressProvider.notifier).state++;
    log(
      ref.read(progressProvider.notifier).state.toString(),
      name: 'analyzeNotes:progress',
    );
  }
  ref.read(analysisProgressProvider.notifier).state =
      AnalysisProgress.completed;
  ref.read(progressProvider.notifier).state = 0;
  log(
    ref.read(analysisProgressProvider.notifier).state.toString(),
    name: 'removePreviousAnalysis',
  );
  log(
    ref.read(progressProvider.notifier).state.toString(),
    name: 'analyzeNotes:progress',
  );
  return;
}
