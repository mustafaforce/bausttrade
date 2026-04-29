import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final user = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      if (user == null) {
        return const Left(AuthFailure('No user logged in'));
      }
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await remoteDataSource.isLoggedIn();
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        name: name,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final user = await remoteDataSource.getUserById(id);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
