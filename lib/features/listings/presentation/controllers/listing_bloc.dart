import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/listing.dart';
import '../../domain/usecases/create_listing_usecase.dart';
import '../../domain/usecases/delete_listing_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_listings_usecase.dart';
import '../../domain/usecases/update_listing_usecase.dart';

part 'listing_event.dart';
part 'listing_state.dart';

class ListingBloc extends Bloc<ListingEvent, ListingState> {
  final CreateListingUseCase createListingUseCase;
  final GetListingsUseCase getListingsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final DeleteListingUseCase deleteListingUseCase;
  final UpdateListingUseCase updateListingUseCase;

  ListingBloc({
    required this.createListingUseCase,
    required this.getListingsUseCase,
    required this.getCategoriesUseCase,
    required this.deleteListingUseCase,
    required this.updateListingUseCase,
  }) : super(ListingInitial()) {
    on<CreateListingEvent>(_onCreateListing);
    on<GetListingsEvent>(_onGetListings);
    on<GetCategoriesEvent>(_onGetCategories);
    on<GetListingsByCategoryEvent>(_onGetListingsByCategory);
    on<DeleteListingEvent>(_onDeleteListing);
    on<UpdateListingEvent>(_onUpdateListing);
  }

  Future<void> _onCreateListing(
    CreateListingEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await createListingUseCase(CreateListingParams(
      title: event.title,
      description: event.description,
      price: event.price,
      categoryId: event.categoryId,
      imageUrl: event.imageUrl,
    ));
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(ListingCreated(listing)),
    );
  }

  Future<void> _onGetListings(
    GetListingsEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await getListingsUseCase(NoParams());
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(listings)),
    );
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onGetListingsByCategory(
    GetListingsByCategoryEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await getListingsUseCase(NoParams());
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listings) => emit(ListingsLoaded(listings)),
    );
  }

  Future<void> _onDeleteListing(
    DeleteListingEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await deleteListingUseCase(DeleteListingParams(id: event.id));
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (_) => emit(ListingDeleted()),
    );
  }

  Future<void> _onUpdateListing(
    UpdateListingEvent event,
    Emitter<ListingState> emit,
  ) async {
    emit(ListingLoading());
    final result = await updateListingUseCase(UpdateListingParams(
      id: event.id,
      title: event.title,
      description: event.description,
      price: event.price,
      categoryId: event.categoryId,
      imageUrl: event.imageUrl,
      status: event.status,
    ));
    result.fold(
      (failure) => emit(ListingError(failure.message)),
      (listing) => emit(ListingUpdated(listing)),
    );
  }
}
