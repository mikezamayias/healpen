import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings/preferences_controller.dart';

class VibrateController extends StateNotifier<bool> {
  VibrateController()
      : super(PreferencesController.navigationEnableHapticFeedback.value);

  void run(VoidCallback callback) {
    if (state) {
      HapticFeedback.mediumImpact().whenComplete(() {
        callback();
      });
    } else {
      callback();
    }
  }
}
