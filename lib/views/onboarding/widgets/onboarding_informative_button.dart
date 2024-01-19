import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../widgets/custom_list_tile.dart';

class OnboardingInformativeButton extends StatelessWidget {
  final String titleString;
  final VoidCallback onTap;

  const OnboardingInformativeButton({
    super.key,
    required this.titleString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      responsiveWidth: true,
      cornerRadius: 0,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Text(
        titleString,
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: context.theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
