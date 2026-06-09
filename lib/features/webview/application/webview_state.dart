enum WebViewStatus {
  initial,
  loading,
  ready,
  error,
}

class WebViewState {
  const WebViewState({
    required this.status,
    this.errorMessage,
    this.retrySeed = 0,
  });

  final WebViewStatus status;
  final String? errorMessage;
  final int retrySeed;

  WebViewState copyWith({
    WebViewStatus? status,
    String? errorMessage,
    int? retrySeed,
  }) {
    return WebViewState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      retrySeed: retrySeed ?? this.retrySeed,
    );
  }

  static const initialState = WebViewState(status: WebViewStatus.initial);
}
