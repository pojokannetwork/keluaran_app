# Keluaran Analitik

Aplikasi Flutter untuk menampilkan data keluaran SGP, HK, SDY dari Spinoria dan grafik frekuensi digit.

## Fitur
- Fetch & cache ke SQLite
- Tabel keluaran harian
- Grafik frekuensi digit 0–9
- Filter pasaran (HK/SGP/SDY)
- Mode offline

## Build lokal
flutter pub get
flutter build apk --release

Hasil: build/app/outputs/flutter-apk/app-release.apk

## GitHub Actions
Setiap push ke branch main akan menghasilkan APK di tab Actions → Artifacts.
