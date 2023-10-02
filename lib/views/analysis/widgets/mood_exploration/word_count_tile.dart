import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_cloud/word_cloud.dart';

import '../../../../controllers/analysis_view_controller.dart';
import '../../../../models/word_cloud_generator.dart';
import '../../../../widgets/custom_list_tile.dart';

class WordCountTile extends ConsumerWidget {
  const WordCountTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordCloudGenerator = WordCloudGenerator();
    final List<Map> wordCloudData = [];
    for (final analysisModel
        in ref.watch(AnalysisViewController.analysisModelListProvider)) {
      wordCloudData
          .addAll(wordCloudGenerator.generateWordCloudData(analysisModel));
    }
    final mydata = WordCloudData(data: wordCloudData);

    return CustomListTile(
      titleString: 'Wisdom Cloud',
      subtitle: WordCloudView(
        data: mydata,
        mapwidth: 500,
        mapheight: 500,
      ),
    );
  }
}
