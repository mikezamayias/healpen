import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../models/snack_bar_options.dart';
import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomSnackBar {
  static final Queue<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>
      _snackBarQueue = Queue();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    BuildContext context, {
    required String message,
    required IconData icon,
    VoidCallback? onActionTap,
    String actionLabel = 'Undo',
  }) {
    final snackBar = SnackBar(
      margin: EdgeInsets.all(gap),
      padding: EdgeInsets.only(right: gap * 2),
      duration: 2.seconds,
      backgroundColor: context.theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      content: CustomListTile(
        backgroundColor: context.theme.colorScheme.secondary,
        textColor: context.theme.colorScheme.onSecondary,
        titleString: message,
        leadingIconData: icon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: gap * 2,
          vertical: gap,
        ),
        cornerRadius: radius,
      ),
      action: onActionTap != null
          ? SnackBarAction(
              label: 'Undo',
              onPressed: onActionTap,
            )
          : null,
    );

    final snackBarController =
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _snackBarQueue.add(snackBarController);

    return snackBarController;
  }

  static void doActionAndShowSnackBar(
    BuildContext context, {
    required Future Function() doAction,
    required SnackBarOptions options,
    required dynamic afterSnackBar,
  }) {
    bool continuteWithAction = true;
    final firstSnackBarController = showSnackBar(
      context,
      message: options.message,
      icon: options.icon,
      onActionTap: () {
        continuteWithAction = false;
      },
    );

    if (continuteWithAction) {
      firstSnackBarController.closed.then((SnackBarClosedReason reason) async {
        if (reason != SnackBarClosedReason.action) {
          // After the first snackbar is dismissed, we show the second one.
          afterSnackBar();
          // And then we do the action.
          await doAction();
        }
      });
    }
  }
}
