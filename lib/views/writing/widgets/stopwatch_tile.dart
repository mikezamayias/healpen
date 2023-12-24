import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class StopwatchTile extends ConsumerStatefulWidget {
  const StopwatchTile({
    super.key,
  });

  @override
  ConsumerState<StopwatchTile> createState() => _StopwatchTileState();
}

class _StopwatchTileState extends ConsumerState<StopwatchTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      useSmallerNavigationSetting: false,
      cornerRadius:
          useSmallerNavigationElements || useSimpleUI ? radius : radius - gap,
      titleString: 'Stopwatch',
      backgroundColor: useSmallerNavigationElements || useSimpleUI
          ? context.theme.colorScheme.surfaceVariant
          : context.theme.colorScheme.surface,
      trailing: Text(
        ref.watch(writingControllerProvider).duration.writingDurationFormat(),
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  bool get useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  bool get useSimpleUI => ref.watch(navigationSimpleUIProvider);
}
