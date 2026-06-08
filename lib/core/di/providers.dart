import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/config/app_environment.dart';
import 'package:sentra_mobile/core/services/connectivity_service.dart';
import 'package:sentra_mobile/core/services/deep_link_service.dart';
import 'package:sentra_mobile/core/services/secure_storage_service.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromDefines();
});

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityPlusService(ref.watch(connectivityProvider));
});

final appLinksProvider = Provider<AppLinks>((ref) {
  return AppLinks();
});

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return AppLinksDeepLinkService(ref.watch(appLinksProvider));
});

final secureStorageDriverProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return FlutterSecureStorageService(ref.watch(secureStorageDriverProvider));
});
