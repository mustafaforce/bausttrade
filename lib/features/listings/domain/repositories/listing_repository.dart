import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/category.dart';
import '../entities/listing.dart';

abstract class ListingRepository {
  Future<Either<Failure, Listing>> createListing({
    required String title,
    String? description,
    required double price,
    String? categoryId,
    String? imageUrl,
  });

  Future<Either<Failure, List<Listing>>> getListings();

  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Listing>>> getListingsByCategory(String categoryId);

  Future<Either<Failure, Listing>> getListingById(String id);

  Future<Either<Failure, void>> deleteListing(String id);

  Future<Either<Failure, Listing>> updateListing({
    required String id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? imageUrl,
    String? status,
  });

  Future<Either<Failure, List<Listing>>> searchListings(String query);
}
