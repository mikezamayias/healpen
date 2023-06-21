import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

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
      onTap: () async {
        await HapticFeedback.heavyImpact();
        // context.read(authProvider).signOut();
      },
    );
  }
}
