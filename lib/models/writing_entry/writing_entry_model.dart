import 'package:json_annotation/json_annotation.dart';

part 'writing_entry_model.g.dart';

@JsonSerializable()
class WritingEntryModel {
  String content;
  bool isPrivate;
  int duration;
  int timestamp;

  WritingEntryModel({
    this.content = '',
    this.isPrivate = false,
    this.duration = 0,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  factory WritingEntryModel.fromDocument(Map<String, dynamic> json) =>
      _$WritingEntryModelFromJson(json);

  Map<String, dynamic> toDocument() => _$WritingEntryModelToJson(this);

  WritingEntryModel copyWith({
    String? content,
    bool? isPrivate,
    int? duration,
    int? timestamp,
  }) {
    return WritingEntryModel(
      content: content ?? this.content,
      isPrivate: isPrivate ?? this.isPrivate,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'WritingEntryModel(content: $content, isPrivate: $isPrivate, duration: $duration, timestamp: $timestamp)';
  }
}
