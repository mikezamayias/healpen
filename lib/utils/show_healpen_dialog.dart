import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

Future showHealpenDialog({
  required BuildContext context,
  required bool doVibrate,
  required Widget customDialog,
}) async {
  return showDialog(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    useSafeArea: true,
    barrierColor: context.theme.colorScheme.background.withOpacity(0.5),
    builder: (_) => customDialog,
  );
}
