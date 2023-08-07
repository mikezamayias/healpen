import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sprung/sprung.dart';

import '../utils/constants.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> animateWidgetList() =>
      animate(interval: 15.milliseconds)
          .fade(curve: curve)
          .slideX(begin: 0.6, curve: curve)
          .scale(
            begin: const Offset(0, 0),
            duration: 60.milliseconds,
          );

  List<Widget> animateLicences() =>
      animate(interval: animationDuration.microseconds)
          .fade(
            begin: 0,
          )
          .scale(begin: const Offset(0, 0), curve: Sprung.overDamped)
          .slideX(begin: -10, curve: Sprung.overDamped);
}

extension WidgetExtensions on Widget {
  Widget animateSlideInFromLeft() => animate()
      .fade(duration: animationDuration.milliseconds)
      .slideX(begin: 1, curve: curve);

  Widget animateSlideInFromRight() => animate()
      .fade(duration: animationDuration.microseconds)
      .slideX(begin: -0.6, curve: curve);

  Widget animateSlideInFromBottom() => animate()
      .fade(duration: animationDuration.microseconds)
      .slideY(begin: 10, curve: curve);

  Widget animateSlideInFromTop() => animate()
      .fade(duration: animationDuration.milliseconds)
      .slideY(begin: -10, curve: curve);

  Widget animateBottomNavigationBar(BuildContext context) =>
      animateSlideInFromTop().animate();

  // animateSlideInFromTop().animate().elevation(
  //       end: 90,
  //       duration: animationDuration.microseconds,
  //       curve: curve,
  //       color: context.theme.colorScheme.primary,
  //       borderRadius: BorderRadius.all(Radius.circular(radius)),
  //     );

  Widget animateAppBar() => animateSlideInFromTop()
      .animate()
      .fade(begin: -1, curve: curve)
      .slideY(begin: -1, curve: curve)
      .scale(
        begin: const Offset(0.6, 0.6),
        duration: animationDuration.milliseconds,
      );
}
