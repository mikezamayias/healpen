import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';

class OnboardingButton extends StatelessWidget {
  final String titleString;
  final VoidCallback? onTap;

  const OnboardingButton({
    super.key,
    required this.titleString,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      responsiveWidth: true,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
      ),
      titleString: titleString,
    );
  }
}
