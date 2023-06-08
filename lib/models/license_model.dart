class LicenceModel {
  final String packageName;
  final List<String> licenceParagraphs;

  LicenceModel({
    required this.packageName,
    required this.licenceParagraphs,
  });

  @override
  String toString() {
    return 'LicenceItemModel(packageName: $packageName, licenceParagraphs: $licenceParagraphs)';
  }
}
