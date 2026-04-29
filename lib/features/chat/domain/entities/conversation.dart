import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String id;
  final String listingId;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final DateTime createdAt;

  const Conversation({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, listingId, buyerId, buyerName, sellerId, sellerName, createdAt];
}