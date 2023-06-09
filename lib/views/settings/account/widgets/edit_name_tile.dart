import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class EditNameTile extends StatelessWidget {
  const EditNameTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser?.displayName;
    final textController = TextEditingController(
      text: displayName,
    );
    return CustomListTile(
      contentPadding: EdgeInsets.all(gap),
      titleString: 'Name',
      subtitle: TextField(
        controller: textController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: displayName ?? 'How should we call you?',
          hintStyle: context.theme.textTheme.titleLarge,
        ),
        style: context.theme.textTheme.titleLarge,
        onSubmitted: (String newDisplayName) async {
          log(newDisplayName, name: 'newDisplayName');
          await FirebaseAuth.instance.currentUser?.updateDisplayName(
            newDisplayName,
          );
        },
      ),
    );
  }
}
