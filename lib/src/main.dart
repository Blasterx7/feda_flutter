import 'package:feda_flutter/src/exports/index.dart';

/// The main entry point for the `feda_flutter` SDK.
///
/// ## Mode Direct (clé API côté client)
/// ```dart
/// FedaFlutter.applyConfig(
///   apiKey: 'sk_sandbox_...',
///   environment: ApiEnvironment.sandbox,
/// );
/// ```
///
/// ## Mode Cloud Proxy (recommandé en production)
/// La clé FedaPay est stockée de façon sécurisée sur ash-bwallet.
/// Le SDK n'a besoin que du `projectKey` interne.
/// ```dart
/// FedaFlutter.applyCloudConfig(
///   projectKey: 'proj_abc123',
///   cloudUrl: 'http://localhost:3000', // URL de votre instance ash-bwallet
///   environment: ApiEnvironment.sandbox,
/// );
/// ```
class FedaFlutter {
  /// La clé API FedaPay (mode direct uniquement).
  final String? apiKey;

  /// La clé publique du projet sur ash-bwallet (mode proxy).
  final String? projectKey;

  /// L'URL du cloud proxy ash-bwallet (mode proxy).
  final String? cloudUrl;

  /// L'environnement ciblé (sandbox ou live).
  final ApiEnvironment environment;

  /// Indique si le SDK est en mode Cloud Proxy.
  bool get isCloudMode => projectKey != null && cloudUrl != null;

  late IDioService _api;

  static FedaFlutter? _instance;

  /// Retourne le singleton initialisé.
  /// Lance une [Exception] si [applyConfig] ou [applyCloudConfig] n'a pas été appelé.
  static FedaFlutter get instance {
    if (_instance == null) {
      throw Exception(
        "FedaFlutter is not initialized. Please call FedaFlutter.applyConfig() "
        "or FedaFlutter.applyCloudConfig() first.",
      );
    }
    return _instance!;
  }

  /// Mode Direct — la clé API FedaPay est passée directement (moins sécurisé).
  ///
  /// ⚠️  Éviter en production mobile : la clé peut être extraite du binaire.
  /// Préférez [applyCloudConfig] pour la production.
  static void applyConfig({
    String? apiKey,
    required ApiEnvironment environment,
  }) {
    _instance = FedaFlutter._(
      apiKey: apiKey,
      environment: environment,
    );
    _instance!._initialize();
  }

  /// Mode Cloud Proxy — la clé FedaPay est stockée sur ash-bwallet.
  ///
  /// Le SDK envoie uniquement le [projectKey] interne ; ash-bwallet
  /// résout la clé FedaPay réelle côté serveur.
  ///
  /// ```dart
  /// FedaFlutter.applyCloudConfig(
  ///   projectKey: 'proj_abc123',
  ///   cloudUrl: 'http://localhost:3000', // URL de votre instance ash-bwallet
  ///   environment: ApiEnvironment.sandbox,
  /// );
  /// ```
  static void applyCloudConfig({
    required String projectKey,
    required String cloudUrl,
    ApiEnvironment environment = ApiEnvironment.sandbox,
  }) {
    _instance = FedaFlutter._(
      projectKey: projectKey,
      cloudUrl: cloudUrl,
      environment: environment,
    );
    _instance!._initialize();
  }

  /// Accès au repository Customers.
  CustomersRepository get customers => CustomersRepository(_api);

  /// Accès au repository Transactions.
  TransactionsRepository get transactions => TransactionsRepository(_api);

  /// Accès au repository Payouts.
  PayoutsRepository get payouts => PayoutsRepository(_api);

  FedaFlutter._({
    this.apiKey,
    this.projectKey,
    this.cloudUrl,
    required this.environment,
  });

  void _initialize() {
    if (isCloudMode) {
      _api = DioServiceImpl.cloudProxy(
        cloudUrl: cloudUrl!,
        projectKey: projectKey!,
        environment: environment,
      );
    } else {
      _api = DioServiceImpl(environment, apiKey);
    }
  }
}

