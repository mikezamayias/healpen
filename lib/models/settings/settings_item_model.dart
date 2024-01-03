import 'package:flutter/material.dart';

import '../../utils/helper_functions.dart';

class SettingsItemModel {
  SettingsItemModel({
    required this.title,
    required this.leadingIconData,
    required this.description,
    this.onTap,
  }) : widget = null;

  SettingsItemModel.withWidget({
    required this.title,
    required this.leadingIconData,
    required this.description,
    required this.widget,
  }) : onTap = ((BuildContext context) {
          pushWithAnimation(
            context: context,
            widget: widget!,
            dataCallback: null,
          );
        });

  final String title;
  final String description;
  final IconData leadingIconData;
  final Function(BuildContext context)? onTap;

  final Widget? widget;
}
