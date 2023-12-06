import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../utils/constants.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> animateWidgetList() => animate()
      .fade(curve: standardCurve)
      .scale(
        begin: const Offset(0, 0),
        duration: shortStandardDuration,
      )
      .slideY(begin: 0.6, curve: standardCurve);

  List<Widget> animateLicenses() => animate(interval: shortStandardDuration)
      .fade()
      .scale(begin: const Offset(0, 0))
      .slideX(
        begin: -10,
        curve: standardEasing,
        duration: standardDuration,
      );
}

extension WidgetExtensions on Widget {
  Widget animateSlideInFromLeft() => animate()
      .fade(duration: standardDuration)
      .slideX(begin: 1, curve: standardCurve);

  Widget animateSlideInFromRight() => animate()
      .fade(duration: standardDuration)
      .slideX(begin: -0.6, curve: standardCurve);

  Widget animateSlideInFromBottom() => animate()
      .fade(duration: standardDuration)
      .slideY(begin: 1, curve: standardCurve);

  Widget animateSlideInFromTop() => animate()
      .fade(duration: standardDuration)
      .slideY(begin: -1, curve: standardCurve);

  Widget animateBottomNavigationBar(BuildContext context) =>
      animateSlideInFromTop().animate();

  Widget animateAppBar() => animate()
      .fade(
        duration: standardDuration,
        curve: standardEasing,
      )
      .slideY(
        duration: standardDuration,
        curve: standardEasing,
        begin: -.3,
        end: 0,
      );
}
