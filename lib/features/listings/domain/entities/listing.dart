import 'package:equatable/equatable.dart';

class Listing extends Equatable {
  final String id;
  final String userId;
  final String? categoryId;
  final String title;
  final String? description;
  final double price;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Listing({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    this.description,
    required this.price,
    this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        categoryId,
        title,
        description,
        price,
        imageUrl,
        status,
        createdAt,
        updatedAt,
      ];
}
