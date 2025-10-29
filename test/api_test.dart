import 'package:feda_flutter/src/core/env/api_environment.dart';
import 'package:feda_flutter/src/core/exceptions/network_exception.dart';
import 'package:feda_flutter/src/network/dio_service.dart';
import 'package:feda_flutter/src/network/dio_service_impl.dart';
import 'package:feda_flutter/src/repositories/example.dart';
import 'package:test/test.dart';

void main() {
  late IDioService dioService;
  late UserRepository repo;

  setUp(() {
    dioService = DioServiceImpl(
      ApiEnvironment.sandbox,
      "FAKE_API_KEY", // pas utilisé pour cette API
    );

    // Override baseUrl uniquement pour ce test
    (dioService as DioServiceImpl).client.options.baseUrl =
        "https://jsonplaceholder.typicode.com";

    repo = UserRepository(dioService);
  });

  test("✅ GET /users returns data", () async {
    final response = await repo.getUsers();

    expect(response.statusCode, 200);
    expect(response.data, isA<List>());
    expect(response.data.isNotEmpty, true);
  });

  test("✅ GET /users/:id returns one user", () async {
    final response = await repo.getUser(1);

    expect(response.statusCode, 200);
    expect(response.data["id"], 1);
    expect(response.data["name"], isNotNull);
  });

  test("❌ GET unknown user returns error", () async {
    try {
      await repo.getUser(999999);
      fail("Should throw NetworkException");
    } catch (e) {
      expect(e, isA<NetworkException>());
    }
  });
}
