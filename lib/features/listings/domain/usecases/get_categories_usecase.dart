import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/category.dart';
import '../repositories/listing_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final ListingRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) {
    return repository.getCategories();
  }
}
