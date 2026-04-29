import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/listing.dart';
import '../../domain/repositories/listing_repository.dart';
import '../datasources/listing_remote_datasource.dart';

class ListingRepositoryImpl implements ListingRepository {
  final ListingRemoteDataSource remoteDataSource;

  ListingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Listing>> createListing({
    required String title,
    String? description,
    required double price,
    String? categoryId,
    String? imageUrl,
  }) async {
    try {
      final listing = await remoteDataSource.createListing(
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        imageUrl: imageUrl,
      );
      return Right(listing);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> getListings() async {
    try {
      final listings = await remoteDataSource.getListings();
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> getListingsByCategory(String categoryId) async {
    try {
      final listings = await remoteDataSource.getListingsByCategory(categoryId);
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> getListingById(String id) async {
    try {
      final listing = await remoteDataSource.getListingById(id);
      return Right(listing);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String id) async {
    try {
      await remoteDataSource.deleteListing(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> updateListing({
    required String id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? imageUrl,
    String? status,
  }) async {
    try {
      final listing = await remoteDataSource.updateListing(
        id: id,
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        imageUrl: imageUrl,
        status: status,
      );
      return Right(listing);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> searchListings(String query) async {
    try {
      final listings = await remoteDataSource.searchListings(query);
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> filterListings({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final listings = await remoteDataSource.filterListings(
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      return Right(listings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
