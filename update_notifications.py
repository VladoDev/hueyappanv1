import re

file_path = 'lib/src/features/notifications/presentation/screens/notifications_screen.dart'

with open(file_path, 'r') as f:
    content = f.read()

# Replace EdgeInsets.all(16) -> EdgeInsets.all(VecinalSpacing.lg)
content = content.replace('EdgeInsets.all(16)', 'EdgeInsets.all(VecinalSpacing.lg)')

# Replace BorderRadius.circular(16) -> BorderRadius.circular(VecinalRadius.lg)
content = content.replace('BorderRadius.circular(16)', 'BorderRadius.circular(VecinalRadius.lg)')

# Replace BorderRadius.circular(20) -> BorderRadius.circular(VecinalRadius.xl)
content = content.replace('BorderRadius.circular(20)', 'BorderRadius.circular(VecinalRadius.xl)')

# Replace TextStyle(color: vc.destructive) -> VecinalTextStyles.bodyMedium.copyWith(color: vc.destructive)
content = content.replace('TextStyle(color: vc.destructive)', 'VecinalTextStyles.bodyMedium.copyWith(color: vc.destructive)')

# Replace TextStyle(color: vc.textSecondary, fontSize: 14) -> VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary)
content = content.replace('TextStyle(color: vc.textSecondary, fontSize: 14)', 'VecinalTextStyles.bodyMedium.copyWith(color: vc.textSecondary)')

# Replace TextStyle(color: vc.textSecondary.withValues(alpha: 0.7), fontSize: 12) -> VecinalTextStyles.bodySmall.copyWith(color: vc.textSecondary.withValues(alpha: 0.7))
content = content.replace('TextStyle(\n                          color: vc.textSecondary.withValues(alpha: 0.7),\n                          fontSize: 12,\n                        )', 'VecinalTextStyles.bodySmall.copyWith(color: vc.textSecondary.withValues(alpha: 0.7))')

# Replace Colors.black.withValues(alpha: 0.05) -> vc.textPrimary.withValues(alpha: 0.05)
content = content.replace('Colors.black.withValues(alpha: 0.05)', 'vc.textPrimary.withValues(alpha: 0.05)')

with open(file_path, 'w') as f:
    f.write(content)

print("Updated notifications_screen.dart")
