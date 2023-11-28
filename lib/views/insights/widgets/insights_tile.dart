import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../controllers/analysis_view_controller.dart';
import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/insights_controller.dart';
import '../../../providers/settings_providers.dart';
import '../../../widgets/custom_list_tile.dart';

class InsightsTile extends ConsumerStatefulWidget {
  const InsightsTile({
    super.key,
  });

  @override
  ConsumerState<InsightsTile> createState() => _AnalysisSectionState();
}

class _AnalysisSectionState extends ConsumerState<InsightsTile> {
  late PageController pageController;
  double viewPortFraction = 1;
  double pageOffset = 0;

  @override
  void initState() {
    pageController = PageController(
      viewportFraction: viewPortFraction,
    )..addListener(() {
        setState(() {
          pageOffset = pageController.page!;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final insightsContoller = ref.watch(insightsControllerProvider);
    final smallNavigationElements =
        ref.watch(navigationSmallerNavigationElementsProvider);
    ref.watch(emotionalEchoControllerProvider).sentimentScore = ref
        .watch(AnalysisViewController.analysisModelListProvider)
        .map((e) => e.score)
        .average;
    List<Widget> insightWidgets = [];
    insightWidgets = insightsContoller.insightModelList
        .map((e) => smallNavigationElements
            ? Padding(
                padding: EdgeInsets.only(top: gap),
                child: e.widget,
              )
            : e.widget)
        .toList();
    return CustomListTile(
      useSmallerNavigationSetting:
          !ref.watch(navigationSmallerNavigationElementsProvider),
      // enableExplanationWrapper:
      //     !ref.watch(navigationSmallerNavigationElementsProvider),
      titleString: insightsContoller.insightModelList
          .elementAt(pageOffset.round())
          .title,
      trailing: SmoothPageIndicator(
        controller: pageController,
        count: insightsContoller.insightModelList.length,
        effect: ExpandingDotsEffect(
          dotHeight: gap,
          dotWidth: gap,
          activeDotColor: context.theme.colorScheme.primary,
          dotColor: context.theme.colorScheme.outline,
        ),
      ),
      padSubtitle: true,
      subtitle: PageView.builder(
        itemCount: insightsContoller.insightModelList.length,
        onPageChanged: (int index) {
          vibrate(ref.watch(navigationEnableHapticFeedbackProvider), () {
            animateToPage(pageController, index);
          });
        },
        controller: pageController,
        itemBuilder: (BuildContext context, int index) {
          double scale = 1 - (index - pageOffset).abs();
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.01)
              ..scale(scale, scale),
            alignment: Alignment.center,
            child: PhysicalModel(
              color: context.theme.colorScheme.surface,
              borderRadius: smallNavigationElements
                  ? BorderRadius.circular(radius)
                  : BorderRadius.circular(radius - gap),
              child: insightWidgets[index],
            ),
          );
        },
      ),
      explanationString: ref.watch(navigationShowInfoProvider)
          ? insightsContoller.insightModelList
              .elementAt(pageOffset.round())
              .explanation
          : null,
      maxExplanationStringLines: 3,
    );
  }
}
