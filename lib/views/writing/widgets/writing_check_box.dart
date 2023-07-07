import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class WritingCheckBox extends ConsumerWidget {
  const WritingCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      cornerRadius: radius - gap,
      contentPadding: EdgeInsets.symmetric(horizontal: gap),
      backgroundColor: context.theme.colorScheme.surface,
      responsiveWidth: true,
      title: CheckboxListTile(
        value: ref.watch(writingControllerProvider).isPrivate,
        enableFeedback: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          ref.watch(writingControllerProvider.notifier).updatePrivate(value!);
        },
        title: const Text(
          'Private note',
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor:
                context.theme.colorScheme.onBackground.withOpacity(0.25),
            builder: (BuildContext context) {
              return CustomDialog(
                titleString: 'Private note',
                contentString:
                    'A private note won\'t be used in analvsis and won\'t be visible anywhere else in the app.',
                actions: [
                  CustomListTile(
                    responsiveWidth: true,
                    titleString: 'Okay',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        },
        child: FaIcon(
          FontAwesomeIcons.circleInfo,
          color: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
