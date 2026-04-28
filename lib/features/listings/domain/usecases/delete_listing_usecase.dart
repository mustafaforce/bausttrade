import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/listing_repository.dart';

class DeleteListingUseCase implements UseCase<void, DeleteListingParams> {
  final ListingRepository repository;

  DeleteListingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteListingParams params) {
    return repository.deleteListing(params.id);
  }
}

class DeleteListingParams extends Equatable {
  final String id;

  const DeleteListingParams({required this.id});

  @override
  List<Object> get props => [id];
}
