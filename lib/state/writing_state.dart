import 'package:flutter/material.dart';

@immutable
class WritingState {
  final String text;
  final bool isPrivate;
  final int seconds;

  const WritingState({
    this.text = '',
    this.isPrivate = false,
    this.seconds = 0,
  });

  WritingState copyWith({
    String? text,
    bool? isPrivate,
    int? seconds,
  }) {
    return WritingState(
      text: text ?? this.text,
      isPrivate: isPrivate ?? this.isPrivate,
      seconds: seconds ?? this.seconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isPrivate': isPrivate,
      'seconds': seconds,
    };
  }
}
