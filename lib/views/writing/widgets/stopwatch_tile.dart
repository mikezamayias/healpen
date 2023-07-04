// time_format_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class StopwatchTile extends ConsumerWidget {
  const StopwatchTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.symmetric(
        vertical: gap,
        horizontal: gap * 2,
      ),
      backgroundColor: context.theme.colorScheme.surface,
      titleString: 'Writing time',
      subtitleString:
          ref.watch(writingControllerProvider).duration.writingDurationFormat(),
      responsiveWidth: true,
    );
  }
}
