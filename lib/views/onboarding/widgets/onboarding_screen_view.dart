import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../models/onboarding/onboarding_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
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
            Row(
              mainAxisSize: onboardingScreenModel.actions.length == 1
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: onboardingScreenModel.actions
                  .map(
                    (OnboardingActionModel action) => OnboardingButton(
                      titleString: action.title,
                      onTap: () {
                        int currentIndex = ref.read(
                            OnboardingController().currentPageIndexProvider);
                        int viewsLength = OnboardingController.views.length;
                        int nextIndex = currentIndex + 1;
                        if (nextIndex > viewsLength - 1) {
                          nextIndex = 0;
                        }
                        ref
                            .read(OnboardingController()
                                .currentPageIndexProvider
                                .notifier)
                            .state = nextIndex;
                        pushWithAnimation(
                          context: context,
                          widget:
                              OnboardingController.views.elementAt(nextIndex),
                          replacement: true,
                          dataCallback: null,
                        );
                      },
                    ),
                  )
                  .toList(),
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
