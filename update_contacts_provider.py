filepath = 'lib/src/features/contacts/presentation/providers/contacts_provider.dart'

with open(filepath, 'r') as f:
    content = f.read()

# Add import
import_statement = "import '../../domain/usecases/add_contact_usecase.dart';\nimport '../../domain/usecases/delete_contact_usecase.dart';"
content = content.replace("import '../../domain/usecases/add_contact_usecase.dart';", import_statement)

# Add provider
provider_statement = """final addContactUseCaseProvider = Provider<AddContactUseCase>((ref) {
  return AddContactUseCase(ref.watch(contactsRepositoryProvider));
});

final deleteContactUseCaseProvider = Provider<DeleteContactUseCase>((ref) {
  return DeleteContactUseCase(ref.watch(contactsRepositoryProvider));
});"""

content = content.replace("""final addContactUseCaseProvider = Provider<AddContactUseCase>((ref) {
  return AddContactUseCase(ref.watch(contactsRepositoryProvider));
});""", provider_statement)

with open(filepath, 'w') as f:
    f.write(content)

print("Updated contacts_provider")
