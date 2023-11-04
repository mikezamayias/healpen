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

  List<Widget> animateLicences() => animate(interval: standardDuration)
      .fade(
        begin: 0,
      )
      .scale(
        begin: const Offset(0, 0),
        curve: emphasizedCurve,
      )
      .slideX(
        begin: -10,
        curve: emphasizedCurve,
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

  // animateSlideInFromTop().animate().elevation(
  //       end: 90,
  //       duration: animationDuration.microseconds,
  //       curve: curve,
  //       color: context.theme.colorScheme.primary,
  //       borderRadius: BorderRadius.all(Radius.circular(radius)),
  //     );

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
