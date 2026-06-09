import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/di/providers.dart';

final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);

  return (() async* {
    yield await service.isOnline();
    yield* service.onConnectivityChanged;
  })();
});
