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

    # Fix VecinalVecinalColors -> VecinalColors
    content = content.replace('VecinalVecinalColors.', 'VecinalColors.')
    
    with open(filepath, 'w') as f:
        f.write(content)

print("Fixed VecinalVecinalColors")
