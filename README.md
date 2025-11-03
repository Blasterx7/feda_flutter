# feda_flutter

feda_flutter is an open-source Flutter package that provides a client and UI helpers for interacting with the Feda payment API (transactions, customers, payouts, etc.).

This repository contains:
- `lib/` — package source (models, repositories, UI widgets)
- `example/` — example Flutter app demonstrating usage
- `test/` — unit and widget tests

## Quick start

From a Flutter project add as a dependency (local or published package):

```bash
flutter pub add feda_flutter
```

Then initialize and use the client in your app:

```dart
final feda = FedaFlutter(apiKey: 'sk_sandbox_xxx', environment: ApiEnvironment.sandbox);
feda.initialize();

final res = await feda.transactions.createTransaction(payload);
```

See `example/` for a full sample app.

For a hands-on playground with ready-to-run snippets and usage examples see `PLAYGROUND.md`.

## Development

Requirements:
- Flutter SDK (stable)
- Dart SDK (comes with Flutter)

Useful commands:

```bash
flutter pub get
flutter analyze
flutter test
flutter format .
```

## Contributing

feda_flutter is an open source project — contributions are welcome. See `CONTRIBUTING.md` for guidelines on issues, pull requests, testing and commit messages.

## License
This project is dual-licensed:

- **Open Source:** under the [AGPLv3 License](./LICENSE)
- **Commercial:** available under a commercial license for closed-source or commercial use.

For commercial licensing, please contact **contact@georges-ayeni.com**

---
_Si vous préférez lire la documentation en français, consultez `CONTRIBUTING.md` et `README.md` (les deux contiennent sections en français)._ 
<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

feda_flutter is a lightweight client and UI helper for integrating the Feda
payments API into Flutter apps and Dart backends. It provides typed repository
clients for Transactions, Customers and Payouts, helpers for token-first web
payment flows, a simple WebView-based `PayWidget`, and runnable examples to
bootstrap integration in real apps.

## Features

- Typed repositories: `TransactionsRepository`, `CustomersRepository`,
  `PayoutsRepository` with ApiResponse<T> results and robust JSON parsing.
- Token-first payment flow helpers and a `PayWidget` that opens the payment
  session in a WebView safely.
- Example apps: a Flutter e‑commerce example and a Dart Frog backend example
  (see `example/`).
- Null-safety and modern Dart patterns; small, dependency-light core.
- Test helpers and a `FakeDioService` pattern to make unit testing repositories
  straightforward.

## Getting started

Prerequisites:
- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)

Quick start:

1. Add the package to your app (local during development):

```yaml
dependencies:
  feda_flutter:
    path: ../feda_flutter
```

2. Initialize the client early in your app (e.g. in `main`):

```dart
final feda = FedaFlutter(apiKey: 'sk_sandbox_xxx', environment: ApiEnvironment.sandbox);
feda.initialize();
```

3. Use repositories to call the API:

```dart
final res = await feda.transactions.createTransaction(payload);
```

See `example/` for full runnable demos.

## Usage

The `example/` app demonstrates common usage patterns. Below is a condensed
and annotated snippet based on `example/lib/main.dart` showing how to
initialize the SDK, call repositories, create customers/transactions and
obtain a transaction token.

```dart
// 1) Initialize once (e.g. in main or top-level stateful widget)
final feda = FedaFlutter(
  apiKey: 'sk_sandbox_xxx', // use a sandbox or a short-lived token in prod
  environment: ApiEnvironment.sandbox,
);
feda.initialize();

// 2) Read lists or single resources
final customersRes = await feda.customers.getCustomers();
if (customersRes.isSuccessful) {
  print('Customers: ${customersRes.data}');
}

final txRes = await feda.transactions.getTransaction(373318);
if (txRes.isSuccessful) {
  print('Transaction: ${txRes.data}');
}

// 3) Create a transaction (using DTO helpers)
final payload = TransactionCreate(
  description: 'Demo transaction',
  amount: 2000,
  currency: CurrencyIso(iso: 'XOF'),
  callbackUrl: 'https://example.com/callback',
  customMetadata: {'order_id': '12345'},
  // Pass an existing customer by id
  customer: {'id': '70635'},
);

final createRes = await feda.transactions.createTransaction(payload);
if (createRes.isSuccessful) {
  final created = createRes.data;
  print('Created tx: ${created?.id}');
}

// 4) Request a token for a transaction and use it in your UI
final tokenRes = await feda.transactions.getTransactionToken(created!.id);
if (tokenRes.isSuccessful) {
  // tokenRes.data may contain different shapes depending on the API; the
  // examples use a token URL that can be opened in a WebView.
  print('Token payload: ${tokenRes.data}');
}

// 5) Navigate to the example payment page (the example app provides a
// `Payment` page wired to the token-first flow)
Navigator.of(context).push(MaterialPageRoute(builder: (_) => Payment()));

```

Notes:
- The example app shows many helper widgets (transaction card, list view,
  customer form) and provides UI buttons to call the repository methods — see
  `example/lib/main.dart` for a complete reference.
- For production, avoid embedding secret keys in the client binary — use the
  token-exchange pattern described in `ROADMAP.md` and `SECURITY.md`.

## Additional information

- Issues & contributions: open issues and PRs on this repository. See
  `CONTRIBUTING.md` for contribution guidelines, commit message format and the
  PR checklist.
