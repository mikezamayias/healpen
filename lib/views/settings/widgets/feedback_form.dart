import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/feedback/feedback.dart';
import '../../../controllers/feedback/feedback_label.dart';
import '../../../controllers/feedback/github_api.dart';
import '../../../env/env.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../../blueprint/blueprint_view.dart';

class FeedbackForm extends ConsumerStatefulWidget {
  const FeedbackForm({super.key});

  @override
  ConsumerState<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<FeedbackForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController labelsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController =
        ref.watch(feedbackControllerProvider.notifier);
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Feedback'],
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomListTile(
                        contentPadding: EdgeInsets.all(gap),
                        titleString: 'Title',
                        subtitle: IntrinsicWidth(
                          child: TextFormField(
                            autocorrect: true,
                            keyboardType: TextInputType.text,
                            maxLines: 2,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Describe the issue in a few words',
                              hintStyle: theme.textTheme.titleLarge,
                              hintMaxLines: 2,
                            ),
                            style: theme.textTheme.titleLarge,
                            onChanged: (String value) =>
                                feedbackController.setTitle(value),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter short and descriptive title';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: gap),
                      CustomListTile(
                        titleString: 'Feedback',
                        contentPadding: EdgeInsets.all(gap),
                        subtitle: IntrinsicWidth(
                          child: TextFormField(
                            controller: feedbackController.bodyTextController,
                            autocorrect: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintStyle: theme.textTheme.titleLarge,
                            ),
                            style: theme.textTheme.titleLarge,
                            onChanged: (String value) =>
                                feedbackController.setBody(value),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a detailed description of the issue';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: gap),
                      CustomListTile(
                        titleString: 'Labels',
                        contentPadding: EdgeInsets.all(gap),
                        subtitle: Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children:
                              FeedbackLabel.values.map((FeedbackLabel label) {
                            return CustomListTile(
                              cornerRadius: radius - gap,
                              responsiveWidth: true,
                              contentPadding: EdgeInsets.all(gap),
                              backgroundColor: Color(label.color),
                              titleString: label.name,
                              subtitleString: label.description,
                              textColor: Color(label.color).isLight
                                  ? Colors.black
                                  : Colors.white,
                              leadingIconData: ref
                                      .watch(feedbackControllerProvider)
                                      .labels!
                                      .contains(label.name)
                                  ? FontAwesomeIcons.solidSquareCheck
                                  : FontAwesomeIcons.square,
                              onTap: () {
                                vibrate(
                                  ref.watch(
                                      navigationReduceHapticFeedbackProvider),
                                  () {
                                    if (ref
                                        .watch(feedbackControllerProvider)
                                        .labels!
                                        .contains(label.name)) {
                                      ref
                                          .watch(feedbackControllerProvider
                                              .notifier)
                                          .removeLabel(label.name);
                                    } else {
                                      ref
                                          .watch(feedbackControllerProvider
                                              .notifier)
                                          .addLabel(label.name);
                                    }
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: gap),
                      CustomListTile(
                        titleString: 'Include Screenshot',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: gap * 2),
                        trailingIconData: ref
                                .watch(feedbackControllerProvider)
                                .includeScreenshot
                            ? FontAwesomeIcons.solidSquareCheck
                            : FontAwesomeIcons.square,
                        onTap: () {
                          vibrate(
                            ref.watch(navigationReduceHapticFeedbackProvider),
                            () {
                              feedbackController.setIncludeScreenshot(!ref
                                  .watch(feedbackControllerProvider)
                                  .includeScreenshot);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: gap),
          Row(
            children: [
              CustomListTile(
                responsiveWidth: true,
                contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                leadingIconData: FontAwesomeIcons.solidPaperPlane,
                titleString: 'Submit',
                onTap: () {
                  vibrate(
                    ref.read(navigationReduceHapticFeedbackProvider),
                    () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (feedbackController.includeScreenshot) {
                          assert(feedbackController.screenshotPath.isNotEmpty,
                              'Screenshot path is empty but includeScreenshot is true');
                        }
                        final api = GitHubAPI(
                          Env.healpenGithubToken,
                          'mikezamayias',
                          'healpen',
                        );
                        api
                            .createIssue(
                          ref.read(feedbackControllerProvider.notifier).title,
                          ref.read(feedbackControllerProvider.notifier).body,
                          feedbackController.screenshotPath,
                          ref.read(feedbackControllerProvider.notifier).labels!,
                        )
                            .whenComplete(
                          () {
                            feedbackController.cleanUp();
                            CustomSnackBar(
                              SnackBarConfig(
                                titleString1: 'Thank you for your feedback!',
                                leadingIconData1:
                                    FontAwesomeIcons.solidPaperPlane,
                              ),
                            ).showSnackBar(context, ref).then((_) {
                              navigator.pop();
                            });
                          },
                        ).catchError(
                          (Object error) {
                            CustomSnackBar(
                              SnackBarConfig(
                                titleString1: 'Something went wrong',
                                leadingIconData1:
                                    FontAwesomeIcons.circleExclamation,
                                titleString2: error.toString(),
                                leadingIconData2:
                                    FontAwesomeIcons.circleExclamation,
                              ),
                            ).showSnackBar(context, ref).whenComplete(() {
                              navigator.pop();
                            });
                          },
                        );
                      } else {
                        // show an error text using labelsController and form key
                        await CustomSnackBar(
                          SnackBarConfig(
                            snackBarMargin: EdgeInsets.zero,
                            titleString1: 'Please fill in all fields',
                            leadingIconData1:
                                FontAwesomeIcons.circleExclamation,
                          ),
                        ).showSnackBar(context, ref);
                      }
                    },
                  );
                },
              ),
              SizedBox(width: gap),
              CustomListTile(
                responsiveWidth: true,
                contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                leadingIconData: FontAwesomeIcons.xmark,
                titleString: 'Cancel',
                onTap: () {
                  vibrate(ref.read(navigationReduceHapticFeedbackProvider), () {
                    navigator.pop();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
