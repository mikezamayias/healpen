import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionalEchoController {
  /// Singleton Constructor
  static final EmotionalEchoController _instance =
      EmotionalEchoController._internal();
  factory EmotionalEchoController() => _instance;
  EmotionalEchoController._internal();

  /// Attributes
  static late double sentiment;
  static late Color goodColor;
  static late Color onGoodColor;
  static late Color badColor;
  static late Color onBadColor;
  static final isPressedProvider = StateProvider<bool>((ref) => false);

  /// Methods
}
