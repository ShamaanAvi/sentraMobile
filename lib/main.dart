import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sentra_mobile/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  runApp(
    const ProviderScope(
      child: SentraApp(),
    ),
  );
}
