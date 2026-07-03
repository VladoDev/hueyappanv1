import '../entities/resident_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmailUsecase {
  final AuthRepository _repository;

  LoginWithEmailUsecase(this._repository);

  Future<ResidentEntity> execute(String email, String password) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      throw ArgumentError('Invalid email format.');
    }

    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty.');
    }
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters.');
    }

    return _repository.loginWithEmail(trimmedEmail, password);
  }
}
