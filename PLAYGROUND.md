feda_flutter — Playground and Examples

This document provides concrete, copy-pasteable examples for common tasks with the package.

Prerequisites
- Add `feda_flutter` to your pubspec (local path during development or from pub.dev once published)
- Initialize the client before calling endpoints

1) Initialize the client

```dart
import 'package:feda_flutter/feda_flutter.dart';

final feda = FedaFlutter(
  apiKey: 'sk_sandbox_xxx',
  environment: ApiEnvironment.sandbox,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  feda.initialize();
  runApp(MyApp());
}
```

2) Create a transaction (server-side style)

```dart
final payload = TransactionCreate(
  description: 'Demo transaction',
  amount: 2000,
  currency: CurrencyIso(iso: 'XOF'),
  callbackUrl: 'https://example.com/callback',
  customMetadata: {'order_id': '12345'},
  customer: {'id': '70635'},
);

final res = await feda.transactions.createTransaction(payload);
if (res.data != null) {
  final tx = res.data!;
  print('Created tx id=${tx.id} payment_url=${tx.paymentUrl}');
}
```

3) Use token-first flow (recommended)

```dart
// After creating transaction, call token endpoint
final createRes = await feda.transactions.createTransaction(payload);
final txId = createRes.data?.id;
if (txId != null) {
  final tokenRes = await feda.transactions.getTransactionToken(txId);
  final tokenUrl = tokenRes.data?.url;
  // Validate and open in WebView
}
```

4) Create a payout

```dart
final payout = PayoutCreate(
  amount: 1500,
  currency: CurrencyIso(iso: 'XOF'),
  customer: CustomerCreate(
    firstname: 'Jane',
    lastname: 'Doe',
    email: 'jane@example.com',
    phoneNumber: PhoneNumber(number: '221771234567', country: 'SN'),
  ),
  mode: 'moov',
);

final payoutRes = await feda.payouts.createPayout(payout);
if (payoutRes.data != null) print('Created payout id=${payoutRes.data!.id}');
```

5) Use the provided PayWidget in Flutter UI

```dart
PayWidget(
  instance: feda,
  transactionToCreate: payload,
  onPaymentSuccess: () => print('Payment success'),
  onPaymentFailed: () => print('Payment failed'),
)
```

6) Running the example app

```bash
cd example
flutter pub get
flutter run
```

7) Testing and static analysis

```bash
flutter analyze
flutter test
```

Notes and tips
- Repositories return an `ApiResponse<T>` wrapper — use `.data` to get the typed model.
- The API may wrap payloads inside keys like `v1/transactions` and include `meta`. Use `*Collection.fromApi(payload)` helpers to normalize responses.
- Prefer token-first flow: create transaction (POST /transactions) -> token endpoint (GET /transactions/{id}/token) -> open token URL in WebView.

Feedback / examples
- Add your own examples to `example/` and send a PR. Follow `CONTRIBUTING.md` for guidelines.
