import 'package:json_annotation/json_annotation.dart';

import '../../utils/helper_functions.dart';

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel {
  String content;
  double score;
  double magnitude;
  double? sentiment;

  SentenceModel({
    this.content = '',
    this.score = 0,
    this.magnitude = 0,
    double? sentiment,
  }) : sentiment = combinedSentimentValue(magnitude, score);

  factory SentenceModel.fromJson(Map<String, dynamic> json) =>
      _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);

  @override
  String toString() {
    return 'SentenceModel('
        'content: $content, score: $score, magnitude: $magnitude, '
        'sentiment: $sentiment'
        ')';
  }

  SentenceModel copyWith({
    int? timestamp,
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
    );
  }
}
