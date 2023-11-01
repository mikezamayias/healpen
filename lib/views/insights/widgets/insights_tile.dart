import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../controllers/insights_controller.dart';
import '../../../models/insight_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/custom_list_tile.dart';

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
    insightsContoller.pageController = PageController(
      initialPage: currentPage,
      viewportFraction: viewPortFraction,
    )..addListener(() {
        setState(() {
          pageOffset = insightsContoller.pageController.page!;
        });
      });
    // final PreferenceModel<List<String>> preferenceModel =
    //     PreferenceModel<List<String>>(
    //   'insightOrder',
    //   insightsContoller.insightModelList
    //       .map((InsightModel e) => e.title)
    //       .toList(),
    // );
    return StreamBuilder(
        stream: FirestoreService().preferencesCollectionReference().snapshots(),
        builder: (context, snapshot) {
          List<Widget> insightWidgets = [];
          if (snapshot.hasData &&
              snapshot.data?.data()?['insightOrder'] != null) {
            List<String> insightOrder =
                List<String>.from(snapshot.data?.data()?['insightOrder']);
            log(
              '$insightOrder',
              name: 'InsightsTile:insightOrder',
            );
            List<InsightModel> tempInsightModelList = [];
            for (String orderedTitle in insightOrder) {
              tempInsightModelList.add(
                insightsContoller.insightModelList.firstWhere(
                  (InsightModel insightModel) =>
                      insightModel.title == orderedTitle,
                ),
              );
            }
            insightsContoller.insightModelList = tempInsightModelList;
          }
          insightWidgets =
              insightsContoller.insightModelList.map((e) => e.widget).toList();
          return CustomListTile(
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
          );
        });
  }
}
