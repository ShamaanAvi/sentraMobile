abstract interface class WebViewService {
  Uri get initialUri;
  bool isAllowedHost(Uri uri);
}

class SentraWebViewService implements WebViewService {
  SentraWebViewService({required this.host});

  final String host;

  @override
  Uri get initialUri => Uri.parse('https://$host');

  @override
  bool isAllowedHost(Uri uri) {
    return uri.host == host;
  }
}
