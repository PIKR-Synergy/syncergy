import express from 'express';
import db from '../db.js';
import sessionMiddleware from '../middleware/session.js';
import auditMiddleware from '../middleware/audit.js';

const router = express.Router();
router.use(sessionMiddleware);

// GET absensi rapat by rapat_id
router.get('/:rapat_id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM absensi_rapat WHERE rapat_id = ?', [req.params.rapat_id]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST absen rapat
router.post('/', auditMiddleware, async (req, res) => {
  const { rapat_id, user_id, status, alamat, ttd_path, waktu_absen, catatan } = req.body;
  try {
    await db.query('INSERT INTO absensi_rapat (rapat_id, user_id, status, alamat, ttd_path, waktu_absen, catatan) VALUES (?, ?, ?, ?, ?, ?, ?)', [rapat_id, user_id, status, alamat, ttd_path, waktu_absen, catatan]);
    res.json({ message: 'Absensi berhasil ditambahkan.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
