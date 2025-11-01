import 'package:feda_flutter/src/exports/index.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayWidget extends StatefulWidget {
  const PayWidget({
    super.key,
    required this.instance,
    required this.onPaymentSuccess,
    required this.onPaymentFailed,
    this.transactionToCreate,
    this.environment,
    this.amount,
    this.currency,
    this.customer,
    this.description,
    this.mode,
    this.callbackUrl = 'https://georges-ayeni.com',
  });

  final FedaFlutter instance;
  final Function onPaymentSuccess;
  final Function onPaymentFailed;
  final TransactionCreate? transactionToCreate;
  final ApiEnvironment? environment; // override environment if needed
  final int? amount;
  final CurrencyIso? currency;
  final Map<String, dynamic>? customer;
  final String? description;
  final String? mode;
  final String? callbackUrl;

  @override
  State<PayWidget> createState() => _PayWidgetState();
}

class _PayWidgetState extends State<PayWidget> {
  bool _isLoading = false;
  late final WebViewController _controller;

  Future<ApiResponse<Transaction>?> _callCreateTransaction(
    FedaFlutter instance,
  ) async {
    try {
      TransactionCreate payload;
      if (widget.transactionToCreate != null) {
        payload = widget.transactionToCreate!;
      } else {
        payload = TransactionCreate(
          description: widget.description ?? 'Payment',
          amount: widget.amount ?? 0,
          currency: widget.currency ?? CurrencyIso(iso: 'XOF'),
          callbackUrl: widget.callbackUrl ?? 'https://georges-ayeni.com',
          customMetadata: null,
          customer: widget.customer,
        );
      }

      debugPrint(
        'PayWidget: creating transaction with payload: ${payload.toJson()}',
      );
      final res = await instance.transactions.createTransaction(payload);
      return res;
    } catch (e, st) {
      debugPrint('PayWidget: create transaction error: $e\n$st');
      return null;
    } finally {
      debugPrint('PayWidget: create transaction completed');
    }
  }

  void initiatePaymentFlow(TransactionCreate transaction, FedaFlutter feda) {
    setState(() => _isLoading = true);

    _callCreateTransaction(feda)
        .then((res) async {
          if (res == null) {
            debugPrint('PayWidget: createTransaction returned null');
            widget.onPaymentFailed();
            return;
          }
          debugPrint(
            'PayWidget: create result (type=${res.runtimeType}) -> $res',
          );

          dynamic body = (res as ApiResponse).data ?? res;

          debugPrint('PayWidget: normalized body type=${body.runtimeType}');

          String? paymentUrl;
          String? paymentToken;

          if (body is Transaction) {
            try {
              final json = body.toJson();
              paymentUrl = body.paymentUrl ?? json['payment_url']?.toString();
              paymentToken =
                  body.paymentToken ?? json['payment_token']?.toString();
            } catch (_) {}
          }

          if ((paymentUrl == null || paymentUrl.isEmpty) && body is Map) {
            final inner = body['v1/transaction'] ?? body['transaction'] ?? body;
            debugPrint('PayWidget: inner map type=${inner.runtimeType}');
            if (inner is Map) {
              paymentUrl = inner['payment_url']?.toString();
              paymentToken = inner['payment_token']?.toString();
            }
          }

          debugPrint('PayWidget: extracted paymentUrl=$paymentUrl');
          debugPrint(
            'PayWidget: extracted paymentToken=${paymentToken != null ? '[REDACTED]' : 'null'}',
          );

          if (paymentUrl != null && paymentUrl.isNotEmpty) {
            debugPrint('PayWidget: trying to parse paymentUrl: $paymentUrl');
            final uri = Uri.tryParse(paymentUrl);
            debugPrint('PayWidget: Uri.tryParse -> $uri');
            if (uri == null || uri.scheme.isEmpty) {
              debugPrint(
                'PayWidget: invalid payment URL (missing scheme): $paymentUrl',
              );
              widget.onPaymentFailed();
              return;
            }

            final sep = paymentUrl.contains('?') ? '&' : '?';
            final full = paymentToken != null && paymentToken.isNotEmpty
                ? '$paymentUrl${sep}token=${Uri.encodeComponent(paymentToken)}'
                : paymentUrl;

            debugPrint('PayWidget: loading full payment URL: $full');
            setState(() {
              _isLoading = false;
              debugPrint("PayWidget: loading full payment URL: $full");
              _controller.loadRequest(Uri.parse(full));
            });
          } else {
            debugPrint('PayWidget: no paymentUrl found in response');
            widget.onPaymentFailed();
          }
        })
        .catchError((e, st) {
          debugPrint('PayWidget: create transaction threw: $e\n$st');
          widget.onPaymentFailed();
        })
        .whenComplete(() {
          setState(() => _isLoading = false);
        });
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigation request: ${request.url}");
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) => {
            debugPrint("URL changed: ${change.url}"),
            if (change.url!.contains('status/success'))
              {
                debugPrint('Payment success detected'),
                widget.onPaymentSuccess(),
              }
            else if (change.url!.contains('status/failure'))
              {
                debugPrint('Payment failure detected'),
                widget.onPaymentFailed(),
              },
          },
        ),
      )
      ..loadRequest(Uri.parse('about:blank'));

    final env = widget.environment ?? widget.instance.environment;
    final fedaFlutter = FedaFlutter(
      apiKey: widget.instance.apiKey,
      environment: env,
    );
    fedaFlutter.initialize();

    final payload =
        widget.transactionToCreate ??
        TransactionCreate(
          description: widget.description ?? 'Payment',
          amount: widget.amount ?? 0,
          currency: widget.currency ?? CurrencyIso(iso: 'XOF'),
          callbackUrl: widget.callbackUrl,
          customMetadata: null,
          customer: widget.customer,
        );

    debugPrint('PayWidget init payload: ${payload.toJson()} env: $env');
    initiatePaymentFlow(payload, fedaFlutter);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: WebViewWidget(controller: _controller),
          );
  }
}
