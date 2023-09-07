import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../widgets/custom_dialog.dart';
import 'constants.dart';

Future showHealpenDialog({
  required BuildContext context,
  required CustomDialog customDialog,
}) async =>
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
