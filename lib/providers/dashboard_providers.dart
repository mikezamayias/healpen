import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardProviders {
  static final DashboardProviders _singleton = DashboardProviders._internal();
  factory DashboardProviders() => _singleton;
  DashboardProviders._internal();

  final currentDateIndex = StateProvider((ref) => 0);
  final currentDate = StateProvider((ref) => DateTime.now());
}
