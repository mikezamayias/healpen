import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'healpen_wrapper.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

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
