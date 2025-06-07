# KESIMPULAN DATABASE PIK-R SYNERGY (VERSI DIPERBAIKI)

## 📁 **1. TABEL `users` (Pengguna Sistem)**

| Field           | Tipe Data    | Keterangan                                    |
| --------------- | ------------ | --------------------------------------------- |
| `user_id`       | INT (PK, AI) | ID unik pengguna                              |
| `name`          | VARCHAR(100) | Nama lengkap                                  |
| `username`      | VARCHAR(50)  | Username login (UNIQUE)                       |
| `password_hash` | VARCHAR(255) | Password yang di-hash (bcrypt/argon2)         |
| `role`          | ENUM         | ('admin', 'pengurus', 'konselor', 'tamu')     |
| `email`         | VARCHAR(100) | Email (UNIQUE jika diisi)                     |
| `phone`         | VARCHAR(20)  | Nomor telepon dengan validasi format          |
| `is_active`     | BOOLEAN      | Status aktif user (default: TRUE)            |
| `created_at`    | DATETIME     | Waktu pembuatan data                          |
| `updated_at`    | DATETIME     | Waktu update terakhir data                    |
| `deleted_at`    | DATETIME     | Soft delete timestamp                         |

---

## 📁 **2. TABEL `biodata_pengurus`**

| Field            | Tipe Data    | Keterangan              |
| ---------------- | ------------ | ----------------------- |
| `id`             | INT (PK, AI) | ID unik                 |
| `user_id`        | INT (FK)     | Relasi ke `users`       |
| `tanggal_lahir`  | DATE         |                         |
| `nama_orang_tua` | VARCHAR(100) |                         |
| `alamat`         | TEXT         | Alamat lengkap pengurus |
| `jabatan`        | VARCHAR(100) | Di organisasi           |
| `foto`           | TEXT         | URL file upload         |
| `keterangan`     | TEXT         |                         |
| `created_at`     | DATETIME     | Waktu pembuatan data    |
| `updated_at`     | DATETIME     | Waktu update terakhir   |

---

## 📁 **3. TABEL `rapat`**

| Field           | Tipe Data    | Keterangan                                   |
| --------------- | ------------ | -------------------------------------------- |
| `id`            | INT (PK, AI) |                                              |
| `nama_rapat`    | VARCHAR(255) |                                              |
| `isi`           | TEXT         | Ringkasan/deskripsi rapat                    |
| `tanggal_rapat` | DATETIME     | Waktu pelaksanaan rapat                      |
| `tempat`        | TEXT         | Lokasi rapat                                 |
| `status`        | ENUM         | ('draft', 'terjadwal', 'berlangsung', 'selesai', 'batal') |
| `created_at`    | DATETIME     | Waktu pembuatan data                         |
| `updated_at`    | DATETIME     | Waktu update terakhir                        |

---

## 📁 **4. TABEL `absensi_rapat`**

| Field      | Tipe Data    | Keterangan                                  |
| ---------- | ------------ | ------------------------------------------- |
| `id`       | INT (PK, AI) |                                             |
| `rapat_id` | INT (FK)     | Relasi ke `rapat`                           |
| `user_id`  | INT (FK)     | Relasi ke `users`                           |
| `status`   | ENUM         | ('hadir', 'tidak_hadir', 'izin', 'terlambat') |
| `alamat`   | TEXT         | Alamat kehadiran                            |
| `ttd_path` | TEXT         | Path tanda tangan digital                   |
| `waktu_absen` | DATETIME  | Waktu melakukan absensi                     |

---

## 📁 **5. TABEL `program_kerja`**

