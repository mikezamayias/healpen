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
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController(
      initialPage: currentPage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titleString: widget.sectionName,
      title: Row(
        children: [
          Text(
            widget.sectionName,
            style: context.theme.textTheme.titleLarge!.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            widget.tileData.elementAt(currentPage).titleString,
            style: TextStyle(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: SmoothPageIndicator(
        controller: pageController,
        count: widget.tileData.length,
        effect: ExpandingDotsEffect(
          dotHeight: gap,
          dotWidth: gap,
          activeDotColor: context.theme.colorScheme.primary,
          dotColor: context.theme.colorScheme.outline,
        ),
      ),
      leadingIconData: ref.watch(navigationShowInfoButtonsProvider)
          ? FontAwesomeIcons.circleInfo
          : null,
      leadingOnTap: ref.watch(navigationShowInfoButtonsProvider)
          ? () {
              vibrate(
                ref.watch(navigationEnableHapticFeedbackProvider),
                () {
                  showHealpenDialog(
                    context: context,
                    doVibrate:
                        ref.watch(navigationEnableHapticFeedbackProvider),
                    customDialog: CustomDialog(
                      titleString: widget.tileData[currentPage].titleString,
                      contentString:
                          widget.tileData[currentPage].explanationString,
                    ),
                  );
                },
              );
            }
          : null,
      enableSubtitleWrapper: false,
      subtitle: Container(
        padding: EdgeInsets.symmetric(vertical: gap),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius - gap),
        ),
        child: PageView.builder(
          itemCount: widget.tileData.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: gap),
            child: widget.tileData[index].content,
          ),
          controller: pageController,
          onPageChanged: (int index) {
            vibrate(
              ref.watch(navigationEnableHapticFeedbackProvider),
              () {
                setState(() {
                  currentPage = index;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
