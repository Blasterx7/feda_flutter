class ApiResponse<T> {
  final T? data;
  final int? statusCode;

  ApiResponse({this.data, this.statusCode});
}
