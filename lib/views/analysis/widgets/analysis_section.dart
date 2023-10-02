import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../providers/settings_providers.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';

class AnalysisSection extends ConsumerStatefulWidget {
  final String sectionName;
  final List<({String titleString, String explanationString})> tileData;

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
                    subtitle: Text(
                      widget.tileData[index].explanationString,
                    ),
                  ),
                ),
                controller: pageController,
                onPageChanged: (int index) {
                  vibrate(
                      ref.watch(navigationReduceHapticFeedbackProvider), () {});
                },
              ),
            ),
            Gap(gap),
            SmoothPageIndicator(
              controller: pageController,
              count: widget.tileData.length,
              effect: ExpandingDotsEffect(
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
