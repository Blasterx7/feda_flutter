import 'package:flutter/material.dart';
import 'package:feda_flutter/src/models/transactions.dart';
import 'package:feda_flutter/src/models/customers.dart' show Meta;
import 'transaction_card.dart';

class TransactionListView extends StatelessWidget {
  final List<Transaction> transactions;
  final Meta? meta;
  final Future<void> Function()? onRefresh;
  final void Function(int id)? onTap;
  final void Function(int page)? onPageChange;

  const TransactionListView({
    super.key,
    required this.transactions,
    this.meta,
    this.onRefresh,
    this.onTap,
    this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh ?? () async {},
            child: transactions.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 48),
                      Center(child: Text('No transactions')),
                    ],
                  )
                : ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, i) {
                      final tx = transactions[i];
                      return TransactionCard(
                        transaction: tx,
                        onTap: () => onTap?.call(tx.id),
                        onReceipt: () {},
                      );
                    },
                  ),
          ),
        ),
        if (meta != null) _buildPagination(context),
      ],
    );
  }

  Widget _buildPagination(BuildContext context) {
    final current = meta!.currentPage;
    final next = meta!.nextPage;
    final prev = meta!.prevPage;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Page $current • ${meta!.totalCount} items'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: prev != null ? () => onPageChange?.call(prev) : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: next != null ? () => onPageChange?.call(next) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
