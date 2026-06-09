import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentra_mobile/features/webview/application/webview_state.dart';

class WebViewStateNotifier extends StateNotifier<WebViewState> {
  WebViewStateNotifier() : super(WebViewState.initialState);

  void markLoading() {
    state = state.copyWith(status: WebViewStatus.loading, errorMessage: null);
  }

  void markReady() {
    state = state.copyWith(status: WebViewStatus.ready, errorMessage: null);
  }

  void markError(String message) {
    state = state.copyWith(
      status: WebViewStatus.error,
      errorMessage: message,
    );
  }

  void retry() {
    state = state.copyWith(
      status: WebViewStatus.loading,
      errorMessage: null,
      retrySeed: state.retrySeed + 1,
    );
  }
}

final webViewStateProvider =
    StateNotifierProvider<WebViewStateNotifier, WebViewState>((ref) {
  return WebViewStateNotifier();
});
