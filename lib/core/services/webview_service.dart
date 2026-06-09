abstract interface class WebViewService {
  Uri get initialUri;
  bool isAllowedHost(Uri uri);
}

class SentraWebViewService implements WebViewService {
  SentraWebViewService({
    required this.initialUrl,
    required this.allowedHosts,
  });

  final String initialUrl;
  final Set<String> allowedHosts;

  @override
  Uri get initialUri => Uri.parse(initialUrl);

  @override
  bool isAllowedHost(Uri uri) {
    return allowedHosts.contains(uri.host.toLowerCase());
  }
}
