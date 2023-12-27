import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../providers/settings_providers.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/no_analysis_found_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../simple/views/simple_insights_tile.dart';
import 'widgets/insights_tile.dart';

class InsightsView extends ConsumerStatefulWidget {
  const InsightsView({super.key});

  @override
  ConsumerState<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends ConsumerState<InsightsView> {
  @override
  Widget build(BuildContext context) {
    return useSimpleUi
        ? const SimpleInsightsTile()
        : BlueprintView(
            showAppBar: showAppBar,
            appBar: AppBar(
              pathNames: [
                PageController().insights.titleGenerator(
                    FirebaseAuth.instance.currentUser?.displayName)
              ],
            ),
            body: (ref.watch(analysisModelSetProvider).isEmpty)
                ? const NoAnalysisFoundTile()
                : const InsightsTile(),
          );
  }

  bool get useSimpleUi => ref.watch(navigationSimpleUIProvider);
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showAppBar => ref.watch(navigationShowAppBarProvider);
}
