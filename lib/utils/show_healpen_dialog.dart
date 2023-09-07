import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../providers/settings_providers.dart';
import '../widgets/custom_dialog.dart';
import 'constants.dart';
import 'helper_functions.dart';

Future showHealpenDialog({
  required BuildContext context,
  required CustomDialog customDialog,
}) async =>
    vibrate(
      ProviderContainer().read(navigationReduceHapticFeedbackProvider),
      () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: context.theme.colorScheme.background.withOpacity(0.8),
          builder: (BuildContext context) => BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: gap * 2,
              sigmaY: gap * 2,
            ),
            child: customDialog,
          ),
        );
      },
    );
