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
    const definedBaseUrl = String.fromEnvironment(
      'SENTRA_BASE_URL',
      defaultValue: _defaultBaseUrl,
    );

    final parsed = Uri.tryParse(definedBaseUrl);
    final isSecure =
        parsed != null && parsed.hasScheme && parsed.scheme == 'https';
    final normalizedBaseUrl = isSecure ? definedBaseUrl : _defaultBaseUrl;

    return AppEnvironment(
      flavor: AppFlavor.production,
      baseUrl: normalizedBaseUrl,
    );
  }
}
