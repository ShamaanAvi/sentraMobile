import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/di/providers.dart';

final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});
