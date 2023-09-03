import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/constants.dart';

class OnboardingScreenView extends StatelessWidget {
  const OnboardingScreenView({
    super.key,
    required this.onboardingScreenModel,
  });

  final OnboardingModel onboardingScreenModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(gap),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: EdgeInsets.all(gap * 2),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              onboardingScreenModel.imagePath,
              width: 100.w,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: gap * 4),
            Text(
              onboardingScreenModel.title,
              style: context.theme.textTheme.headlineSmall!.copyWith(
                color: context.theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              onboardingScreenModel.description,
              style: context.theme.textTheme.bodyLarge,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
