import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordCloudTile extends ConsumerWidget {
  const WordCloudTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('Word Cloud');
    // final wordCloudGenerator = WordCloudGenerator();
    // final List<Map> wordCloudData = [];
    // for (final analysisModel
    //     in ref.watch(AnalysisViewController.analysisModelListProvider)) {
    //   wordCloudData
    //       .addAll(wordCloudGenerator.generateWordCloudData(analysisModel));
    // }
    // final mydata = WordCloudData(data: wordCloudData);
    //
    // return CustomListTile(
    //   titleString: 'Wisdom Cloud',
    //   subtitle: WordCloudView(
    //     data: mydata,
    //     mapwidth: 500,
    //     mapheight: 500,
    //   ),
    // );
  }
}
