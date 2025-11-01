# feda_flutter

feda_flutter is an open-source Flutter package that provides a client and UI helpers for interacting with the Feda payment API (transactions, customers, payouts, etc.).

This repository contains:
- `lib/` — package source (models, repositories, UI widgets)
- `example/` — example Flutter app demonstrating usage
- `test/` — unit and widget tests

## Quick start

From a Flutter project add as a dependency (local or published package):

```yaml
dependencies:
  feda_flutter:
    path: ../feda_flutter
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

Short example showing initialization and a transaction creation using an
existing customer id:

```dart
// Initialize once
final feda = FedaFlutter(apiKey: 'sk_sandbox_xxx', environment: ApiEnvironment.sandbox);
feda.initialize();

// Create a transaction for an existing customer
final payload = TransactionCreate(amount: 1000, currency: CurrencyIso.XOF, customerId: 70635);
final res = await feda.transactions.createTransaction(payload.toJson());
if (res.isSuccessful) {
  final tx = res.data;
  // proceed with token-first flow or show success
}
```

Longer, runnable examples live in the `example/` folder.

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

