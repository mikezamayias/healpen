import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';
import '../widgets/custom_list_tile.dart';

extension ContextExtensions on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar({
    required String message,
    String? explanation,
  }) {
    return showSnackBar(
      leadingIconData: FontAwesomeIcons.circleExclamation,
      message: message,
      explanation: explanation,
      backgroundColor: colorScheme.error,
      foregroundColor: colorScheme.onError,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showSuccessSnackBar({
    required String message,
    String? explanation,
  }) {
    return showSnackBar(
      leadingIconData: FontAwesomeIcons.solidCircleCheck,
      message: message,
      explanation: explanation,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar({
    required IconData leadingIconData,
    required String message,
    String? explanation,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: 6.seconds,
        margin: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: gap),
        content: CustomListTile(
          contentPadding: EdgeInsets.all(radius - gap),
          selectableText: explanation != null,
          leadingIconData: leadingIconData,
          titleString: message,
          explanationString: explanation,
          backgroundColor: backgroundColor,
          textColor: foregroundColor,
          trailing: explanation != null
              ? CustomListTile(
                  responsiveWidth: true,
                  backgroundColor: foregroundColor,
                  textColor: backgroundColor,
                  titleString: 'Copy message',
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: '$message\n$explanation'),
                    ).then(
                      (_) {
                        ScaffoldMessenger.of(this).clearSnackBars();
                        showSuccessSnackBar(message: 'Copied to clipboard');
                      },
                    ).catchError(
                      (error) {
                        ScaffoldMessenger.of(this).clearSnackBars();
                        showErrorSnackBar(
                          message: 'Error while copying to clipboard',
                          explanation: error.toString(),
                        );
                      },
                    );
                  })
              : null,
        ),
      ),
    );
  }
}
