import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../history/widgets/calendar_tile/calendar_tile.dart';
import '../simple_blueprint_view.dart';
import '../widgets/simple_app_bar.dart';

class SimpleCalendarView extends ConsumerWidget {
  const SimpleCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SimpleBlueprintView(
      simpleAppBar: SimpleAppBar(
        appBarTitleString: 'Calendar',
      ),
      body: CalendarTile(),
    );
  }
}
