import 'package:github/github.dart';

enum FeedbackLabel {
  highPriority(
    name: 'Priority: High',
    color: 0xffff0000, // Red
    description: 'This issue is critical and should be addressed immediately.',
  ),
  mediumPriority(
    name: 'Priority: Medium',
    color: 0xffffa500, // Orange
    description:
        'This issue is important but not critical. It should be addressed in the normal course of development.',
  ),
  lowPriority(
    name: 'Priority: Low',
    color: 0xff008000, // Green
    description:
        'This issue has a lower priority and can be addressed when higher-priority issues are resolved.',
  ),
  bug(
    name: 'Bug',
    color: 0xffff0000, // Red
    description:
        'This issue describes a bug or unexpected behavior in the software.',
  ),
  featureRequest(
    name: 'Feature Request',
    color: 0xff008000, // Green
    description: 'This issue is a feature request or enhancement suggestion.',
  ),
  documentation(
    name: 'Documentation',
    color: 0xff0000ff, // Blue
    description: 'This issue involves updating or creating documentation.',
  ),
  enhancement(
    name: 'Enhancement',
    color: 0xff800080, // Purple
    description:
        'This issue suggests an improvement or enhancement to an existing feature.',
  ),
  question(
    name: 'Question',
    color: 0xffffff00, // Yellow
    description: 'This issue is a question or inquiry that needs a response.',
  ),
  helpWanted(
    name: 'Help Wanted',
    color: 0xffffa500, // Orange
    description:
        'This issue is open to community contributions, and help is needed.',
  ),
  inProgress(
    name: 'In Progress',
    color: 0xff008080, // Teal
    description: 'This issue is actively being worked on by a contributor.',
  ),
  closed(
    name: 'Closed',
    color: 0xff808080, // Gray
    description: 'This issue has been resolved and closed.',
  ),
  blocked(
    name: 'Blocked',
    color: 0xffa52a2a, // Brown
    description: 'This issue is blocked by another issue or external factor.',
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
