import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart' as auth;
import '../../../listings/domain/entities/listing.dart';
import '../../domain/entities/message.dart';
import '../controllers/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final String? conversationId;
  final Listing? listing;
  final String? otherUserId;
  final String? sellerName;

  const ChatPage({
    super.key,
    this.conversationId,
    this.listing,
    this.otherUserId,
    this.sellerName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  String? _activeConversationId;
  late final ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<ChatBloc>();
    _activeConversationId = widget.conversationId;
    if (_activeConversationId != null) {
      _chatBloc.add(GetMessagesEvent(_activeConversationId!));
    }
  }

  @override
  void dispose() {
    _chatBloc.add(ResetChatEvent());
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _activeConversationId == null) return;

    final authState = context.read<auth.AuthBloc>().state;
    if (authState is! auth.Authenticated) return;

    context.read<ChatBloc>().add(SendMessageEvent(
      conversationId: _activeConversationId!,
      senderId: authState.user.id,
      content: text,
    ));

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ConversationLoaded) {
          setState(() => _activeConversationId = state.conversation.id);
          _chatBloc.add(GetMessagesEvent(state.conversation.id));
        }
        if (state is MessageSent) {
          _chatBloc.add(GetMessagesEvent(_activeConversationId!));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.sellerName ?? (widget.listing != null
              ? 'Chat about "${widget.listing!.title}"'
              : 'Chat')),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MessagesLoaded &&
                      state.conversationId == _activeConversationId) {
                    return _MessageList(
                      messages: state.messages,
                      currentUserId: (context.read<auth.AuthBloc>().state
                              as auth.Authenticated)
                          .user
                          .id,
                    );
                  }

                  return const Center(child: Text('Start the conversation'));
                },
              ),
            ),
            _MessageInput(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<Message> messages;
  final String currentUserId;

  const _MessageList({required this.messages, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Say hello!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMine = message.senderId == currentUserId;
        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMine ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.content,
              style: TextStyle(color: isMine ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSend,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}