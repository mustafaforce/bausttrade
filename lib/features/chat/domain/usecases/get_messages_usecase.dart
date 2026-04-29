import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<Message>, String> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(String conversationId) {
    return repository.getMessages(conversationId);
  }
}