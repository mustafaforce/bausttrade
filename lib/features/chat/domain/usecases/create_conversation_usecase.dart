import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

class CreateConversationUseCase implements UseCase<Conversation, CreateConversationParams> {
  final ChatRepository repository;

  CreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(CreateConversationParams params) {
    return repository.createConversation(
      listingId: params.listingId,
      buyerId: params.buyerId,
      buyerName: params.buyerName,
      sellerId: params.sellerId,
      sellerName: params.sellerName,
    );
  }
}

class CreateConversationParams extends Equatable {
  final String listingId;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;

  const CreateConversationParams({
    required this.listingId,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  List<Object> get props => [listingId, buyerId, buyerName, sellerId, sellerName];
}