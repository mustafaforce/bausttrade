import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<Message, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) {
    return repository.sendMessage(
      conversationId: params.conversationId,
      senderId: params.senderId,
      content: params.content,
    );
  }
}

class SendMessageParams extends Equatable {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessageParams({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [conversationId, senderId, content];
}