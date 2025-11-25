import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

import 'flicky_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ScreenProtector.preventScreenshotOn();
  } catch (_) {
    // Plugin not available on this platform/emulator; continue without blocking captures.
  }
  runApp(const FlickyApp());
}
