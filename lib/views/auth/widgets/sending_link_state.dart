import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../widgets/loading_tile.dart';

class SendingLinkState extends StatelessWidget {
  const SendingLinkState({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingTile(
      durationTitle: 'Sending link to your email',
      backgroundColor: context.theme.colorScheme.surface,
      textColor: context.theme.colorScheme.onSurface,
    );
  }
}
