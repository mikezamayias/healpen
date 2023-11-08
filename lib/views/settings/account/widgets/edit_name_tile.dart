import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_list_tile.dart';

class EditNameTile extends ConsumerWidget {
  const EditNameTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = FirebaseAuth.instance.currentUser?.displayName;
    final textController = TextEditingController(
      text: displayName,
    );
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      enableExplanationWrapper:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: 'How should you be called?',
      subtitle: TextField(
        controller: textController,
        decoration: InputDecoration(
          contentPadding: ref.watch(navigationSmallerNavigationElementsProvider)
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: gap),
          hintText: displayName ?? 'How should you be called?',
          hintStyle: context.theme.textTheme.titleLarge,
        ),
        style: context.theme.textTheme.titleLarge!.copyWith(
          color: ref.watch(navigationSmallerNavigationElementsProvider)
              ? context.theme.colorScheme.onSurface
              : context.theme.colorScheme.onSurfaceVariant,
        ),
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
