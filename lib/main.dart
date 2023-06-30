import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'healpen_wrapper.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initialize();

  Magic.instance = Magic('pk_live_0C5A55F503F795D9');

  runApp(
    ProviderScope(
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
  );
}
