import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/history_view_controller.dart';
import '../../models/note/note_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (_, __) => SizedBox(height: gap),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final NoteModel entry = snapshot.data![index];
                  return NoteTile(entry: entry);
                },
              );
            } else {
              return const Center(
                child: CustomListTile(
                  titleString: 'No notes yet',
                  subtitle: Text(
                    'Start writing to see your notes here',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
