import 'analysis/analysis_model.dart';

class WordCloudGenerator {
  List<Map> generateWordCloudData(
    AnalysisModel analysisModel,
  ) {
    final wordFrequencyMap = {};

    // Split content into words
    final words = analysisModel.content
        .split(RegExp(r'\s+'))
        .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s));

    // Update the word frequency map
    for (final word in words) {
      final lowerCaseWord = word.toLowerCase();
      wordFrequencyMap[lowerCaseWord] =
          (wordFrequencyMap[lowerCaseWord] ?? 0) + 1;
    }

    // Convert the word frequency map to the required format
    final wordCloudData = wordFrequencyMap.entries
        .map((entry) => {'word': entry.key, 'value': entry.value})
        .toList();

    // Optionally, you might want to sort the list by frequency so that
    // more frequent words appear more prominently in the Word Cloud
    wordCloudData.sort((a, b) => (b['value'] as int) - (a['value'] as int));

    return wordCloudData;
  }
}
