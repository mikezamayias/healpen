import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

int calculateSentiment(double? score, double? magnitude) {
  double threshold = 0.5;
  double realScore = score ?? 0;
  double realMagnitude = magnitude ?? 0;

  int signScore = 0;
  if (realScore > 0) {
    signScore = 1;
  } else if (realScore < 0) {
    signScore = -1;
  }

  // Using a ternary operator for the ceiling function behavior
  int ceilingValue = (realMagnitude - threshold) > 0 ? 1 : 0;

  return signScore * ceilingValue;
}

@JsonSerializable()
class NoteModel {
  String content;
  bool isPrivate;
  bool isFavorite;
  int duration;
  int timestamp;
  int? wordCount;
  double? sentimentScore;
  double? sentimentMagnitude;
  int? sentenceCount;
  int? sentiment;

  NoteModel({
    this.content = '',
    this.isPrivate = false,
    this.isFavorite = false,
    this.duration = 0,
    int? wordCount,
    int? timestamp,
    int? sentenceCount,
    double? sentimentScore,
    double? sentimentMagnitude,
    int? sentiment,
  })  : wordCount = content
            .toString()
            .split(RegExp(r'\s+'))
            .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s))
            .length,
        timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        sentenceCount = sentenceCount ?? 0,
        sentimentScore = sentimentScore ?? 0.0,
        sentimentMagnitude = sentimentMagnitude ?? 0.0,
        sentiment =
            sentiment ?? calculateSentiment(sentimentScore, sentimentMagnitude);

  factory NoteModel.fromDocument(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toDocument() => _$NoteModelToJson(this);

  NoteModel copyWith(
    NoteModel? noteModel, {
    String? content,
    bool? isPrivate,
    bool? isFavorite,
    int? duration,
    int? timestamp,
    int? wordCount,
    double? sentimentScore,
    double? sentimentMagnitude,
    int? sentenceCount,
    int? sentiment,
  }) {
    return NoteModel(
      content: noteModel?.content ?? (content ?? this.content),
      isPrivate: noteModel?.isPrivate ?? (isPrivate ?? this.isPrivate),
      isFavorite: noteModel?.isFavorite ?? (isFavorite ?? this.isFavorite),
      duration: noteModel?.duration ?? (duration ?? this.duration),
      timestamp: noteModel?.timestamp ?? (timestamp ?? this.timestamp),
      wordCount: noteModel?.wordCount ?? (wordCount ?? this.wordCount),
      sentimentScore:
          noteModel?.sentimentScore ?? (sentimentScore ?? this.sentimentScore),
      sentimentMagnitude: noteModel?.sentimentMagnitude ??
          (sentimentMagnitude ?? this.sentimentMagnitude),
      sentenceCount:
          noteModel?.sentenceCount ?? (sentenceCount ?? this.sentenceCount),
      sentiment: noteModel?.sentiment ?? (sentiment ?? this.sentiment),
    );
  }

  @override
  String toString() {
    return 'NoteModel('
        'content: $content, isPrivate: $isPrivate, isFavorite: $isFavorite, '
        'duration: $duration, timestamp: $timestamp, wordCount: $wordCount, '
        'sentimentScore: $sentimentScore, '
        'sentimentMagnitude: $sentimentMagnitude, '
        'sentenceCount: $sentenceCount, sentiment: $sentiment'
        ')';
  }
}
