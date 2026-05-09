import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/meta_colors.dart';
import '../../../../core/design/meta_radius.dart';
import '../../../../core/design/meta_spacing.dart';
import '../../../../core/design/meta_typography.dart';
import '../../../../core/design/widgets/meta_nav.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart' as auth;
import '../../../chat/presentation/controllers/chat_bloc.dart';
import '../../domain/entities/conversation.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadConversations();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      _loadConversations();
    }
  }

  void _loadConversations() {
    final authState = context.read<auth.AuthBloc>().state;
    if (authState is auth.Authenticated) {
      context.read<ChatBloc>().add(GetConversationsEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _loadConversations();
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: MetaAppBar(title: 'Messages', showBack: false),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatInitial || state is ChatLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _loadConversations();
              });
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: MetaColors.critical),
                    const SizedBox(height: MetaSpacing.base),
                    Text(state.message,
                        style: MetaTypography.bodyMd),
                    const SizedBox(height: MetaSpacing.xs),
                    TextButton(
                      onPressed: () {
                        final authState =
                            context.read<auth.AuthBloc>().state;
                        if (authState is auth.Authenticated) {
                          context.read<ChatBloc>().add(
                                GetConversationsEvent(authState.user.id),
                              );
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
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: MetaColors.steel),
                      SizedBox(height: MetaSpacing.base),
                      Text('No conversations yet',
                          style: MetaTypography.headingSm),
                      SizedBox(height: MetaSpacing.xs),
                      Text(
                        'Start a conversation by contacting a seller',
                        style: MetaTypography.bodySm,
                      ),
                    ],
                  ),
                );
              }

              return BlocBuilder<auth.AuthBloc, auth.AuthState>(
                builder: (context, authState) {
                  final currentUserId =
                      authState is auth.Authenticated ? authState.user.id : '';
                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadConversations();
                    },
                    child: ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        final isBuyer =
                            conversation.buyerId == currentUserId;
                        final otherName = isBuyer
                            ? conversation.sellerName
                            : conversation.buyerName;
                        final otherId = isBuyer
                            ? conversation.sellerId
                            : conversation.buyerId;
                        return ConversationTile(
                          conversation: conversation,
                          otherName: otherName,
                          otherId: otherId,
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String otherName;
  final String otherId;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.otherName,
    required this.otherId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MetaSpacing.base,
        vertical: MetaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MetaColors.canvas,
        borderRadius: BorderRadius.circular(MetaRadius.xl),
        border: Border.all(color: MetaColors.hairlineSoft),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(MetaSpacing.md),
        leading: CircleAvatar(
          backgroundColor: MetaColors.surfaceSoft,
          child: Icon(Icons.person, color: MetaColors.ink),
        ),
        title: Text(otherName, style: MetaTypography.bodyMdBold),
        subtitle: Text(
          'Listing: ${conversation.listingId.substring(0, 8)}...',
          style: MetaTypography.bodySm.copyWith(color: MetaColors.steel),
        ),
        trailing: const Icon(Icons.chevron_right, color: MetaColors.steel),
        onTap: () {
          Navigator.pushNamed(context, '/chat', arguments: {
            'conversationId': conversation.id,
            'otherUserId': otherId,
            'sellerName': otherName,
          });
        },
      ),
    );
  }
}
