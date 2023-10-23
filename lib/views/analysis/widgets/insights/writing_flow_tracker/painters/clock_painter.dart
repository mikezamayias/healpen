import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';

import '../../../../../../services/data_analysis_service.dart';
import '../../../../../../utils/constants.dart';

class ClockPainter extends CustomPainter {
  final List<HourlyData> hourlyData;
  final ThemeData theme;

  ClockPainter({
    required this.hourlyData,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final textStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    for (int i = 0; i < hourlyData.length; i++) {
      final HourlyData currentData = hourlyData.elementAt(i);
      HourlyData? previousData;
      if (i > 0) {
        previousData = hourlyData.elementAt(i - 1);
      }
      final stroke = radius *
          currentData.totalWritingTime /
          (60 * 60); // Adjust this formula to your needs
      log(
        currentData.averageSentiment.toString(),
        name: 'log:data.averageSentiment',
      );
      final angle = 2 * pi * (currentData.hour - 6) / 24;
      final paint = Paint()
        ..color = switch (previousData != null) {
          true => Color.alphaBlend(
              getColor(currentData.averageSentiment),
              getColor(previousData!.averageSentiment),
            ),
          false => getColor(currentData.averageSentiment),
        }
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
        text: '${currentData.hour}',
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
    return theme.colorScheme.onSurfaceVariant;
    // return switch (sentiment == null) {
    //   true => theme.colorScheme.outline,
    //   false => Color.lerp(
    //       ref.read(themeProvider).colorScheme.error,
    //       ref.read(themeProvider).colorScheme.primary,
    //       (sentiment! + 3) / (sentimentLabels.length - 1),
    //     )!,
    // };
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Adjust this to your needs
  }
}