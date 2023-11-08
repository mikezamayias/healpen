import 'package:flutter_riverpod/flutter_riverpod.dart';

final emotionalEchoControllerProvider =
    StateProvider<EmotionalEchoController>((ref) => EmotionalEchoController());

class EmotionalEchoController {
  /// Singleton Constructor
  static final EmotionalEchoController _instance =
      EmotionalEchoController._internal();
  factory EmotionalEchoController() => _instance;
  EmotionalEchoController._internal();

  /// Attributes
  static final isPressedProvider = StateProvider<bool>((ref) => false);
  double sentimentScore = 0;
}
