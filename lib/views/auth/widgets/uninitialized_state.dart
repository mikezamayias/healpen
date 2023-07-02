import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class UninitializedState extends ConsumerWidget {
  final EmailLinkAuthProvider provider;

  const UninitializedState({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String emailAddress = '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          cornerRadius: radius,
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          leadingIconData: FontAwesomeIcons.solidEnvelope,
          title: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: 'Email',
              hintStyle: context.theme.textTheme.titleLarge,
            ),
            style: context.theme.textTheme.titleLarge,
            onChanged: (String value) => emailAddress = value,
          ),
        ),
        SizedBox(height: gap),
        CustomListTile(
          responsiveWidth: true,
          titleString: 'Send link',
          cornerRadius: radius,
          contentPadding: EdgeInsets.symmetric(
            vertical: gap,
            horizontal: gap * 2,
          ),
          leadingIconData: FontAwesomeIcons.solidPaperPlane,
          onTap: () => provider.sendLink(emailAddress),
        ),
      ],
    );
  }
}
