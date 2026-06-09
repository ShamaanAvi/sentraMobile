import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/core/di/providers.dart';
import 'package:sentra_mobile/core/services/webview_service.dart';
import 'package:sentra_mobile/features/downloads/application/downloads_provider.dart';
import 'package:sentra_mobile/features/webview/application/webview_controller_provider.dart';
import 'package:sentra_mobile/features/webview/application/webview_state.dart';
import 'package:sentra_mobile/shared/presentation/widgets/app_error_view.dart';
import 'package:sentra_mobile/features/connectivity/application/connectivity_provider.dart';
import 'package:sentra_mobile/shared/presentation/widgets/app_loading_view.dart';

class WebViewHostScreen extends ConsumerStatefulWidget {
  const WebViewHostScreen({super.key});

  @override
  ConsumerState<WebViewHostScreen> createState() => _WebViewHostScreenState();
}

class _WebViewHostScreenState extends ConsumerState<WebViewHostScreen> {
  static final Set<PermissionResourceType> _allowedWebPermissions = {
    PermissionResourceType.CAMERA,
    PermissionResourceType.MICROPHONE,
    PermissionResourceType.CAMERA_AND_MICROPHONE,
  };

  late final PullToRefreshController _pullToRefreshController;
  late final _LifecycleObserver _lifecycleObserver;
  StreamSubscription<Uri>? _deepLinkSubscription;
  InAppWebViewController? _controller;
  Uri? _pendingDeepLinkUri;

