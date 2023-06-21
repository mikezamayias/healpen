// time_format_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class StopwatchTile extends StatelessWidget {
  final int timeInSeconds;

  const StopwatchTile({required this.timeInSeconds, Key? key})
      : super(key: key);

  String formatTime() {
    final hours = timeInSeconds ~/ 3600;
    final minutes = (timeInSeconds % 3600) ~/ 60;
    final seconds = timeInSeconds % 60;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.all(gap),
      backgroundColor: context.theme.colorScheme.surface,
      titleString: 'Writing time',
      subtitleString: formatTime(),
      responsiveWidth: true,
    );
  }
}
