import 'package:app_links/app_links.dart';

abstract interface class DeepLinkService {
  Stream<Uri> get uriStream;
}

class AppLinksDeepLinkService implements DeepLinkService {
  AppLinksDeepLinkService(this._appLinks);

  final AppLinks _appLinks;

  @override
  Stream<Uri> get uriStream => _appLinks.uriLinkStream;
}
