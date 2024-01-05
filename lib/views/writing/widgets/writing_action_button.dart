import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class WritingActionButton extends ConsumerWidget {
  final String? titleString;
  final IconData? iconData;
  final Widget? child;
  final bool? condition;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const WritingActionButton.withIcon({
    super.key,
    required this.titleString,
    required this.iconData,
    this.condition,
    this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
  }) : child = null;

  const WritingActionButton.withWidget({
    super.key,
    required this.titleString,
    required this.child,
  })  : iconData = null,
        condition = null,
        onTap = null,
        backgroundColor = null,
        foregroundColor = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    final isKeyboardOpen =
        ref.watch(WritingController().isKeyboardOpenProvider);
    return CustomListTile(
      responsiveWidth: child == null,
      useSmallerNavigationSetting: false,
      titleString: titleString,
      trailing: child,
      trailingIconData: iconData,
      cornerRadius:
          isKeyboardOpen || smallNavigationElements ? radius : radius - gap,
      contentPadding:
          smallNavigationElements ? EdgeInsets.all(radius - gap) : null,
      backgroundColor: condition != null && condition!
          ? backgroundColor
          : context.theme.colorScheme.outline,
      textColor: condition != null && condition!
          ? foregroundColor
          : context.theme.colorScheme.onPrimary,
      onTap: condition != null && condition!
          ? onTap == null
              ? null
              : () {
                  showHealpenDialog<bool>(
                    context: context,
                    customDialog: CustomDialog(
                      titleString: 'Are you sure?',
                      contentString: 'This action cannot be undone.',
                      textColor: backgroundColor,
                      actions: <CustomListTile>[
                        CustomListTile(
                          responsiveWidth: true,
                          titleString: titleString,
                          textColor: foregroundColor,
                          backgroundColor: backgroundColor,
                          cornerRadius: radius - gap,
                          onTap: () {
                            context.navigator.pop(true);
                          },
                        ),
                        CustomListTile(
                          responsiveWidth: true,
                          titleString: 'Cancel',
                          cornerRadius: radius - gap,
                          onTap: () {
                            context.navigator.pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then((bool? value) {
                    logger.i(
                      'WritingActionButton: showHealpenDialog: value: $value',
                    );
                    if (value != null && value) {
                      onTap!();
                    }
                  });
                }
          : null,
    );
  }
}