- Security: do not commit secret API keys. See `SECURITY.md` and the token
  exchange example in `example/dart_frog_api/` for a recommended approach.
- License: AGPLv3 for open-source use; commercial licensing available — contact
  contact@georges-ayeni.com for details.

## Branch

main        → Version stable (publiée sur pub.dev)
develop     → Travail en cours (intégration)
feature/*   → Chaque nouvelle fonctionnalité
fix/*       → Bugs et patchs
release/*   → Préparation d’une nouvelle version stable
docs/*      → Documentation

## Commit writing

Guidelines to write clear, consistent commit messages that help the team and
automate changelog generation. We recommend using the "Conventional Commits"
format.

Format:

```
<type>(<scope>): <short imperative summary, lower-case, <72 chars>

optional body (explain why and the impact)

optional footer — issue references and BREAKING CHANGE notes
```

Common types:
- feat: new feature
- fix: bug fix
- docs: documentation only changes
- style: formatting, linting, no code change
- refactor: code change that neither fixes a bug nor adds a feature
- perf: performance improvements
- test: adding or fixing tests
- chore: build, tooling, or other chores

Examples:

```
feat(payments): add token-first payment flow

Create transaction and open the payment session via a token URL. This avoids
exposing the raw transaction payment URL and standardizes the flow across
platforms.

Closes: #45
```

```
fix(pay_widget): handle missing token URL gracefully

Avoid crash when the token endpoint returns an unexpected payload. Add a
fallback and improve logging to ease debugging.
```

Best practices:
- Use the imperative mood for the summary (e.g. "add", "fix", "update").
- Keep the summary short and focused; add a body when the change needs
  explanation (motivation, alternatives considered).
- Reference related issues in the footer (e.g. `Closes #123`) and include
  `BREAKING CHANGE:` in the footer when a change is not backward-compatible.
- Use a scope when useful (e.g. `transactions`, `pay_widget`, `payouts`).
- Group related changes in a single commit; avoid mixing refactors and
  functional fixes in the same commit.
- Clean history before merging to `develop`/`main` if necessary (interactive
  rebase or squash) to keep a readable history.

Recommended tooling:
- `commitlint` + `husky` to enforce commit message format.
- A pre-commit hook to run formatter (`flutter format .`) and quick tests.

Merge policy:
- One PR should address a single logical change (do not mix multiple features
  in the same PR).
- Request at least one reviewer; include a short description and testing steps.
- Merge strategy: use squash & merge for a clean history or regular merge if
  you prefer to preserve all commits.

If you want, I can add an example `commitlint` + `husky` configuration and a
commit message template (with pre-commit hooks) — tell me and I'll add them.

## Rédaction des commits

Voici des règles simples et cohérentes pour rédiger des messages de commit lisibles et exploitables par l'équipe.

Nous recommandons d'utiliser le format "Conventional Commits" (léger et compatible avec génération de changelogs).

Format :

```
<type>(<scope>): <sujet en impératif, minuscule, <72 caractères>

corps optionnel (ligne vide au-dessus) — expliquer le pourquoi et les conséquences.

footer optionnel — références aux issues et BREAKING CHANGE
```

Types usuels :
- feat: nouvelle fonctionnalité
- fix: correction de bug
- docs: documentation
- style: mise en forme (formatting, lint), pas de changement fonctionnel
- refactor: refactor sans ajout/suppression de fonctionnalités
- perf: amélioration des performances
- test: ajout/correction de tests
- chore: tâches diverses (build, scripts)

Exemples :

```
feat(payments): add token-first payment flow

Create transaction and open the payment session via token URL. This avoids exposing
the transaction payment URL and standardizes the flow across platforms.

Resolves: #45
```

```
fix(pay_widget): handle missing token URL gracefully

Avoid crash when the token endpoint returns an unexpected payload. Add fallback and
better logging to help debugging.
```

Bonnes pratiques :
- Utiliser l'impératif pour le sujet (ex: "add", "fix", "update").
- Sujet court et précis, corps explicatif si nécessaire (motivation, alternatives rejetées).
- Inclure dans le footer les références liées (ex: `Closes #123`) et les breaking changes :
  `BREAKING CHANGE: description...`.
- Préciser le scope quand c'est utile (ex: `transactions`, `pay_widget`, `payouts`).
- Grouper les changements cohérents dans un même commit; évitez les commits mêlant refactorings et fixes fonctionnels.
- Avant de fusionner dans `develop`/`main`, nettoyer l'historique si nécessaire (rebase interactif, squash) pour une histoire lisible.

Outils recommandés :
- `commitlint` + `husky` pour vérifier le format des messages au commit.
- Un hook pré-commit pour formatter (`flutter format .`) et lancer les tests rapides.

Politique de merge :
- Pull requests : une PR = une intention/cohérence fonctionnelle (ne pas mélanger 3 features dans la même PR).
- Revue : demander au moins 1 reviewer; inclure une courte description et les étapes pour tester.
- Merge : selon la politique du repo — squash & merge pour garder une histoire propre ou merge commits si on veut tout garder.

Si tu veux, je peux générer un exemple de configuration `commitlint` + `husky` et un template de message (pré-commit hooks) — dis‑le et je l'ajouterai.

