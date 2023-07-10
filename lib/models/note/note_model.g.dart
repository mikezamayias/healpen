// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      content: json['content'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      duration: json['duration'] as int? ?? 0,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'content': instance.content,
      'isPrivate': instance.isPrivate,
      'duration': instance.duration,
      'timestamp': instance.timestamp,
    };
