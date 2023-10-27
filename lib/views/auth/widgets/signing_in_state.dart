import 'package:flutter/material.dart';

import '../../../widgets/loading_tile.dart';

class SigningInState extends StatelessWidget {
  const SigningInState({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingTile(
      durationTitle: 'Signing in',
    );
  }
}
