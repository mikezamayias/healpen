import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../controllers/analysis_view_controller.dart';
import '../../../controllers/emotional_echo_controller.dart';
import '../../../controllers/writing_controller.dart';
import '../../../extensions/int_extensions.dart';
import '../../../extensions/widget_extensions.dart';
import '../../../models/analysis/analysis_model.dart';
import '../../../providers/settings_providers.dart';
import '../../../route_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helper_functions.dart';
import '../../../widgets/custom_list_tile.dart';
import '../../history/history_view.dart';
import '../../insights/insights_view.dart';
import '../../settings/settings_view.dart';
import '../../writing/widgets/writing_text_field.dart';
import '../simple_blueprint_view.dart';
import '../widgets/simple_app_bar.dart';

class SimpleHomeView extends ConsumerStatefulWidget {
  const SimpleHomeView({super.key});

  @override
  ConsumerState<SimpleHomeView> createState() => _SimpleUIViewState();
}

class _SimpleUIViewState extends ConsumerState<SimpleHomeView> {
  @override
  Widget build(BuildContext context) {
    final analysisModelSet = ref.watch(analysisModelSetProvider);
    return SimpleBlueprintView(
      showAppBar: !isKeyboardOpen,
      simpleAppBar: SimpleAppBar(
        appBarPadding: _keyboardAwareAppBarPadding,
        automaticallyImplyLeading: false,
        appBarTitleString: isKeyboardOpen ? null : 'How are you feeling today?',
        belowRowWidget: isKeyboardOpen
            ? null
            : SingleChildScrollView(
                clipBehavior: Clip.none,
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
      padBody: false,
      bodyPadding: null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: AnimatedPadding(
              duration: standardDuration,
              curve: standardCurve,
              padding:
                  isKeyboardOpen ? EdgeInsets.zero : EdgeInsets.all(radius),
              child: const WritingTextField(),
            ),
          ),
          if (!isKeyboardOpen) _buildHorizontalScrollingRow(analysisModelSet),
        ],
      ),
    );
  }

  Widget _buildHorizontalScrollingRow(analysisModelSet) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: gap),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _buildFixedWidgets().addSpacer(
              SizedBox(width: radius),
            ),
          ),
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
        FontAwesomeIcons.brain,
        () {
          pushWithAnimation(
            context: context,
            widget: const InsightsView(),
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
        'History',
        FontAwesomeIcons.calendarDays,
        () {
          pushWithAnimation(
            context: context,
            widget: const HistoryView(),
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
            widget: const SettingsView(),
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
        showShadow: false,
        shadowColor: theme.colorScheme.primary,
      );

  EdgeInsets get _keyboardAwareAppBarPadding =>
      !isKeyboardOpen ? EdgeInsets.all(radius) : EdgeInsets.all(gap);

  bool get useSimpleUi => ref.watch(navigationSimpleUIProvider);

  bool get isKeyboardOpen =>
      ref.watch(WritingController().isKeyboardOpenProvider);
}
