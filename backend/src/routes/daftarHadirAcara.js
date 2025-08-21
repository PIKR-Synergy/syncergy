import express from 'express';
import db from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// GET daftar hadir acara
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM daftar_hadir_acara');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST daftar hadir acara
router.post('/', auditMiddleware, async (req, res) => {
  const { tanggal, nama_acara, user_id, nik, nama_peserta, status, alamat, ttd_path, waktu_hadir, catatan } = req.body;
  try {
    await db.query('INSERT INTO daftar_hadir_acara (tanggal, nama_acara, user_id, nik, nama_peserta, status, alamat, ttd_path, waktu_hadir, catatan) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [tanggal, nama_acara, user_id, nik, nama_peserta, status, alamat, ttd_path, waktu_hadir, catatan]);
    res.json({ message: 'Kehadiran acara berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
