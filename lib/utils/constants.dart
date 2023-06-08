import 'package:flutter/animation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sprung/sprung.dart';

final double unit = 4.2.sp;
final double gap = 9 * unit;
final double radius = 30 - gap;
final double elevation = 0 * unit;
const int animationDuration = 150;
const Duration duration = Duration(milliseconds: animationDuration);
final Curve curve = Sprung.overDamped;
