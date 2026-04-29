part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ConversationsLoaded extends ChatState {
  final List<Conversation> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ConversationLoaded extends ChatState {
  final Conversation conversation;

  const ConversationLoaded(this.conversation);

  @override
  List<Object> get props => [conversation];
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final String conversationId;

  const MessagesLoaded({required this.messages, required this.conversationId});

  @override
  List<Object> get props => [messages, conversationId];
}

class MessageSent extends ChatState {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}