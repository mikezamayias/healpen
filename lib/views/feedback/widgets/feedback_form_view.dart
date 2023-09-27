import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../controllers/feedback/feedback.dart';
import '../../../controllers/feedback/feedback_label.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class FeedbackFormView extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const FeedbackFormView({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FeedbackController feedbackController =
        ref.watch(feedbackControllerProvider.notifier);
    return ClipRRect(
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
                      hintStyle: context.theme.textTheme.titleLarge,
                      hintMaxLines: 2,
                    ),
                    style: context.theme.textTheme.titleLarge,
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
                      hintStyle: context.theme.textTheme.titleLarge,
                    ),
                    style: context.theme.textTheme.titleLarge,
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
                  children: FeedbackLabel.values.map((FeedbackLabel label) {
                    return CustomListTile(
                      cornerRadius: radius - gap,
                      responsiveWidth: true,
                      contentPadding: EdgeInsets.all(gap),
                      backgroundColor: Color(label.color),
                      titleString: label.name,
                      explanationString: label.description,
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
                          ref.watch(navigationReduceHapticFeedbackProvider),
                          () {
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
              SizedBox(height: gap),
              CustomListTile(
                titleString: 'Include Screenshot',
                contentPadding: EdgeInsets.symmetric(horizontal: gap * 2),
                trailingIconData:
                    ref.watch(feedbackControllerProvider).includeScreenshot
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
    );
  }
}
