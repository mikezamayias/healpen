extension NumberExtension on Iterable<num> {
  num sum() {
    num sum = 0;
    for (num number in this) {
      sum += number;
    }
    return sum;
  }

  num max() {
    num max = 0;
    for (num number in this) {
      if (number > max) {
        max = number;
      }
    }
    return max;
  }

  num min() {
    num min = 0;
    for (num number in this) {
      if (number < min) {
        min = number;
      }
    }
    return min;
  }
}
