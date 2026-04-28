import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/listing.dart';
import '../repositories/listing_repository.dart';

class UpdateListingUseCase implements UseCase<Listing, UpdateListingParams> {
  final ListingRepository repository;

  UpdateListingUseCase(this.repository);

  @override
  Future<Either<Failure, Listing>> call(UpdateListingParams params) {
    return repository.updateListing(
      id: params.id,
      title: params.title,
      description: params.description,
      price: params.price,
      categoryId: params.categoryId,
      imageUrl: params.imageUrl,
      status: params.status,
    );
  }
}

class UpdateListingParams extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final double? price;
  final String? categoryId;
  final String? imageUrl;
  final String? status;

  const UpdateListingParams({
    required this.id,
    this.title,
    this.description,
    this.price,
    this.categoryId,
    this.imageUrl,
    this.status,
  });

  @override
  List<Object?> get props => [id, title, description, price, categoryId, imageUrl, status];
}
