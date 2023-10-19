import 'dart:developer';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

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

  void setScreenshotUrl(String screenshotUrl) {
    state = state.copyWith(screenshotUrl: screenshotUrl);
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

  void cleanUp() {
    log(
      'Cleaning up feedback controller.',
      name: 'FeedbackController:cleanUp',
    );
    bodyTextController.clear();
    _deleteScreenshot(state.screenshotPath);
    state = FeedbackModel(labels: []);
  }

  void _deleteScreenshot(String screenshotPath) {
    final file = File(screenshotPath);
    if (file.existsSync()) {
      file.deleteSync();
      log(
        'Screenshot deleted successfully.',
        name: 'FeedbackController:_deleteScreenshot',
      );
    } else {
      log(
        'Screenshot does not exist.',
        name: 'FeedbackController:_deleteScreenshot',
      );
    }
  }

  String get title => state.title;

  String get body => state.body;

  String get screenshotPath => state.screenshotPath;

  String get screenshotUrl => state.screenshotUrl;

  List<String>? get labels => state.labels;

  bool get includeScreenshot => state.includeScreenshot;

  @override
  String toString() => 'FeedbackController(state: $state)';

  static Future<String> writeImageToStorage(
      Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath =
        '${output.path}/feedback_${DateTime.now().microsecondsSinceEpoch ~/ 1000}.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }

  static Future<String> uploadScreenshotToFirebase(File screenshot) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('feedback_screenshots/${DateTime.now().toIso8601String()}.png');
    final uploadTask = storageReference.putFile(screenshot);
    final taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> appInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String result = [
      '# App Info',
      'App Name: ${packageInfo.appName}',
      'Package Name: ${packageInfo.packageName}',
      'Version: ${packageInfo.version}',
      'Build Number: ${packageInfo.buildNumber}',
      'Build Signature: ${packageInfo.buildSignature}',
      'Installer Store: ${packageInfo.installerStore}',
    ].join('\n');
    log(
      result,
      name: 'GitHubAPI:appInfo',
    );
    return result;
  }

  static Future<String> deviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (Platform.isAndroid) {
      String result = [
        '# Device Info',
        'Device: ${deviceInfo.data['device']}',
        'Brand: ${deviceInfo.data['brand']}',
        'Model: ${deviceInfo.data['model']}',
        'Version: ${deviceInfo.data['version']}',
        'Board: ${deviceInfo.data['board']}',
        'Is Physical Device: ${deviceInfo.data['isPhysicalDevice']}',
      ].join('\n');
      log(
        result,
        name: 'GitHubAPI:deviceInfo',
      );
      return result;
    } else {
      String result = [
        '# Device Info',
        'Name: ${deviceInfo.data['name']}',
        'System Name: ${deviceInfo.data['systemName']}',
        'System Version: ${deviceInfo.data['systemVersion']}',
        'Is Physical Device: ${deviceInfo.data['isPhysicalDevice']}',
      ].join('\n');
      log(
        result,
        name: 'GitHubAPI:deviceInfo',
      );
      return result;
    }
  }
}

class FeedbackModel {
  String title;
  String body;
  List<String>? labels;
  bool includeScreenshot;
  String screenshotPath;
  String screenshotUrl;

  FeedbackModel({
    this.title = '',
    this.body = '',
    this.labels,
    this.includeScreenshot = true,
    this.screenshotPath = '',
    this.screenshotUrl = '',
  });

  FeedbackModel copyWith({
    String? title,
    String? body,
    List<String>? labels,
    bool? includeScreenshot,
    String? screenshotPath,
    String? screenshotUrl,
  }) {
    return FeedbackModel(
      title: title ?? this.title,
      body: body ?? this.body,
      labels: labels ?? this.labels,
      includeScreenshot: includeScreenshot ?? this.includeScreenshot,
      screenshotPath: screenshotPath ?? this.screenshotPath,
      screenshotUrl: screenshotUrl ?? this.screenshotUrl,
    );
  }

  @override
  String toString() => 'FeedbackModel(title: $title, body: $body, '
      'includeScreenshot: $includeScreenshot, labels: $labels, '
      'screenshotPath: $screenshotPath, screenshotUrl: $screenshotUrl)';
}
