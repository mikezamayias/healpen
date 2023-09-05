// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      content: json['content'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      duration: json['duration'] as int? ?? 0,
      wordCount: json['wordCount'] as int?,
      timestamp: json['timestamp'] as int?,
      sentenceCount: json['sentenceCount'] as int?,
      sentimentScore: (json['sentimentScore'] as num?)?.toDouble(),
      sentimentMagnitude: (json['sentimentMagnitude'] as num?)?.toDouble(),
      sentiment: json['sentiment'] as int?,
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'content': instance.content,
      'isPrivate': instance.isPrivate,
      'isFavorite': instance.isFavorite,
      'duration': instance.duration,
      'timestamp': instance.timestamp,
      'wordCount': instance.wordCount,
      'sentimentScore': instance.sentimentScore,
      'sentimentMagnitude': instance.sentimentMagnitude,
      'sentenceCount': instance.sentenceCount,
      'sentiment': instance.sentiment,
    };
