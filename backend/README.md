# Syncergy Backend Setup

## 1. Instalasi Dependensi
```
npm install
```

## 2. Konfigurasi Environment
Salin file `.env.example` menjadi `.env` dan sesuaikan dengan konfigurasi database Anda.

## 3. Setup Database
- Import file `dev-note/database.sql` ke MySQL Anda untuk membuat seluruh tabel dan struktur database.
- Contoh perintah (di terminal MySQL):
  ```sql
  SOURCE d:/Pribadi/xampp/htdocs/CMS/dev-note/database.sql;
  ```

## 4. Menjalankan Backend
```
npm run dev
```

Server akan berjalan di port sesuai variabel `PORT` pada `.env` (default: 3001).
