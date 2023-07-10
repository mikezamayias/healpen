import 'package:flutter/material.dart' hide AppBar, Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/history_view_controller.dart';
import '../../extensions/int_extensions.dart';
import '../../models/writing_entry/writing_entry_model.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/divider.dart';
import '../blueprint/blueprint_view.dart';

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
          stream: HistoryViewController().writingEntriesStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<WritingEntryModel>> snapshot,
          ) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final WritingEntryModel entry = snapshot.data![index];
                return CustomListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  titleString: entry.timestamp.timestampFormat(),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.textTheme.bodyLarge!.copyWith(
                          color: context.theme.colorScheme.onBackground,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Duration / ',
                              style:
                                  context.theme.textTheme.bodyMedium!.copyWith(
                                color: context.theme.colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: entry.duration.writingDurationFormat(),
                              style:
                                  context.theme.textTheme.bodyLarge!.copyWith(
                                color: context.theme.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Word Count / ',
                              style:
                                  context.theme.textTheme.bodyMedium!.copyWith(
                                color: context.theme.colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: '${entry.content.split(' ').length}',
                              style:
                                  context.theme.textTheme.bodyLarge!.copyWith(
                                color: context.theme.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
