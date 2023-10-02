import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../utils/show_healpen_dialog.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_list_tile.dart';

class AnalysisSection extends ConsumerStatefulWidget {
  final String sectionName;
  final List<
      ({
        String titleString,
        String explanationString,
        Widget? content,
      })> tileData;

  const AnalysisSection({
    super.key,
    required this.sectionName,
    required this.tileData,
  });

  @override
  ConsumerState<AnalysisSection> createState() => _AnalysisSectionState();
}

class _AnalysisSectionState extends ConsumerState<AnalysisSection> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: widget.sectionName,
      enableSubtitleWrapper: false,
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: gap),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius - gap),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                itemCount: widget.tileData.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: gap),
                  child: CustomListTile(
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: theme.colorScheme.surface,
                    titleString: widget.tileData[index].titleString,
                    enableSubtitleWrapper: false,
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: gap),
                      child: widget.tileData[index].content,
                    ),
                    leadingIconData: FontAwesomeIcons.circleInfo,
                    leadingOnTap: () {
                      vibrate(
                        ref.watch(navigationReduceHapticFeedbackProvider),
                        () {
                          showHealpenDialog(
                            context: context,
                            doVibrate: ref
                                .watch(navigationReduceHapticFeedbackProvider),
                            customDialog: CustomDialog(
                              titleString: widget.tileData[index].titleString,
                              contentString:
                                  widget.tileData[index].explanationString,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                controller: pageController,
                onPageChanged: (int index) {
                  vibrate(
                    ref.watch(navigationReduceHapticFeedbackProvider),
                    () {},
                  );
                },
              ),
            ),
            Gap(gap),
            SmoothPageIndicator(
              controller: pageController,
              count: widget.tileData.length,
              effect: ExpandingDotsEffect(
                dotHeight: gap,
                dotWidth: gap,
                activeDotColor: context.theme.colorScheme.primary,
                dotColor: context.theme.colorScheme.surfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
