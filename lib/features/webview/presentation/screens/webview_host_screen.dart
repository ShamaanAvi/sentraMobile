import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/di/providers.dart';
import 'package:sentra_mobile/features/connectivity/application/connectivity_provider.dart';
import 'package:sentra_mobile/shared/presentation/widgets/app_loading_view.dart';

class WebViewHostScreen extends ConsumerWidget {
  const WebViewHostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(appEnvironmentProvider);
    final onlineState = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SENTRA'),
      ),
      body: SafeArea(
        child: onlineState.when(
          data: (isOnline) {
            if (!isOnline) {
              return const Center(
                child: Text('You are offline. Please reconnect and retry.'),
              );
            }

            return Center(
              child: Text(
                'Phase 1 foundation ready.\nWebView target: ${environment.baseUrl}',
                textAlign: TextAlign.center,
              ),
            );
          },
          loading: AppLoadingView.new,
          error: (error, stackTrace) {
            return Center(
              child: Text('Connectivity error: $error'),
            );
          },
        ),
      ),
    );
  }
}
