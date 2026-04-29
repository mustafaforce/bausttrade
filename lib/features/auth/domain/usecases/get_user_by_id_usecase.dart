import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetUserByIdUseCase implements UseCase<User, String> {
  final AuthRepository repository;

  GetUserByIdUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(String id) {
    return repository.getUserById(id);
  }
}