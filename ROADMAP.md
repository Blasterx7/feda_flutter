# feda_flutter — 6‑Month Roadmap

This document describes the 6‑month roadmap for the `feda_flutter` open‑source
project. The primary goals are improved developer ergonomics, stronger typing,
robust token flow, simplified transaction creation with existing customers,
and two runnable examples (Flutter e‑commerce + Dart Frog backend).

Primary audience: public (contributors and users). English is the primary
language for documentation; a brief French summary is provided at the end.

=======================================================================
High level objectives
=======================================================================
- Provide a single, simple initialization (provider/singleton) so `FedaFlutter`
  is created once and injected into repositories.
- Improve typing across models and repositories to reduce runtime typing errors
  and increase compile-time safety.
- Diagnose and fix token generation issues; make token-first payment flow
  robust across payload variants.
- Simplify the UX/API for creating transactions with an existing customer.
- Provide two production-like examples: an e‑commerce Flutter app and a
  Dart Frog API backend to demonstrate real-world integration.
- Improve test coverage and add CI workflows to protect the public API.

=======================================================================
Timeline & Phases (6 months)
=======================================================================
Phase A — Month 0–3 (Nov 2025 — Jan 2026)
- Provider singleton architecture
  - Owner: maintainers
  - Estimate: 2–3 weeks
  - Deliverables: `FedaFlutter.initialize(...)`, `FedaFlutter.instance`,
    repository constructors accepting client instance, tests and migration notes.
  - Acceptance: examples show single init; tests pass; `flutter analyze` OK.

- Strong typing improvements
  - Owner: maintainers
  - Estimate: 2–3 weeks (incremental PRs)
  - Deliverables: typed models, ApiResponse<T> consistently used, stricter
    JSON factories with clear errors, migration notes for breaking changes.
  - Acceptance: public API signatures documented; no sound-null-safety warnings.

- Token generation bug fixes
  - Owner: maintainers
  - Estimate: 1–2 weeks
  - Deliverables: robust token parsing, fallback strategies, clear errors,
    tests for different payload shapes.
  - Acceptance: unit tests reproduce reported edge cases and pass.

- Create-transaction with existing customer UX
  - Owner: maintainers
  - Estimate: 1–2 weeks
  - Deliverables: convenience helpers/overloads for `createTransaction` that
    accept a `customerId` or `Customer` object; docs and examples.
  - Acceptance: checkout example uses `customerId` successfully.

- Examples skeletons (start)
  - Owner: maintainers
  - Estimate: 1 week
  - Deliverables: `example/ecommerce/` skeleton and `example/dart_frog_api/`
    skeleton with README and basic wiring to provider singleton.

Phase B — Month 3–6 (Feb 2026 — Apr 2026)
- Finish E‑commerce example & integration tests
  - Estimate: 3–4 weeks
  - Deliverables: full checkout flow, token-first integration, UI widgets,
    README and smoke tests.
  - Acceptance: runnable example, CI smoke test passes.

- Finish Dart Frog backend example & webhook handling
  - Estimate: 2–3 weeks
  - Deliverables: sample endpoints (/create-transaction, /get-token, /webhook),
    tests and README.
  - Acceptance: end-to-end flow documented and tested locally.

- Tests & CI
  - Estimate: 2–3 weeks
  - Deliverables: GitHub Actions workflow(s) running `flutter analyze`, unit
    tests, and example smoke tests; matrix for supported SDK versions.
  - Acceptance: green CI on main/develop for required checks.

- Docs & migration guide
  - Estimate: 1–2 weeks
  - Deliverables: `PLAYGROUND.md` updates, `ROADMAP.md` (this file),
    `docs/MIGRATION.md` explaining typing and provider changes.
  - Acceptance: docs cover how to migrate and examples updated.

- Release & communication
  - Estimate: 1 week
  - Deliverables: changelog automation, release notes, published release (or
    draft), community announcement.

=======================================================================
Epics & Work Items (prioritized)
=======================================================================
1) Provider / Initialization (High)
   - Design API: `FedaFlutter.initialize`, `FedaFlutter.instance`, `Feda.of(context)`
     optional helper for UI.
   - Update repositories to take a `client` instead of static imports.
   - Add `reset()` method (test-only) and docs.

2) Typing improvements (High)
   - Replace dynamic/Map returns with typed DTOs and ApiResponse<T>.
   - Add strict JSON parsing with informative exceptions for malformed payloads.
   - Provide deprecation wrappers where necessary.

3) Token endpoint fixes (Critical)
   - Audit existing token-related code and response shapes.
   - Add defensive parsing: accept both token.url or token.token, validate schemes
     (https), and construct a usable URL if needed.
   - Add retry wrapper for transient failures and configurable timeouts.

4) Transaction helpers for existing customers (Medium)
   - Add helper overloads: `createTransactionForCustomer(customerId, ...)`.
   - Validate parameters and prefer returning typed Transaction objects.

5) Examples (High)
   - E‑commerce example: product list, cart, checkout, success/failure flow.
   - Dart Frog backend: endpoints and webhooks.

6) Tests & CI (High)
   - Standardize `FakeDioService` for unit tests.
   - Add widget/integration smoke tests for example flows.

