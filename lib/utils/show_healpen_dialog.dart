import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../widgets/custom_dialog.dart';
import 'helper_functions.dart';

Future showHealpenDialog({
  required BuildContext context,
  required bool doVibrate,
  required CustomDialog customDialog,
}) async {
  if (doVibrate) {
    vibrate(doVibrate, () {});
  }
  return showDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    useSafeArea: true,
    barrierColor: context.theme.colorScheme.background.withOpacity(0.5),
    builder: (_) => customDialog,
  );
}
