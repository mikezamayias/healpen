import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
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
import 'widgets/calendar_tile/calendar_tile.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: AppBar(
        pathNames: [
          PageController()
              .history
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
              return const CalendarTile();
            }
          }
          // if (analysisSnapshot.data == null) {
          //   return const LoadingTile(durationTitle: 'Loading metrics');
          // } else {
          //   if (analysisSnapshot.hasError) {
          //     return Center(
          //       child: CustomListTile(
          //         titleString: 'Something went wrong',
          //         backgroundColor: context.theme.colorScheme.error,
          //         textColor: context.theme.colorScheme.onError,
          //         subtitle: SelectableText(snapshot.error.toString()),
          //       ),
          //     );
          //   }
          //   if (analysisSnapshot.data!.isNotEmpty) {
          //     return AnimatedContainer(
          //       duration: standardDuration,
          //       curve: standardCurve,
          //       decoration:
          //           ref.watch(navigationSmallerNavigationElementsProvider)
          //               ? BoxDecoration(
          //                   borderRadius: BorderRadius.circular(radius),
          //                   color: context.theme.colorScheme.surface,
          //                 )
          //               : BoxDecoration(
          //                   borderRadius: BorderRadius.circular(radius),
          //                   color: context.theme.colorScheme.surfaceVariant,
          //                 ),
          //       padding: ref.watch(navigationSmallerNavigationElementsProvider)
          //           ? EdgeInsets.zero
          //           : EdgeInsets.all(gap / 2),
          //       child: const CalendarTile(),
          //     );
          //   } else {
          //     return Center(
          //       child: CustomListTile(
          //         titleString: 'No notes yet',
          //         subtitle: const Text('Start writing to see your notes here'),
          //         onTap: () => ref
          //             .read(
          //                 HealpenController().currentPageIndexProvider.notifier)
          //             .state = 0,
          //         leadingIconData: FontAwesomeIcons.pencil,
          //         showcaseLeadingIcon: true,
          //       ),
          //     );
          //   }
          // }
        },
      ),
    );
  }
}
