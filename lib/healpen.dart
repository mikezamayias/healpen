import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/healpen/healpen_controller.dart';
import 'controllers/page_controller.dart' as page_controller;
import 'providers/settings_providers.dart';
import 'utils/constants.dart';
import 'utils/helper_functions.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

class Healpen extends ConsumerWidget {
  const Healpen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Animate> pages = [
      for (final page in page_controller.PageController().pages)
        page.widget
            .animate()
            .fade(duration: emphasizedDuration, curve: emphasizedCurve),
    ];
    return Scaffold(
      body: PageView.builder(
        controller: ref.watch(HealpenController().pageControllerProvider),
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
            ref
                .watch(HealpenController().currentPageIndexProvider.notifier)
                .state = value;
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return AnimatedOpacity(
            duration: slightlyLongEmphasizedDuration,
            curve: emphasizedCurve,
            opacity:
                ref.watch(HealpenController().currentPageIndexProvider) == index
                    ? 1
                    : 0,
            child: pages.elementAt(index),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
