import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../models/analysis/analysis_model.dart';
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
        stream: AnalysisViewController.analysisStream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> analysisSnapshot,
        ) {
          if (analysisSnapshot.data == null) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          } else {
            if (analysisSnapshot.data!.docs.isEmpty) {
              return const CustomListTile(
                titleString: 'No analysis found',
                subtitle: Text(
                  'You have no analysis yet. '
                  'Try writing a few notes to get started.',
                ),
              );
            } else {
              for (QueryDocumentSnapshot<Map<String, dynamic>> element
                  in analysisSnapshot.data!.docs) {
                AnalysisViewController.analysisModelList.add(
                  AnalysisModel.fromJson(element.data()),
                );
              }
              return Column(
                children: [
                  const AverageOverallSentimentTile(),
                  SizedBox(height: gap),
                  const SplineSentimentTile(),
                  SizedBox(height: gap),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
