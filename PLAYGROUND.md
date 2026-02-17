feda_flutter — Playground and Examples

This document provides concrete, copy-pasteable examples for common tasks with the package.

Prerequisites
- Add `feda_flutter` to your pubspec (local path during development or from pub.dev once published)
- Initialize the client before calling endpoints

1) Initialize the client

```dart
import 'package:feda_flutter/feda_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FedaFlutter.applyConfig(
    apiKey: 'sk_sandbox_xxx',
    environment: ApiEnvironment.sandbox,
  );
  
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

final res = await FedaFlutter.instance.transactions.createTransaction(payload);
if (res.data != null) {
  final tx = res.data!;
  print('Created tx id=${tx.id} payment_url=${tx.paymentUrl}');
}
```

3) Use token-first flow (recommended)

```dart
// After creating transaction, call token endpoint
final createRes = await FedaFlutter.instance.transactions.createTransaction(payload);
final txId = createRes.data?.id;
if (txId != null) {
  final tokenRes = await FedaFlutter.instance.transactions.getTransactionToken(txId);
  final tokenUrl = tokenRes.data?.url;
  // Validate and open in WebView
}
```

### Server-side token exchange (recommended for production)

Do NOT embed long-lived secret keys in client apps. Instead create a backend
endpoint that mints short-lived tokens for the client to use when opening the
payment session. Example (pseudo Dart Frog handler):

```dart
// POST /session
Future<Response> createSession(RequestContext ctx) async {
  final body = await ctx.request.json();
  // Validate request (amount, customer id, etc.)
  final res = await http.post(Uri.parse('https://api.feda.example/v1/transactions'),
    headers: {'Authorization': 'Bearer SK_LONG_LIVED'},
    body: jsonEncode(body),
  );
  final tx = jsonDecode(await res.transform(utf8.decoder).join());
  // Call token endpoint server-side using long-lived key
  final tokenRes = await http.get(Uri.parse('https://api.feda.example/v1/transactions/${tx['id']}/token'),
    headers: {'Authorization': 'Bearer SK_LONG_LIVED'},
  );
  final token = jsonDecode(await tokenRes.transform(utf8.decoder).join());
  // Return only the short-lived token/url to the client
  return Response.json({'token_url': token['url']});
}
```

Client flow:
1. Client calls your `/session` endpoint (no long-lived key in the client).
2. Backend creates transaction and fetches token using the server-side key.
3. Backend returns short-lived token/url to the client which opens it in WebView.

This pattern prevents exposing the long-lived secret key in distributed
client binaries. See `example/dart_frog_api/` for a ready-to-run sample.

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

final payoutRes = await FedaFlutter.instance.payouts.createPayout(payout);
if (payoutRes.data != null) print('Created payout id=${payoutRes.data!.id}');
```

5) Use the provided PayWidget in Flutter UI

```dart
PayWidget(
  instance: FedaFlutter.instance,
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
