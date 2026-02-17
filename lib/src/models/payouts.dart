import '../utils/json_parsers.dart';
import 'customer_create.dart';
import 'transactions.dart' show CurrencyIso;
import 'customers.dart' show Meta;

class Payout {
  final int id;
  final String? reference;
  final num amount;
  final String? status;
  final int? customerId;
  final int? currencyId;
  final String? mode;
  final String? lastErrorCode;
  final num? commission;
  final num? fees;
  final num? fixedCommission;
  final num? amountTransferred;
  final num? amountDebited;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final DateTime? failedAt;
  final DateTime? deletedAt;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? customMetadata;
  final int? paymentMethodId;
  final String? transactionKey;
  final String? merchantReference;
  final int? accountId;
  final int? balanceId;

  Payout({
    required this.id,
    this.reference,
    required this.amount,
    this.status,
    this.customerId,
    this.currencyId,
    this.mode,
    this.lastErrorCode,
    this.commission,
    this.fees,
    this.fixedCommission,
    this.amountTransferred,
    this.amountDebited,
    this.createdAt,
    this.updatedAt,
    this.scheduledAt,
    this.sentAt,
    this.failedAt,
    this.deletedAt,
    this.metadata,
    this.customMetadata,
    this.paymentMethodId,
    this.transactionKey,
    this.merchantReference,
    this.accountId,
    this.balanceId,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      reference: json['reference'],
      amount: parseNum(json['amount'], fallback: 0),
      status: json['status'],
      customerId: json['customer_id'] is int
          ? json['customer_id']
          : (json['customer_id'] != null
              ? int.tryParse('${json['customer_id']}')
              : null),
      currencyId: json['currency_id'] is int
          ? json['currency_id']
          : (json['currency_id'] != null
              ? int.tryParse('${json['currency_id']}')
              : null),
      mode: json['mode'],
      lastErrorCode: json['last_error_code'],
      commission: parseNumNullable(json['commission']),
      fees: parseNumNullable(json['fees']),
      fixedCommission: parseNumNullable(json['fixed_commission']),
      amountTransferred: parseNumNullable(json['amount_transferred']),
      amountDebited: parseNumNullable(json['amount_debited']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      scheduledAt: parseDate(json['scheduled_at']),
      sentAt: parseDate(json['sent_at']),
      failedAt: parseDate(json['failed_at']),
      deletedAt: parseDate(json['deleted_at']),
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      customMetadata: json['custom_metadata'] != null
          ? Map<String, dynamic>.from(json['custom_metadata'])
          : null,
      paymentMethodId: json['payment_method_id'] is int
          ? json['payment_method_id']
          : (json['payment_method_id'] != null
              ? int.tryParse('${json['payment_method_id']}')
              : null),
      transactionKey: json['transaction_key'],
      merchantReference: json['merchant_reference'],
      accountId: json['account_id'] is int
          ? json['account_id']
          : (json['account_id'] != null
              ? int.tryParse('${json['account_id']}')
              : null),
      balanceId: json['balance_id'] is int
          ? json['balance_id']
          : (json['balance_id'] != null
              ? int.tryParse('${json['balance_id']}')
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'amount': amount,
      'status': status,
      'customer_id': customerId,
      'currency_id': currencyId,
      'mode': mode,
      'last_error_code': lastErrorCode,
      'commission': commission,
      'fees': fees,
      'fixed_commission': fixedCommission,
      'amount_transferred': amountTransferred,
      'amount_debited': amountDebited,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'scheduled_at': scheduledAt?.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'failed_at': failedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'metadata': metadata,
      'custom_metadata': customMetadata,
      'payment_method_id': paymentMethodId,
      'transaction_key': transactionKey,
      'merchant_reference': merchantReference,
      'account_id': accountId,
      'balance_id': balanceId,
    };
  }
}

class PayoutCreate {
  final num amount;
  final CurrencyIso currency;
  final CustomerCreate customer;
  final String? mode;

  PayoutCreate(
      {required this.amount,
      required this.currency,
      required this.customer,
      this.mode});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency.toJson(),
      'customer': customer.toJson(),
      if (mode != null) 'mode': mode,
    };
  }
}

class PayoutCollection {
  final List<Payout> payouts;
  final Meta? meta;

  PayoutCollection({required this.payouts, this.meta});

  factory PayoutCollection.fromApi(dynamic payload) {
    if (payload is List) {
      final list = payload
          .map((e) => Payout.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return PayoutCollection(payouts: list, meta: null);
    }

    if (payload is Map) {
      List<dynamic>? listValue;
      Map<String, dynamic>? metaMap;

      payload.forEach((key, value) {
        if (listValue == null && value is List) {
          if (value.isNotEmpty &&
              value.first is Map &&
              (value.first as Map).containsKey('id')) {
            listValue = value;
          } else if (listValue == null &&
              key.toLowerCase().contains('payout')) {
            listValue = value;
          }
        }

        if (key.toLowerCase() == 'meta' && value is Map) {
          metaMap = Map<String, dynamic>.from(value);
        }
      });

      final payouts = <Payout>[];
      if (listValue != null) {
        for (final item in listValue!) {
          if (item is Map) {
            payouts.add(Payout.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      final meta = metaMap != null ? Meta.fromJson(metaMap!) : null;
      return PayoutCollection(payouts: payouts, meta: meta);
    }

    return PayoutCollection(payouts: [], meta: null);
  }
}
