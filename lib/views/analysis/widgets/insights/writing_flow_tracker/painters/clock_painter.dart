import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../providers/settings_providers.dart';
import '../../../../../../services/data_analysis_service.dart';
import '../../../../../../utils/constants.dart';

class ClockPainter extends CustomPainter {
  static final ref = ProviderContainer();
  final theme = ref.read(themeProvider);

  final List<HourlyData> hourlyData;

  ClockPainter(this.hourlyData);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final textStyle = theme.textTheme.labelLarge;
    for (final data in hourlyData) {
      final stroke = radius *
          data.totalWritingTime /
          (60 * 60); // Adjust this formula to your needs
      log(
        data.averageSentiment.toString(),
        name: 'log:data.averageSentiment',
      );
      final angle = 2 * pi * (data.hour - 6) / 24;
      final paint = Paint()
        ..color = getColor(data.averageSentiment)
        ..style = PaintingStyle.stroke
        ..strokeWidth = gap / 2
        ..strokeCap = StrokeCap.round; // Add this line
      final startOffset = Offset(
        center.dx,
        center.dy,
      );
      final endOffset = Offset(
        center.dx + radius * stroke.clamp(0.1, 0.78) * cos(angle),
        center.dy + radius * stroke.clamp(0.1, 0.78) * sin(angle),
      );
      canvas.drawLine(startOffset, endOffset, paint);
      final textSpan = TextSpan(
        text: '${data.hour}',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textOffset = Offset(
        center.dx + (radius * 0.9) * cos(angle) - textPainter.width / 2,
        center.dy + (radius * 0.9) * sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  Color getColor(double? sentiment) {
    // return Color.lerp(
    //   ref.read(themeProvider).colorScheme.error,
    //   ref.read(themeProvider).colorScheme.primary,
    //   (sentiment + 3) / (sentimentLabels.length - 1),
    // )!;
    return switch (sentiment == null) {
      true => theme.colorScheme.outlineVariant,
      false => theme.colorScheme.outline
    };
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Adjust this to your needs
  }
}
