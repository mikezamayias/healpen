import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../utils/constants.dart';

class ModernAppBar extends StatelessWidget {
  const ModernAppBar({
    super.key,
    required this.onBackgroundColor,
  });

  final Color onBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: radius,
        right: radius,
        bottom: radius / 2,
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Healpen',
        style: context.theme.textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w700,
          color: onBackgroundColor,
        ),
      ),
    );
  }
}
