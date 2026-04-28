part of 'listing_bloc.dart';

abstract class ListingState extends Equatable {
  const ListingState();

  @override
  List<Object?> get props => [];
}

class ListingInitial extends ListingState {}

class ListingLoading extends ListingState {}

class ListingsLoaded extends ListingState {
  final List<Listing> listings;

  const ListingsLoaded(this.listings);

  @override
  List<Object> get props => [listings];
}

class CategoriesLoaded extends ListingState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ListingCreated extends ListingState {
  final Listing listing;

  const ListingCreated(this.listing);

  @override
  List<Object> get props => [listing];
}

class ListingDeleted extends ListingState {}

class ListingUpdated extends ListingState {
  final Listing listing;

  const ListingUpdated(this.listing);

  @override
  List<Object> get props => [listing];
}

class ListingError extends ListingState {
  final String message;

  const ListingError(this.message);

  @override
  List<Object> get props => [message];
}
