import '../repositories/auth_repository.dart';

class SendPasswordResetUsecase {
  final AuthRepository _repository;

  SendPasswordResetUsecase(this._repository);

  Future<void> execute(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      throw ArgumentError('Invalid email format.');
    }

    return _repository.sendPasswordResetEmail(trimmedEmail);
  }
}
