import express from 'express';
import db from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// GET buku tamu
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM buku_tamu');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST buku tamu
router.post('/', auditMiddleware, async (req, res) => {
  const { tanggal, nama, jabatan, instansi, email, telepon, tujuan, ttd_path, waktu_kunjungan, waktu_selesai, status, dilayani_oleh } = req.body;
  try {
    await db.query('INSERT INTO buku_tamu (tanggal, nama, jabatan, instansi, email, telepon, tujuan, ttd_path, waktu_kunjungan, waktu_selesai, status, dilayani_oleh) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [tanggal, nama, jabatan, instansi, email, telepon, tujuan, ttd_path, waktu_kunjungan, waktu_selesai, status, dilayani_oleh]);
    res.json({ message: 'Tamu berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
