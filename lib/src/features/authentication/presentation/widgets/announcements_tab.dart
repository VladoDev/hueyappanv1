import 'package:flutter/material.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';

class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community News',
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(VecinalSpacing.xl),
        children: [
          _buildNewsCard(
            'New Access Control Guidelines',
            'Please ensure your guest register codes are generated via the portal 24 hours prior to their arrival. RFID tags are required for vehicle access.',
            'May 28, 2026',
            'Security Committee',
            vc,
          ),
          const SizedBox(height: 16),
          _buildNewsCard(
            'Annual Swimming Pool Opening',
            'The neighborhood swimming pool will open for the season starting this Friday. Pool hours are 8:00 AM - 10:00 PM daily. Please review the safety rules posted at the entry.',
            'May 24, 2026',
            'Administration',
            vc,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String body, String date, String author, VecinalSemanticColors vc) {
    return Card(
      color: vc.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.lg),
        side: BorderSide(color: vc.noticeBorder, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: VecinalTextStyles.bodySmall.copyWith(
                    color: vc.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: vc.noticeBg,
                    borderRadius: BorderRadius.circular(VecinalRadius.sm),
                  ),
                  child: Text(
                    author,
                    style: VecinalTextStyles.labelSmall.copyWith(
                      color: vc.noticeText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: VecinalTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: vc.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: VecinalTextStyles.bodyMedium.copyWith(
                color: vc.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
