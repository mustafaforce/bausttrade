import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/design/widgets/meta_nav.dart';
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
  final _scrollController = ScrollController();
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
    _scrollController.dispose();
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
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
          _scrollToBottom();
        }
        if (state is MessagesLoaded) {
          _scrollToBottom();
        }
      },
      child: Scaffold(
        appBar: MetaAppBar(
          title: widget.sellerName ??
              (widget.listing != null
                  ? 'Chat about "${widget.listing!.title}"'
                  : 'Chat'),
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
                      scrollController: _scrollController,
                    );
                  }

                  return Center(
                    child: Text('Start the conversation',
                        style: MetaTypography.bodyMd.copyWith(
                            color: MetaColors.steel)),
                  );
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
  final ScrollController scrollController;

  const _MessageList({
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Say hello!',
            style: MetaTypography.bodyMd),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(MetaSpacing.base),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMine = message.senderId == currentUserId;
        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: MetaSpacing.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: MetaSpacing.base,
              vertical: MetaSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isMine ? MetaColors.primary : MetaColors.surfaceSoft,
              borderRadius: BorderRadius.circular(MetaRadius.xl),
            ),
            child: Text(
              message.content,
              style: MetaTypography.bodyMd.copyWith(
                color: isMine ? MetaColors.canvas : MetaColors.inkDeep,
              ),
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

  const _MessageInput({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: MetaSpacing.base,
        vertical: MetaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MetaColors.canvas,
        boxShadow: [
          BoxShadow(
            color: MetaColors.inkDeep.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MetaColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(MetaRadius.full),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: MetaTypography.bodySm.copyWith(
                        color: MetaColors.steel),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: MetaSpacing.base,
                      vertical: MetaSpacing.sm,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: MetaTypography.bodyMd,
                ),
              ),
            ),
            const SizedBox(width: MetaSpacing.xs),
            Container(
              decoration: const BoxDecoration(
                color: MetaColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.send, color: MetaColors.canvas),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
