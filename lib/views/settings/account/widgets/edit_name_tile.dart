import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../widgets/custom_list_tile/custom_list_tile.dart';

class EditNameTile extends StatelessWidget {
  const EditNameTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser!.displayName;
    return CustomListTile(
      titleString: 'Name',
      subtitle: TextField(
        decoration: InputDecoration(
          hintText: displayName ?? 'How should we call you?',
          hintStyle: context.theme.textTheme.titleLarge,
        ),
        style: context.theme.textTheme.titleLarge,
        onSubmitted: (String newDisplayName) async {
          log(newDisplayName, name: 'newDisplayName');
          await FirebaseAuth.instance.currentUser!.updateDisplayName(
            newDisplayName,
          );
        },
      ),
    );
  }
}
