import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../writing/widgets/save_note_button.dart';
import '../../writing/widgets/stopwatch_tile.dart';
import '../../writing/widgets/writing_text_field.dart';
import '../simple_blueprint_view.dart';
import '../widgets/simple_app_bar.dart';
import 'simple_calendar_view.dart';
import 'simple_insights_tile.dart';
import 'simple_settings_view.dart';

class SimpleHomeView extends ConsumerStatefulWidget {
  const SimpleHomeView({super.key});

  @override
  ConsumerState<SimpleHomeView> createState() => _SimpleUIViewState();
}

class _SimpleUIViewState extends ConsumerState<SimpleHomeView> {
  @override
  Widget build(BuildContext context) {
    final analysisModelSet = ref.watch(analysisModelSetProvider);
    final isKeyboardOpen =
        ref.watch(WritingController().isKeyboardOpenProvider);

    return Stack(
      children: <Widget>[
        SimpleBlueprintView(
          simpleUiAppBar: SimpleAppBar(
            automaticallyImplyLeading: false,
            appBarPadding: _keyboardAwarePadding(isKeyboardOpen),
            appBarLeading: isKeyboardOpen ? const StopwatchTile() : null,
            appBarTitleString:
                isKeyboardOpen ? null : 'How are you feeling today?',
            appBarTrailing: isKeyboardOpen
                ? const SaveNoteButton()
                : IntrinsicHeight(
                    child: CustomListTile(
                      responsiveWidth: true,
                      contentPadding: EdgeInsets.all(radius),
                      leadingIconData: FontAwesomeIcons.sliders,
                      onTap: () {
                        pushWithAnimation(
                          context: context,
                          widget: const SimpleSettingsView(),
                          dataCallback: null,
                        );
                      },
                    ),
                  ),
          ),
          body: const WritingTextField(),
        ),
        if (!isKeyboardOpen)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildHorizontalScrollingRow(analysisModelSet),
          ),
      ],
    );
  }

  Widget _buildHorizontalScrollingRow(analysisModelSet) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: radius),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildRowChildren(analysisModelSet),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRowChildren(Set<AnalysisModel> analysisModelSet) {
    return [
      ..._buildNoteTiles(analysisModelSet),
      ..._buildFixedWidgets(),
    ];
  }

  List<Widget> _buildNoteTiles(Set<AnalysisModel> analysisModelSet) {
    return analysisModelSet
        .toList()
        .reversed
        .take(min(3, analysisModelSet.length))
        .map((AnalysisModel e) => Padding(
              padding: EdgeInsets.only(left: radius),
              child: _buildNoteListTile(e),
            ))
        .followedBy([Padding(padding: EdgeInsets.only(left: radius))]).toList();
  }

  List<Widget> _buildFixedWidgets() {
    return [
      SizedBox(width: radius),
      _buildCustomListTileButtons(
        'Insights',
        FontAwesomeIcons.lightbulb,
        () {
          pushWithAnimation(
            context: context,
            widget: const SimpleInsightsTile(),
            dataCallback: () {
              ref.read(EmotionalEchoController.scoreProvider.notifier).state =
                  ref
                      .watch(analysisModelSetProvider)
                      .map((e) => e.score)
                      .average;
            },
          );
        },
      ),
      SizedBox(width: radius),
      _buildCustomListTileButtons(
        'Calendar',
        FontAwesomeIcons.calendar,
        () {
          pushWithAnimation(
            context: context,
            widget: const SimpleCalendarView(),
            dataCallback: null,
          );
        },
      ),
      SizedBox(width: radius),
    ];
  }

  Widget _buildNoteListTile(AnalysisModel analysisModel) =>
      _buildCustomListTileButtons(
        DateFormat.MMMd().format(
          analysisModel.timestamp.timestampToDateTime(),
        ),
        getSentimentIcon(
          analysisModel.score,
        ),
        () {
          pushNamedWithAnimation(
            context: context,
            routeName: RouterController.noteViewRoute.route,
            arguments: (analysisModel: analysisModel),
            dataCallback: () {
              ref.read(EmotionalEchoController.scoreProvider.notifier).state =
                  analysisModel.score;
            },
          );
        },
      );

  Widget _buildCustomListTileButtons(
    String title,
    IconData icon,
    void Function()? onTap,
  ) =>
      IntrinsicHeight(
        child: CustomListTile(
          responsiveWidth: true,
          leadingIconData: icon,
          titleString: title,
          onTap: onTap,
        ),
      );

  EdgeInsets _keyboardAwarePadding(bool isKeyboardOpen) =>
      isKeyboardOpen ? EdgeInsets.all(radius) : EdgeInsets.all(gap * 3);
}
