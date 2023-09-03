import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final double unit = 4.2.sp;
final double gap = 9 * unit;
final double radius = 30 - gap;
final double elevation = 0 * unit;
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// The curve used for most small UI animations.
const Curve standardCurve = Cubic(0.2, 0.0, 0, 1.0);

/// The shortest duration used with Standard curve, 50 milliseconds.
final Duration shortStandardDuration = 50.milliseconds;

/// The slightly shorter duration used with Standard curve, 100
/// milliseconds.
final Duration slightlyShortStandardDuration = 100.milliseconds;

/// The duration used with Standard curve, 200 milliseconds.
final Duration standardDuration = 200.milliseconds;

/// The curve used for most big UI animations.
const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;

/// The duration used with Emphasized curve, 500 milliseconds.
final Duration emphasizedDuration = 500.milliseconds;

/// The slightly longer duration used with Emphasized curve, 700 milliseconds.
final Duration slightlyLongEmphasizedDuration = 700.milliseconds;

/// The longer duration used with Emphasized curve, 1000 milliseconds.
final Duration longEmphasizedDuration = 1000.milliseconds;
