import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../utils/constants.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key? key,
    required this.label,
    this.condition,
    this.onTap,
  }) : super(key: key);

  final String label;
  final bool? condition;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: curve,
        duration: animationDuration.milliseconds,
        padding: EdgeInsets.symmetric(
          horizontal: gap * 1.8,
          vertical: gap,
        ),
        decoration: BoxDecoration(
          color: switch (condition) {
            false => context.theme.colorScheme.background,
            _ => context.theme.colorScheme.primary,
          },
          borderRadius: BorderRadius.circular(radius - gap),
          border: Border.all(
            color: switch (condition) {
              false => context.theme.colorScheme.outline,
              _ => context.theme.colorScheme.primary,
            },
            width: 3,
          ),
        ),
        child: Text(
          label,
          style: context.theme.textTheme.titleMedium?.copyWith(
            // color: condition
            //     ? context.theme.colorScheme.onPrimary
            //     : context.theme.colorScheme.onSurface,
            color: switch (condition) {
              false => context.theme.colorScheme.onSurface,
              _ => context.theme.colorScheme.onPrimary,
            },
          ),
        ),
      ),
    );
  }
}
