import 'package:flutter/material.dart';

class PayLauncher {
  static Future<void> launch(
    BuildContext context,
    String url, {
    VoidCallback? onSuccess,
    VoidCallback? onFailed,
  }) async {
    throw UnimplementedError('PayLauncher.launch() is not implemented on this platform.');
  }
}
