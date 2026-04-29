import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart' as auth;
import '../../../chat/presentation/controllers/chat_bloc.dart';
import '../../domain/entities/conversation.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<auth.AuthBloc>().state;
    if (authState is auth.Authenticated) {
      context.read<ChatBloc>().add(GetConversationsEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      final authState = context.read<auth.AuthBloc>().state;
                      if (authState is auth.Authenticated) {
                        context.read<ChatBloc>().add(GetConversationsEvent(authState.user.id));
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ConversationsLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No conversations yet'),
                    SizedBox(height: 8),
                    Text(
                      'Start a conversation by contacting a seller',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return ConversationTile(conversation: conversation);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationTile({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.person, color: Colors.blue),
      ),
      title: Text('Conversation ${conversation.id.substring(0, 8)}...'),
      subtitle: Text('Listing: ${conversation.listingId.substring(0, 8)}...'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(context, '/chat', arguments: {
          'conversationId': conversation.id,
          'otherUserId': conversation.sellerId,
        });
      },
    );
  }
}