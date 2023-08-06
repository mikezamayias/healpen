import 'package:flutter/material.dart' hide AppBar, Divider, PageController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/history_view_controller.dart';
import '../../controllers/page_controller.dart';
import '../../models/note/note_model.dart';
import '../../providers/page_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/note_tile.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: [
          'Your past notes',
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: StreamBuilder(
          stream: HistoryViewController().notesStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<NoteModel>> snapshot,
          ) {
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

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingTile(durationTitle: 'Loading notes');
            }

            if (snapshot.data!.isNotEmpty) {
              List<NoteModel> noteModels = snapshot.data!;
              List<Widget> noteModelTiles =
                  noteModels.map((e) => NoteTile(entry: e)).toList();
              return ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: gap),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, int index) => noteModelTiles[index],
              );
            } else {
              return CustomListTile(
                titleString: 'No notes yet',
                contentPadding: EdgeInsets.all(gap),
                subtitle: const Text('Start writing to see your notes here'),
                onTap: () => ref.read(currentPageProvider.notifier).state =
                    PageController().writing,
                leadingIconData: FontAwesomeIcons.pencil,
                showcaseLeadingIcon: true,
              );
            }
          },
        ),
      ),
    );
  }
}
