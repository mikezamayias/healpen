import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../extensions/widget_extensions.dart';
import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../../utils/logger.dart';
import '../../../../widgets/custom_list_tile.dart';

class EditNameTile extends ConsumerStatefulWidget {
  static final nameProvider = StateProvider<String>((ref) => '');
  static final textEditingControllerProvider =
      Provider<TextEditingController>((ref) => TextEditingController());

  const EditNameTile({
    super.key,
  });

  @override
  ConsumerState<EditNameTile> createState() => _EditNameTileState();
}

class _EditNameTileState extends ConsumerState<EditNameTile> {
  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      showShadow: false,
      useSmallerNavigationSetting: !_useSmallerNavigationElements,
      enableExplanationWrapper: !_useSmallerNavigationElements,
      titleString: 'How should you be called?',
      subtitle: StreamBuilder<String?>(
        stream: FirebaseAuth.instance
            .userChanges()
            .map((event) => event?.displayName),
        builder: (context, snapshot) {
          textController.text = snapshot.data ?? '';
          return Row(
            children: [
              Expanded(
                child: TextField(
                  enableSuggestions: false,
                  controller: textController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: gap),
                    hintText: snapshot.data,
                    hintStyle: context.theme.textTheme.titleLarge,
                  ),
                  style: context.theme.textTheme.titleLarge!.copyWith(
                    color: _useSmallerNavigationElements
                        ? context.theme.colorScheme.onSurface
                        : context.theme.colorScheme.onSurfaceVariant,
                  ),
                  onChanged: handleSubmitted,
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: textController,
                builder: (context, value, child) {
                  return IconButton(
                    color: context.theme.colorScheme.primary,
                    icon: const FaIcon(
                      FontAwesomeIcons.check,
                    ),
                    onPressed: canUpdateStringValue(value.text, snapshot.data)
                        ? handlePressed
                        : null,
                  ).animateSlideInFromBottom();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void handleSubmitted(String value) {
    ref.read(EditNameTile.nameProvider.notifier).state = value.trim();
    logger.i(ref.read(EditNameTile.nameProvider));
  }

  Future<void> handlePressed() async {
    String msg = '';
    try {
      msg = 'Display name updated successfully';
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(ref.read(EditNameTile.nameProvider));
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      textController.clear();
      logger.i(ref.read(EditNameTile.nameProvider));
    } on FirebaseException catch (e) {
      msg = 'Failed to update display name with error: ${e.message}';
      logger.e(msg);
    } catch (e) {
      msg = 'An unexpected error occurred: $e';
      logger.e(msg);
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  bool get _useSmallerNavigationElements =>
      ref.watch(navigationSmallerNavigationElementsProvider);

  TextEditingController get textController =>
      ref.watch(EditNameTile.textEditingControllerProvider);
}
