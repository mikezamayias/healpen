import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../providers/settings_providers.dart';
import '../../../widgets/custom_list_tile.dart';

class ActionButton extends ConsumerWidget {
  final String? titleString;
  final IconData leadingIconData;
  final bool condition;
  final void Function() onTap;
  final Color? activeColor;

  const ActionButton({
    super.key,
    this.titleString,
    required this.leadingIconData,
    required this.condition,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useSimpleUi = ref.watch(navigationSimpleUIProvider);
    return CustomListTile(
      responsiveWidth: true,
      useSmallerNavigationSetting: false,
      titleString: titleString,
      leadingIconData: leadingIconData,
      cornerRadius: 0,
      contentPadding: EdgeInsets.zero,
      backgroundColor: !useSimpleUi
          ? context.theme.colorScheme.surfaceVariant
          : context.theme.colorScheme.surface,
      textColor: condition
          ? activeColor ?? context.theme.colorScheme.primary
          : context.theme.colorScheme.outline,
      onTap: onTap,
    );
  }
}
