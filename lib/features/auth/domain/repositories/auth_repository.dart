import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> signInWithGoogle();
  Future<Either<String, UserEntity>> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<Either<String, UserEntity>> checkAuthStatus();
}
