import 'package:flutter/material.dart';

class OnboardingModel {
  final Widget hero;
  final String title;
  final String description;
  final String actionText;
  final VoidCallback actionCallback;

  OnboardingModel({
    required this.hero,
    required this.title,
    required this.description,
    required this.actionText,
    required this.actionCallback,
  });
}
