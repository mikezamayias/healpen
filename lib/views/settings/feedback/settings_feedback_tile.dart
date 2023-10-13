import 'dart:io';

import 'package:feedback/feedback.dart' hide FeedbackController;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/feedback/feedback.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../feedback/feedback_view.dart';

class SettingsFeedbackTile extends ConsumerWidget {
  const SettingsFeedbackTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomListTile(
      responsiveWidth: true,
      leadingIconData: FontAwesomeIcons.solidCommentDots,
      contentPadding: EdgeInsets.symmetric(
        horizontal: gap * 2,
        vertical: gap,
      ),
      textColor: context.theme.colorScheme.onPrimary,
      titleString: 'Feedback',
      onTap: () {
        vibrate(
          PreferencesController.navigationEnableHapticFeedback.value,
          () {
            final feedbackController =
                ref.watch(feedbackControllerProvider.notifier);
            BetterFeedback.of(context).show((UserFeedback userFeedback) {
              FeedbackController.writeImageToStorage(userFeedback.screenshot)
                  .then((String screenshotPath) {
                feedbackController.bodyTextController.text = userFeedback.text;
                feedbackController.setScreenshotPath(screenshotPath);
                FeedbackController.uploadScreenshotToFirebase(
                  File(feedbackController.screenshotPath),
                ).then((String screenshotUrl) {
                  feedbackController.setScreenshotUrl(screenshotUrl);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FeedbackView(),
                    ),
                  );
                });
              });
            });
          },
        );
      },
    );
  }
}
