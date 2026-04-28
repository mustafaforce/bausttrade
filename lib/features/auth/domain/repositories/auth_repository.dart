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

  Future<bool> isLoggedIn();
}
