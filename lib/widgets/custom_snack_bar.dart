import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../controllers/vibrate_controller.dart';
import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomSnackBar {
  final SnackBarConfig _snackBarConfig;

  CustomSnackBar(this._snackBarConfig);

  Future<void> showSnackBar(BuildContext context) async {
    final snackBar1 = _snackBarConfig.createSnackBar1();
    final snackBar2 = _snackBarConfig.createSnackBar2();
    VibrateController().run(() async {
      final SnackBarClosedReason snackBar1ClosedReasonFuture =
          await scaffoldMessengerKey.currentState!
              .showSnackBar(snackBar1)
              .closed;
      snackBar1ClosedReasonFuture;
      if (snackBar1ClosedReasonFuture != SnackBarClosedReason.remove) {
        if (_snackBarConfig.actionAfterSnackBar1 != null) {
          await _snackBarConfig.actionAfterSnackBar1!();

          if (snackBar2 != null) {
            VibrateController().run(() {
              scaffoldMessengerKey.currentState!.showSnackBar(snackBar2);
            });
          }
        }
      }
    });
  }
}

class SnackBarConfig {
  final bool smallNavigationElements;
  final String titleString1;
  final IconData leadingIconData1;
  final List<
          ({IconData? iconData, String? titleString, void Function()? onTap})>?
      trailingWidgets1;
  final EdgeInsets? snackBarMargin;
  final Future Function()? actionAfterSnackBar1;

  final String? titleString2;
  final IconData? leadingIconData2;

  SnackBarConfig({
    required this.smallNavigationElements,
    required this.titleString1,
    required this.leadingIconData1,
    this.trailingWidgets1,
    this.snackBarMargin,
    this.actionAfterSnackBar1,
    this.titleString2,
    this.leadingIconData2,
  });

  SnackBar createSnackBar1() {
    return createSnackBar(
      titleString1,
      leadingIconData1,
      snackBarMargin,
      trailingWidgets1,
    );
  }

  SnackBar? createSnackBar2() {
    return titleString2 != null && leadingIconData2 != null
        ? createSnackBar(titleString2!, leadingIconData2!, snackBarMargin)
        : null;
  }

  SnackBar createSnackBar(
    String titleString,
    IconData leadingIconData, [
    EdgeInsets? snackBarMargin,
    List<
            ({
              IconData? iconData,
              String? titleString,
              void Function()? onTap,
            })>?
        trailingWidgets,
  ]) {
    return SnackBar(
      margin:
          scaffoldMessengerKey.currentContext!.mediaQuery.viewInsets.bottom == 0
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  bottom: gap,
                  right: gap,
                  left: gap,
                ),
      padding:
          scaffoldMessengerKey.currentContext!.mediaQuery.viewInsets.bottom == 0
              ? EdgeInsets.zero
              : EdgeInsets.zero,
      duration: 4.seconds,
      content: Builder(
        builder: (BuildContext context) {
          return CustomListTile(
            useSmallerNavigationSetting: false,
            contentPadding: EdgeInsets.all(gap),
            backgroundColor: context.theme.colorScheme.secondary,
            textColor: context.theme.colorScheme.onSecondary,
            titleString: titleString,
            leadingIconData: leadingIconData,
            trailing: trailingWidgets != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (final e in trailingWidgets)
                        CustomListTile(
                          useSmallerNavigationSetting: false,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: gap,
                            vertical: gap,
                          ),
                          cornerRadius: radius - gap,
                          responsiveWidth: true,
                          backgroundColor:
                              context.theme.colorScheme.primaryContainer,
                          textColor:
                              context.theme.colorScheme.onPrimaryContainer,
                          onTap: e.onTap,
                          titleString: e.titleString,
                          leadingIconData: e.iconData,
                        ),
                    ],
                  )
                : null,
          );
        },
      ),
    );
  }
}
