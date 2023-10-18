class AppBarModel {
  final List<String> pathNames;
  final bool automaticallyImplyLeading;
  final void Function()? onBackButtonPressed;

  AppBarModel({
    this.pathNames = const [],
    this.automaticallyImplyLeading = true,
    this.onBackButtonPressed,
  });

  AppBarModel copyWith({
    List<String>? pathNames,
    bool? automaticallyImplyLeading,
    void Function()? onBackButtonPressed,
  }) {
    return AppBarModel(
      pathNames: pathNames ?? this.pathNames,
      automaticallyImplyLeading:
          automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      onBackButtonPressed: onBackButtonPressed ?? this.onBackButtonPressed,
    );
  }
}
