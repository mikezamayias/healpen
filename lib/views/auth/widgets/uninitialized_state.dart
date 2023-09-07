import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validate;

import '../../../providers/custom_auth_provider.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class UninitializedState extends ConsumerWidget {
  const UninitializedState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String emailAddress = '';
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomListTile(
            leadingIconData: FontAwesomeIcons.solidEnvelope,
            backgroundColor: context.theme.colorScheme.surfaceVariant,
            textColor: context.theme.colorScheme.onSurfaceVariant,
            title: IntrinsicWidth(
              child: TextFormField(
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Email',
                  hintStyle: context.theme.textTheme.titleLarge,
                ),
                style: context.theme.textTheme.titleLarge,
                onChanged: (String value) => emailAddress = value,
                validator: (value) {
                  if (validate.isEmail('$value')) {
                    return null;
                  } else {
                    return 'Please enter a valid email address';
                  }
                },
              ),
            ),
          ),
          SizedBox(height: gap),
          CustomListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
            responsiveWidth: true,
            titleString: 'Send link',
            leadingIconData: FontAwesomeIcons.solidPaperPlane,
            onTap: () {
              if (formKey.currentState!.validate()) {
                vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                  ref
                      .watch(CustomAuthProvider().emailLinkAuthProvider)
                      .sendLink(emailAddress);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
