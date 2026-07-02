import 'package:flutter/material.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';

class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.communityNews,
          style: VecinalTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: vc.primaryDefault,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: VecinalSpacing.xl,
          right: VecinalSpacing.xl,
          top: VecinalSpacing.xl,
          bottom: 100,
        ),
        children: [
          _buildNewsCard(
            l10n.news1Title,
            l10n.news1Body,
            l10n.news1Date,
            l10n.news1Author,
            vc,
          ),
          const SizedBox(height: 16),
          _buildNewsCard(
            l10n.news2Title,
            l10n.news2Body,
            l10n.news2Date,
            l10n.news2Author,
            vc,
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    String title,
    String body,
    String date,
    String author,
    VecinalSemanticColors vc,
  ) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
