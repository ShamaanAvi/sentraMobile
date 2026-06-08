import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentra_mobile/features/webview/presentation/screens/webview_host_screen.dart';

class AppRouter {
  const AppRouter._();

  static GoRouter createRouter() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => const WebViewHostScreen(),
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(
            child: Text('Navigation error: ${state.error}'),
          ),
        );
      },
    );
  }
}
