import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadState {
  const DownloadState({
    this.isDownloading = false,
    this.lastFilePath,
    this.errorMessage,
  });

  final bool isDownloading;
  final String? lastFilePath;
  final String? errorMessage;

  DownloadState copyWith({
    bool? isDownloading,
    String? lastFilePath,
    String? errorMessage,
  }) {
    return DownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      lastFilePath: lastFilePath ?? this.lastFilePath,
      errorMessage: errorMessage,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  DownloadNotifier() : super(const DownloadState());

  void markStarted() {
    state = state.copyWith(
      isDownloading: true,
      errorMessage: null,
    );
  }

  void markCompleted(String filePath) {
    state = state.copyWith(
      isDownloading: false,
      lastFilePath: filePath,
      errorMessage: null,
    );
  }

  void markFailed(String message) {
    state = state.copyWith(
      isDownloading: false,
      errorMessage: message,
    );
  }
}

final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier();
});
