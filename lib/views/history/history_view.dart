import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/history_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../extensions/int_extensions.dart';
import '../../extensions/widget_extensions.dart';
import '../../models/note/note_model.dart';
import '../../providers/page_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../../widgets/text_divider.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/note_tile.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      showAppBarTitle: ref.watch(navigationShowAppBarTitle),
      appBar: const AppBar(
        pathNames: [
          'Your past notes',
        ],
      ),
      body: StreamBuilder(
        stream: HistoryViewController().notesStream,
        initialData: const <NoteModel>[],
        builder: (
          BuildContext context,
          AsyncSnapshot<List<NoteModel>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingTile(durationTitle: 'Loading notes');
          } else {
            if (snapshot.hasError) {
              return Center(
                child: CustomListTile(
                  titleString: 'Something went wrong',
                  backgroundColor: context.theme.colorScheme.error,
                  textColor: context.theme.colorScheme.onError,
                  subtitle: SelectableText(snapshot.error.toString()),
                ),
              );
            }
            if (snapshot.data!.isNotEmpty) {
              List<NoteModel> noteModels = snapshot.data!;
              Set<String> timestamps = {
                for (var noteModel in noteModels)
                  noteModel.timestamp.timestampFormat().split(', ').first,
              };
              List<List<Widget>> groupedNoteTiles = [];
              for (var timestamp in timestamps) {
                groupedNoteTiles.add(
                  noteModels
                      .where(
                        (NoteModel noteModel) =>
                            noteModel.timestamp
                                .timestampFormat()
                                .split(', ')
                                .first ==
                            timestamp,
                      )
                      .map((NoteModel e) => NoteTile(entry: e))
                      .toList(),
                );
              }
              List<Widget> widgets = <Widget>[
                for (var i = 0; i < timestamps.length; i++) ...[
                  TextDivider(timestamps.elementAt(i)),
                  ...groupedNoteTiles[i]
                ]
              ].animateWidgetList();
              return ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: ListView.separated(
                  itemCount: widgets.length,
                  separatorBuilder: (_, __) => SizedBox(height: gap),
                  itemBuilder: (_, int index) => widgets[index],
                ),
              );
            } else {
              return Column(
                children: [
                  CustomListTile(
                    titleString: 'No notes yet',
                    contentPadding: EdgeInsets.all(gap),
                    subtitle:
                        const Text('Start writing to see your notes here'),
                    onTap: () => ref.read(currentPageProvider.notifier).state =
                        PageController().writing,
                    leadingIconData: FontAwesomeIcons.pencil,
                    showcaseLeadingIcon: true,
                  ),
                  const Spacer(),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
