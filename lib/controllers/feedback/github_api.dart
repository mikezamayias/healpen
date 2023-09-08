import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:github/github.dart';

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

  Future<void> createIssue(
    String title,
    String feedbackText,
    String? screenshotUrl,
    List<String> labels,
  ) async {
    final github = GitHub(auth: Authentication.withToken(token));
    final repoSlug = RepositorySlug(owner, repo);
    final issue = IssueRequest(
      title: title,
      body: '''
      Body:
      $feedbackText
      Screenshot:
      ${screenshotUrl != null}
      ''',
      labels: labels,
    );
    await github.issues.create(repoSlug, issue);
  }
}
