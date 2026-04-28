import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      phone: params.phone,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String? phone;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, name, phone];
}
