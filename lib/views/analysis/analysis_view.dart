import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../models/analysis/analysis_model.dart';
import '../../providers/settings_providers.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../../widgets/text_divider.dart';
import '../blueprint/blueprint_view.dart';
import '../settings/writing/widgets/analyze_notes_tile.dart';
import 'widgets/analysis_section.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: AppBar(
        pathNames: [
          PageController()
              .analysis
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreService().analysisCollectionReference().snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<AnalysisModel>> analysisSnapshot,
        ) {
          if (analysisSnapshot.data == null) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          } else {
            if (analysisSnapshot.data!.docs.isEmpty) {
              return Column(
                children: [
                  const CustomListTile(
                    titleString: 'No data found',
                    subtitleString:
                        'You don\'t have any insights yet. Try writing a few notes '
                        'to get started or tap the \'Update note analysis\' '
                        'button.',
                  ),
                  // TODO: add a stream builder to check if there are writing entries in the database first and then show the button
                  ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: gap),
                      child: const TextDivider('Or'),
                    ),
                    const AnalyzeNotesTile(),
                  ],
                ],
              );
            } else {
              ref
                  .watch(AnalysisViewController.analysisModelListProvider)
                  .clear();
              for (QueryDocumentSnapshot<AnalysisModel> element
                  in analysisSnapshot.data!.docs) {
                ref
                    .watch(AnalysisViewController.analysisModelListProvider)
                    .add(element.data());
              }
              return const AnalysisSection();
            }
          }
        },
      ),
    );
  }
}
