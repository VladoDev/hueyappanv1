import '../entities/contact_entity.dart';
import '../repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository _repository;

  AddContactUseCase(this._repository);

  Future<void> execute(ContactEntity contact) {
    if (contact.name.trim().isEmpty || contact.phoneNumber.trim().isEmpty) {
      throw ArgumentError('Name and phone number cannot be empty.');
    }
    return _repository.addContact(contact);
  }
}
