import 'package:flutter/material.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';

class VecinalEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const VecinalEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: vc.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: VecinalTextStyles.bodyLarge.copyWith(
                color: vc.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
