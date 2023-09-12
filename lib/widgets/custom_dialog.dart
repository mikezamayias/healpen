import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart';
import 'custom_list_tile.dart';

class CustomDialog extends StatelessWidget {
  final String titleString;
  final String? contentString;
  final Color? backgroundColor;
  final List<CustomListTile> actions;

  const CustomDialog({
    super.key,
    required this.titleString,
    this.contentString,
    this.backgroundColor,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: gap * 2,
        sigmaY: gap * 2,
      ),
      child: Dialog(
        insetPadding: EdgeInsets.all(gap * 2),
        elevation: 0,
        backgroundColor:
            backgroundColor ?? context.theme.colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: EdgeInsets.all(gap),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                titleString,
                style: context.theme.textTheme.headlineSmall!.copyWith(
                  color: context.theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.start,
              ),
              if (contentString != null) ...[
                SizedBox(height: gap),
                Container(
                  padding: EdgeInsets.all(gap),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.background,
                    borderRadius: BorderRadius.circular(radius - gap),
                  ),
                  child: Text(
                    contentString!,
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
              if (actions.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(top: gap),
                  child: Row(
                    // add a sized box between children to add space between them
                    children: [
                      for (int i = 0; i < actions.length; i++) ...[
                        actions[i],
                        if (i != actions.length - 1) ...[
                          SizedBox(width: gap),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
