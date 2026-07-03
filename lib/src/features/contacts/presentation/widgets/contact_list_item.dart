import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import '../../domain/entities/contact_entity.dart';
import '../providers/contacts_provider.dart';

class ContactListItem extends ConsumerWidget {
  final ContactEntity contact;

  const ContactListItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final categoryStyles = _getCategoryStyles(contact.category, vc);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: VecinalSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VecinalRadius.md),
        side: BorderSide(color: vc.borderDefault, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: VecinalSpacing.md,
          vertical: VecinalSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor: categoryStyles.bgColor,
          child: Icon(categoryStyles.icon, color: categoryStyles.textColor),
        ),
        title: Text(
          contact.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: VecinalTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _buildSubtitle(context, vc, categoryStyles),
        trailing: _buildActions(context, ref, vc),
      ),
    );
  }

  Widget _buildSubtitle(
    BuildContext context,
    VecinalSemanticColors vc,
    _CategoryStyle categoryStyles,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              contact.phoneNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: VecinalTextStyles.bodySmall.copyWith(
                color: vc.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: categoryStyles.bgColor,
                borderRadius: BorderRadius.circular(VecinalRadius.sm),
              ),
              child: Text(
                _getLocalizedCategoryName(context, contact.category),
                style: VecinalTextStyles.labelSmall.copyWith(
                  color: categoryStyles.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            contact.isFavorite ? Icons.star : Icons.star_border,
            color: contact.isFavorite ? Colors.amber : vc.textHint,
          ),
          onPressed: () => _toggleFavorite(ref),
        ),
        IconButton(
          icon: Icon(Icons.phone, color: vc.primaryDefault),
          onPressed: () => _showCallConfirmDialog(context, ref, vc),
        ),
      ],
    );
  }

  void _toggleFavorite(WidgetRef ref) {
    ref
        .read(toggleFavoriteUseCaseProvider)
        .execute(contact.id, !contact.isFavorite);
    ref
        .read(analyticsProvider)
        .logEvent(
          name: 'toggle_favorite_contact',
          parameters: {
            'contact_name': contact.name,
            'is_favorite': !contact.isFavorite ? 1 : 0,
          },
        );
  }

  void _showCallConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.callConfirmTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.callConfirmBody(contact.name, contact.phoneNumber)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _makeCall(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: vc.primaryDefault,
              foregroundColor: vc.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(VecinalRadius.md),
              ),
            ),
            child: Text(
              l10n.callAction,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(BuildContext context, WidgetRef ref) async {
    final uri = Uri(scheme: 'tel', path: contact.phoneNumber);
    await ref
        .read(analyticsProvider)
        .logEvent(
          name: 'call_contact',
          parameters: {
            'contact_name': contact.name,
            'contact_phone': contact.phoneNumber,
          },
        );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not launch dialer')));
    }
  }

  String _getLocalizedCategoryName(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category.toLowerCase()) {
      case 'security':
        return l10n.securityCategory;
      case 'admin':
        return l10n.adminCategory;
      case 'services':
        return l10n.servicesCategory;
      case 'emergency':
        return l10n.emergencyCategory;
      default:
        return category;
    }
  }

  _CategoryStyle _getCategoryStyles(String category, VecinalSemanticColors vc) {
    switch (category.toLowerCase()) {
      case 'security':
        return _CategoryStyle(
          icon: Icons.shield_outlined,
          bgColor: vc.noticeBg,
          textColor: vc.noticeText,
        );
      case 'admin':
        return _CategoryStyle(
          icon: Icons.admin_panel_settings_outlined,
          bgColor: vc.paymentBg,
          textColor: vc.paymentText,
        );
      case 'emergency':
        return _CategoryStyle(
          icon: Icons.warning_amber_rounded,
          bgColor: vc.emergencyBg,
          textColor: vc.emergencyText,
        );
      case 'services':
      default:
        return _CategoryStyle(
          icon: Icons.build_outlined,
          bgColor: vc.ticketBg,
          textColor: vc.ticketText,
        );
    }
  }
}

class _CategoryStyle {
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  _CategoryStyle({
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}
