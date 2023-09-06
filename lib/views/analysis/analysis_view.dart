import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';

import '../../controllers/analysis_view_controller.dart';
import '../../providers/settings_providers.dart';
import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/loading_tile.dart';
import '../blueprint/blueprint_view.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlueprintView(
      hideAppBarTitle: ref.watch(hideAppBarTitle),
      appBar: const AppBar(
        pathNames: ['Your writing insights'],
      ),
      body: StreamBuilder(
        stream: AnalysisViewController().metricGroupingsStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<String>> metricGroupingsSnapshot,
        ) {
          if (metricGroupingsSnapshot.hasError) {
            return Center(
              child: CustomListTile(
                titleString: 'Something went wrong',
                backgroundColor: context.theme.colorScheme.error,
                textColor: context.theme.colorScheme.onError,
                subtitle:
                    SelectableText(metricGroupingsSnapshot.error.toString()),
              ),
            );
          }

          if (metricGroupingsSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const LoadingTile(durationTitle: 'Loading metrics');
          }

          if (metricGroupingsSnapshot.data!.isNotEmpty) {
            return Column(
              children: metricGroupingsSnapshot.data!
                  .asMap()
                  .entries
                  .map(
                    (entry) => Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomListTile(
                              contentPadding: EdgeInsets.all(gap),
                              titleString: entry.value,
                              subtitle: const Center(
                                child: Text(
                                  'To be implemented.',
                                ),
                              ),
                            ),
                          ),
                          if (entry.key !=
                              metricGroupingsSnapshot.data!.length - 1)
                            SizedBox(height: gap),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
              child: CustomListTile(
                titleString: 'No metrics yet',
              ),
            );
          }
        },
      ),
    );
  }
}
