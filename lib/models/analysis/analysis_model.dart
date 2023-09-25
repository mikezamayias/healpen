import 'package:json_annotation/json_annotation.dart';

import '../../utils/helper_functions.dart';
import '../sentence/sentence_model.dart';

part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  int timestamp;
  String content;
  double score;
  double magnitude;
  double? sentiment;
  String language;
  @JsonKey(includeToJson: false)
  List<SentenceModel> sentences;

  AnalysisModel({
    this.timestamp = 0,
    this.content = '',
    this.score = 0,
    this.magnitude = 0,
    double? sentiment,
    this.language = '',
    this.sentences = const [],
  }) : sentiment = combinedSentimentValue(magnitude, score);

  factory AnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$AnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  @override
  String toString() {
    return 'AnalysisModel('
        'timestamp: $timestamp, content: $content, score: $score, '
        'magnitude: $magnitude, sentiment: $sentiment, language: $language, '
        'sentences: $sentences'
        ')';
  }

  AnalysisModel copyWith({
    int? timestamp,
    String? content,
    double? score,
    double? magnitude,
    double? sentiment,
    String? language,
    List<SentenceModel>? sentences,
  }) {
    return AnalysisModel(
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      score: score ?? this.score,
      magnitude: magnitude ?? this.magnitude,
      sentiment: sentiment ?? this.sentiment,
      language: language ?? this.language,
      sentences: sentences ?? this.sentences,
    );
  }
}
