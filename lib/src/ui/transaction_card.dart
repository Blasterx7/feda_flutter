import 'package:flutter/material.dart';
import 'package:feda_flutter/src/models/transactions.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onReceipt;
  final VoidCallback? onPayment;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.onReceipt,
    this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    final amountStr = transaction.amount.toString();
    final dateStr =
        transaction.createdAt?.toLocal().toString().split('.').first ?? '-';
    final status = transaction.status ?? '-';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(transaction.reference ?? '—'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Amount: $amountStr'),
            Text('Status: $status'),
            Text('Date: $dateStr'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'receipt') onReceipt?.call();
            if (v == 'pay') onPayment?.call();
          },
          itemBuilder: (_) => [
            if (transaction.receiptUrl != null)
              const PopupMenuItem(value: 'receipt', child: Text('Receipt')),
            if (transaction.paymentUrl != null)
              const PopupMenuItem(value: 'pay', child: Text('Open payment')),
          ],
        ),
      ),
    );
  }
}
