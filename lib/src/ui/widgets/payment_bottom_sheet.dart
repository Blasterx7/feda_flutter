import 'package:flutter/material.dart';
import 'package:feda_flutter/src/exports/index.dart';

/// Bottom sheet réutilisable pour les paiements FedaPay.
///
/// Fonctionne en mode Direct (apiKey) et Cloud Proxy (projectKey).
/// En mode Sandbox, affiche automatiquement des boutons de simulation.
///
/// ## Utilisation
/// ```dart
/// await PaymentBottomSheet.show(
///   context,
///   amount: 1000,
///   description: 'Abonnement mensuel',
///   onSuccess: () => print('Paiement réussi !'),
/// );
/// ```
class PaymentBottomSheet extends StatefulWidget {
  final double amount;
  final String currency;
  final String description;
  final List<String> operators;
  final Color? primaryColor;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  const PaymentBottomSheet({
    super.key,
    required this.amount,
    required this.description,
    this.currency = 'XOF',
    this.operators = const ['mtn_open', 'moov', 'mtn_ci'],
    this.primaryColor,
    this.onSuccess,
    this.onFailure,
  });

  static Future<void> show(
    BuildContext context, {
    required double amount,
    required String description,
    String currency = 'XOF',
    List<String> operators = const ['mtn_open', 'moov', 'mtn_ci'],
    Color? primaryColor,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => PaymentBottomSheet(
        amount: amount,
        description: description,
        currency: currency,
        operators: operators,
        primaryColor: primaryColor,
        onSuccess: onSuccess,
        onFailure: onFailure,
      ),
    );
  }

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final _phoneController = TextEditingController();
  String? _selectedOperator;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isSandbox =>
      FedaFlutter.instance.environment == ApiEnvironment.sandbox;

  Color get _primary => widget.primaryColor ?? const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Badge Sandbox
          if (_isSandbox)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.science_outlined, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    'MODE SANDBOX — Aucun paiement réel',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Titre + montant
          Text(
            widget.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.amount.toStringAsFixed(0)} ${widget.currency}',
            style: TextStyle(
              color: _primary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Sélecteur d'opérateur
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Opérateur mobile',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.cell_tower),
            ),
            items: widget.operators
                .map(
                  (op) => DropdownMenuItem(value: op, child: Text(op)),
                )
                .toList(),
            onChanged: (v) => setState(() {
              _selectedOperator = v;
              _errorMessage = null;
            }),
          ),
          const SizedBox(height: 12),

          // Champ téléphone
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: '+229...',
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.phone),
            ),
            onChanged: (_) => setState(() => _errorMessage = null),
          ),
          const SizedBox(height: 20),

          // Bouton Payer
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Payer ${widget.amount.toStringAsFixed(0)} ${widget.currency}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),

          // Boutons simulateur sandbox
          if (_isSandbox) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 14),
                    label: const Text('Simuler succès', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSuccess?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: const Text('Simuler échec', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onFailure?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pay() async {
    if (_selectedOperator == null) {
      setState(() => _errorMessage = 'Sélectionnez un opérateur');
      return;
    }
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Entrez votre numéro de téléphone');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final payload = TransactionCreate(
        amount: widget.amount.toInt(),
        currency: CurrencyIso(iso: widget.currency),
        description: widget.description,
        customer: null,
        callbackUrl: null,
        customMetadata: {'operator': _selectedOperator, 'phone': phone},
      );
      final result = await FedaFlutter.instance.transactions.createTransaction(payload);

      if (result.data != null && mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
