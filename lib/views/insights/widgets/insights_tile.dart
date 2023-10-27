import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../controllers/insights_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../../wrappers/keep_alive_wrapper.dart';

class InsightsTile extends ConsumerStatefulWidget {
  const InsightsTile({
    super.key,
  });

  @override
  ConsumerState<InsightsTile> createState() => _AnalysisSectionState();
}

class _AnalysisSectionState extends ConsumerState<InsightsTile> {
  int currentPage = 0;
  double viewPortFraction = 1;
  double pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    final insightsContoller = ref.watch(insightsControllerProvider);
    List<Widget> insightWidgets =
        insightsContoller.insightModelList.map((e) => e.widget).toList();
    insightsContoller.pageController = PageController(
      initialPage: currentPage,
      viewportFraction: viewPortFraction,
    )..addListener(() {
        setState(() {
          pageOffset = insightsContoller.pageController.page!;
        });
      });
    return KeepAliveWrapper(
      child: CustomListTile(
        titleString:
            insightsContoller.insightModelList.elementAt(currentPage).title,
        trailing: SmoothPageIndicator(
          controller: insightsContoller.pageController,
          count: insightsContoller.insightModelList.length,
          effect: ExpandingDotsEffect(
            dotHeight: gap,
            dotWidth: gap,
            activeDotColor: context.theme.colorScheme.primary,
            dotColor: context.theme.colorScheme.outline,
          ),
        ),
        enableSubtitleWrapper: false,
        expandSubtitle: true,
        padSubtitle: true,
        subtitle: PageView.builder(
          itemCount: insightsContoller.insightModelList.length,
          itemBuilder: (BuildContext context, int index) {
            double scale = 1 - (index - pageOffset).abs();
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..scale(scale, scale),
              alignment: Alignment.center,
              child: PhysicalModel(
                color: context.theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(radius - gap),
                child: Padding(
                  padding: EdgeInsets.all(gap),
                  child: insightWidgets[index],
                ),
              ),
            );
          },
          controller: insightsContoller.pageController,
          onPageChanged: (int index) => vibrate(
            ref.watch(navigationEnableHapticFeedbackProvider),
            () {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        explanationString: insightsContoller.insightModelList
            .elementAt(currentPage)
            .explanation,
        maxExplanationStringLines: 3,
      ),
    );
  }
}
