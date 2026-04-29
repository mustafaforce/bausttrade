part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetConversationsEvent extends ChatEvent {
  final String userId;

  const GetConversationsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetOrCreateConversationEvent extends ChatEvent {
  final String listingId;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;

  const GetOrCreateConversationEvent({
    required this.listingId,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  List<Object> get props => [listingId, buyerId, buyerName, sellerId, sellerName];
}

class GetMessagesEvent extends ChatEvent {
  final String conversationId;

  const GetMessagesEvent(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessageEvent({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [conversationId, senderId, content];
}