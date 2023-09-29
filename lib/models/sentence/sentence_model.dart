import 'package:json_annotation/json_annotation.dart';

import '../../utils/helper_functions.dart';

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel {
  String content;
  double score;
  double magnitude;
  double? sentiment;
  int? wordCount;

  SentenceModel({
    this.content = '',
    this.score = 0,
    this.magnitude = 0,
    double? sentiment,
    int? wordCount,
  })  : wordCount = content
            .toString()
            .split(RegExp(r'\s+'))
            .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s))
            .length,
        sentiment = combinedSentimentValue(magnitude, score);

  factory SentenceModel.fromJson(Map<String, dynamic> json) =>
      _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);

  @override
  String toString() {
    return 'SentenceModel('
        'content: $content, score: $score, magnitude: $magnitude, '
        'sentiment: $sentiment, wordCount: $wordCount'
        ')';
  }

  SentenceModel copyWith({
    int? timestamp,
    int? wordCount,
    String? content,
    double? score,
    double? magnitude,
    double? sentiment,
    String? language,
    List<SentenceModel>? sentences,
  }) {
    return SentenceModel(
      content: content ?? this.content,
      score: score ?? this.score,
      magnitude: magnitude ?? this.magnitude,
      sentiment: sentiment ?? this.sentiment,
      wordCount: wordCount ?? this.wordCount,
    );
  }
}
