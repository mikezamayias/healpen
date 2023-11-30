import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/constants.dart';

class OnboardingScreenView extends ConsumerWidget {
  const OnboardingScreenView({
    super.key,
    required this.onboardingScreenModel,
  });

  final OnboardingModel onboardingScreenModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(gap * 2),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            onboardingScreenModel.imagePath,
            fit: BoxFit.contain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedOpacity(
                duration: standardDuration,
                curve: standardCurve,
                opacity: onboardingScreenModel ==
                        OnboardingController().currentOnboardingScreenModel(
                            ref.watch(OnboardingController()
                                .currentPageIndexProvider))
                    ? 1
                    : 0,
                child: Text(
                  onboardingScreenModel.title,
                  textAlign: TextAlign.start,
                  style: context.theme.textTheme.headlineSmall!.copyWith(
                    color: context.theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: standardDuration,
                curve: standardCurve,
                opacity: onboardingScreenModel ==
                        OnboardingController().currentOnboardingScreenModel(
                            ref.watch(OnboardingController()
                                .currentPageIndexProvider))
                    ? 1
                    : 0,
                child: Text(
                  onboardingScreenModel.description,
                  textAlign: TextAlign.start,
                  style: context.theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
