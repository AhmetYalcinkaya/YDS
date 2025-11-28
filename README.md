# 📚 YDS 1000 Kelime - Akıllı Kelime Öğrenme Uygulaması

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.22+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)
![License](https://img.shields.io/badge/License-MIT-green)

Modern, kullanıcı dostu bir kelime öğrenme uygulaması. Spaced Repetition algoritması ile etkili öğrenme, karanlık mod desteği ve şık tasarım.

[Özellikler](#-özellikler) • [Kurulum](#-kurulum) • [Mimari](#-mimari) • [Ekran Görüntüleri](#-ekran-görüntüleri)

</div>

---

## ✨ Özellikler

### 🎯 Akıllı Öğrenme Sistemi
- **Spaced Repetition Algoritması**: Bilimsel olarak kanıtlanmış aralıklı tekrar sistemi
- **Zorluk Değerlendirmesi**: Her kelime için 3 seviye (Kolay, Orta, Zor)
- **Kişiselleştirilmiş Günlük Hedef**: Kullanıcı bazlı hedef belirleme ve takip
- **İlerleme Takibi**: Gerçek zamanlı istatistikler ve başarı yüzdesi

### 📖 Kelime Yönetimi
- **1000+ Kelime Veritabanı**: YDS sınavına özel kelime havuzu
- **Kendi Kelimelerinizi Ekleyin**: Özel kelime ekleme, düzenleme ve silme
- **Akıllı Filtreleme**: Ezberlenen, öğrenilen ve tüm kelimeler
- **Arama Özelliği**: Hem İngilizce hem Türkçe arama desteği
- **Örnek Cümleler**: Her kelime için bağlam içinde kullanım örnekleri

### 🎨 Modern Kullanıcı Arayüzü
- **🌙 Karanlık Mod**: Göz dostu karanlık tema desteği
- **Material Design 3**: Modern ve şık tasarım dili
- **Responsive Layout**: Tüm ekran boyutlarına uyumlu
- **Smooth Animations**: Akıcı geçişler ve animasyonlar
- **Tab Navigation**: 4 ana sekme ile kolay gezinme

### 📊 İstatistikler & Profil
- **Detaylı İstatistikler**: Toplam, ezberlenen, öğrenilen kelime sayıları
- **Seri Takibi**: Günlük çalışma serisi (streak)
- **Renkli Kartlar**: Görsel olarak zengin istatistik gösterimi
- **Kullanıcı Profili**: Kişiselleştirilmiş deneyim

### 🔐 Güvenlik & Kimlik Doğrulama
- **Supabase Auth**: Güvenli kullanıcı yönetimi
- **Email/Password**: Klasik giriş sistemi
- **Row Level Security**: Kullanıcı verilerinin korunması

---

## 🚀 Kurulum

### Gereksinimler

- **Flutter SDK**: 3.22 veya üzeri
- **Dart**: 3.4 veya üzeri
- **Supabase Hesabı**: Ücretsiz tier yeterli
- **Developer Mode** (Windows): Symlink desteği için
  ```bash
  start ms-settings:developers
  ```

### Adım Adım Kurulum

1. **Projeyi Klonlayın**
   ```bash
   git clone https://github.com/yourusername/yds_app.git
   cd yds_app
   ```

2. **Bağımlılıkları Yükleyin**
   ```bash
   flutter pub get
   ```

3. **Ortam Değişkenlerini Ayarlayın**
   
   Proje kökünde `.env` dosyası oluşturun:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Supabase Veritabanını Kurun**
   
   Supabase SQL Editor'de aşağıdaki tabloları oluşturun:
   - `words` - Global kelime havuzu
   - `user_words` - Kullanıcı özel kelimeleri
   - `user_progress` - Öğrenme ilerlemesi
   - `users` - Kullanıcı profilleri

   > **Not**: SQL migration dosyaları `supabase/migrations/` klasöründe bulunmaktadır.

5. **Kod Üretimi**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Uygulamayı Çalıştırın**
   ```bash
   flutter run
   ```

---

## 🏗️ Mimari

### Clean Architecture + Feature-First

```
lib/
├── core/                    # Uygulama geneli
│   ├── constants/          # Sabitler
│   ├── network/            # Supabase client
│   └── theme/              # Tema ve renkler
├── features/               # Feature modülleri
│   ├── auth/              # Kimlik doğrulama
│   │   ├── data/          # Repository implementasyonları
│   │   ├── domain/        # Entities, repositories (interface)
│   │   └── presentation/  # UI, providers, pages
│   ├── study/             # Ana öğrenme modülü
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── navigation/        # Tab navigation
└── shared/                # Paylaşılan widget'lar
    └── widgets/           # Ortak UI bileşenleri
```

### Kullanılan Teknolojiler

| Kategori | Teknoloji | Açıklama |
|----------|-----------|----------|
| **Framework** | Flutter 3.22+ | Cross-platform UI framework |
| **State Management** | Riverpod 2.5+ | Reactive state management |
| **Backend** | Supabase | BaaS (Backend as a Service) |
| **Database** | PostgreSQL | Supabase üzerinde |
| **Code Generation** | Freezed, JSON Serializable | Immutable models |
| **Architecture** | Clean Architecture | Katmanlı mimari |
| **Design Pattern** | Repository Pattern | Data abstraction |

### State Management

- **Riverpod StateNotifier**: Reactive state yönetimi
- **Provider Scope**: Dependency injection
- **AsyncValue**: Loading, error, data states

### Veri Akışı

```
UI (Widget)
    ↓
Provider (StateNotifier)
    ↓
Repository (Interface)
    ↓
Repository Implementation
    ↓
Supabase Client
    ↓
PostgreSQL Database
```

---

## 📱 Ekran Görüntüleri

### Ana Sayfa (Çalışma)
- Günlük ilerleme kartı
- Kelime kartları (flip animasyonu)
- Zorluk değerlendirme butonları

### Kelimeler
- Tüm kelimeler listesi
- Arama özelliği
- Kategori filtreleme

### Profil
- İstatistik kartları (grid layout)
- Karanlık mod toggle
- Çıkış yapma

### Karanlık Mod
- Göz dostu renkler
- Tüm sayfalarda tutarlı tema

---

## 🎯 Spaced Repetition Algoritması

Uygulama, bilimsel olarak kanıtlanmış **Spaced Repetition** (Aralıklı Tekrar) algoritmasını kullanır:

### Zorluk Seviyeleri

| Seviye | Açıklama | Sonraki Tekrar |
|--------|----------|----------------|
| 🟢 **Kolay** | Kelimeyi çok iyi biliyorum | +7 gün |
| 🟡 **Orta** | Hatırladım ama zorlandım | +3 gün |
| 🔴 **Zor** | Hatırlayamadım | +1 gün |

### Algoritma Mantığı

```dart
if (difficulty == Difficulty.easy) {
  interval = previousInterval * 2.5;  // Üstel artış
} else if (difficulty == Difficulty.medium) {
  interval = previousInterval * 1.5;
} else {
  interval = 1;  // Başa dön
}
```

---

## 🔮 Gelecek Özellikler

- [ ] **Quiz Modu**: Çoktan seçmeli testler
- [ ] **Bildirimler**: Günlük hatırlatıcılar
- [ ] **Offline Mod**: İnternet olmadan çalışma
- [ ] **Sesli Telaffuz**: Kelimelerin okunuşu
- [ ] **Sosyal Özellikler**: Arkadaşlarla yarışma

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit edin (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 👨‍💻 Geliştirici

**Ahmet Yalçınkaya**

- GitHub: [@AhmetYalcinkaya](https://github.com/AhmetYalcinkaya)
- Email: a.yalcinkaya0@gmail.com

---

## 🙏 Teşekkürler

- [Flutter Team](https://flutter.dev) - Harika framework için
- [Supabase](https://supabase.com) - Backend altyapısı için
- [Riverpod](https://riverpod.dev) - State management için

---

<div align="center">

**⭐ Projeyi beğendiyseniz yıldız vermeyi unutmayın!**

Made with ❤️ and Flutter

</div>
