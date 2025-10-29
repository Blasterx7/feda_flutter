import 'package:feda_flutter/src/constants/index.dart';

enum ApiEnvironment {
  sandbox,
  live;

  String get baseUrl {
    switch (this) {
      case ApiEnvironment.sandbox:
        return FEDA_SANDBOX_API_URL + FEDA_API_VERSION_V1;
      case ApiEnvironment.live:
        return FEDA_API_URL + FEDA_API_VERSION_V1;
    }
  }
}
