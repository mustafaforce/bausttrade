import '../../domain/entities/conversation.dart';

class ConversationModel extends Conversation {
  const ConversationModel({
    required super.id,
    required super.listingId,
    required super.buyerId,
    required super.sellerId,
    required super.buyerName,
    required super.sellerName,
    required super.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      listingId: json['listing_id'] as String,
      buyerId: json['buyer_id'] as String,
      buyerName: json['buyer_name'] as String,
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}