import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

import '../utils/constants.dart' as constants;

class ConditionalChip extends StatelessWidget {
  const ConditionalChip({
    Key? key,
    required this.label,
    required this.condition,
    this.onTap,
  }) : super(key: key);

  final String label;
  final bool condition;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleGestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: constants.curve,
        duration: constants.duration,
        padding: EdgeInsets.symmetric(
          horizontal: constants.gap * 1.8,
          vertical: constants.gap,
        ),
        decoration: BoxDecoration(
          color: condition
              ? context.theme.colorScheme.primary
              : context.theme.colorScheme.background,
          borderRadius: BorderRadius.circular(constants.radius - constants.gap),
          border: Border.all(
            color: condition
                ? context.theme.colorScheme.primary
                : context.theme.colorScheme.outline,
            width: 3,
          ),
        ),
        child: Text(
          label,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: condition
                ? context.theme.colorScheme.onPrimary
                : context.theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
