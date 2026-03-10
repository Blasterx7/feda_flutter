import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A service to launch FedaPay payment URLs.
class PayLauncher {
  /// Launches the given [url].
  /// On mobile, this might open a WebView.
  /// On Web/Desktop, it opens the browser.
  static Future<void> launch(
    BuildContext context,
    String url, {
    VoidCallback? onSuccess,
    VoidCallback? onFailed,
  }) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Note: On Web/Desktop, we can't easily track success/failure via URL change
      // like we do in WebView. The user will have to rely on webhooks or polling.
    } else {
      if (onFailed != null) onFailed();
    }
  }
}
