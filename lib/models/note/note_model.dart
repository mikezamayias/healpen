import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class NoteModel {
  String content;
  bool isPrivate;
  int duration;
  int timestamp;

  NoteModel({
    this.content = '',
    this.isPrivate = false,
    this.duration = 0,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory NoteModel.fromDocument(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toDocument() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? content,
    bool? isPrivate,
    int? duration,
    int? timestamp,
  }) {
    return NoteModel(
      content: content ?? this.content,
      isPrivate: isPrivate ?? this.isPrivate,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'NoteModel(content: $content, isPrivate: $isPrivate, duration: $duration, timestamp: $timestamp)';
  }
}
