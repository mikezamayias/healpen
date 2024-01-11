import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/date_view_controller.dart';
import '../../extensions/date_time_extensions.dart';
import '../../extensions/widget_extensions.dart';
import '../../models/note_tile_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import '../history/widgets/note_tile.dart';
import 'widgets/delete_action_button.dart';
import 'widgets/select_action_button.dart';
import 'widgets/select_all_notes_action_button.dart';
import 'widgets/select_none_notes_action_button.dart';

class DateView extends ConsumerStatefulWidget {
  final DateTime date;

  const DateView(this.date, {super.key});

  @override
  ConsumerState<DateView> createState() => _DateViewState();
}

class _DateViewState extends ConsumerState<DateView> {
  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      padBodyHorizontally: false,
      bottomSafeArea: false,
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: gap),
        child: AppBar(
          automaticallyImplyLeading: true,
          pathNames: [dialogTitle],
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (ref
                  .watch(DateViewController.noteSelectionEnabledProvider)) ...[
                if (DateViewController.someNotesSelected(ref))
                  const DeleteActionButton(),
                const SelectAllNotesActionButton(),
                const SelectNoneNotesActionButton()
              ],
              const SelectActionButton(),
            ].addSpacer(
              SizedBox(width: gap),
              spacerAtEnd: false,
              spacerAtStart: false,
            ),
          ),
          onBackButtonPressed: () {
            DateViewController.dispose(ref);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverSafeArea(
            sliver: SliverList.separated(
              itemCount: noteTileList.length,
              itemBuilder: (_, int index) => noteTileList[index],
              separatorBuilder: (_, __) => SizedBox(height: gap),
            ),
          )
        ],
      ),
    );
  }

  String get dialogTitle {
    return widget.date.toEEEEMMMd();
  }

  List<Widget> get noteTileList => ref
      .watch(DateViewController.noteModelSetProvider)
      .map((NoteTileModel noteTileModel) => NoteTile(noteTileModel))
      .toList()
      .animate(interval: slightlyShortStandardDuration)
      .fade(
        duration: standardDuration,
        curve: standardCurve,
      )
      .slideX(
        duration: standardDuration,
        curve: standardCurve,
        begin: -0.6,
        end: 0,
      );
}
