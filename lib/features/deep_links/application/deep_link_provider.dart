import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/di/providers.dart';

final deepLinkStreamProvider = StreamProvider<Uri>((ref) {
  return ref.watch(deepLinkServiceProvider).uriStream;
});
