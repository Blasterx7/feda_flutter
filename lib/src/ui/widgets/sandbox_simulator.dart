import 'package:flutter/material.dart';
import 'package:feda_flutter/src/exports/index.dart';

/// Widget de simulation de paiement pour le mode Sandbox.
///
/// Visible uniquement quand [FedaFlutter] est configuré en mode Sandbox.
/// Permet de tester les flux success/failure sans faire de vrai paiement.
///
/// ```dart
/// // Afficher le simulateur en mode développement :
/// if (FedaFlutter.instance.environment == ApiEnvironment.sandbox) {
///   SandboxSimulator.show(context, onSuccess: ..., onFailure: ...);
/// }
/// ```
class SandboxSimulator extends StatelessWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final VoidCallback? onPending;

  const SandboxSimulator({
    super.key,
    this.onSuccess,
    this.onFailure,
    this.onPending,
  });

  /// Affiche le simulateur comme bottom sheet.
  /// Ne fait rien si l'environnement n'est pas sandbox.
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
    VoidCallback? onPending,
  }) {
    if (FedaFlutter.instance.environment != ApiEnvironment.sandbox) {
      debugPrint('[SandboxSimulator] Ignored — not in sandbox mode.');
      return Future.value();
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SandboxSimulator(
        onSuccess: onSuccess,
        onFailure: onFailure,
        onPending: onPending,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Titre avec icône lab
          const Row(
            children: [
              Icon(Icons.science, color: Colors.amber, size: 22),
              SizedBox(width: 8),
              Text(
                'Sandbox Simulator',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 8),
              Chip(
                label: Text(
                  'DEV',
                  style: TextStyle(fontSize: 10, color: Colors.amber),
                ),
                backgroundColor: Color(0xFF2E2E4E),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Simulez le résultat d\'un paiement sans effectuer de transaction réelle.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Boutons de simulation
          _SimulatorButton(
            icon: Icons.check_circle_rounded,
            label: 'Paiement réussi',
            subtitle: 'Simule une transaction approuvée',
            color: const Color(0xFF00C853),
            onTap: () {
              Navigator.pop(context);
              onSuccess?.call();
            },
          ),
          const SizedBox(height: 10),
          _SimulatorButton(
            icon: Icons.pending_rounded,
            label: 'Paiement en attente',
            subtitle: 'Simule une transaction pending',
            color: const Color(0xFFFFAB00),
            onTap: () {
              Navigator.pop(context);
              onPending?.call();
            },
          ),
          const SizedBox(height: 10),
          _SimulatorButton(
            icon: Icons.cancel_rounded,
            label: 'Paiement échoué',
            subtitle: 'Simule un refus ou erreur réseau',
            color: const Color(0xFFFF1744),
            onTap: () {
              Navigator.pop(context);
              onFailure?.call();
            },
          ),
          const SizedBox(height: 16),
          const Text(
            '⚠️  Ce simulateur n\'est disponible qu\'en mode Sandbox.\nIl sera automatiquement retiré en production (Live).',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _SimulatorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SimulatorButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}
