abstract interface class DownloadService {
  Future<void> prepare();
}

class StubDownloadService implements DownloadService {
  @override
  Future<void> prepare() async {}
}
