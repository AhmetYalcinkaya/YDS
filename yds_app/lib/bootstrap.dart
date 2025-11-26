import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/env/app_environment.dart';

/// Ortak bootstrap akışı: env dosyasını yükler, Supabase'i başlatır ve uygulamayı çalıştırır.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: AppEnvironment.fileName);
  await Supabase.initialize(
    url: AppEnvironment.read(AppEnvironment.supabaseUrlKey),
    anonKey: AppEnvironment.read(AppEnvironment.supabaseAnonKey),
  );

  runApp(const ProviderScope(child: YdsApp()));
}
