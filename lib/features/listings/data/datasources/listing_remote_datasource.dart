import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../models/category_model.dart';
import '../models/listing_model.dart';

abstract class ListingRemoteDataSource {
  Future<ListingModel> createListing({
    required String title,
    String? description,
    required double price,
    String? categoryId,
    String? imageUrl,
  });

  Future<List<ListingModel>> getListings();

  Future<List<CategoryModel>> getCategories();

  Future<List<ListingModel>> getListingsByCategory(String categoryId);

  Future<ListingModel> getListingById(String id);

  Future<void> deleteListing(String id);

  Future<ListingModel> updateListing({
    required String id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? imageUrl,
    String? status,
  });
}

class ListingRemoteDataSourceImpl implements ListingRemoteDataSource {
  final SupabaseClient supabaseClient;

  ListingRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ListingModel> createListing({
    required String title,
    String? description,
    required double price,
    String? categoryId,
    String? imageUrl,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;

    Logger.api('POST', '/listings');

    try {
      final response = await supabaseClient.from('listings').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'price': price,
        'category_id': categoryId,
        'image_url': imageUrl,
      }).select().single();

      Logger.success('Listing created: ${response['id']}');
      return ListingModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to create listing', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<ListingModel>> getListings() async {
    Logger.api('GET', '/listings?status=eq.active');

    try {
      final response = await supabaseClient
          .from('listings')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false);

      Logger.success('Fetched ${response.length} listings');
      return (response as List).map((e) => ListingModel.fromJson(e)).toList();
    } catch (e, st) {
      Logger.error('Failed to fetch listings', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    Logger.api('GET', '/categories');

    try {
      final response = await supabaseClient
          .from('categories')
          .select()
          .order('name');

      Logger.success('Fetched ${response.length} categories');
      return (response as List).map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e, st) {
      Logger.error('Failed to fetch categories', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<ListingModel>> getListingsByCategory(String categoryId) async {
    Logger.api('GET', '/listings?category_id=eq.$categoryId');

    try {
      final response = await supabaseClient
          .from('listings')
          .select()
          .eq('category_id', categoryId)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      Logger.success('Fetched ${response.length} listings for category');
      return (response as List).map((e) => ListingModel.fromJson(e)).toList();
    } catch (e, st) {
      Logger.error('Failed to fetch listings by category', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ListingModel> getListingById(String id) async {
    Logger.api('GET', '/listings/$id');

    try {
      final response = await supabaseClient
          .from('listings')
          .select()
          .eq('id', id)
          .single();

      Logger.success('Fetched listing: $id');
      return ListingModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to fetch listing', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteListing(String id) async {
    Logger.api('DELETE', '/listings/$id');

    try {
      await supabaseClient.from('listings').delete().eq('id', id);
      Logger.success('Deleted listing: $id');
    } catch (e, st) {
      Logger.error('Failed to delete listing', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ListingModel> updateListing({
    required String id,
    String? title,
    String? description,
    double? price,
    String? categoryId,
    String? imageUrl,
    String? status,
  }) async {
    Logger.api('PATCH', '/listings/$id');

    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (price != null) updates['price'] = price;
      if (categoryId != null) updates['category_id'] = categoryId;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (status != null) updates['status'] = status;

      final response = await supabaseClient
          .from('listings')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      Logger.success('Updated listing: $id');
      return ListingModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to update listing', error: e, stackTrace: st);
      rethrow;
    }
  }
}
