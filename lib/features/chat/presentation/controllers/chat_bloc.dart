import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/get_or_create_conversation_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetConversationsUseCase getConversationsUseCase;
  final GetOrCreateConversationUseCase getOrCreateConversationUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc({
    required this.getConversationsUseCase,
    required this.getOrCreateConversationUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial()) {
    on<GetConversationsEvent>(_onGetConversations);
    on<GetOrCreateConversationEvent>(_onGetOrCreateConversation);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onGetConversations(
    GetConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getConversationsUseCase(event.userId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (conversations) => emit(ConversationsLoaded(conversations)),
    );
  }

  Future<void> _onGetOrCreateConversation(
    GetOrCreateConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getOrCreateConversationUseCase(
      GetOrCreateConversationParams(
        listingId: event.listingId,
        buyerId: event.buyerId,
        buyerName: event.buyerName,
        sellerId: event.sellerId,
        sellerName: event.sellerName,
      ),
    );
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (conversation) => emit(ConversationLoaded(conversation)),
    );
  }

  Future<void> _onGetMessages(
    GetMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    final result = await getMessagesUseCase(event.conversationId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesLoaded(
        messages: messages,
        conversationId: event.conversationId,
      )),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await sendMessageUseCase(SendMessageParams(
      conversationId: event.conversationId,
      senderId: event.senderId,
      content: event.content,
    ));
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) => emit(MessageSent(message)),
    );
  }
}