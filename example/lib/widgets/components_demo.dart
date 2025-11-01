import 'package:flutter/material.dart';
import 'package:feda_flutter/feda_flutter.dart';

class ComponentsDemo extends StatefulWidget {
  final FedaFlutter feda;

  const ComponentsDemo({super.key, required this.feda});

  @override
  State<ComponentsDemo> createState() => _ComponentsDemoState();
}

class _ComponentsDemoState extends State<ComponentsDemo> {
  List<Transaction> _transactions = [];
  Meta? _meta;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSampleTransactions();
  }

  void _loadSampleTransactions() {
    final now = DateTime.now().toIso8601String();
    final sample = {
      'id': 373318,
      'reference': 'TX-1234',
      'amount': 5000,
      'description': 'Demo',
      'customer_id': 70635,
      'created_at': now,
    };
    setState(() {
      _transactions = [Transaction.fromJson(sample)];
      _meta = Meta.fromJson({
        'current_page': 1,
        'next_page': null,
        'prev_page': null,
        'per_page': 20,
        'total_pages': 1,
        'total_count': 1,
      });
    });
  }

  Future<void> _onCreateCustomer(Map<String, dynamic> payload) async {
    setState(() => _loading = true);
    try {
      final res = await widget.feda.customers.createCustomer(payload);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer created (status ${res.statusCode})')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Components demo')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: TransactionListView(
                    transactions: _transactions,
                    meta: _meta,
                    onRefresh: () async {},
                  ),
                ),
                const SizedBox(height: 12),
                CustomerFormWidget(onSubmit: _onCreateCustomer),
              ],
            ),
          ),
          if (_loading)
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.35),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
