import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart' hide Feedback, AppBar;
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
import '../../blueprint/blueprint_view.dart';

class FeedbackForm extends ConsumerWidget {
  const FeedbackForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> widgets = [
      CustomListTile(
        contentPadding: EdgeInsets.all(gap),
        titleString: 'Title',
        subtitle: IntrinsicWidth(
          child: TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintStyle: context.theme.textTheme.titleLarge,
            ),
            style: context.theme.textTheme.titleLarge,
            onChanged: (String value) =>
                ref.watch(feedbackControllerProvider.notifier).setTitle(value),
          ),
        ),
      ),
      CustomListTile(
        titleString: 'Feedback',
        contentPadding: EdgeInsets.all(gap),
        subtitle: IntrinsicWidth(
          child: TextFormField(
            autocorrect: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintStyle: context.theme.textTheme.titleLarge,
            ),
            style: context.theme.textTheme.titleLarge,
            onChanged: (String value) =>
                ref.watch(feedbackControllerProvider.notifier).setBody(value),
          ),
        ),
      ),
      CustomListTile(
        titleString: 'Include Screenshot',
        contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
        trailingIconData:
            ref.watch(feedbackControllerProvider).includeScreenshot
                ? FontAwesomeIcons.solidSquareCheck
                : FontAwesomeIcons.square,
        onTap: () {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
            ref.watch(feedbackControllerProvider.notifier).setIncludeScreenshot(
                !ref.watch(feedbackControllerProvider).includeScreenshot);
          });
        },
      ),
      CustomListTile(
        titleString: 'Labels',
        contentPadding: EdgeInsets.all(gap),
        subtitle: Wrap(
          spacing: gap,
          runSpacing: gap,
          children: FeedbackLabel.values.map((FeedbackLabel label) {
            return CustomListTile(
              cornerRadius: radius - gap,
              responsiveWidth: true,
              contentPadding: EdgeInsets.all(gap),
              backgroundColor: Color(label.color),
              titleString: label.name,
              subtitleString: label.description,
              textColor:
                  Color(label.color).isLight ? Colors.black : Colors.white,
              leadingIconData: ref
                      .watch(feedbackControllerProvider)
                      .labels!
                      .contains(label.name)
                  ? FontAwesomeIcons.solidSquareCheck
                  : FontAwesomeIcons.square,
              onTap: () {
                vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                  log(
                    label.name,
                      name: 'FeedbackForm:label.name',
                    );
                    log(
                      '${ref.watch(feedbackControllerProvider).labels!.contains(label.name)}',
                      name: 'FeedbackForm:labelsProvider',
                    );
                    if (ref
                        .watch(feedbackControllerProvider)
                        .labels!
                        .contains(label.name)) {
                      ref
                          .watch(feedbackControllerProvider.notifier)
                          .removeLabel(label.name);
                    } else {
                      ref
                          .watch(feedbackControllerProvider.notifier)
                          .addLabel(label.name);
                    }
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
      Row(
        children: [
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
            leadingIconData: FontAwesomeIcons.solidPaperPlane,
            titleString: 'Submit',
            onTap: () {
              vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                GitHubAPI api = GitHubAPI(
                  Env.healpenGithubToken,
                  'mikezamayias',
                  'healpen',
                );
                String? screenshotUrl;
                if (ref
                    .watch(feedbackControllerProvider.notifier)
                    .includeScreenshot) {
                  assert(
                    ref
                            .watch(feedbackControllerProvider.notifier)
                            .screenshotPath !=
                        '',
                    'Screenshot path is empty',
                  );
                  api
                      .uploadScreenshotToFirebase(File(ref
                          .watch(feedbackControllerProvider.notifier)
                          .screenshotPath))
                      .then((String value) => screenshotUrl = value);
                }
                log(
                  '$screenshotUrl',
                  name: 'FeedbackForm:createIssueFromFeedback:screenshotUrl',
                );
                log(
                  ref.watch(feedbackControllerProvider.notifier).title,
                  name: 'FeedbackForm:createIssueFromFeedback:title',
                );
                log(
                  ref.watch(feedbackControllerProvider.notifier).body,
                  name: 'FeedbackForm:createIssueFromFeedback:body',
                );
                log(
                  ref
                      .watch(feedbackControllerProvider.notifier)
                      .labels
                      .toString(),
                  name: 'FeedbackForm:createIssueFromFeedback:labels',
                );
                log(
                  ref
                      .watch(feedbackControllerProvider.notifier)
                      .includeScreenshot
                      .toString(),
                  name:
                      'FeedbackForm:createIssueFromFeedback:includeScreenshot',
                );
                api
                    .createIssue(
                        ref.watch(feedbackControllerProvider.notifier).title,
                        ref.watch(feedbackControllerProvider.notifier).body,
                        screenshotUrl,
                        ref
                            .watch(feedbackControllerProvider.notifier)
                            .labels!
                            .toList())
                    .then((value) {
                  // ref.watch(feedbackControllerProvider.notifier).reset();
                  // context.navigator.pop();
                });
              });
            },
          ),
          const Spacer(),
          CustomListTile(
            responsiveWidth: true,
            contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
            leadingIconData: FontAwesomeIcons.solidCircleXmark,
            titleString: 'Cancel',
            onTap: () {
              vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                context.navigator.pop();
              });
            },
          ),
        ],
      ),
    ];

    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Feedback Form'],
        automaticallyImplyLeading: true,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ListView.separated(
          itemCount: widgets.length,
          itemBuilder: (_, index) => widgets.elementAt(index),
          separatorBuilder: (_, __) => SizedBox(height: gap),
        ),
      ),
    );
  }
}