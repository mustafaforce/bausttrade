part of 'listing_bloc.dart';

abstract class ListingEvent extends Equatable {
  const ListingEvent();

  @override
  List<Object?> get props => [];
}

class CreateListingEvent extends ListingEvent {
  final String title;
  final String? description;
  final double price;
  final String? categoryId;
  final String? imageUrl;

  const CreateListingEvent({
    required this.title,
    this.description,
    required this.price,
    this.categoryId,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [title, description, price, categoryId, imageUrl];
}

class GetListingsEvent extends ListingEvent {}

class GetCategoriesEvent extends ListingEvent {}

class GetListingsByCategoryEvent extends ListingEvent {
  final String categoryId;

  const GetListingsByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class DeleteListingEvent extends ListingEvent {
  final String id;

  const DeleteListingEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateListingEvent extends ListingEvent {
  final String id;
  final String? title;
  final String? description;
  final double? price;
  final String? categoryId;
  final String? imageUrl;
  final String? status;

  const UpdateListingEvent({
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
