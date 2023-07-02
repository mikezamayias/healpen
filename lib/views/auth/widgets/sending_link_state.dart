import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class SendingLinkState extends StatelessWidget {
  const SendingLinkState({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      cornerRadius: radius,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      leading: const CircularProgressIndicator(),
      titleString: 'Sending link to your email',
    );
  }
}
