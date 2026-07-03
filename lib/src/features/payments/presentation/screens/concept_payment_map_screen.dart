import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/housing_payment_entity.dart';
import '../providers/payments_provider.dart';

class ConceptPaymentMapScreen extends ConsumerWidget {
  final String conceptId;

  const ConceptPaymentMapScreen({super.key, required this.conceptId});

  static const List<String> leftColumn = [
    '155 B',
    '155 A',
    '154 B',
    '154 A',
    '153 B',
    '153 A',
    '152 B',
    '152 A',
    '151 B',
    '151 A',
    '150 B',
    '150 A',
    '149 B',
    '149 A',
    '148 B',
    '148 A',
    '147 B',
    '147 A',
    '146 B',
    '146 A',
    '145 C',
    '145 B',
    '145 A',
  ];

  static const List<String> rightColumn = [
    '134 A',
    '134 B',
    '135 A',
    '135 B',
    '136 A',
    '136 B',
    '137 A',
    '137 B',
    '138 A',
    '138 B',
    '139 A',
    '139 B',
    '140 A',
    '140 B',
    '141 A',
    '141 B',
    '142 A',
    '142 B',
    '143 A',
    '143 B',
    '144 A',
    '144 B',
    '144 C',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final paymentsAsync = ref.watch(conceptPaymentsStreamProvider(conceptId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa de Pagos',
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: paymentsAsync.when(
        data: (payments) {
          return Column(
            children: [
              _buildLegend(vc),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 100,
                    left: 16,
                    right: 16,
                  ),
                  itemCount: leftColumn.length,
                  itemBuilder: (context, index) {
                    final leftHouse = leftColumn[index];
                    final rightHouse = rightColumn[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildHouseBlock(leftHouse, payments, vc),
                          ),
                          const SizedBox(width: 40), // Calle
                          Expanded(
                            child: _buildHouseBlock(rightHouse, payments, vc),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLegend(VecinalSemanticColors vc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _legendItem('No Registrado', Colors.grey[300]!, vc),
          _legendItem('Pendiente', Colors.red[400]!, vc),
          _legendItem('Parcial', Colors.orange[400]!, vc),
          _legendItem('Pagado', Colors.green[400]!, vc),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, VecinalSemanticColors vc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: VecinalTextStyles.bodySmall.copyWith(color: vc.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHouseBlock(
    String rawHouse,
    List<HousingPaymentEntity> payments,
    VecinalSemanticColors vc,
  ) {
    // Parse "155 B" -> lot "155", house "B"
    final parts = rawHouse.split(' ');
    if (parts.length != 2) return const SizedBox.shrink();

    final lot = parts[0];
    final house = parts[1];

    final payment = payments
        .where((p) => p.lot == lot && p.house == house)
        .firstOrNull;

    Color color;
    Color textColor = Colors.white;

    if (payment == null) {
      color = Colors.grey[300]!;
      textColor = Colors.black54;
    } else {
      if (payment.paymentStatus == 'paid') {
        color = Colors.green[400]!;
      } else if (payment.paymentStatus == 'partial') {
        color = Colors.orange[400]!;
      } else {
        color = Colors.red[400]!;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          rawHouse,
          style: VecinalTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
