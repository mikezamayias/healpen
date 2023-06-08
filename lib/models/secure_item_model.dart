class SecureItemModel {
  SecureItemModel({this.key, this.value});

  String? key;
  String? value;

  @override
  toString() {
    return 'SecureItemModel(key: $key, value: $value)';
  }
}
