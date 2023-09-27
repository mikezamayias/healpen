import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class OnboardingButton extends StatelessWidget {
  final Widget? title;
  final String? titleString;
  final VoidCallback? onTap;

  const OnboardingButton({
    super.key,
    this.title,
    this.titleString,
    this.onTap,
  }) : assert(title != null || titleString != null);

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
          title: title,
          titleString: titleString,
        ),
      ),
    );
  }
}
