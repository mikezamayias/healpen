import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../extensions/widget_extensions.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30.w,
                    width: 30.w,
                    alignment: Alignment.bottomLeft,
                    child: onboardingScreenModel.hero,
                  ),
                  Text(
                    onboardingScreenModel.title,
                    textAlign: TextAlign.start,
                    style: context.theme.textTheme.headlineMedium!.copyWith(
                      color: context.theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate(delay: longEmphasizedDuration)
                      .fade(
                        duration: emphasizedDuration,
                        curve: emphasizedCurve,
                      )
                      .slideY(
                        duration: emphasizedDuration,
                        curve: emphasizedCurve,
                        begin: -0.5,
                        end: 0,
                      ),
                  Text(
                    onboardingScreenModel.description,
                    textAlign: TextAlign.start,
                    style: context.theme.textTheme.bodyLarge,
                  )
                      .animate(delay: slightlyLongEmphasizedDuration * 2)
                      .fade(
                        duration: emphasizedDuration,
                        curve: emphasizedCurve,
                      )
                      .slideY(
                        duration: emphasizedDuration,
                        curve: emphasizedCurve,
                        begin: -0.1,
                        end: 0,
                      ),
                ].addSpacer(
                  SizedBox(height: radius),
                  spacerAtEnd: false,
                  spacerAtStart: false,
                ),
              ),
            ),
            OnboardingButton(
              titleString: onboardingScreenModel.actionText,
              onTap: onboardingScreenModel.actionCallback,
            )
          ],
        ),
      ),
    );
  }
}
