import re
import os

files = [
    'lib/src/features/authentication/presentation/widgets/profile_tab.dart',
    'lib/src/features/authentication/presentation/screens/forgot_password_screen.dart',
    'lib/src/features/authentication/presentation/screens/main_shell_screen.dart',
    'lib/src/features/authentication/presentation/screens/login_screen.dart',
    'lib/src/features/authentication/presentation/widgets/home_tab.dart',
    'lib/src/features/authentication/presentation/screens/register_screen.dart',
    'lib/src/features/polls/presentation/widgets/poll_card.dart',
    'lib/src/features/polls/presentation/pages/create_poll_page.dart',
    'lib/src/features/polls/presentation/pages/revert_requests_page.dart',
    'lib/src/features/contacts/presentation/widgets/contact_list_item.dart',
    'lib/src/features/app_settings/presentation/screens/force_update_screen.dart',
    'lib/src/features/payments/presentation/screens/concept_form_screen.dart',
    'lib/src/features/payments/presentation/screens/concept_payment_map_screen.dart',
    'lib/src/features/payments/presentation/screens/concept_detail_screen.dart',
    'lib/src/features/water_status/presentation/widgets/water_status_icon.dart',
    'lib/src/features/notifications/presentation/screens/notifications_screen.dart'
]

def process_file(filepath):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return
    
    with open(filepath, 'r') as f:
        content = f.read()

    # We need to make sure we import VecinalColors if it's not already imported
    # VecinalColors is in lib/src/core/theme/vecinal_theme.dart
    
    # We will replace Colors.xxx with VecinalColors.yyy
    content = re.sub(r'Colors\.red\.shade\d+', 'VecinalColors.red800', content)
    content = re.sub(r'Colors\.green\.shade\d+', 'VecinalColors.green800', content)
    
    content = content.replace('Colors.red[400]!', 'VecinalColors.red400')
    content = content.replace('Colors.green[400]!', 'VecinalColors.green400')
    content = content.replace('Colors.orange[400]!', 'VecinalColors.amber400')
    content = content.replace('Colors.grey[300]!', 'VecinalColors.gray200')
    content = content.replace('Colors.grey[400]', 'VecinalColors.gray400')
    content = content.replace('Colors.orange.withValues', 'VecinalColors.amber400.withValues')
    
    content = content.replace('Colors.white', 'VecinalColors.white')
    content = content.replace('Colors.black54', 'VecinalColors.gray600')
    content = content.replace('Colors.black', 'VecinalColors.black')
    content = content.replace('Colors.red', 'VecinalColors.red600')
    content = content.replace('Colors.green', 'VecinalColors.green400')
    content = content.replace('Colors.orange', 'VecinalColors.amber400')
    content = content.replace('Colors.amber', 'VecinalColors.amber400')
    content = content.replace('Colors.grey', 'VecinalColors.gray400')

    # Ensure import is present if VecinalColors is used
    if 'VecinalColors.' in content and 'vecinal_theme.dart' not in content:
        # insert import at top
        content = "import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';\n" + content

    with open(filepath, 'w') as f:
        f.write(content)

for filepath in files:
    process_file(filepath)

print("VecinalColors replacement complete.")
