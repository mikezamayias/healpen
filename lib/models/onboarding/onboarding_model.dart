import 'package:flutter/material.dart';

class OnboardingModel {
  final Widget hero;
  final String title;
  final String description;
  final List<OnboardingActionModel> actions;
  final List<OnboardingActionModel>? informativeActions;

  OnboardingModel({
    required this.hero,
    required this.title,
    required this.description,
    required this.actions,
    this.informativeActions,
  });
}

class OnboardingActionModel {
  final String title;
  final VoidCallback? actionCallback;

  OnboardingActionModel({
    required this.title,
    this.actionCallback,
  });
}
