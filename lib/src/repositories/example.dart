import 'package:feda_flutter/src/core/models/api_response.dart';

import 'base_repository.dart';

class UserRepository extends BaseRepository {
  UserRepository(super.client);

  Future<ApiResponse<dynamic>> getUsers() =>
      safeCall(() => client.get("/users"));

  Future<ApiResponse<dynamic>> getUser(int id) =>
      safeCall(() => client.get("/users/$id"));

  Future<ApiResponse<dynamic>> createUser(Map<String, dynamic> data) =>
      safeCall(() => client.post("/users", data: data));
  
  Future<ApiResponse<dynamic>> updateUser(int id, Map<String, dynamic> data) =>
      safeCall(() => client.put("/users/$id", data: data));

  Future<ApiResponse<dynamic>> deleteUser(int id) =>
      safeCall(() => client.delete("/users/$id"));
}
