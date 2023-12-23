import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../providers/settings_providers.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/no_analysis_found_tile.dart';
import '../blueprint/blueprint_view.dart';
import '../simple/views/simple_calendar_view.dart';
import 'widgets/calendar_tile/calendar_tile.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return useSimpleUI
        ? const SimpleCalendarView()
        : BlueprintView(
            showAppBar: showAppBar,
            appBar: AppBar(
              pathNames: [
                PageController().history.titleGenerator(
                    FirebaseAuth.instance.currentUser?.displayName),
              ],
            ),
            body: (ref.watch(analysisModelSetProvider).isEmpty)
                ? const NoAnalysisFoundTile()
                : const CalendarTile(),
          );
  }

  bool get useSimpleUI => ref.watch(navigationSimpleUIProvider);
  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);
  bool get showAppBar => ref.watch(navigationShowAppBarProvider);
}
