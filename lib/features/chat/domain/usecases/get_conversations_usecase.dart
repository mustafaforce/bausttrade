import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase implements UseCase<List<Conversation>, String> {
  final ChatRepository repository;

  GetConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Conversation>>> call(String userId) {
    return repository.getConversations(userId);
  }
}