  @override
  void initState() {
    super.initState();
    _lifecycleObserver = _LifecycleObserver(onResume: () async {
      if (!mounted) {
        return;
      }

      final online = ref.read(isOnlineProvider).maybeWhen(
            data: (value) => value,
            orElse: () => true,
          );

      if (online) {
        await _controller?.reload();
      }
    });
    WidgetsBinding.instance.addObserver(_lifecycleObserver);

    _pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: const Color(0xFF0D3B66)),
      onRefresh: () async {
        await _controller?.reload();
      },
    );

    _deepLinkSubscription = ref.read(deepLinkServiceProvider).uriStream.listen(
      (uri) async {
        await _handleDeepLink(uri);
      },
    );
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  Future<void> _handleDeepLink(Uri incomingUri) async {
    final webViewService = ref.read(webViewServiceProvider);
    final externalUrlService = ref.read(externalUrlServiceProvider);

    final resolvedInternalUri = _resolveInternalDeepLinkUri(incomingUri);
    if (resolvedInternalUri == null) {
      await externalUrlService.openExternal(incomingUri);
      return;
    }

    if (_controller == null) {
      _pendingDeepLinkUri = resolvedInternalUri;
      return;
    }

    await _controller?.loadUrl(
      urlRequest: URLRequest(url: WebUri(resolvedInternalUri.toString())),
    );
  }

  Uri? _resolveInternalDeepLinkUri(Uri incomingUri) {
    final webViewService = ref.read(webViewServiceProvider);

    if (incomingUri.scheme == 'https' &&
        webViewService.isAllowedHost(incomingUri)) {
      return incomingUri;
    }

    if (incomingUri.scheme == 'sentra') {
      final raw = incomingUri.toString().replaceFirst('sentra://', '');
      final parsed = Uri.tryParse(raw);
      if (parsed != null &&
          parsed.scheme == 'https' &&
          webViewService.isAllowedHost(parsed)) {
        return parsed;
      }
    }

    return null;
  }

  Future<bool> _onWillPop() async {
    final controller = _controller;
    if (controller != null) {
      final canGoBack = await controller.canGoBack();
      if (canGoBack) {
        await controller.goBack();
        return false;
      }
    }

    if (!mounted) {
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to close SENTRA Mobile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

  Future<void> _reloadInitialUrl() async {
    final webViewService = ref.read(webViewServiceProvider);
    await _controller?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri(webViewService.initialUri.toString()),
      ),
    );
  }

  Future<void> _handleDownload(DownloadStartRequest request) async {
    final downloadNotifier = ref.read(downloadNotifierProvider.notifier);
    final downloadService = ref.read(downloadServiceProvider);
    final webViewService = ref.read(webViewServiceProvider);
    final sourceUri = request.url.uriValue;

    final isSecureInternal =
        sourceUri.scheme == 'https' && webViewService.isAllowedHost(sourceUri);
    if (!isSecureInternal) {
      downloadNotifier.markFailed('Blocked non-internal or insecure download.');
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Blocked download from untrusted source.'),
        ),
      );
      return;
    }

    try {
      downloadNotifier.markStarted();
      final filePath = await downloadService.downloadFile(
        source: sourceUri,
        preferredFileName: request.suggestedFilename,
      );
      downloadNotifier.markCompleted(filePath);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Download completed'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              downloadService.openFile(filePath);
            },
          ),
        ),
      );
    } catch (error) {
      downloadNotifier.markFailed(error.toString());
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $error'),
        ),
      );
    }
  }

  Future<NavigationActionPolicy> _handleNavigation(
    NavigationAction action,
    WebViewService webViewService,
  ) async {
    final uri = action.request.url;
    if (uri == null) {
      return NavigationActionPolicy.CANCEL;
    }

    final externalUrlService = ref.read(externalUrlServiceProvider);
    final uriValue = uri.uriValue;
    final scheme = uri.scheme;
    final isHttpScheme = scheme == 'http' || scheme == 'https';

    if (!isHttpScheme) {
      await externalUrlService.openExternal(uriValue);
      return NavigationActionPolicy.CANCEL;
    }

    if (scheme != 'https') {
      ref.read(webViewStateProvider.notifier).markError(
            'Only secure HTTPS navigation is allowed.',
          );
      return NavigationActionPolicy.CANCEL;
    }

    final isInternal = webViewService.isAllowedHost(uriValue);
    if (!isInternal) {
      await externalUrlService.openExternal(uriValue);
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }

  @override
  Widget build(BuildContext context) {
    final webViewService = ref.watch(webViewServiceProvider);
    final onlineState = ref.watch(isOnlineProvider);
    final webViewState = ref.watch(webViewStateProvider);
    final notifier = ref.read(webViewStateProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final shouldExit = await _onWillPop();
        if (shouldExit) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SENTRA'),
        ),
        body: SafeArea(
          child: onlineState.when(
            data: (isOnline) {
              if (!isOnline) {
                return AppErrorView(
                  message: 'No internet connection. Please reconnect and retry.',
                  onRetry: () async {
                    notifier.retry();
                    await _reloadInitialUrl();
                  },
                );
              }

              return Stack(
                children: [
                  InAppWebView(
                    key: ValueKey(webViewState.retrySeed),
                    pullToRefreshController: _pullToRefreshController,
                    initialUrlRequest: URLRequest(
                      url: WebUri(webViewService.initialUri.toString()),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      domStorageEnabled: true,
                      databaseEnabled: true,
                      useHybridComposition: true,
                      mixedContentMode:
                          MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
                      safeBrowsingEnabled: true,
                      supportZoom: false,
                      allowsInlineMediaPlayback: true,
                      isInspectable: false,
                      transparentBackground: false,
                      mediaPlaybackRequiresUserGesture: false,
                      allowFileAccessFromFileURLs: true,
                      allowUniversalAccessFromFileURLs: false,
                      useShouldOverrideUrlLoading: true,
                      clearCache: false,
                      cacheEnabled: true,
                      sharedCookiesEnabled: true,
                    ),
                    onWebViewCreated: (controller) {
                      _controller = controller;
                      notifier.markLoading();
                      final pendingUri = _pendingDeepLinkUri;
                      if (pendingUri != null) {
                        _pendingDeepLinkUri = null;
                        controller.loadUrl(
                          urlRequest: URLRequest(
                            url: WebUri(pendingUri.toString()),
                          ),
                        );
                      }
                    },
                    onLoadStart: (controller, url) {
                      _controller = controller;
                      notifier.markLoading();
                    },
                    onLoadStop: (controller, url) {
                      _pullToRefreshController.endRefreshing();
                      notifier.markReady();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress >= 100) {
                        _pullToRefreshController.endRefreshing();
                        notifier.markReady();
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      _pullToRefreshController.endRefreshing();
                      notifier.markError(
                        'Failed to load content (${error.description}).',
                      );
                    },
                    onReceivedHttpError: (controller, request, response) {
                      _pullToRefreshController.endRefreshing();
                      notifier.markError(
                        'Server returned HTTP ${response.statusCode}.',
                      );
                    },
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      notifier.markError(
                        'Secure connection validation failed.',
                      );
                      return ServerTrustAuthResponse(
                        action: ServerTrustAuthResponseAction.CANCEL,
                      );
                    },
                    onDownloadStartRequest: (controller, request) async {
                      await _handleDownload(request);
                    },
                    onPermissionRequest: (controller, request) async {
                      final canGrant = request.resources.every(
                        _allowedWebPermissions.contains,
                      );

                      return PermissionResponse(
                        resources: request.resources,
                        action: canGrant
                            ? PermissionResponseAction.GRANT
                            : PermissionResponseAction.DENY,
                      );
                    },
                    shouldOverrideUrlLoading: (controller, action) async {
                      return _handleNavigation(action, webViewService);
                    },
                  ),
                  if (webViewState.status == WebViewStatus.loading)
                    const ColoredBox(
                      color: Colors.white,
                      child: AppLoadingView(),
                    ),
                  if (webViewState.status == WebViewStatus.error)
                    ColoredBox(
                      color: Colors.white,
                      child: AppErrorView(
                        message: webViewState.errorMessage ??
                            'Unable to load SENTRA right now.',
                        onRetry: () async {
                          notifier.retry();
                          await _reloadInitialUrl();
                        },
                      ),
                    ),
                ],
              );
            },
            loading: AppLoadingView.new,
            error: (error, stackTrace) {
              return AppErrorView(
                message: 'Connectivity error: $error',
                onRetry: () async {
                  notifier.retry();
                  await _reloadInitialUrl();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  _LifecycleObserver({required this.onResume});

  final Future<void> Function() onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
