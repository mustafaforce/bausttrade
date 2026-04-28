import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/listing.dart';
import '../repositories/listing_repository.dart';

class SearchListingsUseCase implements UseCase<List<Listing>, SearchListingsParams> {
  final ListingRepository repository;

  SearchListingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Listing>>> call(SearchListingsParams params) {
    return repository.searchListings(params.query);
  }
}

class SearchListingsParams extends Equatable {
  final String query;

  const SearchListingsParams({required this.query});

  @override
  List<Object> get props => [query];
}