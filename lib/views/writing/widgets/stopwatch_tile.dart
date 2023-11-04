import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class StopwatchTile extends ConsumerWidget {
  const StopwatchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      useSmallerNavigationSetting: false,
      cornerRadius: ref.watch(navigationSmallerNavigationElementsProvider)
          ? radius
          : radius - gap,
      backgroundColor: context.theme.colorScheme.surface,
      textColor: context.theme.colorScheme.onSurface,
      titleString: 'Stopwatch',
      trailing: Text(
        ref.watch(writingControllerProvider).duration.writingDurationFormat(),
        style: context.theme.textTheme.titleLarge,
      ),
    );
  }
}
