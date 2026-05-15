import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  });

  Future<bool> isLoggedIn();

  Future<UserModel> getUserById(String id);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    Logger.api('POST', '/auth/signup', data: {'email': email, 'name': name});
    try {
      final authResponse = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Registration failed');
      }

      Logger.api('POST', '/users', data: {'email': email, 'name': name});
      final userResponse = await supabaseClient.from('users').insert({
        'id': authResponse.user!.id,
        'email': email,
        'name': name,
        'phone': phone,
      }).select().single();

      Logger.success('User registered: ${authResponse.user!.id}');

      await supabaseClient.auth.signOut();

      return UserModel.fromJson(userResponse);
    } catch (e, st) {
      Logger.error('Registration failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    Logger.api('POST', '/auth/signin', data: {'email': email});
    try {
      final authResponse = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Login failed');
      }

      Logger.api('GET', '/users/${authResponse.user!.id}');
      final userResponse = await supabaseClient
          .from('users')
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      Logger.success('User logged in: ${authResponse.user!.id}');
      return UserModel.fromJson(userResponse);
    } catch (e, st) {
      Logger.error('Login failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    Logger.api('POST', '/auth/signout');
    try {
      await supabaseClient.auth.signOut();
      Logger.success('User logged out');
    } catch (e, st) {
      Logger.error('Logout failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      Logger.log('No active session');
      return null;
    }

    Logger.api('GET', '/users/${session.user.id}');
    try {
      final userResponse = await supabaseClient
          .from('users')
          .select()
          .eq('id', session.user.id)
          .maybeSingle();

      if (userResponse == null) {
        Logger.log('User not found in database');
        return null;
      }

      Logger.success('Current user fetched: ${session.user.id}');
      return UserModel.fromJson(userResponse);
    } catch (e, st) {
      Logger.error('Failed to fetch current user', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final session = supabaseClient.auth.currentSession;
    Logger.log('Session active: ${session != null}');
    return session != null;
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;

    Logger.api('PATCH', '/users/$userId');
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await supabaseClient
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      Logger.success('Profile updated: $userId');
      return UserModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Profile update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    Logger.api('GET', '/users/$id');
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('id', id)
          .single();

      Logger.success('User fetched: $id');
      return UserModel.fromJson(response);
    } catch (e, st) {
      Logger.error('Failed to fetch user', error: e, stackTrace: st);
      rethrow;
    }
  }
}
