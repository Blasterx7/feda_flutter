## 0.2.1

* Added Nuxt-based documentation site in `docs/`.
* Added Nuxt-based changelog site in `change/`.
* Added GitHub Actions workflow to auto-create releases from `CHANGELOG.md` on tag push.
* Added GitHub PR template.

## 0.2.0

* Enforced strict typing in `TransactionsRepository`, `CustomersRepository`, and `PayoutsRepository` — methods now accept typed DTOs and return `ApiResponse<T>`.
* Fixed `PayWidget` to handle token-only API responses by constructing the checkout URL as a fallback.
* Improved `BaseRepository.normalizeApiData` to only unwrap known Fedapay wrapper keys (`v1/*`).
* Refactored test suite to use a shared `FakeDioService` and added DTO-specific test cases.

## 0.1.0

* Added Singleton pattern for `FedaFlutter` initialization (issue #).
* Lowered Dart SDK constraint to `^3.0.0` for broader compatibility.
* Updated documentation with new usage examples.

## 0.0.4

* Added `PayWidget` for easier payment integration.
* Added support for payouts.
* Improved example app and documentation.

## 0.0.1

* Initial release of `feda_flutter`.
* Basic support for Transactions and Customers API.
