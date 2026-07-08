import re

filepath = 'lib/src/core/theme/vecinal_theme.dart'

with open(filepath, 'r') as f:
    content = f.read()

# Add warning and success to the ThemeExtension class definition
content = content.replace(
    '      // ── Acción destructiva\n      destructive,\n      destructiveBg,',
    '      // ── Acción destructiva\n      destructive,\n      destructiveBg,\n      warning,\n      success,'
)

# Add to constructor
content = content.replace(
    '    required this.destructive,\n    required this.destructiveBg,',
    '    required this.destructive,\n    required this.destructiveBg,\n    required this.warning,\n    required this.success,'
)

# Add to copyWith signature
content = content.replace(
    '    Color? destructive,\n    Color? destructiveBg,',
    '    Color? destructive,\n    Color? destructiveBg,\n    Color? warning,\n    Color? success,'
)

# Add to copyWith return
content = content.replace(
    '      destructive: destructive ?? this.destructive,\n      destructiveBg: destructiveBg ?? this.destructiveBg,',
    '      destructive: destructive ?? this.destructive,\n      destructiveBg: destructiveBg ?? this.destructiveBg,\n      warning: warning ?? this.warning,\n      success: success ?? this.success,'
)

# Add to lerp return
content = content.replace(
    '      destructive: Color.lerp(destructive, other.destructive, t)!,\n      destructiveBg: Color.lerp(destructiveBg, other.destructiveBg, t)!,',
    '      destructive: Color.lerp(destructive, other.destructive, t)!,\n      destructiveBg: Color.lerp(destructiveBg, other.destructiveBg, t)!,\n      warning: Color.lerp(warning, other.warning, t)!,\n      success: Color.lerp(success, other.success, t)!,'
)

# Add to vecinalLight implementation
content = content.replace(
    '  destructive: VecinalColors.red600,\n  destructiveBg: VecinalColors.red50,',
    '  destructive: VecinalColors.red600,\n  destructiveBg: VecinalColors.red50,\n  warning: VecinalColors.amber400,\n  success: VecinalColors.green400,'
)

# Add to vecinalDark implementation
content = content.replace(
    '  destructive: VecinalColors.red400,\n  destructiveBg: VecinalColors.red900,',
    '  destructive: VecinalColors.red400,\n  destructiveBg: VecinalColors.red900,\n  warning: VecinalColors.amber200,\n  success: VecinalColors.green200,'
)

with open(filepath, 'w') as f:
    f.write(content)

print("Patched vecinal_theme.dart")
