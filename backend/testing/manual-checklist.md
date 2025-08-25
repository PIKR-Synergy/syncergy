# Manual Testing Checklist for Syncergy Backend API

This file lists all API endpoints and features that must be manually tested for correctness, security, and compliance with project conventions.

## User Management
- [ ] List users (`GET /api/users`)
- [ ] Create user (`POST /api/users`)
- [ ] Update user (`PUT /api/users/{id}`)
- [ ] Soft delete user (`DELETE /api/users/{id}`)
- [ ] Role enforcement
- [ ] Audit logging

## User Sessions
- [ ] List sessions (`GET /api/sessions`)
- [ ] Delete session (`DELETE /api/sessions/{id}`)
- [ ] Multi-device/session expiry

## Biodata Pengurus
- [ ] Get biodata (`GET /api/biodata/{user_id}`)
- [ ] Create biodata (`POST /api/biodata`)
- [ ] Update biodata (`PUT /api/biodata/{user_id}`)

## Rapat & Absensi
- [ ] List rapat (`GET /api/rapat`)
- [ ] Create rapat (`POST /api/rapat`)
- [ ] Absensi rapat (`POST /api/rapat/{id}/absensi`)
- [ ] Create notulen (`POST /api/notulen`)

## Program Kerja & Kegiatan
- [ ] List program kerja (`GET /api/program-kerja`)
- [ ] Create program kerja (`POST /api/program-kerja`)
- [ ] Update program kerja (`PUT /api/program-kerja/{id}`)
- [ ] List kegiatan (`GET /api/kegiatan`)
- [ ] Create kegiatan (`POST /api/kegiatan`)

## Daftar Hadir Acara & Buku Tamu
- [ ] List daftar hadir acara (`GET /api/daftar-hadir-acara`)
- [ ] Create daftar hadir acara (`POST /api/daftar-hadir-acara`)
- [ ] List buku tamu (`GET /api/buku-tamu`)
- [ ] Create buku tamu (`POST /api/buku-tamu`)

## File Uploads
- [ ] List file uploads (`GET /api/file-uploads`)
- [ ] Upload file (`POST /api/file-uploads`)

## Konseling
- [ ] List daftar konseling (`GET /api/daftar-konseling`)
- [ ] Create daftar konseling (`POST /api/daftar-konseling`)
- [ ] Update daftar konseling status (`PUT /api/daftar-konseling/{id}`)
- [ ] List konseling sessions (`GET /api/konseling`)
- [ ] Update konseling session (`PUT /api/konseling/{id}`)

## Audit & Versioning
- [ ] List activity logs (`GET /api/activity-logs`)
- [ ] List data versions (`GET /api/data-versions`)
- [ ] Query performance stats (`GET /api/performance`)

## Reports
- [ ] Monthly report (`GET /api/report/monthly`)
- [ ] Security audit (`GET /api/security-audit`)

---

- [ ] Check standard JSON response format
- [ ] Check error handling (4xx/5xx)
- [ ] Check soft delete (`deleted_at`)
- [ ] Check JWT authentication
- [ ] Check audit logging for critical changes
- [ ] Check role-based access control
