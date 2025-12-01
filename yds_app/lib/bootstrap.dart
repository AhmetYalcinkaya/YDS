import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env/app_environment.dart';
import 'core/services/notification_service.dart';

/// Ortak bootstrap akışı: env dosyasını yükler, Supabase'i başlatır ve uygulamayı çalıştırır.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Try to load .env file if it exists (optional)
  try {
    await dotenv.load(fileName: AppEnvironment.fileName);
  } catch (e) {
    // .env file not found, will use hardcoded values
    debugPrint('.env file not found, using hardcoded Supabase credentials');
  }

  await Supabase.initialize(
    url: AppEnvironment.supabaseUrl,
    anonKey: AppEnvironment.supabaseAnonKey,
  );

  await NotificationService().init();

  runApp(const ProviderScope(child: YdsApp()));
}
