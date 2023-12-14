import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/custom_dialog.dart';
import '../../../../widgets/custom_list_tile.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: 12,
      ),
      titleString: 'Delete Account',
      leadingIconData: FontAwesomeIcons.trash,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              backgroundColor: context.theme.colorScheme.tertiaryContainer,
              titleString: 'You are about to delete your account.',
              contentString:
                  'Are you sure you want to delete your account?\n\nYour data will be deleted and you will be signed out of the app.',
              actions: [
                CustomListTile(
                  cornerRadius: radius - gap,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: gap * 2,
                    vertical: gap,
                  ),
                  onTap: () => context.navigator.pop(),
                  titleString: 'Cancel',
                  responsiveWidth: true,
                ),
                CustomListTile(
                  cornerRadius: radius - gap,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: gap * 2,
                    vertical: gap,
                  ),
                  onTap: () => context.navigator.pop(),
                  titleString: 'Proceed',
                  backgroundColor: context.theme.colorScheme.tertiary,
                  textColor: context.theme.colorScheme.onTertiary,
                  responsiveWidth: true,
                ),
              ],
            );
          },
        );
        // User user = FirebaseAuth.instance.currentUser!;
        // log('$user', name: 'Deleting user');
        // user.delete().onError(
        //   (error, stackTrace) {
        //     logger.i('$error', name: 'Error deleting user');
        //     showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return CustomDialog(
        //           titleString: 'Error deleting account',
        //           contentString: 'Please sign in again.',
        //           actions: [
        //             CustomListTile(
        //               onTap: () => context.navigator.push(
        //                 MaterialPageRoute(
        //                   builder: (context) => const AuthView(),
        //                 ),
        //               ),
        //               titleString: 'OK',
        //             ),
        //           ],
        //         );
        //       },
        //     );
        //   },
        // ).then(
        //   (_) {
        //     context.navigator
        //         .pushReplacement(
        //           MaterialPageRoute(
        //             builder: (context) => const AuthView(),
        //           ),
        //         )
        //         .whenComplete(
        //           () => HapticFeedback.heavyImpact(),
        //         );
        //   },
        // );
      },
    );
  }
}
