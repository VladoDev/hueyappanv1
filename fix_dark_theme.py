filepath = 'lib/src/core/theme/vecinal_theme.dart'

with open(filepath, 'r') as f:
    content = f.read()

# Add warning and success to vecinalDarkColors
content = content.replace(
    '  destructive: VecinalColors.red400,\n  destructiveBg: VecinalColors.red900,',
    '  destructive: VecinalColors.red400,\n  destructiveBg: VecinalColors.red900,\n  warning: VecinalColors.amber200,\n  success: VecinalColors.green200,'
)

with open(filepath, 'w') as f:
    f.write(content)

print("Fixed dark theme missing properties")
