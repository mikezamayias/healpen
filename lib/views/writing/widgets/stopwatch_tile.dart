// time_format_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../extensions/int_extensions.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class StopwatchTile extends StatelessWidget {
  final int timeInSeconds;

  const StopwatchTile({
    required this.timeInSeconds,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.all(gap),
      backgroundColor: context.theme.colorScheme.surface,
      titleString: 'Writing time',
      subtitleString: timeInSeconds.writingDurationFormat(),
      responsiveWidth: true,
    );
  }
}
