import '../../domain/entities/listing.dart';

class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.userId,
    super.categoryId,
    required super.title,
    super.description,
    required super.price,
    super.imageUrl,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
