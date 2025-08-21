# Panduan Testing Manual API Syncergy

## Cara Testing
- Gunakan Postman atau cURL untuk menguji setiap endpoint.
- Pastikan response sesuai standar JSON dan status code.
- Cek audit log, session, dan soft delete pada setiap aksi penting.

---

## 1. Authentication
### Login
```
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'
```
- Response: token JWT, user info

### Register
```
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","username":"testuser","password":"testpass","role":"anggota","email":"test@mail.com"}'
```
- Response: user created

---

## 2. Users CRUD
### List Users
```
curl -X GET http://localhost:3000/api/users \
  -H "Authorization: Bearer <token>"
```
### Create User
```
curl -X POST http://localhost:3000/api/users \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"User Baru","username":"userbaru","password":"pass","role":"anggota","email":"baru@mail.com"}'
```
### Update User
```
curl -X PUT http://localhost:3000/api/users/1 \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name":"User Update"}'
```
### Delete User (Soft Delete)
```
curl -X DELETE http://localhost:3000/api/users/1 \
  -H "Authorization: Bearer <token>"
```

---

## 3. Session Management
### List Sessions
```
curl -X GET http://localhost:3000/api/sessions \
  -H "Authorization: Bearer <token>"
```
### Logout Session
```
curl -X DELETE http://localhost:3000/api/sessions/<session_id> \
  -H "Authorization: Bearer <token>"
```

---

## 4. Rapat & Absensi
### List Rapat
```
curl -X GET http://localhost:3000/api/rapat \
  -H "Authorization: Bearer <token>"
```
### Create Rapat
```
curl -X POST http://localhost:3000/api/rapat \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"nama_rapat":"Rapat Test","isi":"Deskripsi","tanggal_rapat":"2025-08-21 10:00:00","tempat":"Ruang 1","status":"terjadwal"}'
```
### Absensi Rapat
```
curl -X POST http://localhost:3000/api/absensi-rapat \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"rapat_id":1,"user_id":2,"status":"hadir","alamat":"Jakarta"}'
```

---

## 5. Notulen Rapat
### List Notulen
```
curl -X GET http://localhost:3000/api/notulen-rapat/1 \
  -H "Authorization: Bearer <token>"
```
### Create Notulen
```
curl -X POST http://localhost:3000/api/notulen-rapat \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"rapat_id":1,"tanggal":"2025-08-21","waktu":"10:00:00","tempat":"Ruang 1","jumlah_peserta":10,"materi":"Materi","isi_notulen":"Isi","notulis_id":2,"status":"draft"}'
```

---

## 6. Program Kerja & Kegiatan
### List Program Kerja
```
curl -X GET http://localhost:3000/api/program-kerja \
  -H "Authorization: Bearer <token>"
```
### Create Program Kerja
```
curl -X POST http://localhost:3000/api/program-kerja \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"nama":"Program Baru","deskripsi":"Deskripsi","tanggal_mulai":"2025-08-21","tanggal_selesai":"2025-08-22"}'
```
### List Kegiatan
```
curl -X GET http://localhost:3000/api/kegiatan \
  -H "Authorization: Bearer <token>"
```
### Create Kegiatan
```
curl -X POST http://localhost:3000/api/kegiatan \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"nama_kegiatan":"Kegiatan Baru","tanggal":"2025-08-21"}'
```

---

## 7. Buku Tamu & Daftar Hadir Acara
### List Buku Tamu
```
curl -X GET http://localhost:3000/api/buku-tamu \
  -H "Authorization: Bearer <token>"
```
### Tambah Buku Tamu
```
curl -X POST http://localhost:3000/api/buku-tamu \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"tanggal":"2025-08-21","nama":"Tamu Baru","instansi":"Instansi","tujuan":"Kunjungan"}'
```
### List Daftar Hadir Acara
```
curl -X GET http://localhost:3000/api/daftar-hadir-acara \
  -H "Authorization: Bearer <token>"
```
### Tambah Daftar Hadir Acara
```
curl -X POST http://localhost:3000/api/daftar-hadir-acara \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"tanggal":"2025-08-21","nama_acara":"Acara Test","nik":"1234567890","nama_peserta":"Peserta Test","status":"hadir"}'
```

---

## 8. Konseling & Daftar Konseling
### List Konseling
```
curl -X GET http://localhost:3000/api/konseling \
  -H "Authorization: Bearer <token>"
```
### Tambah Konseling
```
curl -X POST http://localhost:3000/api/konseling \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"tanggal":"2025-08-21","tema":"Tema Konseling","konselor_id":2,"peserta_id":3,"jenis":"individual","status":"terjadwal"}'
```
### List Daftar Konseling
```
curl -X GET http://localhost:3000/api/daftar-konseling \
  -H "Authorization: Bearer <token>"
```
### Tambah Daftar Konseling
```
curl -X POST http://localhost:3000/api/daftar-konseling \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"tanggal_daftar":"2025-08-21","tanggal_konseling":"2025-08-22","konselor_id":2,"nama_pendaftar":"Tamu","jenis_konseling":"offline","topik_konseling":"Topik"}'
```

---

## 9. File Upload
### Upload File
```
curl -X POST http://localhost:3000/api/file-upload \
  -H "Authorization: Bearer <token>" \
  -F "file=@/path/to/file.pdf"
```

---

## 10. Audit & Monitoring
### List Audit Log
```
curl -X GET http://localhost:3000/api/audit \
  -H "Authorization: Bearer <token>"
```

---

## Checklist Hasil
- Semua endpoint CRUD berjalan dan response sesuai.
- Data yang dihapus tidak hilang (soft delete).
- Audit log tercatat di setiap aksi penting.
- Session management berjalan (login, logout, expiry).
- File upload berhasil dan path valid.
- Password policy, error handling, dan response standar.
- Semua relasi dan query sesuai skema database.

---

## Catatan
- Ganti `<token>` dengan JWT hasil login.
- Ganti parameter sesuai data yang ada.
- Cek database untuk validasi hasil aksi.
- Cek audit log dan session untuk setiap aksi.
