import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helper_functions.dart';
import '../../../controllers/insight_controller.dart';
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
  // TODO: Make this list user customizale under insight settings and move the explanation string to that reorderable list

  int currentPage = 0;
  double viewPortFraction = 1;
  double pageOffset = 0;

  late PageController pageController;
  late List<Widget> insightWidgets;

  @override
  void initState() {
    pageController = PageController(
      initialPage: currentPage,
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
    insightWidgets = ref
        .watch(insightControllerProvider)
        .insightModels
        .map((e) => KeepAliveWrapper(child: e.widget))
        .toList();
    return CustomListTile(
      titleString: ref
          .watch(insightControllerProvider)
          .insightModels
          .elementAt(currentPage)
          .title,
      trailing: SmoothPageIndicator(
        controller: pageController,
        count: ref.watch(insightControllerProvider).insightModels.length,
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
        itemCount: ref.watch(insightControllerProvider).insightModels.length,
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
        controller: pageController,
        onPageChanged: (int index) => vibrate(
          ref.watch(navigationEnableHapticFeedbackProvider),
          () {
            setState(() {
              currentPage = index;
            });
          },
        ),
      ),
      explanationString: ref
          .watch(insightControllerProvider)
          .insightModels
          .elementAt(currentPage)
          .explanation,
      maxExplanationStringLines: 3,
    );
  }
}
