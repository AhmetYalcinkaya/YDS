Lütfen uygulama ikonu için yüksek çözünürlüklü bir PNG dosyası koyun.

Dosya yolu (zorunlu): assets/images/app_icon.png
Önerilen boyut: 1024x1024 veya 2048x2048, PNG, transparan arka plan (isteğe bağlı).

İşlem:
1) Yukarıdaki yola `app_icon.png` dosyanızı kopyalayın.
2) Proje kökünden çalıştırın:
   flutter pub get
   flutter pub run flutter_launcher_icons:main

Notlar:
- `flutter_launcher_icons` Android ve iOS için gereken tüm ikon boyutlarını otomatik oluşturur.
- Bu dosyayı versiyona eklemeden önce orijinal yüksek çözünürlüklü .png'i güvenli bir yerde saklayın.

Alternatif (ben SVG oluşturdum):

- Ben proje içine `assets/images/app_icon.svg` oluşturdum — bu vektörel bir ikon ve istediğiniz boyutta kalite kaybı olmadan dönüştürülebilir.
- PNG'ye dönüştürmek isterseniz aşağıdaki yolları kullanabilirsiniz.

ImageMagick (Windows PowerShell):
```powershell
magick assets/images/app_icon.svg -resize 1024x1024 assets/images/app_icon.png
```

Inkscape (CLI):
```powershell
inkscape assets/images/app_icon.svg --export-filename=assets/images/app_icon.png --export-width=1024 --export-height=1024
```

Sonrasında `flutter_launcher_icons` çalıştırabilirsiniz:
```powershell
flutter pub get
flutter pub run flutter_launcher_icons:main
```

Not: Üretilen `app_icon.png`'i repoya ekleyebilirsiniz veya orijinal SVG'yi saklayıp PNG'yi .gitignore ile hariç tutabilirsiniz.
