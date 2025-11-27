# YDS 1000 Kelime Uygulaması

Supabase tabanlı, Riverpod + Clean Architecture prensiplerini uygulayan YDS kelime çalışma uygulaması.

## Kurulum

1. Gerekli araçlar:
   - Flutter SDK 3.22+
   - Dart 3.4+
   - Developer Mode (Windows) → symlink gereksinimi için `start ms-settings:developers`
2. Bağımlılıklar:
   ```bash
   flutter pub get
   ```
3. Ortam değişkenleri:
   - Proje kökünde `.env` oluşturun.
   - İçeriği:
     ```
     SUPABASE_URL=...
     SUPABASE_ANON_KEY=...
     ```
4. Kod üretimi:
   ```bash
    dart run build_runner build --delete-conflicting-outputs
   ```
5. Çalıştırma:
   ```bash
   flutter run
   ```

## Mimari Özeti

- `lib/core`: Tema, env yönetimi, sabitler, Supabase provider.
- `lib/features`: Feature-first (ör: `study`) → data/domain/presentation katmanları.
- `lib/shared`: Feature’lar arası paylaşılan UI bileşenleri.
- State management: Riverpod `StateNotifier`.
- Modeller: `freezed` + `json_serializable`.

Kurallar ve detaylı rehber: `cursoe rule for flutter/flutter rules.txt`.
