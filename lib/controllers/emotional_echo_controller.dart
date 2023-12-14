import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionalEchoController {
  /// Singleton Constructor
  static final EmotionalEchoController _instance =
      EmotionalEchoController._internal();
  factory EmotionalEchoController() => _instance;
  EmotionalEchoController._internal();

  /// Attributes
  static final isPressedProvider = StateProvider<bool>((ref) => false);
  static final scoreProvider = StateProvider<double>((ref) => 0);
}
