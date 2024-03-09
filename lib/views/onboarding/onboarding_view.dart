import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/onboarding/onboarding_controller.dart';
import '../blueprint/blueprint_view.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      padBodyHorizontally: false,
      body: PageView.builder(
        clipBehavior: Clip.none,
        controller: ref.watch(OnboardingController().pageControllerProvider),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: OnboardingController.views.length,
        itemBuilder: (context, index) => OnboardingController.views[index],
      ),
    );
  }
}
