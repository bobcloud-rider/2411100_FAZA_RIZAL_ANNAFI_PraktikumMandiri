# Aplikasi Manajemen Tugas Mahasiswa (offline)

Praktikum Mandiri — Studi Kasus Praktikum 1: *Offline Mobile Application*.
Aplikasi Android berbasis Flutter yang mencatat, memantau, dan memperbarui
status tugas mahasiswa **tanpa internet**.

## Fitur

- Daftar tugas dari database lokal (SQLite).
- Menambahkan tugas baru via form input.
- Melihat detail satu tugas secara lengkap.
- Mengubah data tugas yang sudah tersimpan.
- Menghapus tugas dengan konfirmasi pengguna.
- Mengubah status: `belum`, `proses`, `selesai`.
- Tampilan sederhana agar mudah digunakan di layar kecil.

## Model data

| Field       | Tipe                | Keterangan                     |
|-------------|---------------------|---------------------------------|
| id          | INTEGER             | Primary key                     |
| mata_kuliah | TEXT                | Mata kuliah                     |
| judul       | TEXT                | Judul tugas                    |
| deskripsi   | TEXT                | Isi tugas                      |
| deadline    | TEXT (ISO 8601)     | Tanggal deadline               |
| prioritas   | TEXT                | rendah / menengah / tinggi     |
| status      | TEXT                | belum / proses / selesai       |

## Arsitektur

```
UI (screens) → ViewModel (ChangeNotifier) → Repository → DatabaseHelper → SQLite
```

Pemisahan ini memastikan UI tidak mengakses database secara langsung.

## Cara menjalankan

```bash
flutter pub get
flutter run        # pilih emulator atau HP Android
flutter analyze
flutter test
```

> Uji penyimpanan SQLite dilakukan di **emulator/HP Android**, bukan browser web.