| Field              | Tipe Data    | Keterangan                                   |
| ------------------ | ------------ | -------------------------------------------- |
| `id`               | INT (PK, AI) |                                              |
| `nama_kegiatan`    | VARCHAR(255) |                                              |
| `tujuan`           | TEXT         |                                              |
| `sasaran`          | TEXT         |                                              |
| `mitra_kerja`      | TEXT         | Bisa berupa nama instansi                    |
| `frekuensi`        | ENUM         | ('Harian', 'Mingguan', 'Bulanan', 'Tahunan') |
| `hasil_diharapkan` | TEXT         |                                              |
| `status`           | ENUM         | ('draft', 'aktif', 'selesai', 'ditunda')     |
| `tanggal_mulai`    | DATE         | Tanggal mulai program                        |
| `tanggal_selesai`  | DATE         | Tanggal target selesai                       |
| `keterangan`       | TEXT         |                                              |
| `created_at`       | DATETIME     | Waktu pembuatan data                         |
| `updated_at`       | DATETIME     | Waktu update terakhir                        |

---

## 📁 **6. TABEL `daftar_hadir_acara`**

| Field        | Tipe Data    | Keterangan                |
| ------------ | ------------ | ------------------------- |
| `id`         | INT (PK, AI) |                           |
| `tanggal`    | DATE         |                           |
| `nama_acara` | VARCHAR(255) |                           |
| `user_id`    | INT (FK)     | Relasi ke `users`         |
| `status`     | ENUM         | ('hadir', 'tidak_hadir', 'izin') |
| `alamat`     | TEXT         | Alamat kehadiran          |
| `ttd_path`   | TEXT         | Path tanda tangan digital |
| `waktu_hadir`| DATETIME     | Waktu kehadiran           |

---

## 📁 **7. TABEL `notulen_rapat`**

| Field            | Tipe Data    | Keterangan        |
| ---------------- | ------------ | ----------------- |
| `id`             | INT (PK, AI) |                   |
| `rapat_id`       | INT (FK)     | Relasi ke `rapat` |
| `tanggal`        | DATE         |                   |
| `waktu`          | TIME         |                   |
| `tempat`         | TEXT         |                   |
| `jumlah_peserta` | INT          |                   |
| `materi`         | TEXT         |                   |
| `isi_notulen`    | TEXT         |                   |
| `keterangan`     | TEXT         |                   |
| `notulis_id`     | INT (FK)     | Relasi ke `users` (yang membuat notulen) |
| `created_at`     | DATETIME     | Waktu pembuatan   |
| `updated_at`     | DATETIME     | Waktu update      |

---

## 📁 **8. TABEL `kegiatan`**

| Field           | Tipe Data    | Keterangan |
| --------------- | ------------ | ---------- |
| `id`            | INT (PK, AI) |            |
| `tanggal`       | DATE         |            |
| `nama_kegiatan` | VARCHAR(255) |            |
| `sasaran`       | TEXT         |            |
| `lokasi`        | TEXT         |            |
| `hasil_dicapai` | TEXT         |            |
| `status`        | ENUM         | ('direncanakan', 'berlangsung', 'selesai', 'batal') |
| `penanggung_jawab_id` | INT (FK) | Relasi ke `users` |
| `keterangan`    | TEXT         |            |
| `created_at`    | DATETIME     | Waktu pembuatan |
| `updated_at`    | DATETIME     | Waktu update    |

---

## 📁 **9. TABEL `buku_tamu`**

| Field      | Tipe Data    | Keterangan                |
| ---------- | ------------ | ------------------------- |
| `id`       | INT (PK, AI) |                           |
| `tanggal`  | DATE         |                           |
| `nama`     | VARCHAR(100) |                           |
| `jabatan`  | VARCHAR(100) |                           |
| `instansi` | VARCHAR(255) |                           |
| `tujuan`   | TEXT         |                           |
| `ttd_path` | TEXT         | Path tanda tangan digital |
| `waktu_kunjungan` | TIME  | Waktu kunjungan          |
| `created_at` | DATETIME   | Waktu pencatatan         |

---

## 📁 **10. TABEL `konseling`**

