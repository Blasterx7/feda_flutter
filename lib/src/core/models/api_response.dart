class ApiResponse<T> {
  final T? data;
  final int? statusCode;
  /// Optional pagination / meta information returned by some endpoints.
  /// Kept as a raw map so we avoid importing model classes into this core
  /// wrapper and keep it lightweight.
  final Map<String, dynamic>? meta;

  ApiResponse({this.data, this.statusCode, this.meta});
}
