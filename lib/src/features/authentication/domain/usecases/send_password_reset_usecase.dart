import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetUsecase {
  final AuthRepository _repository;

  SendPasswordResetUsecase(this._repository);

  Future<void> execute(String email) async {
    debugPrint('Usecase: Validando email $email');
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmedEmail)) {
      throw ArgumentError('Invalid email format.');
    }

    debugPrint('Usecase: Email válido, llamando al repositorio');
    return _repository.sendPasswordResetEmail(trimmedEmail);
  }
}
