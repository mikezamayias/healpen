import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../widgets/custom_dialog.dart';
import 'constants.dart';

Future<T?> showHealpenDialog<T>({
  required BuildContext context,
  required bool doVibrate,
  required CustomDialog customDialog,
}) async {
  if (doVibrate) {
    HapticFeedback.vibrate();
  }
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: context.theme.colorScheme.background.withOpacity(0.5),
    builder: (BuildContext context) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: gap * 2,
        sigmaY: gap * 2,
      ),
      child: customDialog,
    ),
  );
}
