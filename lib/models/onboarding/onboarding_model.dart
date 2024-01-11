import 'dart:ui';

class OnboardingModel {
  final String title;
  final String description;
  final String actionText;
  final VoidCallback actionCallback;

  OnboardingModel._({
    required this.title,
    required this.description,
    required this.actionText,
    required this.actionCallback,
  });

  factory OnboardingModel.builder() {
    return OnboardingModel._(
      title: '',
      description: '',
      actionText: '',
      actionCallback: () {},
    );
  }

  OnboardingModel copyWith({
    String? title,
    String? description,
    String? actionText,
    VoidCallback? actionCallback,
  }) {
    return OnboardingModel._(
      title: title ?? this.title,
      description: description ?? this.description,
      actionText: actionText ?? this.actionText,
      actionCallback: actionCallback ?? this.actionCallback,
    );
  }
}
