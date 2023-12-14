import 'package:json_annotation/json_annotation.dart';

part 'sentence_model.g.dart';

@JsonSerializable()
class SentenceModel {
  String content;
  double score;
  double magnitude;
  int? wordCount;

  SentenceModel({
    this.content = '',
    this.score = 0,
    this.magnitude = 0,
    int? wordCount,
  }) : wordCount = content
            .toString()
            .split(RegExp(r'\s+'))
            .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s))
            .length;

  factory SentenceModel.fromJson(Map<String, dynamic> json) =>
      _$SentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceModelToJson(this);

  @override
  String toString() {
    return 'SentenceModel('
        'content: $content, score: $score, magnitude: $magnitude, '
        'wordCount: $wordCount'
        ')';
  }

  SentenceModel copyWith({
    int? timestamp,
    int? wordCount,
    String? content,
    double? score,
    double? magnitude,
    String? language,
    List<SentenceModel>? sentences,
  }) {
    return SentenceModel(
      content: content ?? this.content,
      score: score ?? this.score,
      magnitude: magnitude ?? this.magnitude,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SentenceModel &&
        other.content == content &&
        other.score == score &&
        other.magnitude == magnitude &&
        other.wordCount == wordCount;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        score.hashCode ^
        magnitude.hashCode ^
        wordCount.hashCode;
  }
}
