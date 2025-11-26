import 'package:flutter/material.dart';

/// Uygulama tema ayarları.
class AppTheme {
  AppTheme._();

  /// Açık tema konfigürasyonu.
  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2F80ED),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: 'Roboto',
      ),
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: false,
        elevation: 0,
        backgroundColor: base.colorScheme.surface,
        foregroundColor: base.colorScheme.onSurface,
      ),
    );
  }
}

