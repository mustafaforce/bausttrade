import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Conversation>> createConversation({
    required String listingId,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
  }) async {
    try {
      final conversation = await remoteDataSource.createConversation(
        listingId: listingId,
        buyerId: buyerId,
        buyerName: buyerName,
        sellerId: sellerId,
        sellerName: sellerName,
      );
      return Right(conversation);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversations(String userId) async {
    try {
      final conversations = await remoteDataSource.getConversations(userId);
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Conversation?>> getConversationByListingAndBuyer({
    required String listingId,
    required String buyerId,
  }) async {
    try {
      final conversation = await remoteDataSource.getConversationByListingAndBuyer(
        listingId: listingId,
        buyerId: buyerId,
      );
      return Right(conversation);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages(String conversationId) async {
    try {
      final messages = await remoteDataSource.getMessages(conversationId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        content: content,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}