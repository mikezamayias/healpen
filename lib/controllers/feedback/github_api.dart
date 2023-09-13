import 'dart:developer';

import 'package:github/github.dart';

import 'feedback.dart';

class GitHubAPI {
  final String token;
  final String owner;
  final String repo;

  GitHubAPI(this.token, this.owner, this.repo);

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
        await FeedbackController.appInfo(),
        await FeedbackController.deviceInfo(),
        if (screenshotUrl != null)
          '# Screenshot\n![screenshot]($screenshotUrl)',
      ].join('\n'),
      labels: labels,
    );
    await github.issues.create(repoSlug, issue);
  }
}
