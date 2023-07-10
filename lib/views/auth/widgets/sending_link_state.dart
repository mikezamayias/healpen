import 'package:flutter/material.dart';

import '../../../widgets/loading_tile.dart';

class SendingLinkState extends StatelessWidget {
  const SendingLinkState({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingTile(
      durationTitle: 'Sending link to your email',
    );
  }
}
