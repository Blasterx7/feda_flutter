/// A generic wrapper around every FedaPay API response.
///
/// [T] is the type of the deserialized payload (e.g. [Transaction],
/// `List<Customer>`, etc.).
///
/// ```dart
/// final ApiResponse<Transaction> res = await transactions.getTransaction(42);
/// if (res.data != null) {
///   print(res.data!.status);
/// }
/// ```
class ApiResponse<T> {
  /// The deserialized response payload, or `null` if the request failed
  /// or returned no body.
  final T? data;

  /// The HTTP status code returned by the server (e.g. 200, 201, 404).
  final int? statusCode;

  /// Optional pagination / meta information returned by some endpoints.
  /// Kept as a raw map so we avoid importing model classes into this core
  /// wrapper and keep it lightweight.
  final Map<String, dynamic>? meta;

  /// Creates an [ApiResponse] with the given [data], [statusCode] and [meta].
  ApiResponse({this.data, this.statusCode, this.meta});
}
