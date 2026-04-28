import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/listing.dart';
import '../repositories/listing_repository.dart';

class CreateListingUseCase implements UseCase<Listing, CreateListingParams> {
  final ListingRepository repository;

  CreateListingUseCase(this.repository);

  @override
  Future<Either<Failure, Listing>> call(CreateListingParams params) {
    return repository.createListing(
      title: params.title,
      description: params.description,
      price: params.price,
      categoryId: params.categoryId,
      imageUrl: params.imageUrl,
    );
  }
}

class CreateListingParams extends Equatable {
  final String title;
  final String? description;
  final double price;
  final String? categoryId;
  final String? imageUrl;

  const CreateListingParams({
    required this.title,
    this.description,
    required this.price,
    this.categoryId,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [title, description, price, categoryId, imageUrl];
}
