import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../extensions/widget_extensions.dart';
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
    final padding = _keyboardAwarePadding(isKeyboardOpen);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SimpleBlueprintView(
          simpleAppBar: SimpleAppBar(
            appBarPadding: padding,
            automaticallyImplyLeading: false,
            appBarLeading: isKeyboardOpen ? const StopwatchTile() : null,
            appBarTitleString:
                isKeyboardOpen ? null : 'How are you feeling today?',
            appBarTrailing: isKeyboardOpen ? const SaveNoteButton() : null,
            belowRowWidget: isKeyboardOpen
                ? null
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildNoteTiles(analysisModelSet)
                          .take(6)
                          .toList()
                          .addSpacer(SizedBox(width: radius)),
                    ),
                  ),
          ),
          body: const WritingTextField(),
        ),
        if (!isKeyboardOpen) _buildHorizontalScrollingRow(analysisModelSet),
      ],
    );
  }

  Widget _buildHorizontalScrollingRow(analysisModelSet) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildFixedWidgets().addSpacer(SizedBox(width: radius)),
        ),
      ),
    );
  }

  List<Widget> _buildNoteTiles(Set<AnalysisModel> analysisModelSet) {
    return <Widget>[
      ...analysisModelSet
          .toList()
          .reversed
          .map((AnalysisModel e) => _buildNoteListTile(e))
    ];
  }

  List<Widget> _buildFixedWidgets() {
    return <Widget>[
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
      _buildCustomListTileButtons(
        'Settings',
        FontAwesomeIcons.sliders,
        () {
          pushWithAnimation(
            context: context,
            widget: const SimpleSettingsView(),
            dataCallback: null,
          );
        },
      ),
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
      CustomListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: gap * 2,
          vertical: gap,
        ),
        responsiveWidth: true,
        leadingIconData: icon,
        titleString: title,
        onTap: onTap,
      );

  EdgeInsets _keyboardAwarePadding(bool isKeyboardOpen) =>
      !isKeyboardOpen ? EdgeInsets.all(radius) : EdgeInsets.all(gap);
}
