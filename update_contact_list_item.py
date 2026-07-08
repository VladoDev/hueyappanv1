import re
filepath = 'lib/src/features/contacts/presentation/widgets/contact_list_item.dart'

with open(filepath, 'r') as f:
    content = f.read()

# Add auth_provider import if not exists
if 'auth_provider.dart' not in content:
    content = content.replace("import '../../domain/entities/contact_entity.dart';", "import '../../domain/entities/contact_entity.dart';\nimport '../../../authentication/presentation/providers/auth_provider.dart';")

# Add isAdmin to build method
if 'final isAdmin =' not in content:
    build_method = """  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final categoryStyles = _getCategoryStyles(contact.category, vc);
    final authState = ref.watch(authStateProvider);
    final isAdmin = authState.value?.isAdmin ?? false;"""
    content = content.replace("""  Widget build(BuildContext context, WidgetRef ref) {
    final vc = context.vecinalColors;
    final categoryStyles = _getCategoryStyles(contact.category, vc);""", build_method)

# Pass isAdmin to _buildActions
content = content.replace("_buildActions(context, ref, vc)", "_buildActions(context, ref, vc, isAdmin)")
content = content.replace("""  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
  ) {""", """  Widget _buildActions(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
    bool isAdmin,
  ) {""")

# Add Delete IconButton to _buildActions
actions_body = """    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAdmin)
          IconButton(
            icon: Icon(Icons.delete_outline, color: vc.destructive),
            onPressed: () => _showDeleteConfirmDialog(context, ref, vc),
          ),
        IconButton(
          icon: Icon(
            contact.isFavorite ? Icons.star : Icons.star_border,"""
content = content.replace("""    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            contact.isFavorite ? Icons.star : Icons.star_border,""", actions_body)

# Add _showDeleteConfirmDialog method
delete_method = """  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    VecinalSemanticColors vc,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Eliminar Contacto",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("¿Estás seguro de que deseas eliminar a ${contact.name}? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(color: vc.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(deleteContactUseCaseProvider).execute(contact.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: vc.destructiveBg,
              foregroundColor: vc.textOnEmergency,
            ),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  void _showCallConfirmDialog"""
content = content.replace("  void _showCallConfirmDialog", delete_method)

with open(filepath, 'w') as f:
    f.write(content)

print("Updated contact_list_item")
