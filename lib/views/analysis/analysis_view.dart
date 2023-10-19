import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../models/analysis/analysis_model.dart';
import '../../providers/settings_providers.dart';
import '../../services/firestore_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/analysis_section.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarProvider),
      appBar: const AppBar(
        pathNames: ['Your writing insights'],
      ),
      body: StreamBuilder(
        stream: FirestoreService().analysisCollectionReference().snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> analysisSnapshot,
        ) {
          if (analysisSnapshot.data == null) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          } else {
            if (analysisSnapshot.data!.docs.isEmpty) {
              return const CustomListTile(
                titleString: 'No data found',
                subtitleString:
                    'You don\'t have any insights yet. Try writing a few notes '
                    'to get started or tap the \'Update note analysis\' '
                    'button.',
              );
            } else {
              ref
                  .watch(AnalysisViewController.analysisModelListProvider)
                  .clear();
              for (QueryDocumentSnapshot<Map<String, dynamic>> element
                  in analysisSnapshot.data!.docs) {
                ref.watch(AnalysisViewController.analysisModelListProvider).add(
                      AnalysisModel.fromJson(element.data()),
                    );
              }
              return const AnalysisSection();
            }
          }
        },
      ),
    );
  }
}
