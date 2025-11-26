import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ortam değişkenlerini yöneten yardımcı sınıf.
class AppEnvironment {
  AppEnvironment._();

  /// .env dosya adı.
  static const fileName = '.env';

  /// Supabase URL
  static const supabaseUrl = 'https://hbtrlhljcpheuhgiagch.supabase.co';

  /// Supabase anon key
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhidHJsaGxqY3BoZXVoZ2lhZ2NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxNTM5MjUsImV4cCI6MjA3OTcyOTkyNX0.N9SU4MVp8IqJYAV4nhkC0ff4ISCLCPH6Zll3ALMJC4U';

  /// Environment variable keys (for .env file if used)
  static const supabaseUrlKey = 'SUPABASE_URL';
  static const supabaseAnonKeyEnv = 'SUPABASE_ANON_KEY';

  /// Read environment variable or return hardcoded value
  static String read(String key) {
    // Return hardcoded values directly
    if (key == supabaseUrlKey) return supabaseUrl;
    if (key == supabaseAnonKeyEnv) return supabaseAnonKey;

    // Try to read from .env if available
    final value = dotenv.env[key];
    if (value != null && value.isNotEmpty) {
      return value;
    }

    throw StateError('Env değişkeni eksik: $key');
  }
}
