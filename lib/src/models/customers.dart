class Customer {
  final int id;
  final String firstname;
  final String lastname;
  final String fullName;
  final String email;
  final int accountId;
  final int phoneNumberId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Customer({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.fullName,
    required this.email,
    required this.accountId,
    required this.phoneNumberId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      accountId: json['account_id'] ?? 0,
      phoneNumberId: json['phone_number_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'full_name': fullName,
      'email': email,
      'account_id': accountId,
      'phone_number_id': phoneNumberId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

class Meta {
  final int currentPage;
  final int? nextPage;
  final int? prevPage;
  final int perPage;
  final int totalPages;
  final int totalCount;

  Meta({
    required this.currentPage,
    this.nextPage,
    this.prevPage,
    required this.perPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 0,
      nextPage: json['next_page'],
      prevPage: json['prev_page'],
      perPage: json['per_page'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'next_page': nextPage,
      'prev_page': prevPage,
      'per_page': perPage,
      'total_pages': totalPages,
      'total_count': totalCount,
    };
  }
}

/// Helper to deserialize API responses that may be wrapped.
/// The Fedapay API sometimes returns: {"v1/customers": [...], "meta": {...}}
/// or directly a list of customers. This class normalizes both shapes.
class CustomerCollection {
  final List<Customer> customers;
  final Meta? meta;

  CustomerCollection({required this.customers, this.meta});

  /// Create a collection from an API payload which can be:
  /// - a List of customer maps
  /// - a Map with a key containing 'customer' that maps to a List and an
  ///   optional 'meta' map
  factory CustomerCollection.fromApi(dynamic payload) {
    if (payload is List) {
      final list = payload
          .map((e) => Customer.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return CustomerCollection(customers: list, meta: null);
    }

    if (payload is Map) {
      // Try to find the customers list inside the map
      List<dynamic>? listValue;
      Map<String, dynamic>? metaMap;

      payload.forEach((key, value) {
        if (listValue == null && value is List) {
          // Heuristic: choose the first list whose items look like customers
          if (value.isNotEmpty &&
              value.first is Map &&
              (value.first as Map).containsKey('id')) {
            listValue = value;
          } else if (listValue == null &&
              key.toLowerCase().contains('customer')) {
            listValue = value;
          }
        }

        if (key.toLowerCase() == 'meta' && value is Map) {
          metaMap = Map<String, dynamic>.from(value);
        }
      });

      final customers = <Customer>[];
      if (listValue != null) {
        final lv = listValue;
        for (final item in lv!) {
          if (item is Map) {
            customers.add(Customer.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      final meta = metaMap != null ? Meta.fromJson(metaMap!) : null;
      return CustomerCollection(customers: customers, meta: meta);
    }

    // Fallback: empty collection
    return CustomerCollection(customers: [], meta: null);
  }
}
