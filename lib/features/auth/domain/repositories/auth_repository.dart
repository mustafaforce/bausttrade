import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  });

  Future<bool> isLoggedIn();
}