| Field         | Tipe Data    | Keterangan                               |
| ------------- | ------------ | ---------------------------------------- |
| `id`          | INT (PK, AI) |                                          |
| `tanggal`     | DATE         |                                          |
| `tema`        | TEXT         |                                          |
| `konselor_id` | INT (FK)     | Relasi ke `users` dengan role `konselor` |
| `peserta_id`  | INT (FK)     | Relasi ke `users` (yang dikonseling)    |
| `status`      | ENUM         | ('terjadwal', 'berlangsung', 'selesai', 'batal') |
| `catatan`     | TEXT         | Catatan hasil konseling                  |
| `created_at`  | DATETIME     | Waktu pembuatan                          |
| `updated_at`  | DATETIME     | Waktu update                             |

---

## 📁 **11. TABEL `daftar_konseling`**

| Field               | Tipe Data    | Keterangan                               |
| ------------------- | ------------ | ---------------------------------------- |
| `id`                | INT (PK, AI) |                                          |
| `tanggal_daftar`    | DATE         |                                          |
| `tanggal_konseling` | DATE         | (harus ≥ `tanggal_daftar`)               |
| `konselor_id`       | INT (FK)     | Relasi ke `users` dengan role `konselor` |
| `pendaftar_id`      | INT (FK)     | Relasi ke `users` (yang mendaftar)      |
| `jenis_konseling`   | ENUM         | ('online', 'offline')                    |
| `lokasi`            | TEXT         |                                          |
| `status`            | ENUM         | ('pending', 'disetujui', 'ditolak', 'selesai') |
| `keterangan`        | TEXT         |                                          |
| `created_at`        | DATETIME     | Waktu pendaftaran                        |

---

## 📁 **12. TABEL `file_uploads` (Tambahan)**

| Field           | Tipe Data    | Keterangan                    |
| --------------- | ------------ | ----------------------------- |
| `id`            | INT (PK, AI) |                               |
| `filename`      | VARCHAR(255) | Nama file di server           |
| `original_name` | VARCHAR(255) | Nama file asli                |
| `file_path`     | TEXT         | Path lengkap file             |
| `file_size`     | INT          | Ukuran file dalam bytes       |
| `mime_type`     | VARCHAR(100) | Tipe file (image/pdf/etc)     |
| `uploaded_by`   | INT (FK)     | Relasi ke `users`             |
| `uploaded_at`   | DATETIME     | Waktu upload                  |

---

## 📁 **13. TABEL `activity_logs` (Tambahan)**

| Field         | Tipe Data    | Keterangan                |
| ------------- | ------------ | ------------------------- |
| `id`          | INT (PK, AI) |                           |
| `user_id`     | INT (FK)     | Relasi ke `users`         |
| `action`      | VARCHAR(100) | Jenis aksi (create, update, delete) |
| `table_name`  | VARCHAR(50)  | Nama tabel yang diubah    |
| `record_id`   | INT          | ID record yang diubah     |
| `description` | TEXT         | Deskripsi aktivitas       |
| `ip_address`  | VARCHAR(45)  | IP address user           |
| `user_agent`  | TEXT         | Browser/device info       |
| `created_at`  | DATETIME     | Waktu aktivitas           |

---

## 📁 **14. Relasi (Relationships)**

### **Primary Relationships:**
- `users` → Hub utama untuk semua tabel lain
- `rapat` → `absensi_rapat`, `notulen_rapat`
- `users` (role: konselor) → `konseling`, `daftar_konseling`

### **Enhanced Relationships:**
- `users` → `biodata_pengurus` (One-to-One)
- `users` → `file_uploads` (One-to-Many)
- `users` → `activity_logs` (One-to-Many)
- `kegiatan` → `users` (penanggung jawab)
- `konseling` → `users` (peserta dan konselor)

---

## 🔧 **FITUR TAMBAHAN YANG DIIMPLEMENTASI:**

1. **Soft Delete** - Field `deleted_at` untuk data penting
2. **Activity Logging** - Track semua perubahan data
3. **File Management** - Sistem upload file terpusat
4. **Status Tracking** - Status untuk rapat, kegiatan, konseling
5. **Data Validation** - Constraint dan check untuk integritas data
6. **Performance Optimization** - Index untuk query yang sering digunakan
7. **Audit Trail** - Timestamp di semua tabel penting
