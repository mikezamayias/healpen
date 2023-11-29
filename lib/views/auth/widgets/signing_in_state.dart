import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../widgets/loading_tile.dart';

class SigningInState extends StatelessWidget {
  const SigningInState({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingTile(
      durationTitle: 'Signing in',
      backgroundColor: context.theme.colorScheme.surface,
      textColor: context.theme.colorScheme.onSurface,
    );
  }
}
