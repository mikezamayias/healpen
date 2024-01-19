import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/constants.dart';
import '../../blueprint/blueprint_view.dart';
import 'onboarding_button.dart';

class OnboardingScreenView extends ConsumerWidget {
  final OnboardingModel onboardingScreenModel;
  const OnboardingScreenView({
    super.key,
    required this.onboardingScreenModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      padBodyHorizontally: false,
      body: Padding(
        padding: EdgeInsets.all(radius),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 21.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30.w,
                    width: 30.w,
                    alignment: Alignment.bottomLeft,
                    child: onboardingScreenModel.hero,
                  ),
                  SizedBox(height: gap),
                  Text(
                    onboardingScreenModel.title,
                    textAlign: TextAlign.start,
                    style: context.theme.textTheme.headlineSmall!.copyWith(
                      color: context.theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    onboardingScreenModel.description,
                    textAlign: TextAlign.start,
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      color: context.theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            OnboardingButton(
              titleString: onboardingScreenModel.actionText,
              onTap: onboardingScreenModel.actionCallback,
            ),
          ],
        ),
      )
          .animate()
          .slideX(
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            begin: 0.5.w,
            end: 0,
          )
          .fade(duration: longEmphasizedDuration, curve: emphasizedCurve)
          .scale(
            duration: emphasizedDuration,
            curve: emphasizedCurve,
            begin: const Offset(2, 2),
            end: const Offset(1, 1),
          ),
    );
  }
}
