import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/feedback/feedback.dart';
import '../../../controllers/feedback/github_api.dart';
import '../../../controllers/settings/preferences_controller.dart';
import '../../../env/env.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';

class FeedbackFormActions extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const FeedbackFormActions({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FeedbackController feedbackController =
        ref.watch(feedbackControllerProvider.notifier);
    return Row(
      children: [
        CustomListTile(
          responsiveWidth: true,
          leadingIconData: FontAwesomeIcons.solidPaperPlane,
          titleString: 'Submit',
          onTap: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              if (feedbackController.includeScreenshot) {
                assert(feedbackController.screenshotUrl.isNotEmpty,
                    'Screenshot path is empty but includeScreenshot is true');
              }
              final api = GitHubAPI(
                Env.healpenGithubToken,
                'mikezamayias',
                'healpen',
              );
              api
                  .createIssue(
                feedbackController.title,
                feedbackController.body,
                feedbackController.screenshotUrl,
                feedbackController.labels!,
              )
                  .whenComplete(
                () {
                  feedbackController.cleanUp();
                  CustomSnackBar(
                    SnackBarConfig(
                      vibrate: PreferencesController
                          .navigationEnableHapticFeedback.value,
                      titleString1: 'Thank you for your feedback!',
                      leadingIconData1: FontAwesomeIcons.solidPaperPlane,
                    ),
                  ).showSnackBar(context).then((_) {
                    context.navigator.pop();
                  });
                },
              ).catchError(
                (Object error) {
                  CustomSnackBar(
                    SnackBarConfig(
                      vibrate: PreferencesController
                          .navigationEnableHapticFeedback.value,
                      titleString1: 'Something went wrong',
                      leadingIconData1: FontAwesomeIcons.circleExclamation,
                      titleString2: error.toString(),
                      leadingIconData2: FontAwesomeIcons.circleExclamation,
                    ),
                  ).showSnackBar(context).whenComplete(() {
                    context.navigator.pop();
                  });
                },
              );
            } else {
              // show an error text using labelsController and form key
              await CustomSnackBar(
                SnackBarConfig(
                  vibrate: PreferencesController
                      .navigationEnableHapticFeedback.value,
                  snackBarMargin: EdgeInsets.zero,
                  titleString1: 'Please fill in all fields',
                  leadingIconData1: FontAwesomeIcons.circleExclamation,
                ),
              ).showSnackBar(context);
            }
          },
        ),
        SizedBox(width: gap),
        CustomListTile(
            responsiveWidth: true,
            leadingIconData: FontAwesomeIcons.xmark,
            titleString: 'Cancel',
            onTap: () {
              feedbackController.cleanUp();
              CustomSnackBar(
                SnackBarConfig(
                  vibrate: PreferencesController
                      .navigationEnableHapticFeedback.value,
                  titleString1: 'We appreciate any feedback!',
                  leadingIconData1: FontAwesomeIcons.solidCompass,
                ),
              ).showSnackBar(context).then((_) {
                context.navigator.pop();
              });
            }),
      ],
    );
  }
}
