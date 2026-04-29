import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/listing.dart';
import '../repositories/listing_repository.dart';

class FilterListingsUseCase implements UseCase<List<Listing>, FilterListingsParams> {
  final ListingRepository repository;

  FilterListingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Listing>>> call(FilterListingsParams params) {
    return repository.filterListings(
      categoryId: params.categoryId,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    );
  }
}

class FilterListingsParams extends Equatable {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;

  const FilterListingsParams({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
  });

  @override
  List<Object?> get props => [categoryId, minPrice, maxPrice];
}