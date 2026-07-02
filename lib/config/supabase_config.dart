import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration.
/// Replace these with your actual Supabase project credentials.
class SupabaseConfig {
  SupabaseConfig._();

  /// Your Supabase project URL (e.g., https://xxxxx.supabase.co)
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  /// Your Supabase anon/publishable key
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
