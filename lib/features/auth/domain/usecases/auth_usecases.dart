import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<String, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<Either<String, UserEntity>> call(String email, String password) async {
    return await repository.signInWithEmail(email, password);
  }
}

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<Either<String, UserEntity>> call(String email, String password) async {
    return await repository.signUpWithEmail(email, password);
  }
}

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}

class CheckAuthStatus {
  final AuthRepository repository;

  CheckAuthStatus(this.repository);

  Future<Either<String, UserEntity>> call() async {
    return await repository.checkAuthStatus();
  }
}
