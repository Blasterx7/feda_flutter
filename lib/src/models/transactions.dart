import 'package:flutter/material.dart';

import 'customer_create.dart';
import 'customers.dart';
import '../utils/json_parsers.dart';

class CurrencyIso {
  final String iso;

  CurrencyIso({required this.iso});

  factory CurrencyIso.fromJson(Map<String, dynamic> json) {
    return CurrencyIso(iso: json['iso'] ?? '');
  }

  Map<String, dynamic> toJson() => {'iso': iso};
}

class Transaction {
  final int id;
  final String? reference;
  final num amount;
  final String? description;
  final String? callbackUrl;
  final String? status;
  final int? customerId;
  final int? currencyId;
  final String? mode;
  final Map<String, dynamic>? metadata;
  final num? commission;
  final num? fees;
  final num? fixedCommission;
  final num? amountTransferred;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final DateTime? canceledAt;
  final DateTime? declinedAt;
  final DateTime? refundedAt;
  final DateTime? transferredAt;
  final DateTime? deletedAt;
  final String? lastErrorCode;
  final Map<String, dynamic>? customMetadata;
  final num? amountDebited;
  final String? receiptUrl;
  final int? paymentMethodId;
  final List<dynamic>? subAccountsCommissions;
  final String? transactionKey;
  final String? merchantReference;
  final int? accountId;
  final int? balanceId;

  Transaction({
    required this.id,
    this.reference,
    required this.amount,
    this.description,
    this.callbackUrl,
    this.status,
    this.customerId,
    this.currencyId,
    this.mode,
    this.metadata,
    this.commission,
    this.fees,
    this.fixedCommission,
    this.amountTransferred,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.canceledAt,
    this.declinedAt,
    this.refundedAt,
    this.transferredAt,
    this.deletedAt,
    this.lastErrorCode,
    this.customMetadata,
    this.amountDebited,
    this.receiptUrl,
    this.paymentMethodId,
    this.subAccountsCommissions,
    this.transactionKey,
    this.merchantReference,
    this.accountId,
    this.balanceId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Use shared parsing helpers for consistent behavior across models.

    return Transaction(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      reference: json['reference'],
      amount: parseNum(json['amount'], fallback: 0),
      description: json['description'],
      callbackUrl: json['callback_url'],
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
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      commission: parseNumNullable(json['commission']),
      fees: parseNumNullable(json['fees']),
      fixedCommission: parseNumNullable(json['fixed_commission']),
      amountTransferred: parseNumNullable(json['amount_transferred']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      approvedAt: parseDate(json['approved_at']),
      canceledAt: parseDate(json['canceled_at']),
      declinedAt: parseDate(json['declined_at']),
      refundedAt: parseDate(json['refunded_at']),
      transferredAt: parseDate(json['transferred_at']),
      deletedAt: parseDate(json['deleted_at']),
      lastErrorCode: json['last_error_code'],
      customMetadata: json['custom_metadata'] != null
          ? Map<String, dynamic>.from(json['custom_metadata'])
          : null,
      amountDebited: parseNumNullable(json['amount_debited']),
      receiptUrl: json['receipt_url'],
      paymentMethodId: json['payment_method_id'] is int
          ? json['payment_method_id']
          : (json['payment_method_id'] != null
                ? int.tryParse('${json['payment_method_id']}')
                : null),
      subAccountsCommissions: json['sub_accounts_commissions'] != null
          ? List<dynamic>.from(json['sub_accounts_commissions'])
          : null,
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
      'description': description,
      'callback_url': callbackUrl,
      'status': status,
      'customer_id': customerId,
      'currency_id': currencyId,
      'mode': mode,
      'metadata': metadata,
      'commission': commission,
      'fees': fees,
      'fixed_commission': fixedCommission,
      'amount_transferred': amountTransferred,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'canceled_at': canceledAt?.toIso8601String(),
      'declined_at': declinedAt?.toIso8601String(),
      'refunded_at': refundedAt?.toIso8601String(),
      'transferred_at': transferredAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'last_error_code': lastErrorCode,
      'custom_metadata': customMetadata,
      'amount_debited': amountDebited,
      'receipt_url': receiptUrl,
      'payment_method_id': paymentMethodId,
      'sub_accounts_commissions': subAccountsCommissions,
      'transaction_key': transactionKey,
      'merchant_reference': merchantReference,
      'account_id': accountId,
      'balance_id': balanceId,
    };
  }
}

/// Model used to create a transaction. The `customer` field can be either
/// a `CustomerCreate` (full customer data) or a map/object with only an `id`.
class TransactionCreate {
  final String description;
  final num amount;
  final CurrencyIso currency;
  final String? callbackUrl;
  final Map<String, dynamic>? customMetadata;
  final Object? customer; // CustomerCreate or Map<String, dynamic> with id

  TransactionCreate({
    required this.description,
    required this.amount,
    required this.currency,
    this.callbackUrl,
    this.customMetadata,
    this.customer,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'description': description,
      'amount': amount,
      'currency': currency.toJson(),
    };

    if (callbackUrl != null) map['callback_url'] = callbackUrl;
    if (customMetadata != null) map['custom_metadata'] = customMetadata;

    if (customer != null) {
      if (customer is CustomerCreate) {
        map['customer'] = (customer as CustomerCreate).toJson();
      } else if (customer is Map<String, dynamic>) {
        map['customer'] = customer;
      } else {
        // Fallback: try to call toJson if available
        try {
          final dynamic c = customer;
          map['customer'] = c.toJson();
        } catch (_) {
          // ignore
          debugPrint('TransactionCreate.toJson: unable to serialize customer');
        }
      }
    }

    return map;
  }
}

/// Response returned by the `/transactions/{id}/token` endpoint.
class TransactionToken {
  final String token;
  final String url;

  TransactionToken({required this.token, required this.url});

  factory TransactionToken.fromJson(Map<String, dynamic> json) {
    return TransactionToken(token: json['token'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {'token': token, 'url': url};
}

/// Helper to deserialize API responses that may be wrapped (and include
/// pagination meta). The Fedapay API sometimes returns:
/// {"v1/transactions": [...], "meta": {...}} or directly a list.
class TransactionCollection {
  final List<Transaction> transactions;
  final Meta? meta;

  TransactionCollection({required this.transactions, this.meta});

  factory TransactionCollection.fromApi(dynamic payload) {
    if (payload is List) {
      final list = payload
          .map((e) => Transaction.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return TransactionCollection(transactions: list, meta: null);
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
              key.toLowerCase().contains('transaction')) {
            listValue = value;
          }
        }

        if (key.toLowerCase() == 'meta' && value is Map) {
          metaMap = Map<String, dynamic>.from(value);
        }
      });

      final transactions = <Transaction>[];
      if (listValue != null) {
        for (final item in listValue!) {
          if (item is Map) {
            transactions.add(
              Transaction.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        }
      }

      final meta = metaMap != null ? Meta.fromJson(metaMap!) : null;
      return TransactionCollection(transactions: transactions, meta: meta);
    }

    return TransactionCollection(transactions: [], meta: null);
  }
}
