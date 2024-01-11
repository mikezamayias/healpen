import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class OnboardingButton extends StatelessWidget {
  final String titleString;
  final VoidCallback onTap;

  const OnboardingButton({
    super.key,
    required this.titleString,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AnimatedSize(
        duration: emphasizedDuration,
        reverseDuration: emphasizedDuration,
        curve: emphasizedCurve,
        child: CustomListTile(
          responsiveWidth: true,
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          title: Text(
            titleString,
            style: context.theme.textTheme.titleLarge!.copyWith(
              color: context.theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
