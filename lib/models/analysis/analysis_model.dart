import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  int? timestamp;
  String? content;
  double? score;
  double? magnitude;
  double? sentiment;
  String? language;
  List<AnalysisModel>? sentences;

  AnalysisModel({
    this.timestamp,
    this.content,
    this.score,
    this.magnitude,
    this.sentiment,
    this.language,
    this.sentences,
  });

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
    List<AnalysisModel>? sentences,
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

  /// Calculates the combined sentiment value based on the given magnitude and score.
  /// The magnitude is normalized to a value between 0 and 1, and then multiplied by the score and 5.
  /// The result is returned as a double with 2 decimal places.
  ///
  /// [magnitude] The magnitude of the sentiment.
  /// [score] The score of the sentiment.
  ///
  /// Returns
  /// [clippedResult] The combined sentiment value as a double with 2 decimal places.
  double combinedSentimentValue(double magnitude, double score) {
    log('$score', name: 'AnalysisModel:score');
    log('$magnitude', name: 'AnalysisModel:magnitude');
    double normalizedMagnitude = (magnitude / 2).clamp(0, 1);
    log('$normalizedMagnitude', name: 'AnalysisModel:normalizedMagnitude');
    double result = normalizedMagnitude * score * 5;
    log('$result', name: 'AnalysisModel:result');
    double clippedResult = (result * 100).truncate() / 100;
    log('$clippedResult', name: 'AnalysisModel:clippedResult');
    return clippedResult;
  }
}
