import '../repositories/contacts_repository.dart';

class DeleteContactUseCase {
  final ContactsRepository repository;

  DeleteContactUseCase(this.repository);

  Future<void> execute(String contactId) {
    return repository.deleteContact(contactId);
  }
}
