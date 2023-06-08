import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../utils/constants.dart' as constants;

class AnimatedItem extends StatelessWidget {
  final Widget child;

  const AnimatedItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: constants.duration,
      curve: constants.curve,
      child: child,
    );
  }
}
