import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../providers/settings_providers.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'custom_list_tile.dart';

class CustomSnackBar {
  final SnackBarConfig _snackBarConfig;

  CustomSnackBar(this._snackBarConfig);

  void showSnackBar(BuildContext context, WidgetRef ref) {
    final snackBar1 = _snackBarConfig.createSnackBar1();
    final snackBar2 = _snackBarConfig.createSnackBar2();
    vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
      scaffoldMessengerKey.currentState!
          .showSnackBar(snackBar1)
          .closed
          .then((SnackBarClosedReason value) async {
        if (!(value == SnackBarClosedReason.remove)) {
          if (_snackBarConfig.actionAfterSnackBar1 != null) {
            _snackBarConfig.actionAfterSnackBar1!().then((_) {
              if (snackBar2 != null) {
                vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                  scaffoldMessengerKey.currentState!.showSnackBar(snackBar2);
                });
              }
            });
          }
        }
      });
    });
  }
}

class SnackBarConfig {
  final String titleString1;
  final IconData leadingIconData1;
  final List<Widget>? trailingWidgets1;
  final Future Function()? actionAfterSnackBar1;

  final String? titleString2;
  final IconData? leadingIconData2;

  SnackBarConfig({
    required this.titleString1,
    required this.leadingIconData1,
    this.trailingWidgets1,
    this.actionAfterSnackBar1,
    this.titleString2,
    this.leadingIconData2,
  });

  SnackBar createSnackBar1() {
    return createSnackBar(titleString1, leadingIconData1, trailingWidgets1);
  }

  SnackBar? createSnackBar2() {
    return titleString2 != null && leadingIconData2 != null
        ? createSnackBar(titleString2!, leadingIconData2!)
        : null;
  }

  SnackBar createSnackBar(
    String titleString,
    IconData leadingIconData, [
    List<Widget>? trailingWidgets,
  ]) {
    return SnackBar(
      margin: EdgeInsets.all(gap),
      padding: EdgeInsets.zero,
      duration: 3.seconds,
      content: Builder(
        builder: (BuildContext context) {
          return CustomListTile(
            backgroundColor: context.theme.colorScheme.secondary,
            textColor: context.theme.colorScheme.onSecondary,
            titleString: titleString,
            leadingIconData: leadingIconData,
            contentPadding: EdgeInsets.only(
              top: gap,
              bottom: gap,
              right: trailingWidgets != null ? gap : gap * 2,
              left: gap * 2,
            ),
            cornerRadius: radius,
            trailing: trailingWidgets != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: trailingWidgets,
                  )
                : null,
          );
        },
      ),
    );
  }
}
