class CurrentAppColorController {
  // Singleton
  static final CurrentAppColorController _currentAppColor =
      CurrentAppColorController._internal();
  CurrentAppColorController._internal();
  factory CurrentAppColorController() => _currentAppColor;
}
