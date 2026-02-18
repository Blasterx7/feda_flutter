---
seo:
  title: feda_flutter — FedaPay Flutter SDK
  description: Integrate FedaPay payments in your Flutter app with a simple, type-safe Dart package.
---

::u-page-hero{class="dark:bg-gradient-to-b from-neutral-900 to-neutral-950"}
---
orientation: horizontal
---
#top
:hero-background

#title
FedaPay payments for [Flutter]{.text-primary}.

#description
`feda_flutter` is a Dart/Flutter package that makes it easy to integrate [FedaPay](https://fedapay.com) payment processing — transactions, customers, payouts, and a ready-to-use `PayWidget`.

#links
  :::u-button
  ---
  to: /getting-started
  size: xl
  trailing-icon: i-lucide-arrow-right
  ---
  Get started
  :::

  :::u-button
  ---
  icon: i-simple-icons-dart
  color: neutral
  variant: outline
  size: xl
  to: https://pub.dev/packages/feda_flutter
  target: _blank
  ---
  View on pub.dev
  :::

#default
  :::prose-pre
  ---
  code: |
    flutter pub add feda_flutter
  filename: Terminal
  ---

  ```bash [Terminal]
  flutter pub add feda_flutter
  ```
  :::
::

::u-page-section{class="dark:bg-neutral-950"}
#title
Everything you need for FedaPay

#features
  :::u-page-feature
  ---
  icon: i-lucide-credit-card
  ---
  #title
  Transactions

  #description
  Create, update, and list transactions. Supports typed DTOs and returns strict `ApiResponse<Transaction>`.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-users
  ---
  #title
  Customers

  #description
  Manage your FedaPay customers with `CustomerCreate` DTO and full CRUD support.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-send
  ---
  #title
  Payouts

  #description
  Send payouts to mobile money accounts with `PayoutCreate` DTO and mode selection.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-smartphone
  ---
  #title
  PayWidget

  #description
  Drop-in Flutter widget that handles the full payment flow with a WebView — no extra setup needed.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-shield-check
  ---
  #title
  Strict Typing

  #description
  All repository methods accept typed DTOs and return `ApiResponse<T>` for safe, predictable code.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-zap
  ---
  #title
  Singleton Pattern

  #description
  Initialize once with `FedaFlutter.initialize()` and access your repositories anywhere in the app.
  :::
::
