import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class DownloadService {
  Future<String> downloadFile({
    required Uri source,
    String? preferredFileName,
  });

  Future<void> openFile(String filePath);
}

class AppDownloadService implements DownloadService {
  AppDownloadService(this._httpClient);

  final HttpClient _httpClient;

  @override
  Future<String> downloadFile({
    required Uri source,
    String? preferredFileName,
  }) async {
    final request = await _httpClient.getUrl(source);
    final response = await request.close();
    if (response.statusCode >= 400) {
      throw HttpException(
        'Download failed with status ${response.statusCode}',
        uri: source,
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = _resolveFileName(source, preferredFileName);
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    final sink = file.openWrite();
    await response.pipe(sink);
    await sink.close();

    return file.path;
  }

  @override
  Future<void> openFile(String filePath) async {
    await OpenFilex.open(filePath);
  }

  String _resolveFileName(Uri source, String? preferredFileName) {
    if (preferredFileName != null && preferredFileName.trim().isNotEmpty) {
      return preferredFileName.trim();
    }

    final fromPath = source.pathSegments.isNotEmpty ? source.pathSegments.last : '';
    if (fromPath.isNotEmpty) {
      return fromPath;
    }

    return 'sentra_download_${DateTime.now().millisecondsSinceEpoch}.bin';
  }
}
