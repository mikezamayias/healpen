import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/writing_controller.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';

class WritingCheckBox extends ConsumerWidget {
  const WritingCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writingControllerProvider);
    final controller = ref.read(writingControllerProvider.notifier);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
      leading: SizedBox(
        width: 24.sp,
        child: IconButton.filledTonal(
          onPressed: () {
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
          iconSize: 18.sp,
          icon: const FaIcon(FontAwesomeIcons.info),
        ),
      ),
      title: CheckboxListTile(
        value: state.isPrivate,
        enableFeedback: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        onChanged: (bool? value) {
          controller.updatePrivate(value!);
        },
        title: Padding(
          padding: EdgeInsets.only(left: gap),
          child: const Text(
            'Private note',
          ),
        ),
      ),
    );
  }
}
