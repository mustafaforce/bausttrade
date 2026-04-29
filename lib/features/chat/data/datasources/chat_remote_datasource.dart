import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ConversationModel> createConversation({
    required String listingId,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
  });

  Future<List<ConversationModel>> getConversations(String userId);

  Future<ConversationModel?> getConversationByListingAndBuyer({
    required String listingId,
    required String buyerId,
  });

  Future<List<MessageModel>> getMessages(String conversationId);

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  ChatRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ConversationModel> createConversation({
    required String listingId,
    required String buyerId,
    required String buyerName,
    required String sellerId,
    required String sellerName,
  }) async {
    Logger.api('POST', '/conversations');

    try {
      final response = await supabaseClient.from('conversations').insert({
        'listing_id': listingId,
        'buyer_id': buyerId,
        'buyer_name': buyerName,
        'seller_id': sellerId,
        'seller_name': sellerName,
      }).select().single();

      Logger.success('Conversation created: ${response['id']}');
      return ConversationModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to create conversation', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<ConversationModel>> getConversations(String userId) async {
    Logger.api('GET', '/conversations?user_id=$userId');

    try {
      final response = await supabaseClient
          .from('conversations')
          .select()
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .order('created_at', ascending: false);

      Logger.success('Fetched ${response.length} conversations');
      return (response as List)
          .map((e) => ConversationModel.fromJson(e))
          .toList();
    } catch (e, st) {
      Logger.error('Failed to fetch conversations', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ConversationModel?> getConversationByListingAndBuyer({
    required String listingId,
    required String buyerId,
  }) async {
    Logger.api('GET', '/conversations?listing_id=$listingId&buyer_id=$buyerId');

    try {
      final response = await supabaseClient
          .from('conversations')
          .select()
          .eq('listing_id', listingId)
          .eq('buyer_id', buyerId)
          .maybeSingle();

      if (response == null) {
        Logger.success('No existing conversation found');
        return null;
      }

      Logger.success('Found conversation: ${response['id']}');
      return ConversationModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to get conversation', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId) async {
    Logger.api('GET', '/messages?conversation_id=$conversationId');

    try {
      final response = await supabaseClient
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      Logger.success('Fetched ${response.length} messages');
      return (response as List)
          .map((e) => MessageModel.fromJson(e))
          .toList();
    } catch (e, st) {
      Logger.error('Failed to fetch messages', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    Logger.api('POST', '/messages');

    try {
      final response = await supabaseClient.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
      }).select().single();

      Logger.success('Message sent: ${response['id']}');
      return MessageModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to send message', error: e, stackTrace: st);
      rethrow;
    }
  }
}