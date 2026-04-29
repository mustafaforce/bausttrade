import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Conversation>> createConversation({
    required String listingId,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
  });

  Future<Either<Failure, List<Conversation>>> getConversations(String userId);

  Future<Either<Failure, Conversation?>> getConversationByListingAndBuyer({
    required String listingId,
    required String buyerId,
  });

  Future<Either<Failure, List<Message>>> getMessages(String conversationId);

  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });
}