import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ortam değişkenlerini yöneten yardımcı sınıf.
class AppEnvironment {
  AppEnvironment._();

  /// .env dosya adı.
  static const fileName = '.env';

  /// Supabase URL anahtarı.
  static const supabaseUrlKey = 'https://hbtrlhljcpheuhgiagch.supabase.co';

  /// Supabase anon anahtar anahtarı.
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhidHJsaGxqY3BoZXVoZ2lhZ2NoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxNTM5MjUsImV4cCI6MjA3OTcyOTkyNX0.N9SU4MVp8IqJYAV4nhkC0ff4ISCLCPH6Zll3ALMJC4U';

  /// İstenen ortam değişkenini okur, yoksa hata fırlatır.
  //
  static String read(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Env değişkeni eksik: $key');
    }
    return value;
  }
}
