import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/listing.dart';
import '../repositories/listing_repository.dart';

class GetListingsUseCase implements UseCase<List<Listing>, NoParams> {
  final ListingRepository repository;

  GetListingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Listing>>> call(NoParams params) {
    return repository.getListings();
  }
}
