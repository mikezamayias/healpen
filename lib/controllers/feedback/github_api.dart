import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:github/github.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GitHubAPI {
  final String token;
  final String owner;
  final String repo;

  GitHubAPI(this.token, this.owner, this.repo);

  Future<String> uploadScreenshotToFirebase(File screenshot) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('feedback_screenshots/${DateTime.now().toIso8601String()}.png');
    final uploadTask = storageReference.putFile(screenshot);
    final taskSnapshot = await uploadTask;
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> appInfo() async {
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

  Future<String> deviceInfo() async {
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

  Future<void> createIssue(
    String title,
    String feedbackText,
    String? screenshotUrl,
    List<String> labels,
  ) async {
    log(
      '$screenshotUrl',
      name: 'GitHubAPI:createIssue:screenshotUrl',
    );
    final github = GitHub(auth: Authentication.withToken(token));
    final repoSlug = RepositorySlug(owner, repo);
    final issue = IssueRequest(
      title: title,
      body: [
        '# Feedback\n$feedbackText',
        await appInfo(),
        await deviceInfo(),
        if (screenshotUrl != null) '# Screenshot\n$screenshotUrl',
      ].join('\n'),
      labels: labels,
    );
    await github.issues.create(repoSlug, issue);
  }
}
