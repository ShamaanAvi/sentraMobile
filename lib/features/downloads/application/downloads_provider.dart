import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadState {
  const DownloadState({
    this.isDownloading = false,
    this.lastFilePath,
  });

  final bool isDownloading;
  final String? lastFilePath;

  DownloadState copyWith({
    bool? isDownloading,
    String? lastFilePath,
  }) {
    return DownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      lastFilePath: lastFilePath ?? this.lastFilePath,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  DownloadNotifier() : super(const DownloadState());

  void markStarted() {
    state = state.copyWith(isDownloading: true);
  }

  void markCompleted(String filePath) {
    state = state.copyWith(
      isDownloading: false,
      lastFilePath: filePath,
    );
  }
}

final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier();
});
