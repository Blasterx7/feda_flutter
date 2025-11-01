import 'package:feda_flutter/src/exports/index.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayWidget extends StatefulWidget {
  const PayWidget({
    super.key,
    required this.transactionToCreate,
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
    required this.instance,
  });

  final FedaFlutter instance;
  final Function onPaymentSuccess;
  final Function onPaymentFailed;
  final TransactionCreate transactionToCreate;

  @override
  State<PayWidget> createState() => _PayWidgetState();
}

class _PayWidgetState extends State<PayWidget> {
  WebViewController get _controller => WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update when progress
        },
        onPageStarted: (String url) {
          // Do something on page starting
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(''));

  Future<Transaction> _callCreateTransaction(instance) async {
    try {
      final payload = widget.transactionToCreate;

      return await instance.transactions.createTransaction(payload)
          as Transaction;
    } catch (e) {
      debugPrint(e.toString());
      return Transaction(id: 0, amount: 0);
    } finally {
      debugPrint("Completed");
    }
  }

  Future<TransactionToken> _callGenerateToken({
    required FedaFlutter instance,
    int? transactionId,
  }) async {
    try {
      return await instance.transactions.getTransactionToken(transactionId!)
          as TransactionToken;
    } catch (e) {
      debugPrint(e.toString());
      return TransactionToken(token: '', url: '');
    } finally {
      debugPrint("Completed");
    }
  }

  @override
  Future<void> initState() async {
    super.initState();
    final fedaFlutter = FedaFlutter(
      apiKey: widget.instance.apiKey,
      environment: widget.instance.environment,
    );

    await _callCreateTransaction(fedaFlutter).then((transaction) async {
      if (transaction.id != 0) {
        await _callGenerateToken(
          instance: fedaFlutter,
          transactionId: transaction.id,
        ).then((transactionToken) {
          if (transactionToken.token.isNotEmpty) {
            _controller.loadRequest(Uri.parse(transactionToken.url));
          } else {
            widget.onPaymentFailed();
          }
        });
      } else {
        widget.onPaymentFailed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
