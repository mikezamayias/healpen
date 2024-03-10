import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../route_controller.dart';
import '../../../utils/constants.dart';
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
        CustomListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          titleString: 'We\'ve sent a link to your email',
          explanationString:
              'Click the link to sign in! Please check your inbox and spam folders.',
          leadingIconData: FontAwesomeIcons.solidEnvelopeOpen,
          textColor: context.theme.colorScheme.onSurface,
        ),
        SizedBox(height: gap),
        CustomListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: gap * 2,
            vertical: gap,
          ),
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.arrowLeft,
          titleString: 'Something not right?',
          explanationString: 'Start again.',
          onTap: () {
            context.navigator
                .pushReplacementNamed(RouterController.authViewRoute.route);
          },
        ),
      ],
    );
  }
}
