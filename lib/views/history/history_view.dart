import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/healpen/healpen_controller.dart';
import '../../controllers/history_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../models/note/note_model.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/calendar_tile/calendar_tile.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      showAppBar: ref.watch(navigationShowAppBarProvider),
      appBar: AppBar(
        pathNames: [
          PageController()
              .history
              .titleGenerator(FirebaseAuth.instance.currentUser?.displayName),
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
              HistoryViewController.noteModels = snapshot.data!;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: context.theme.colorScheme.surfaceVariant,
                ),
                padding: EdgeInsets.all(gap / 2),
                child: CalendarTile(
                  noteModels: HistoryViewController.notesToAnalyze,
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
                    onTap: () => ref
                        .read(HealpenController()
                            .currentPageIndexProvider
                            .notifier)
                        .state = 0,
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
