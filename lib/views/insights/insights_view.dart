import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../providers/settings_providers.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/no_analysis_found_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/insights_tile.dart';

class InsightsView extends ConsumerWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: AppBar(
        pathNames: [
          PageController()
              .insights
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName)
        ],
      ),
      body: (ref.watch(analysisModelListProvider).isEmpty)
          ? const NoAnalysisFoundTile()
          : const InsightsTile(),
    );
  }
}
