import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'env/env.dart';
import 'healpen_wrapper.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();
  OpenAI.apiKey = Env.openAiApiKey;

  Animate.restartOnHotReload = true;

  runApp(
    ProviderScope(
      child: Iterum(
        child: ResponsiveSizer(
          builder: (
            BuildContext context,
            Orientation orientation,
            ScreenType screenType,
          ) {
            return const HealpenWrapper();
          },
        ),
      ),
    ),
  );
}
