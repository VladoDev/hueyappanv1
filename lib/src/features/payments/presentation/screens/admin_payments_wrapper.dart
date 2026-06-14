import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'admin_payments_view.dart';
import 'neighbor_payments_view.dart';

class AdminPaymentsWrapperScreen extends ConsumerStatefulWidget {
  final String lot;
  final String house;

  const AdminPaymentsWrapperScreen({
    super.key,
    required this.lot,
    required this.house,
  });

  @override
  ConsumerState<AdminPaymentsWrapperScreen> createState() => _AdminPaymentsWrapperScreenState();
}

class _AdminPaymentsWrapperScreenState extends ConsumerState<AdminPaymentsWrapperScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.navPayments,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.createConcept,
            onPressed: () => context.push('/payments/new'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: vc.primaryDefault,
          unselectedLabelColor: vc.textSecondary,
          indicatorColor: vc.primaryDefault,
          tabs: [
            Tab(text: l10n.maintenanceFees),
            Tab(text: l10n.adminPanel),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NeighborPaymentsView(
            lot: widget.lot,
            house: widget.house,
            isEmbedded: true,
          ),
          const AdminPaymentsView(isEmbedded: true),
        ],
      ),
    );
  }
}
