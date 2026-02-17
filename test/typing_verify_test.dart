import 'package:feda_flutter/feda_flutter.dart';
import 'package:feda_flutter/src/models/payouts.dart'; // Import PayoutCreate explicitly if not exported
import 'package:test/test.dart';

void main() {
  group('Typing Verification', () {
    test('TransactionCreate DTO serializes correctly', () {
      final dto = TransactionCreate(
        description: 'Test',
        amount: 1000,
        currency: CurrencyIso(iso: 'XOF'),
        customer: CustomerCreate(
          firstname: 'John',
          lastname: 'Doe',
          email: 'john@doe.com',
          phoneNumber: PhoneNumber(number: '123456', country: 'BJ'),
        ),
      );

      final json = dto.toJson();
      expect(json['description'], 'Test');
      expect(json['amount'], 1000);
      expect(json['currency']['iso'], 'XOF');
      expect(json['customer']['firstname'], 'John');
    });

    test('CustomerCreate DTO serializes correctly', () {
      final dto = CustomerCreate(
        firstname: 'Jane',
        lastname: 'Doe',
        email: 'jane@doe.com',
        phoneNumber: PhoneNumber(number: '654321', country: 'TG'),
      );
      final json = dto.toJson();
      expect(json['firstname'], 'Jane');
      expect(json['phone_number']['number'], '654321');
    });

    test('PayoutCreate DTO serializes correctly', () {
      final dto = PayoutCreate(
        amount: 500,
        currency: CurrencyIso(iso: 'XOF'),
        customer: CustomerCreate(
          firstname: 'Alice',
          lastname: 'Smith',
          email: 'alice@smith.com',
          phoneNumber: PhoneNumber(number: '987654', country: 'CI'),
        ),
        mode: 'mtn',
      );
      final json = dto.toJson();
      expect(json['amount'], 500);
      expect(json['mode'], 'mtn');
      expect(json['customer']['lastname'], 'Smith');
    });
  });
}
