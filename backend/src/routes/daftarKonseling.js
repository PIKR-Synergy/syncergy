import express from 'express';
import db from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// GET daftar konseling
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM daftar_konseling');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST daftar konseling
router.post('/', auditMiddleware, async (req, res) => {
  const { tanggal_daftar, tanggal_konseling, waktu_konseling, konselor_id, pendaftar_id, nama_pendaftar, kontak_pendaftar, jenis_konseling, topik_konseling, lokasi, status, prioritas, alasan_penolakan, keterangan } = req.body;
  try {
    await db.query('INSERT INTO daftar_konseling (tanggal_daftar, tanggal_konseling, waktu_konseling, konselor_id, pendaftar_id, nama_pendaftar, kontak_pendaftar, jenis_konseling, topik_konseling, lokasi, status, prioritas, alasan_penolakan, keterangan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [tanggal_daftar, tanggal_konseling, waktu_konseling, konselor_id, pendaftar_id, nama_pendaftar, kontak_pendaftar, jenis_konseling, topik_konseling, lokasi, status, prioritas, alasan_penolakan, keterangan]);
    res.json({ message: 'Pendaftaran konseling berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
