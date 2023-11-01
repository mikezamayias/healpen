import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'services/firebase_service.dart';
import 'wrappers/healpen_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

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
