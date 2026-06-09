import 'package:url_launcher/url_launcher.dart';

abstract interface class ExternalUrlService {
  Future<bool> openExternal(Uri uri);
}

class UrlLauncherExternalUrlService implements ExternalUrlService {
  const UrlLauncherExternalUrlService();

  @override
  Future<bool> openExternal(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
