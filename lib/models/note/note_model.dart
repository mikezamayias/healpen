import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  String content;
  bool isPrivate;
  bool isFavorite;
  int duration;
  int timestamp;
  int wordCount;

  NoteModel({
    this.content = '',
    this.isPrivate = false,
    this.isFavorite = false,
    this.duration = 0,
    int? wordCount,
    int? timestamp,
  })  : wordCount = content
            .toString()
            .split(RegExp(r'\s+'))
            .where((s) => RegExp(r'[a-zA-Z]').hasMatch(s))
            .length,
        timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory NoteModel.fromDocument(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toDocument() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? content,
    bool? isPrivate,
    bool? isFavorite,
    int? duration,
    int? timestamp,
    int? wordCount,
  }) {
    return NoteModel(
      content: content ?? this.content,
      isPrivate: isPrivate ?? this.isPrivate,
      isFavorite: isFavorite ?? this.isFavorite,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
      wordCount: wordCount ?? this.wordCount,
    );
  }

  @override
  String toString() {
    return 'NoteModel(content: $content, isPrivate: $isPrivate, duration: $duration, timestamp: $timestamp, wordCount: $wordCount, isFavorite: $isFavorite)';
  }
}
