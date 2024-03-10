import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validated/validated.dart' as validate;

import '../../../providers/custom_auth_provider.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import 'legal_prompt.dart';

class UninitializedState extends ConsumerWidget {
  const UninitializedState({super.key});

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
            contentPadding: EdgeInsets.symmetric(
              horizontal: gap * 2,
              vertical: gap,
            ),
            leadingIconData: FontAwesomeIcons.solidEnvelope,
            // backgroundColor: context.theme.colorScheme.surface,
            textColor: context.theme.colorScheme.onSurface,
            title: IntrinsicWidth(
              child: TextFormField(
                autofocus: false,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: gap),
            child: CustomListTile(
              backgroundColor: context.theme.colorScheme.surface,
              title: const LegalPrompt(),
            ),
          ),
          Center(
            child: CustomListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: gap * 2,
                vertical: gap,
              ),
              responsiveWidth: true,
              titleString: 'Send link',
              leadingIconData: FontAwesomeIcons.solidPaperPlane,
              onTap: ref.watch(isDeviceConnectedProvider)
                  ? () {
                      if (formKey.currentState!.validate()) {
                        ref
                            .watch(CustomAuthProvider().emailLinkAuthProvider)
                            .sendLink(emailAddress);
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
