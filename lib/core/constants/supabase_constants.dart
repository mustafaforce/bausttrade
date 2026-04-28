import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SupabaseConstants {
  static String? _supabaseUrl;
  static String? _supabaseAnonKey;

  static Future<void> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final envFile = File('${directory.path}/.env');

    if (await envFile.exists()) {
      final contents = await envFile.readAsString();
      for (final line in contents.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

        final parts = trimmed.split('=');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();

          if (key == 'SUPABASE_URL') {
            _supabaseUrl = value;
          } else if (key == 'SUPABASE_ANON_KEY') {
            _supabaseAnonKey = value;
          }
        }
      }
    }
  }

  static String get supabaseUrl => _supabaseUrl ?? '';
  static String get supabaseAnonKey => _supabaseAnonKey ?? '';
}
