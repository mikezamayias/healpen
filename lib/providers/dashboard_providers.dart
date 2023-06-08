class DashboardProviders {
  /// Singleton
  static final DashboardProviders _instance = DashboardProviders._internal();
  factory DashboardProviders() => _instance;
  DashboardProviders._internal();
}
