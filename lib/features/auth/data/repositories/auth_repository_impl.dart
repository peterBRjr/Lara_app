import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> signInWithEmail(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signInWithEmail(email, password);
      return Right(userModel);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<Either<String, UserEntity>> checkAuthStatus() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel != null) {
        return Right(userModel);
      } else {
        return const Left('User not logged in');
      }
    } catch (e) {
       return Left(e.toString());
    }
  }
}
