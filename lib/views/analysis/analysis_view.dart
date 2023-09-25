import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../extensions/int_extensions.dart';
import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/average_overall_sentiment_tile.dart';
import 'widgets/sentiment_spline_tile.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitle),
      appBar: const AppBar(
        pathNames: ['Your writing insights'],
      ),
      body: StreamBuilder(
        stream: AnalysisViewController().metricGroupingsStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<NoteModel>> metricGroupingsSnapshot,
        ) {
          if (metricGroupingsSnapshot.hasError) {
            return Center(
              child: CustomListTile(
                titleString: 'Something went wrong',
                backgroundColor: context.theme.colorScheme.error,
                textColor: context.theme.colorScheme.onError,
                subtitle:
                    SelectableText(metricGroupingsSnapshot.error.toString()),
              ),
            );
          }
          if (metricGroupingsSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          }
          if (metricGroupingsSnapshot.data!.isNotEmpty) {
            return FutureBuilder(
              future: Future.delayed(
                standardDuration,
                () {
                  ref
                          .read(AnalysisViewController.noteModelsProviders.notifier)
                          .state =
                      metricGroupingsSnapshot.data!
                          .sortedBy<num>((element) => element.timestamp);
                  log(
                    '${ref.watch(AnalysisViewController.noteModelsProviders.notifier).state.first.timestamp.timestampToDateTime()}',
                    name: 'AnalysisView:futureBuilder',
                  );
                  log(
                    '${ref.watch(AnalysisViewController.noteModelsProviders.notifier).state.last.timestamp.timestampToDateTime()}',
                    name: 'AnalysisView:futureBuilder',
                  );
                },
              ),
              builder: (context, snapshot) {
                return AnimatedSize(
                  duration: emphasizedDuration,
                  reverseDuration: emphasizedDuration,
                  curve: emphasizedCurve,
                  child: ref
                          .read(AnalysisViewController.noteModelsProviders)
                          .isNotEmpty
                      ? Column(
                          children: [
                            const AverageOverallSentimentTile(),
                            SizedBox(height: gap),
                            const SplineSentimentTile(),
                            SizedBox(height: gap),
                          ],
                        )
                      : const LoadingTile(durationTitle: 'Loading metrics'),
                );
              },
            );
          } else {
            return const CustomListTile(
              titleString: 'No metrics yet',
              subtitleString: 'Start writing to see your metrics!',
              leadingIconData: FontAwesomeIcons.solidChartBar,
            );
          }
        },
      ),
    );
  }
}
