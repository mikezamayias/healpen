import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class AwaitingDynamicLinkState extends StatelessWidget {
  const AwaitingDynamicLinkState({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      cornerRadius: radius,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      leadingIconData: FontAwesomeIcons.solidEnvelopeOpen,
      titleString: 'We\'ve sent you an email with a magic link.',
      subtitleString: 'Please check your email and follow the link to sign in.',
    );
  }
}
