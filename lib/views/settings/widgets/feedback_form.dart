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

class FeedbackForm extends ConsumerStatefulWidget {
  const FeedbackForm({super.key});

  @override
  ConsumerState<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<FeedbackForm> {
  @override
  Widget build(BuildContext context) {
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
                ref.watch(Feedback.titleProvider.notifier).state = value,
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
                ref.watch(Feedback.bodyProvider.notifier).state = value,
          ),
        ),
      ),
      CustomListTile(
        titleString: 'Include Screenshot',
        contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
        trailingIconData: ref.watch(Feedback.includeScreenshotProvider)
            ? FontAwesomeIcons.solidSquareCheck
            : FontAwesomeIcons.square,
        onTap: () {
          vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
            ref.watch(Feedback.includeScreenshotProvider.notifier).state =
                !ref.watch(Feedback.includeScreenshotProvider.notifier).state;
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
            // return CustomListTile(
            //   cornerRadius: radius - gap,
            //   responsiveWidth: true,
            //   contentPadding: EdgeInsets.all(gap),
            //   backgroundColor: Color(label.color),
            //   titleString: label.name,
            //   subtitleString: label.description,
            //   textColor:
            //       Color(label.color).isLight ? Colors.black : Colors.white,
            //   leadingIconData:
            //       ref.watch(Feedback.labelsProvider).contains(label.name)
            //           ? FontAwesomeIcons.solidSquareCheck
            //           : FontAwesomeIcons.square,
            //   onTap: () {
            //     vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
            //       log(
            //         label.name,
            //         name: 'FeedbackForm:tempLabels',
            //       );
            //       if (ref.watch(Feedback.labelsProvider).contains(label.name)) {
            //         ref
            //             .read(Feedback.labelsProvider.notifier)
            //             .state
            //             .remove(label.name);
            //       } else {
            //         ref
            //             .read(Feedback.labelsProvider.notifier)
            //             .state
            //             .add(label.name);
            //       }
            //     });
            //   },
            // );
            return ChoiceChip(
              label: Text(label.name),
              padding: EdgeInsets.all(gap),
              backgroundColor: Color(label.color),
              selectedColor: Color(label.color),
              // Ensure the background color remains the same when selected
              labelStyle: context.theme.textTheme.titleSmall!.copyWith(
                color: Color(label.color).isLight ? Colors.black : Colors.white,
              ),
              onSelected: (bool value) {
                vibrate(ref.watch(navigationReduceHapticFeedbackProvider), () {
                  log(
                    label.name,
                    name: 'FeedbackForm:tempLabels',
                  );
                  if (ref.watch(Feedback.labelsProvider).contains(label.name)) {
                    ref
                        .read(Feedback.labelsProvider.notifier)
                        .state
                        .remove(label.name);
                  } else {
                    ref
                        .read(Feedback.labelsProvider.notifier)
                        .state
                        .add(label.name);
                  }
                });
              },
              selected: ref.watch(Feedback.labelsProvider).contains(label.name),
              selectedShadowColor: Color(label.color),
              shadowColor: Color(label.color),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
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
                createIssueFromFeedback(context);
                // context.navigator.pop();
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

  Future<void> createIssueFromFeedback(BuildContext context) async {
    GitHubAPI api = GitHubAPI(
      Env.healpenGithubToken,
      'mikezamayias',
      'healpen',
    );
    String? screenshotUrl;
    if (ref.read(Feedback.includeScreenshotProvider) &&
        ref.read(Feedback.screenshotPathProvider).isNotEmpty) {
      screenshotUrl = await api.uploadScreenshotToFirebase(
          File(ref.read(Feedback.screenshotPathProvider)));
    }
    log(
      '$screenshotUrl',
      name: 'screenshotUrl',
    );
    log(
      ref.read(Feedback.titleProvider),
      name: 'title',
    );
    log(
      ref.read(Feedback.bodyProvider),
      name: 'body',
    );
    log(
      ref.read(Feedback.labelsProvider).toString(),
      name: 'labels',
    );
    log(
      ref.read(Feedback.includeScreenshotProvider).toString(),
      name: 'includeScreenshotProvider',
    );
    await api.createIssue(
      ref.read(Feedback.titleProvider),
      ref.read(Feedback.bodyProvider),
      screenshotUrl,
      ref.read(Feedback.labelsProvider).toList(),
    );
  }
}
