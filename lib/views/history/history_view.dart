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

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(navigationSimpleUIProvider)
        ? const SimpleCalendarView()
        : BlueprintView(
            showAppBar: ref.watch(navigationShowAppBarProvider),
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
}
