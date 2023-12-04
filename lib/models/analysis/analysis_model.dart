import 'package:json_annotation/json_annotation.dart';

import '../sentence/sentence_model.dart';

part 'analysis_model.g.dart';

@JsonSerializable()
class AnalysisModel {
  int timestamp;
  int duration;
  String content;
  double score;
  double magnitude;
  int? wordCount;
  String language;
  @JsonKey(includeToJson: false)
  List<SentenceModel> sentences;

  AnalysisModel({
    this.timestamp = 0,
    this.duration = 0,
    this.content = '',
    this.score = 0,
    this.magnitude = 0,
    int? wordCount,
    this.language = '',
    this.sentences = const [],
  }) : wordCount = content
            .toString()
            .split(RegExp(r'\s+'))
            .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s))
            .length;

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return _$AnalysisModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnalysisModelToJson(this);

  @override
  String toString() {
    return 'AnalysisModel('
        'timestamp: $timestamp, duration: $duration, content: $content, '
        'score: $score, magnitude: $magnitude, wordCount: $wordCount, '
        'language: $language, sentences: $sentences'
        ')';
  }

  AnalysisModel copyWith({
    int? timestamp,
    int? duration,
    String? content,
    double? score,
    double? magnitude,
    int? wordCount,
    String? language,
    List<SentenceModel>? sentences,
  }) {
    return AnalysisModel(
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      content: content ?? this.content,
      score: score ?? this.score,
      magnitude: magnitude ?? this.magnitude,
      wordCount: wordCount ?? this.wordCount,
      language: language ?? this.language,
      sentences: sentences ?? this.sentences,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisModel &&
        other.timestamp == timestamp &&
        other.duration == duration &&
        other.content == content &&
        other.score == score &&
        other.magnitude == magnitude &&
        other.wordCount == wordCount &&
        other.language == language &&
        other.sentences == sentences;
  }

  @override
  int get hashCode {
    return timestamp.hashCode ^
        duration.hashCode ^
        content.hashCode ^
        score.hashCode ^
        magnitude.hashCode ^
        wordCount.hashCode ^
        language.hashCode ^
        sentences.hashCode;
  }
}
