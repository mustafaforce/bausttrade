import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      name: params.name,
      phone: params.phone,
      avatarUrl: params.avatarUrl,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? phone;
  final String? avatarUrl;

  const UpdateProfileParams({
    this.name,
    this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, phone, avatarUrl];
}
