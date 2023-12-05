extension DoubleExtension on double {
  double withDecimalPlaces(int decimalPlaces) {
    return double.parse(toStringAsFixed(decimalPlaces));
  }
}
