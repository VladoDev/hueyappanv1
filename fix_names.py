import re
import os

files = [
    'lib/src/features/authentication/presentation/screens/forgot_password_screen.dart',
    'lib/src/features/authentication/presentation/screens/login_screen.dart',
    'lib/src/features/payments/presentation/screens/concept_detail_screen.dart',
    'lib/src/features/payments/presentation/screens/concept_payment_map_screen.dart',
    'lib/src/features/polls/presentation/widgets/poll_card.dart'
]

for filepath in files:
    with open(filepath, 'r') as f:
        content = f.read()

    content = content.replace('VecinalColors.amber400400', 'VecinalColors.amber400')
    content = content.replace('VecinalColors.red600400', 'VecinalColors.red400')
    content = content.replace('VecinalColors.green400400', 'VecinalColors.green400')
    content = content.replace('VecinalColors.red600800', 'VecinalColors.red800')
    content = content.replace('VecinalColors.green400800', 'VecinalColors.green800')

    # Remove const before CircularProgressIndicator if it has color: VecinalColors.xxx
    content = re.sub(r'const\s+(CircularProgressIndicator\([^)]*color:\s*VecinalColors\.\w+[^)]*\))', r'\1', content)
    
    # Remove const before Icon if it has color: VecinalColors.xxx
    content = re.sub(r'const\s+(Icon\([^)]*color:\s*VecinalColors\.\w+[^)]*\))', r'\1', content)
    
    # Remove const before TextStyle if it has color: VecinalColors.xxx
    content = re.sub(r'const\s+(TextStyle\([^)]*color:\s*VecinalColors\.\w+[^)]*\))', r'\1', content)

    with open(filepath, 'w') as f:
        f.write(content)

print("Fixed bad names and consts")
