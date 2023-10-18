import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/app_bar_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import 'path_title.dart';

class PathTitleWithLeading extends ConsumerStatefulWidget {
  const PathTitleWithLeading({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PathTitleWithLeadingState();
}

class _PathTitleWithLeadingState extends ConsumerState<PathTitleWithLeading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton.filled(
          padding: EdgeInsets.zero,
          enableFeedback: true,
          onPressed: _handleBackButton,
          color: theme.colorScheme.onPrimary,
          icon: const FaIcon(FontAwesomeIcons.chevronLeft),
        ),
        SizedBox(width: gap),
        const PathTitle(),
      ],
    );
  }

  void _handleBackButton() {
    vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
      VoidCallback? onBackButtonPressed =
          ref.watch(appBarControllerProvider).onBackButtonPressed;
      if (onBackButtonPressed != null) {
        onBackButtonPressed();
      } else {
        navigator.pop();
      }
    });
  }
}
