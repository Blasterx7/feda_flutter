import 'dart:convert';

// Import the package but hide widget names that are also defined in the
// example folder to avoid ambiguous imports when using local demo widgets.
import 'package:app/pages/payment.dart';
import 'package:feda_flutter/feda_flutter.dart'
    hide TransactionCard, TransactionListView, CustomerFormWidget;
import 'widgets/transaction_card.dart';
import 'widgets/transaction_list_view.dart';
import 'widgets/customer_form.dart';
import 'package:flutter/material.dart';
import 'widgets/components_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Feda Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FedaFlutter _fedaFlutter = FedaFlutter(
    apiKey: 'sk_sandbox_oRoKr1GM3bUyrI4x9m56UoUl',
    environment: ApiEnvironment.sandbox,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fedaFlutter.initialize();
    
  }

  final List<String> _logs = [];
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  // Fields for creating a customer
  final TextEditingController _custFirstNameController =
      TextEditingController();
  final TextEditingController _custLastNameController = TextEditingController();
  final TextEditingController _custEmailController = TextEditingController();
  final TextEditingController _custPhoneNumberController =
      TextEditingController();
  final TextEditingController _custPhoneCountryController =
      TextEditingController(text: 'SN');
  bool _loading = false;

  void _setLoading(bool v) {
    setState(() {
      _loading = v;
    });
  }

  void _appendLog(String entry) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toIso8601String()} - $entry');
      if (_logs.length > 200) _logs.removeLast();
    });
  }

  String _serialize(dynamic o) {
    try {
      if (o == null) return 'null';
      if (o is Iterable) {
        final list = o.map((e) {
          try {
            return (e as dynamic).toJson();
          } catch (_) {
            return e;
          }
        }).toList();
        return const JsonEncoder.withIndent('  ').convert(list);
      }

      try {
        final m = (o as dynamic).toJson();
        return const JsonEncoder.withIndent('  ').convert(m);
      } catch (_) {
        return const JsonEncoder.withIndent('  ').convert(o);
      }
    } catch (e) {
      return o.toString();
    }
  }

  Future<void> _callGetCustomers() async {
    _appendLog('Calling getCustomers()');
    _setLoading(true);
    try {
      final res = await _fedaFlutter.customers.getCustomers();
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callGetCustomer(int id) async {
    _appendLog('Calling getCustomer($id)');
    _setLoading(true);
    try {
      final res = await _fedaFlutter.customers.getCustomer(id);
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callGetTransactions() async {
    _appendLog('Calling getTransactions()');
    _setLoading(true);
    try {
      final res = await _fedaFlutter.transactions.getTransactions();
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
      // If the repository returned pagination/meta info include it in the logs
      if (res.meta != null) {
        _appendLog('meta: ${_serialize(res.meta)}');
      }
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callGetTransaction(int id) async {
    _appendLog('Calling getTransaction($id)');
    _setLoading(true);
    try {
      final res = await _fedaFlutter.transactions.getTransaction(id);
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callGetTransactionToken(int id) async {
    _appendLog('Calling getTransactionToken($id)');
    _setLoading(true);
    try {
      final res = await _fedaFlutter.transactions.getTransactionToken(id);
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callCreateTransaction() async {
    _appendLog('Calling createTransaction()');
    _setLoading(true);
    try {
      final payload = TransactionCreate(
        description: 'Demo transaction',
        amount: 2000,
        currency: CurrencyIso(iso: 'XOF'),
        callbackUrl: 'https://example.com/callback',
        customMetadata: {'order_id': '12345'},
        customer: {'id': '70635'},
      );

      final res = await _fedaFlutter.transactions.createTransaction(payload);
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _callCreateCustomer() async {
    _appendLog('Calling createCustomer()');
    _setLoading(true);
    try {
      final firstname = _custFirstNameController.text.trim();
      final lastname = _custLastNameController.text.trim();
      final email = _custEmailController.text.trim();
      final phone = _custPhoneNumberController.text.trim();
      final country = _custPhoneCountryController.text.trim();

      // Build a CustomerCreate DTO. Phone number is required by the DTO.
      final payload = CustomerCreate(
        firstname: firstname.isEmpty ? 'Demo' : firstname,
        lastname: lastname.isEmpty ? 'Customer' : lastname,
        email: email.isEmpty ? 'demo@example.com' : email,
        phoneNumber: PhoneNumber(
          number: phone.isEmpty ? '221771234567' : phone,
          country: country.isEmpty ? 'SN' : country,
        ),
      );

      final res = await _fedaFlutter.customers.createCustomer(payload);
      _appendLog('status: ${res.statusCode}');
      _appendLog(_serialize(res.data));
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customerIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Customer ID',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _transactionIdController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Transaction ID',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Inputs to create a customer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _custFirstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _custLastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last name',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _custEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _custPhoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone number',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _custPhoneCountryController,
                            decoration: const InputDecoration(labelText: 'CC'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to payment page
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (ctx) => Payment()));
                      },
                      child: const Text('Make payment'),
                    ),
                    ElevatedButton(
                      onPressed: _callGetCustomers,
                      child: const Text('Get Customers'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final id =
                            int.tryParse(_customerIdController.text) ?? 1;
                        _callGetCustomer(id);
                      },
                      child: const Text('Get Customer (ID)'),
                    ),
                    ElevatedButton(
                      onPressed: _callGetTransactions,
                      child: const Text('Get Transactions'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final id =
                            int.tryParse(_transactionIdController.text) ??
                            373318;
                        _callGetTransaction(id);
                      },
                      child: const Text('Get Transaction (ID)'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final id =
                            int.tryParse(_transactionIdController.text) ??
                            373318;
                        _callGetTransactionToken(id);
                      },
                      child: const Text('Get Transaction Token (ID)'),
                    ),
                    ElevatedButton(
                      onPressed: _callCreateTransaction,
                      child: const Text('Create Transaction'),
                    ),
                    ElevatedButton(
                      onPressed: _callCreateCustomer,
                      child: const Text('Create Customer'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ComponentsDemo(feda: _fedaFlutter),
                          ),
                        );
                      },
                      child: const Text('Widgets Demo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ComponentsDemo(feda: _fedaFlutter),
                          ),
                        );
                      },
                      child: const Text('Widgets Demo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Transaction Card demo page
                        final sample = Transaction.fromJson({
                          'id': 373318,
                          'reference': 'TX-1234',
                          'amount': 5000,
                          'description': 'Demo',
                          'customer_id': 70635,
                          'created_at': DateTime.now().toIso8601String(),
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Transaction Card'),
                              ),
                              body: Center(
                                child: TransactionCard(transaction: sample),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Transaction Card Demo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Transaction List demo page
                        final sample = Transaction.fromJson({
                          'id': 373318,
                          'reference': 'TX-1234',
                          'amount': 5000,
                          'description': 'Demo',
                          'customer_id': 70635,
                          'created_at': DateTime.now().toIso8601String(),
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Transaction List'),
                              ),
                              body: TransactionListView(
                                transactions: [sample],
                                meta: {
                                  'current_page': 1,
                                  'next_page': null,
                                  'prev_page': null,
                                  'per_page': 20,
                                  'total_pages': 1,
                                  'total_count': 1,
                                },
                                onRefresh: () async {},
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Transaction List Demo'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Customer form demo page
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Customer Form'),
                              ),
                              body: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomerForm(
                                  onSubmit: (payload) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Submitted: ${payload.toString()}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Customer Form Demo'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _logs.isEmpty
                        ? const Text(
                            'No logs yet. Tap a button to run a request.',
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: _logs.length,
                            itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(_logs[i]),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
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
      // No floating action button in this example UI.
    );
  }
}
