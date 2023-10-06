import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

//   double threshold = 0.5;
//   double realScore = score ?? 0;
//   double realMagnitude = magnitude ?? 0;
//
//   int signScore = 0;
//   if (realScore > 0) {
//     signScore = 1;
//   } else if (realScore < 0) {
//     signScore = -1;
//   }
//
//   // Using a ternary operator for the ceiling function behavior
//   int ceilingValue = (realMagnitude - threshold) > 0 ? 1 : 0;
//
//   return signScore * ceilingValue;
// }

@JsonSerializable()
class NoteModel {
  String content;
  bool isPrivate;
  bool isFavorite;
  int duration;
  int timestamp;

  NoteModel({
    this.content = '',
    this.isPrivate = false,
    this.isFavorite = false,
    this.duration = 0,
    int? timestamp,
    int? sentenceCount,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  NoteModel copyWith({
    String? content,
    bool? isPrivate,
    bool? isFavorite,
    int? duration,
    int? timestamp,
  }) {
    return NoteModel(
      content: content ?? this.content,
      isPrivate: isPrivate ?? this.isPrivate,
      isFavorite: isFavorite ?? this.isFavorite,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'NoteModel('
        'content: $content, isPrivate: $isPrivate, isFavorite: $isFavorite, '
        'duration: $duration, timestamp: $timestamp'
        ')';
  }
}
