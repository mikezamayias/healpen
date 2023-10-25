class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;

  @override
  String toString() {
    return 'ChartData(x: $x, y: $y)';
  }
}
