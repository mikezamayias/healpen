import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../controllers/writing_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class WritingActionButton extends ConsumerWidget {
  final String? titleString;
  final IconData? iconData;
  final Widget? child;
  final bool? condition;
  final void Function()? onTap;
  final Color? activeColor;

  const WritingActionButton.withIcon({
    super.key,
    required this.titleString,
    required this.iconData,
    this.condition,
    this.onTap,
    this.activeColor,
  }) : child = null;

  const WritingActionButton.withWidget({
    super.key,
    required this.titleString,
    required this.child,
  })  : iconData = null,
        condition = null,
        onTap = null,
        activeColor = null;

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
          ? activeColor
          : context.theme.colorScheme.outline,
      textColor: condition != null && condition!
          ? context.theme.colorScheme.onPrimary
          : context.theme.colorScheme.onPrimary,
      onTap: condition != null && condition! ? onTap : null,
    );
  }
}
