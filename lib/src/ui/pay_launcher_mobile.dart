import 'dart:io';
import 'package:flutter/material.dart';
import 'package:feda_flutter/src/ui/pay_widget.dart';
import 'package:feda_flutter/src/exports/index.dart';
import 'package:url_launcher/url_launcher.dart';

class PayLauncher {
  static Future<void> launch(
    BuildContext context,
    String url, {
    VoidCallback? onSuccess,
    VoidCallback? onFailed,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // Note: We can't easily detect success/failure when opening in browser
        // without a deep link or callback URL mechanism integrated.
      } else if (onFailed != null) {
        onFailed();
      }
      return;
    }

    // On mobile, we can show the PayWidget in a bottom sheet or dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: PayWidget(
          transactionToken: _extractToken(url),
          onPaymentSuccess: () {
            Navigator.pop(context);
            if (onSuccess != null) onSuccess();
          },
          onPaymentFailed: () {
            Navigator.pop(context);
            if (onFailed != null) onFailed();
          },
        ),
      ),
    );
  }

  static String? _extractToken(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.pathSegments.last;
    } catch (_) {
      return null;
    }
  }
}
