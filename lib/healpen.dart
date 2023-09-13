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
    return Scaffold(
      body: PageView(
        controller: ref.watch(HealpenController().pageControllerProvider),
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
            ref
                .watch(HealpenController().currentPageIndexProvider.notifier)
                .state = value;
          });
        },
        // itemCount: page_controller.PageController().pages.length,
        // itemBuilder: (context, index) => page_controller.PageController()
        //     .pages[index]
        //     .widget
        //     .animate()
        //     .fade(duration: emphasizedDuration, curve: emphasizedCurve),
        children: [
          for (final page in page_controller.PageController().pages)
            page.widget
                .animate()
                .fade(duration: emphasizedDuration, curve: emphasizedCurve),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
