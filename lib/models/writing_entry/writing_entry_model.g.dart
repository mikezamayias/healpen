// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'writing_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WritingEntryModel _$WritingEntryModelFromJson(Map<String, dynamic> json) =>
    WritingEntryModel(
      content: json['content'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      duration: json['duration'] as int? ?? 0,
      timestamp: json['timestamp'] as int?,
    );

Map<String, dynamic> _$WritingEntryModelToJson(WritingEntryModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'isPrivate': instance.isPrivate,
      'duration': instance.duration,
      'timestamp': instance.timestamp,
    };
