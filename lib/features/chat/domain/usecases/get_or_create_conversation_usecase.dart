import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

class GetOrCreateConversationUseCase implements UseCase<Conversation, GetOrCreateConversationParams> {
  final ChatRepository repository;

  GetOrCreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, Conversation>> call(GetOrCreateConversationParams params) async {
    final existing = await repository.getConversationByListingAndBuyer(
      listingId: params.listingId,
      buyerId: params.buyerId,
    );

    return existing.fold(
      (failure) => Left(failure),
      (conversation) async {
        if (conversation != null) {
          return Right(conversation);
        }
        return repository.createConversation(
          listingId: params.listingId,
          buyerId: params.buyerId,
          buyerName: params.buyerName,
          sellerId: params.sellerId,
          sellerName: params.sellerName,
        );
      },
    );
  }
}

class GetOrCreateConversationParams extends Equatable {
  final String listingId;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;

  const GetOrCreateConversationParams({
    required this.listingId,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
  });

  @override
  List<Object> get props => [listingId, buyerId, buyerName, sellerId, sellerName];
}