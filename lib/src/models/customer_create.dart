class PhoneNumber {
  final String number;
  final String country;

  PhoneNumber({required this.number, required this.country});

  Map<String, dynamic> toJson() => {'number': number, 'country': country};
}

class CustomerCreate {
  final String firstname;
  final String lastname;
  final String email;
  final PhoneNumber phoneNumber;

  CustomerCreate({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'phone_number': phoneNumber.toJson(),
  };
}
