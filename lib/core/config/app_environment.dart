enum AppFlavor { production }

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.baseUrl,
  });

  final AppFlavor flavor;
  final String baseUrl;

  static const String _defaultBaseUrl = 'https://sentra.airforce.lk';

  factory AppEnvironment.fromDefines() {
    const baseUrl = String.fromEnvironment(
      'SENTRA_BASE_URL',
      defaultValue: _defaultBaseUrl,
    );

    return const AppEnvironment(
      flavor: AppFlavor.production,
      baseUrl: baseUrl,
    );
  }
}
