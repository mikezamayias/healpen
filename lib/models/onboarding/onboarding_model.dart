import 'package:flutter/material.dart';

class OnboardingModel {
  final Widget hero;
  final String title;
  final String description;
  final List<OnboardingActionModel> actions;

  OnboardingModel({
    required this.hero,
    required this.title,
    required this.description,
    required this.actions,
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
