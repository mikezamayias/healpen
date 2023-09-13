import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class AwaitingDynamicLinkState extends ConsumerWidget {
  const AwaitingDynamicLinkState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomListTile(
          leadingIconData: FontAwesomeIcons.solidEnvelopeOpen,
          titleString: 'We\'ve sent you an email with a magic link.',
          subtitleString:
              'Please check your email and follow the link to sign in. Don\'t forget to check your spam folder too!',
        ),
        SizedBox(height: gap),
        CustomListTile(
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.arrowLeft,
          selectableText: true,
          // backgroundColor: context.theme.colorScheme.error,
          // textColor: context.theme.colorScheme.onError,
          titleString: 'Something not right?',
          subtitleString: 'Start again.',
          onTap: () {
            vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
              context.navigator.pushReplacementNamed('/auth');
            });
          },
        ),
      ],
    );
  }
}