7) Docs, migration & release (Medium)
   - Produce `MIGRATION.md` and update `PLAYGROUND.md`.
   - Prepare changelog automation (from Conventional Commits).

=======================================================================
Acceptance criteria (global)
=======================================================================
- Public API supports single initialization and easy repository access.
- Typing changes are documented with migration steps; no major regressions.
- Token-first payment flow handles the documented server payloads and edge cases.
- Both examples run locally and have simple README run steps.
- CI runs `flutter analyze` and unit tests on every PR; green for main branch.

=======================================================================
KPIs & success metrics
=======================================================================
- CI green rate: 100% for required checks on main/develop.
- Unit coverage for critical parsing/model code >= 80% (or measurable increase).
- Reduction in token-related issues by 90% within 4 weeks after release.
- Two runnable examples available and referenced in the main README.

=======================================================================
Dependencies & risks
=======================================================================
- Third-party packages (webview_flutter, dio, dart_frog) may change APIs —
  mitigate by pinning versions and adding compatibility tests.
- Typing migration can introduce breaking changes — mitigate with a migration
  guide and deprecation window.
- Token behavior may vary by environment — mitigate with defensive parsing and
  configurable timeouts/retries.

=======================================================================
Security: API keys & secrets
=======================================================================
Problem: embedding long-lived API secret keys directly into mobile or web
builds makes them retrievable via reverse engineering or runtime inspection.
For a payments SDK this is high risk because leaked keys can be abused to
perform transactions or read sensitive data.

Recommended mitigations:
- Avoid shipping secret API keys in client binaries. Instead, require server‑side
  token exchange: the client requests a short-lived token or session from a
  trusted backend which performs the privileged API calls.
- Use scoped, short‑lived keys / tokens for client operations. Implement server
  endpoints that mint limited-scope tokens (e.g. only allow creating a
  transaction for a specific amount/customer) and expire quickly.
- Promote secure storage for any client-side secrets (Android Keystore,
  iOS Keychain) and use platform-specific APIs for retrieval.
- Consider native-side secret handling (move sensitive logic to native code
  or backend) and obfuscate code where appropriate (but obfuscation is not a
  substitute for proper server-side controls).
- Implement key rotation policies and monitoring for suspicious usage (rate
  limits, geo/IP alerts). Provide dev docs explaining how to rotate keys.
- Document and provide an example server-side proxy (see `example/dart_frog_api/`)
  that demonstrates a secure token exchange pattern and webhook validation.
- Use HTTPS everywhere and consider certificate pinning for highly sensitive
  clients, noting it complicates maintenance and is optional.

Acceptance criteria:
- No README/example instructs users to put long-lived secret keys directly in
  public client source. Examples must use a token-exchange flow or demo-only
  sandbox keys clearly labeled as such.
- Provide an example server that mints short-lived tokens and documents key
  rotation steps.
- Add a security section to `CONTRIBUTING.md` describing responsible
  disclosure and contact for key compromise.

Next steps (security work):
1. Add a `SECURITY.md` (if not already present) that covers key compromise and
   responsible disclosure; reference it from README/CONTRIBUTING.
2. Implement the token-exchange pattern in the `example/dart_frog_api/`
   skeleton and document the flow in `PLAYGROUND.md` and `MIGRATION.md`.
3. Add a short checklist in `docs/MIGRATION.md` and `CONTRIBUTING.md` reminding
   contributors not to commit secrets and how to use environment variables/CI
   secret stores.

=======================================================================
Implementation notes
=======================================================================
- Make incremental, reviewable PRs that each address one area (provider,
  typing, token fixes). Prefer small PRs to ease review and reduce merge conflicts.
- Reuse existing test harness patterns (FakeDioService) and expand coverage.
- For provider design, choose a simple singleton + optional context provider
  rather than a heavy DI framework.

=======================================================================
Artifacts to create
=======================================================================
- `ROADMAP.md` (this file)
- `docs/MIGRATION.md` (typing + provider changes)
- `example/ecommerce/` and `example/dart_frog_api/` skeletons + readmes
- `.github/workflows/ci.yml` to run analyze/tests and example smoke tests

=======================================================================
Next steps (recommended immediate work)
=======================================================================
1. Begin Provider design and a minimal PR that implements `FedaFlutter.initialize`
   and `FedaFlutter.instance` with tests (priority 1).
2. Simultaneously start the token audit and create unit tests reproducing
   problematic payloads (priority 1 — critical).
3. Incrementally migrate public repository signatures to typed ApiResponse<T>.

=======================================================================
Brief French summary
=======================================================================
Objectifs principaux : initialisation unique, meilleur typage, correction des
bugs token, création de transaction pour customer existant, deux exemples
exécutables (Flutter e‑commerce + Dart Frog). Horizon : 6 mois (0–3 / 3–6).

Si tu veux, je peux maintenant :
- A) créer un fichier `docs/MIGRATION.md` avec les étapes de migration détaillées.
- B) implémenter la PR de provider singleton (création d'une branche `feature/provider`).
- C) générer les skeletons d'exemples dans `example/`.

Dis‑moi A, B ou C et je lance l'action correspondante.
