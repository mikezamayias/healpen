import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, FeedbackModel>(
  (ref) => FeedbackController(),
);

class FeedbackController extends StateNotifier<FeedbackModel> {
  FeedbackController._() : super(FeedbackModel(labels: []));
  static final FeedbackController _instance = FeedbackController._();
  factory FeedbackController() => _instance;

  final TextEditingController bodyTextController = TextEditingController();

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setBody(String body) {
    state = state.copyWith(body: body);
  }

  void setScreenshotPath(String screenshotPath) {
    state = state.copyWith(screenshotPath: screenshotPath);
  }

  void addLabel(String label) {
    state = state.copyWith(labels: [...state.labels!, label]);
  }

  void removeLabel(String label) {
    state = state.copyWith(labels: state.labels!..remove(label));
  }

  void setIncludeScreenshot(bool includeScreenshot) {
    state = state.copyWith(includeScreenshot: includeScreenshot);
  }

  void reset() {
    state = FeedbackModel(labels: []);
  }

  String get title => state.title;

  String get body => state.body;

  String get screenshotPath => state.screenshotPath;

  List<String>? get labels => state.labels;

  bool get includeScreenshot => state.includeScreenshot;

  @override
  String toString() => 'FeedbackController(state: $state)';
}

class FeedbackModel {
  String title;
  String body;
  List<String>? labels;
  bool includeScreenshot;
  String screenshotPath;

  FeedbackModel({
    this.title = '',
    this.body = '',
    this.labels,
    this.includeScreenshot = true,
    this.screenshotPath = '',
  });

  FeedbackModel copyWith({
    String? title,
    String? body,
    List<String>? labels,
    bool? includeScreenshot,
    String? screenshotPath,
  }) {
    return FeedbackModel(
      title: title ?? this.title,
      body: body ?? this.body,
      labels: labels ?? this.labels,
      includeScreenshot: includeScreenshot ?? this.includeScreenshot,
      screenshotPath: screenshotPath ?? this.screenshotPath,
    );
  }

  @override
  String toString() => 'FeedbackModel(title: $title, body: $body, '
      'includeScreenshot: $includeScreenshot '
      'screenshotPath: $screenshotPath, labels: $labels)';
}
