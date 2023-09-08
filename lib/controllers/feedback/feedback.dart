import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feedback {
  // make it singleton
  static final Feedback _instance = Feedback._internal();

  factory Feedback() => _instance;

  Feedback._internal();

  // bool includeScreenshot = false;
  static final titleProvider = StateProvider<String>((ref) => '');
  static final bodyProvider = StateProvider<String>((ref) => '');
  static final screenshotPathProvider = StateProvider<String>((ref) => '');
  static final labelsProvider = StateProvider<Set<String>>((ref) => {});
  static final includeScreenshotProvider = StateProvider<bool>((ref) => false);
}
