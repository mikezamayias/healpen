class PreferenceModel<T> {
  final String key;
  T value;

  PreferenceModel(this.key, this.value);

  @override
  String toString() {
    return 'PreferenceModel{key: $key, value: $value}';
  }

  withValue(T value) {
    return PreferenceModel(key, value);
  }
}
