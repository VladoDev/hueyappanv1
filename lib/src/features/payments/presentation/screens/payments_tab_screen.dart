import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import 'neighbor_payments_view.dart';
import 'admin_payments_view.dart';

class PaymentsTabScreen extends ConsumerWidget {
  const PaymentsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user.isAdmin) {
      return const AdminPaymentsView();
    } else {
      return NeighborPaymentsView(lot: user.lot,
        house: user.house);
    }
  }
}
