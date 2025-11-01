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

This project is licensed under the terms in `LICENSE`.

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

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Branch

main        → Version stable (publiée sur pub.dev)
develop     → Travail en cours (intégration)
feature/*   → Chaque nouvelle fonctionnalité
fix/*       → Bugs et patchs
release/*   → Préparation d’une nouvelle version stable
docs/*      → Documentation

## Commit writting

