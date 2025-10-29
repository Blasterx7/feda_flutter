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
