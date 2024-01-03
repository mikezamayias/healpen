import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../extensions/analysis_model_extensions.dart';
import '../../models/analysis/analysis_model.dart';
import '../../utils/constants.dart';
import '../../utils/helper_functions.dart';
import '../simple/views/simple_insights_tile.dart';
import 'widgets/add_entry_button.dart';
import 'widgets/entry_tile.dart';
import 'widgets/modern_app_bar.dart';
import 'widgets/modern_app_bar_action.dart';

class ModernView extends ConsumerStatefulWidget {
  const ModernView({super.key});

  @override
  ConsumerState<ModernView> createState() => _ModernViewState();
}

class _ModernViewState extends ConsumerState<ModernView> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar.large(
                automaticallyImplyLeading: false,
                leadingWidth: 0,
                backgroundColor: backgroundColor,
                pinned: true,
                centerTitle: false,
                flexibleSpace: ModernAppBar(
                  onBackgroundColor: onBackgroundColor,
                ),
                actions: [
                  ModernAppBarAction(
                    iconData: FontAwesomeIcons.brain,
                    onTap: () {
                      pushWithAnimation(
                        context: context,
                        widget: const SimpleInsightsTile(),
                        dataCallback: null,
                      );
                    },
                  ),
                ],
              ),
              SliverSafeArea(
                top: false,
                sliver: LiveSliverList(
                  controller: scrollController,
                  showItemDuration: standardDuration,
                  showItemInterval: shortStandardDuration,
                  itemCount: ref.watch(analysisModelSetProvider).length,
                  itemBuilder: buildAnimatedItem,
                ),
              ),
            ],
          ),
          const SafeArea(
            top: false,
            child: AddEntryButton(),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedItem(
      BuildContext context, int index, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      // And slide transition
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: EdgeInsets.only(left: radius, right: radius, top: radius),
          child: EntryTile(
            analysisModel: ref
                .read(analysisModelSetProvider)
                .toList()
                .reversed
                .elementAt(index),
          ),
        ),
      ),
    );
  }

  Set<AnalysisModel> get analysisModelSet =>
      ref.watch(analysisModelSetProvider);

  Color get shapeColor => getShapeColorOnSentiment(
        context.theme,
        analysisModelSet.averageScore(),
      );

  Color get textColor => getTextColorOnSentiment(
        context.theme,
        analysisModelSet.averageScore(),
      );

  Color get backgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? shapeColor : textColor;

  Color get onBackgroundColor =>
      context.mediaQuery.platformBrightness.isLight ? textColor : shapeColor;
}
