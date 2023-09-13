import 'package:github/github.dart';

enum FeedbackLabel {
  highPriority(
    name: 'Priority: High',
    color: 0xffffc0cb,
    description: 'This issue is critical and should be addressed immediately.',
  ),
  mediumPriority(
    name: 'Priority: Medium',
    color: 0xffffdab9,
    description: 'This issue is important but not critical. It should be '
        'addressed in the normal course of development.',
  ),
  lowPriority(
    name: 'Priority: Low',
    color: 0xffbdfcc9,
    description: 'This issue has a lower priority and can be addressed '
        'when higher-priority issues are resolved.',
  ),
  bug(
    name: 'Bug',
    color: 0xffffc0cb,
    description: 'This issue describes a bug or unexpected behavior '
        'in the software.',
  ),
  featureRequest(
    name: 'Feature Request',
    color: 0xffb0e0e6,
    description: 'This issue is a feature request or enhancement suggestion.',
  ),
  enhancement(
    name: 'Enhancement',
    color: 0xffe6e6fa,
    description: 'This issue suggests an improvement or enhancement to '
        'an existing feature.',
  ),
  question(
    name: 'Question',
    color: 0xffffff00,
    description: 'This issue is a question or inquiry that needs a response.',
  );

  const FeedbackLabel({
    required this.name,
    required this.color,
    required this.description,
  });

  final String name;
  final int color;
  final String description;

  @override
  String toString() {
    return 'FeedbackLabel{name: $name, color: $color, '
        'description: $description';
  }

  IssueLabel toIssueLabel() {
    return IssueLabel(name: name, color: '$color');
  }
}
