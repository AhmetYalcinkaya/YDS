/// Uygulama genel sabitleri.
class AppConstants {
  AppConstants._();

  /// Günlük hedeflenen yeni kelime sayısı.
  static const dailyNewWordTarget = 30;
  /// Feature flag to enable Claude Haiku 4.5 for all clients.
  /// Set to `true` to select Claude Haiku 4.5 where model selection is supported.
  static const enableClaudeHaiku45 = true;
}
