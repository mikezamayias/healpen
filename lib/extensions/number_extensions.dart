extension NumberExtension on List<num> {
  num sum() {
    num sum = 0;
    for (num number in this) {
      sum += number;
    }
    return sum;
  }

  num average() {
    return sum() / length;
  }
}
